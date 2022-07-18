//based on emscripten OpenAL port: http://emscripten.org

var _AL = {};

/**
* @type {Array<_ALContext>}
*/
_AL.contexts = [];

/**
* @type {_ALContext}
*/
_AL.currentContext = null;

_AL.alcErr = 0;
_AL.newSrcId = 1;

_AL.updateSource = function(src) {
	if (src.state !== 0x1012 /* AL_PLAYING */ && src.state !== 0x1013 /* AL_PAUSED */) {
		return;
	}

	if (src._pitch !== src.pitch) {
		for (var i = 0; i < src.queue.length; i++) {
			var entry = src.queue[i];

			if (entry.buffer.pitch !== src.pitch) {
				entry.buffer = _AL.getPtichedBuffer(_AL.currentContext.buf[entry.buffer.id-1], src.pitch);
			}
		}

		if (src.state === 0x1012 /* AL_PLAYING */) {
			src.bufferPosition = _AL.currentContext.ctx.currentTime - (((_AL.currentContext.ctx.currentTime - src.bufferPosition) * src._pitch) / src.pitch);
			_AL.stopSourceQueue(src);
		}

		src._pitch = src.pitch;
	}

	if (src.secOffset >= 0) {
		var secOffset = src.secOffset;
		src.buffersPlayed = 0;

		for (var i = 0; i < src.queue.length; i++) {
			var duration = src.queue[i].buffer.duration * src.pitch;

			if (secOffset >= duration) {
				secOffset -= duration;
				src.buffersPlayed = i+1;
			} else {
				break;
			}
		}

		if (src.buffersPlayed >= src.queue.length) {
			src.buffersPlayed = src.queue.length - 1;
		} else if (src.state === 0x1012 /* AL_PLAYING */) {
			src.bufferPosition = _AL.currentContext.ctx.currentTime - secOffset / src.pitch;
			_AL.stopSourceQueue(src);
		} else {
			src.bufferPosition = secOffset;
		}

		src.secOffset = -1;
	} else if (src.sampleOffset >= 0) {
		src.buffersPlayed = 0;

		for (var i = 0; i < src.queue.length; i++) {
			var entry = src.queue[i];

			if (src.sampleOffset >= entry.buffer.length) {
				src.sampleOffset -= entry.buffer.length;
				src.buffersPlayed = i+1;
			} else {
				break;
			}
		}

		if (src.buffersPlayed >= src.queue.length) {
			src.buffersPlayed = src.queue.length - 1;
		} else if (src.state === 0x1012 /* AL_PLAYING */) {
			src.bufferPosition = _AL.currentContext.ctx.currentTime - _AL.samplesToSec(src.sampleOffset, src.queue[src.buffersPlayed].buffer);
			_AL.stopSourceQueue(src);
		} else {
			src.bufferPosition = _AL.samplesToSec(src.sampleOffset, src.queue[src.buffersPlayed].buffer) * src.pitch;
		}

		src.sampleOffset = -1;
	} else if (src.byteOffset >= 0) {
		src.buffersPlayed = 0;

		for (var i = 0; i < src.queue.length; i++) {
			var entry = src.queue[i];
			var bufferSize = entry.buffer.length * entry.buffer.numberOfChannels * entry.buffer.bytesPerSample;

			if (src.byteOffset >= bufferSize) {
				src.byteOffset -= bufferSize;
				src.buffersPlayed = i+1;
			} else {
				break;
			}
		}

		if (src.buffersPlayed >= src.queue.length) {
			src.buffersPlayed = src.queue.length - 1;
		} else if (src.state === 0x1012 /* AL_PLAYING */) {
			src.bufferPosition = _AL.currentContext.ctx.currentTime - _AL.bytesToSec(src.byteOffset, src.queue[src.buffersPlayed].buffer);
			_AL.stopSourceQueue(src);
		} else {
			src.bufferPosition = _AL.bytesToSec(src.byteOffset, src.queue[src.buffersPlayed].buffer) * src.pitch;
		}

		src.byteOffset = -1;
	}

	if (src.state !== 0x1012 /* AL_PLAYING */) {
		return;
	}

	var entry = src.queue[src.buffersPlayed];
	var startOffset = src.bufferPosition - _AL.currentContext.ctx.currentTime;

	if (!entry.src) {
		// If the start offset is negative, we need to offset the actual buffer.
		var offset = Math.abs(Math.min(startOffset, 0));

		entry.src = _AL.currentContext.ctx.createBufferSource();
		entry.src.buffer = entry.buffer;
		entry.src.onended = _AL.onendedListener.bind(src);
		entry.src.connect(src.gain);
		entry.src.start(0, offset);
	}
}

_AL.setSourceState = function(src, state) {
	if (state === 0x1012 /* AL_PLAYING */) {
		if (src.state !== 0x1013 /* AL_PAUSED */) {
			src.state = 0x1012 /* AL_PLAYING */;
			// Reset our position.
			src.bufferPosition = _AL.currentContext.ctx.currentTime;
			src.buffersPlayed = 0;
		} else {
			src.state = 0x1012 /* AL_PLAYING */;
			// Use the current offset from src.bufferPosition to resume at the correct point.
			src.bufferPosition = _AL.currentContext.ctx.currentTime - src.bufferPosition / src.pitch;
		}

		_AL.stopSourceQueue(src);
		_AL.updateSource(src);
	} else if (state === 0x1013 /* AL_PAUSED */) {
		if (src.state === 0x1012 /* AL_PLAYING */) {
			src.state = 0x1013 /* AL_PAUSED */;
			// Store off the current offset to restore with on resume.
			src.bufferPosition = (_AL.currentContext.ctx.currentTime - src.bufferPosition) * src.pitch;
			_AL.stopSourceQueue(src);
		}
	} else if (state === 0x1014 /* AL_STOPPED */) {
		src.secOffset = -1;
		src.byteOffset = -1;
		src.sampleOffset = -1;

		if (src.state !== 0x1011 /* AL_INITIAL */) {
			src.state = 0x1014 /* AL_STOPPED */;
			src.buffersPlayed = src.queue.length;
			_AL.stopSourceQueue(src);
		}
	} else if (state == 0x1011 /* AL_INITIAL */) {
		if (src.state !== 0x1011 /* AL_INITIAL */) {
			src.state = 0x1011 /* AL_INITIAL */;
			src.bufferPosition = 0;
			src.buffersPlayed = 0;
		}
	}
}

_AL.stopSourceQueue = function(src) {
	for (var i = 0; i < src.queue.length; i++) {
		var entry = src.queue[i];
		if (entry.src) {
			entry.src.onended = null;
			entry.src.stop(0);
			entry.src = null;
		}
	}
}

_AL.stopSources = function(context) {
	for (var srcId in context.src) {
		_AL.stopSourceQueue(context.src[srcId]);
	}
}

_AL.bytesToSec = function(bytes, buffer) {
	return bytes / (buffer.bytesPerSample * buffer.numberOfChannels * buffer.sampleRate);
}

_AL.samplesToSec = function(samples, buffer) {
	return samples / buffer.sampleRate;
}

_AL.secToSamples = function(sec, buffer) {
	return (sec * buffer.sampleRate)|0;
}

_AL.secToBytes = function(sec, buffer) {
	var result = sec * buffer.bytesPerSample * buffer.numberOfChannels * buffer.sampleRate;
	var align = buffer.bytesPerSample * buffer.numberOfChannels;

	if (align == 2) {
		result -= (result & 1);
	} else {
		while (result % align) {
			result -= (result % align);
		}
	}

	return result|0;
}

_AL.getFormatInfo = function(format, info) {
	var channels, bytes;

	switch (format) {
		case 0x1100 /* AL_FORMAT_MONO8 */:
			bytes = 1;
			channels = 1;
			break;
		case 0x1101 /* AL_FORMAT_MONO16 */:
			bytes = 2;
			channels = 1;
			break;
		case 0x1102 /* AL_FORMAT_STEREO8 */:
			bytes = 1;
			channels = 2;
			break;
		case 0x1103 /* AL_FORMAT_STEREO16 */:
			bytes = 2;
			channels = 2;
			break;
		case 0x10010 /* AL_FORMAT_MONO_FLOAT32 */:
			bytes = 4;
			channels = 1;
			break;
		case 0x10011 /* AL_FORMAT_STEREO_FLOAT32 */:
			bytes = 4;
			channels = 2;
			break;
	}

	info[0] = channels;
	info[1] = bytes;
}

_AL.getPtichedBuffer = function(buffer, pitch) {
	var newBuffer = _AL.currentContext.ctx.createBuffer(buffer.numberOfChannels, buffer.length, buffer.sampleRate * pitch);

	for (var i = 0; i < buffer.numberOfChannels; ++i) {
		newBuffer.getChannelData(i).set(buffer.getChannelData(i));
	}

	newBuffer.id = buffer.id;
	newBuffer.pitch = pitch;
	newBuffer.bytesPerSample = buffer.bytesPerSample;
	return newBuffer;
}

_AL.convertBuffer = function(src, dst) {
	switch (dst.bytesPerSample) {
		case 1:
		case 2:
			if (src.numberOfChannels < dst.numberOfChannels || src.numberOfChannels > dst.numberOfChannels) {
				var data = new BBDataBuffer()
				data._New(dst.bytesPerSample * dst.length);

				_AL.convertChannelData(src.getChannelData(0), dst.getChannelData(0), data, dst.bytesPerSample);

				if (src.numberOfChannels < dst.numberOfChannels) {
					dst.getChannelData(1).set(dst.getChannelData(0));
				}
			} else {
				var data = new BBDataBuffer()
				data._New(dst.bytesPerSample * dst.length);

				_AL.convertChannelData(src.getChannelData(0), dst.getChannelData(0), data, dst.bytesPerSample);
				_AL.convertChannelData(src.getChannelData(1), dst.getChannelData(1), data, dst.bytesPerSample);
			}
			break;

		default:
			if (src.numberOfChannels < dst.numberOfChannels) {
				for (var i = 0; i < dst.numberOfChannels; ++i) {
					dst.getChannelData(i).set(src.getChannelData(0));
				}
			} else if (src.numberOfChannels > dst.numberOfChannels) {
				dst.getChannelData(0).set(src.getChannelData(0));
			} else {
				for (var i = 0; i < src.numberOfChannels; ++i) {
					dst.getChannelData(i).set(src.getChannelData(i));
				}
			}
	}

	return dst;
}

_AL.convertChannelData = function(src, dst, buffer, bytes) {
	if (bytes == 1) {
		buffer = buffer.bytes;

		for (var i = 0, l = src.length; i < l; ++i) {
			buffer[i] = src[i] * 128;
		}

		for (var i = 0, l = src.length; i < l; ++i) {
			dst[i] = buffer[i] / 128;
		}
	} else {
		buffer = buffer.shorts;

		for (var i = 0, l = src.length; i < l; ++i) {
			buffer[i] = src[i] * 32768;
		}

		for (var i = 0, l = src.length; i < l; ++i) {
			dst[i] = buffer[i] / 32768;
		}
	}
}

_AL.createSourcePanner = function (src, panningModel, distanceModel) {
	if (_AL.currentContext.distanceModel === 0 && !panningModel && !distanceModel) return;

	var panner = src.panner = _AL.currentContext.ctx.createPanner();
	panner.panningModel = panningModel ? panningModel : 'HRTF';
	panner.distanceModel = distanceModel ? distanceModel : _AL.currentContext._distanceModel;
	panner.refDistance = src.refDistance;
	panner.maxDistance = src.maxDistance;
	panner.rolloffFactor = src.rolloffFactor;
	panner.setPosition(src.position[0], src.position[1], src.position[2]);
	//panner.setVelocity(src.velocity[0], src.velocity[1], src.velocity[2]);
	panner.connect(_AL.currentContext.ctx.destination);

	// Disconnect from the default source.
	src.gain.disconnect();
	src.gain.connect(panner);
}

_AL.updateSourcesPanner = function(context) {
	if (!_AL.currentContext) return;
	var lPos = _AL.currentContext.ctx.listener._position || [0,0,0];

	for (var srcId in _AL.currentContext.src) {
		var src = context.src[srcId];

		if (src) {
			if (_AL.currentContext.distanceModel !== 0) {
				if (!src.panner) {
					_AL.createSourcePanner(src);
				}

				src.panner.distanceModel = _AL.currentContext._distanceModel;
				src.panner.maxDistance = src.maxDistance;
			} else {
				if (src.panner) {
					_AL.destroySourcePanner(src);
				}
			}

			if (src.relative) {
				src.panner.setPosition(src.position[0] + lPos[0], src.position[1] + lPos[1], src.position[2] + lPos[2]);
			}
		}
	}
}

_AL.destroySourcePanner = function(src) {
	src.panner = null;
	// Disconnect from the panner.
	src.gain.disconnect();
	src.gain.connect(_AL.currentContext.ctx.destination);
}

/**
* @this {_ALSource}
*/
_AL.onendedListener = function() {
	// Update our location in the queue.
	this.bufferPosition += this.queue[this.buffersPlayed].buffer.duration;
	this.buffersPlayed++;

	// Stop / restart the source when we hit the end.
	if (this.buffersPlayed >= this.queue.length) {
		if (this.loop) {
			_AL.setSourceState(this, 0x1012 /* AL_PLAYING */);
		} else {
			_AL.setSourceState(this, 0x1014 /* AL_STOPPED */);
		}
	} else {
		_AL.updateSource(this);
	}
}

/**
* @constructor
*/
function _ALContext(context, gain) {
	this.ctx = context;
	this.gain = gain;
}

_ALContext.prototype = {
	/**
	* @type {!AudioContext}
	*/
	ctx: null,

	/**
	* @type {Object<number, _ALSource>}
	*/
	src: {},

	/**
	* @type {Array<!AudioBuffer>}
	*/
	buf: [],

	/**
	* @type {!GainNode}
	*/
	gain: null,
	distanceModel: 0,
	_distanceModel: 'linear',
	err: 0
};

/**
* @constructor
*/
function _ALSource(gain) {
	this.state = 0x1011 /* AL_INITIAL */;
	this.queue = [];
	this.loop = false;
	this.pitch = 1.0;
	this.relative = false;
	this.gain = gain;
	this.buffersPlayed = 0;
	this.bufferPosition = 0;
	this.secOffset = -1;
	this.byteOffset = -1;
	this.sampleOffset = -1;
	this._pitch = 1.0;
}

_ALSource.prototype = {
	/**
	* @type {!AudioPannerNode}
	*/
	panner: null,

	/**
	* @type {!GainNode}
	*/
	gain: null,

	get refDistance() {
		return this._refDistance || 1;
	},
	set refDistance(val) {
		this._refDistance = val;
		if (!this.panner) {
			_AL.createSourcePanner(this);
		}
		if ( _AL.currentContext.distanceModel !== 0) this.panner.refDistance = val;
	},
	get maxDistance() {
		return this._maxDistance || 10000;
	},
	set maxDistance(val) {
		this._maxDistance = val;
		if (!this.panner) {
			_AL.createSourcePanner(this);
		}
		if (_AL.currentContext.distanceModel !== 0) this.panner.maxDistance = val;
	},
	get rolloffFactor() {
		return this._rolloffFactor || 1;
	},
	set rolloffFactor(val) {
		this._rolloffFactor = val;
		if (!this.panner) {
			_AL.createSourcePanner(this);
		}
		if ( _AL.currentContext.distanceModel !== 0) this.panner.rolloffFactor = val;
	},
	get position() {
		return this._position || [0, 0, 0];
	},
	set position(val) {
		this._position = val;
		if (!this.panner) {
			_AL.createSourcePanner(this);
		}
		if (this.panner) this.panner.setPosition(val[0], val[1], val[2]);
	},
	get velocity() {
		return this._velocity || [0, 0, 0];
	},
	set velocity(val) {
		this._velocity = val;
		if (!this.panner) {
			_AL.createSourcePanner(this);
		}
		//if (this.panner) this.panner.setVelocity(val[0], val[1], val[2]);
	},
	get direction() {
		return this._direction || [0, 0, 0];
	},
	set direction(val) {
		this._direction = val;
		if (!this.panner) {
			_AL.createSourcePanner(this);
		}
		if (this.panner) this.panner.setOrientation(val[0], val[1], val[2]);
	},
	get coneOuterGain() {
		return this._coneOuterGain || 0.0;
	},
	set coneOuterGain(val) {
		this._coneOuterGain = val;
		if (!this.panner) {
			_AL.createSourcePanner(this);
		}
		if (this.panner) this.panner.coneOuterGain = val;
	},
	get coneInnerAngle() {
		return this._coneInnerAngle || 360.0;
	},
	set coneInnerAngle(val) {
		this._coneInnerAngle = val;
		if (this.panner) this.panner.coneInnerAngle = val;
	},
	get coneOuterAngle() {
		return this._coneOuterAngle || 360.0;
	},
	set coneOuterAngle(val) {
		this._coneOuterAngle = val;
		if (!this.panner) {
			_AL.createSourcePanner(this);
		}
		if (this.panner) this.panner.coneOuterAngle = val;
	}
};

/**
* @constructor
*/
function _ALCdevice(device){
	this._device=device;
}

/**
* @constructor
*/
function _ALCcontext(device){
	var ctx = new device._device();
	window['wa'] = ctx;
	if (typeof ctx.createGain === 'undefined') ctx.createGain = ctx.createGainNode;

	var gain = ctx.createGain();
    gain.connect(ctx.destination);

	_AL.contexts.push(new _ALContext(ctx, gain));
	this._context=_AL.contexts.length;
}

function _alEmptyFunction(){
	for (var i = 0; i < arguments.length; ++i) {
		if (Array.isArray(arguments[i])) {
			for (var j = 0; j < arguments.length; ++j) {
				arguments[i][j] = 0;
			}
		}
	}

	return 0;
}

function _alEmptyErrorFunction(){
	if (!_AL.currentContext) return;
	_AL.currentContext.err = 0xA002 /* AL_INVALID_ENUM */;
	return _alEmptyFunction.apply(this, arguments);
}

function alGenBuffers(count, result) {
	if (!_AL.currentContext) {
		for (var i = 0; i < count; ++i) {
			result[i] = 0;
		}
	}

	for (var i = 0; i < count; ++i) {
		_AL.currentContext.buf.push(null);
		result[i] = _AL.currentContext.buf.length;
	}
}

function alGenBuffer() {
	var result = [0];
	alGenBuffers(1, result);
	return result[0];
}

function alDeleteBuffers(count, buffers) {
	if (!_AL.currentContext) return;

	if (count > _AL.currentContext.buf.length) {
		_AL.currentContext.err = 0xA003 /* AL_INVALID_VALUE */;
		return;
	}

	for (var i = 0; i < count; ++i) {
		var bufferIdx = buffers[i] - 1;

		// Make sure the buffer index is valid.
		if (bufferIdx >= _AL.currentContext.buf.length || !_AL.currentContext.buf[bufferIdx]) {
			_AL.currentContext.err = 0xA001 /* AL_INVALID_NAME */;
			return;
		}

		// Make sure the buffer is no longer in use.
		var buffer = _AL.currentContext.buf[bufferIdx];
		for (var srcId in _AL.currentContext.src) {
			var src = _AL.currentContext.src[srcId];
			if (!src) continue;

			for (var k = 0; k < src.queue.length; k++) {
				if (buffer === src.queue[k].buffer) {
					_AL.currentContext.err = 0xA004 /* AL_INVALID_OPERATION */;
					return;
				}
			}
		}
    }

	for (var i = 0; i < count; ++i) {
		delete _AL.currentContext.buf[buffers[i] - 1];
	}
}

function alDeleteBuffer(buffer) {
	alDeleteBuffers(1, [buffer]);
}

function alIsBuffer(buffer) {
	if (!_AL.currentContext) return 0;
    if (buffer > _AL.currentContext.buf.length) return 0;
	if (typeof _AL.currentContext.buf[buffer - 1] === 'undefined') return 0;
	return 1;
}

function _alBufferData(buffer, format, data, size, from, freq) {
	if (!_AL.currentContext) return;
	if (buffer > _AL.currentContext.buf.length) return;

	if (data instanceof AudioBuffer) {
		if (!data.bytesPerSample) {
			data.bytesPerSample = Math.ceil(((data.sampleRate * data.duration) / data.length));
		}
		data.ptich = 1.0;
		data.id = buffer;
		_AL.currentContext.buf[buffer - 1] = data;
	} else {
		var info = [];
		_AL.getFormatInfo(format, info);
		var channels = info[0];
		var bytes = info[1];

		var audioBuffer = _AL.currentContext.buf[buffer - 1];

		if (!audioBuffer || audioBuffer.bytesPerSample !== bytes || audioBuffer.numberOfChannels !== channels || audioBuffer.sampleRate !== freq || audioBuffer.length !== size / (bytes * channels)) {
			if (audioBuffer) {
				alDeleteBuffer(buffer);
			}

			try {
				_AL.currentContext.buf[buffer - 1] = _AL.currentContext.ctx.createBuffer(channels, size / (bytes * channels), freq);
				_AL.currentContext.buf[buffer - 1].bytesPerSample =  bytes;
			} catch (e) {
				_AL.currentContext.err = 0xA003 /* AL_INVALID_VALUE */;
				return;
			}

			_AL.currentContext.buf[buffer - 1].id = buffer;
			_AL.currentContext.buf[buffer - 1].pitch = 1.0;
		}

		var buf = new Array(channels);
		for (var i = 0; i < channels; ++i) {
			buf[i] = _AL.currentContext.buf[buffer - 1].getChannelData(i);
		}

		switch (bytes) {
			case 1:
				data = data.bytes;

				for (var i = 0, l = size / (bytes * channels); i < l; ++i) {
					for (var j = 0; j < channels; ++j) {
						buf[j][i] = data[from+i*channels+j] / 128;
					}
				}
				break;

			case 2:
				from >>= 1;
				data = data.shorts;

				for (var i = 0, l = size / (bytes * channels); i < l; ++i) {
					for (var j = 0; j < channels; ++j) {
						buf[j][i] = data[from+i*channels+j] / 32768;
					}
				}
				break;

			case 4:
				from >>= 2;
				data = data.floats;

				for (var i = 0, l = size / (bytes * channels); i < l; ++i) {
					for (var j = 0; j < channels; ++j) {
						buf[j][i] = data[from+i*channels+j];
					}
				}
				break;
		}
	}
}

function alBufferData(buffer, format, data, size, freq) {
	_alBufferData(buffer, format, data, size, 0, freq);
}

function alBufferData2(buffer, format, data, size, from, freq) {
	_alBufferData(buffer, format, data, size, from, freq);
}

function alUploadBufferData(path, buffer, data, listener, format, freq, values) {
	if (!_AL.currentContext) return;

	BBHtml5Game.Html5Game().LoadAudioData(BBGame.Game().PathToUrl(path), (function(decodedData) {
		if (decodedData) {
			var channels, bytes;

			if (format !== 0 || freq !== 0) {
				if (format !== 0) {
					var info = [];
					_AL.getFormatInfo(format, info);
					channels = info[0];
					bytes = info[1];
				} else {
					channels = decodedData.numberOfChannels;
					bytes = Math.ceil(((decodedData.sampleRate * decodedData.duration) / decodedData.length));
				}

				if (channels !== decodedData.numberOfChannels || bytes !== Math.ceil(((decodedData.sampleRate * decodedData.duration) / decodedData.length))) {
					var audioBuffer = _AL.currentContext.ctx.createBuffer(channels, decodedData.length, freq ? freq : decodedData.sampleRate);
					audioBuffer.bytesPerSample = bytes;
					decodedData = _AL.convertBuffer(decodedData, audioBuffer);
				} else if (freq !== 0 && freq !== decodedData.sampleRate) {
					var audioBuffer = _AL.currentContext.ctx.createBuffer(channels, decodedData.length, freq);
					audioBuffer.bytesPerSample = bytes;

					for (var i = 0; i < decodedData.numberOfChannels; ++i) {
						audioBuffer.getChannelData(i).set(decodedData.getChannelData(i));
					}

					decodedData = audioBuffer;
				}
			}

			if (data) {
				var channels = decodedData.numberOfChannels;
				var bytes = decodedData.bytesPerSample;
				var size = decodedData.length * bytes * decodedData.numberOfChannels;

				data.Discard();
				data._New(size);

				var buf = new Array(channels);
				for (var i = 0; i < channels; ++i) {
					buf[i] = decodedData.getChannelData(i);
				}

				switch (bytes) {
					case 1:
						data = data.bytes;

						for (var i = 0, l = size / (bytes * channels); i < l; ++i) {
							for (var j = 0; j < channels; ++j) {
								data[i*channels+j] = buf[j][i] * 128;
							}
						}

						break;

					case 2:
						data = data.shorts;

						for (var i = 0, l = size / (bytes * channels); i < l; ++i) {
							for (var j = 0; j < channels; ++j) {
								data[i*channels+j] = buf[j][i] * 32768;
							}
						}

						break;

					case 4:
						data = data.floats;

						for (var i = 0, l = size / (bytes * channels); i < l; ++i) {
							for (var j = 0; j < channels; ++j) {
								data[i*channels+j] = buf[j][i];
							}
						}
				}
			}

			if (buffer) {
				_alBufferData(buffer, 0, decodedData, 0, 0, 0);
			} else if (values.length == 3) {
				values[0] = decodedData.numberOfChannels;
				values[1] = decodedData.bytesPerSample;
				values[2] = decodedData.sampleRate;
			}

			if (listener) listener.handleEvent();
		}
	}).bind(this));
}

function alGetBufferf(buffer, param, value) {
	if (!_AL.currentContext) return;
	_AL.currentContext.err = 0xA002;

	var buf = _AL.currentContext.buf[buffer - 1];
	if (!buf) {
		_AL.currentContext.err = 0xA001 /* AL_INVALID_NAME */;
		return;
	}
}

function alGetBufferi(buffer, param, value) {
	if (!_AL.currentContext) return;

	var buf = _AL.currentContext.buf[buffer - 1];
	if (!buf) {
		_AL.currentContext.err = 0xA001 /* AL_INVALID_NAME */;
		return;
	}

	switch (param) {
		case 0x2001 /* AL_FREQUENCY */:
			value[0] = buf.sampleRate;
			break;
		case 0x2002 /* AL_BITS */:
			value[0] = buf.bytesPerSample * 8;
			break;
		case 0x2003 /* AL_CHANNELS */:
			value[0] = buf.numberOfChannels;
			break;
		case 0x2004 /* AL_SIZE */:
			value[0] = buf.length * buf.bytesPerSample * buf.numberOfChannels;
			break;
		default:
			_AL.currentContext.err = 0xA002 /* AL_INVALID_ENUM */;
			break;
    }
}

function alGenSources(count, result) {
	if (!_AL.currentContext) return;

	for (var i = 0; i < count; ++i) {
		var gain = _AL.currentContext.ctx.createGain();
		gain.connect(_AL.currentContext.gain);

		var src = _AL.currentContext.src[_AL.newSrcId] = new _ALSource(gain);
		result[i] = _AL.newSrcId;
		_AL.newSrcId++;
	}
}

function alGenSource() {
	var result = [0];
	alGenSources(1, result);
	return result[0];
}

function alDeleteSources(count, sources) {
	if (!_AL.currentContext) return;

	for (var i = 0; i < count; ++i) {
		delete _AL.currentContext.src[sources[i]];
	}
}

function alDeleteSource(source) {
	alDeleteSources(1, [source]);
}

function alIsSource(source) {
	if (!_AL.currentContext) return 0;
	if (!_AL.currentContext.src[source]) return 0;
	return 1;
}

function alSourcef(source, param, value) {
	if (!_AL.currentContext) return;

	var src = _AL.currentContext.src[source];
	if (!src) {
		_AL.currentContext.err = 0xA001 /* AL_INVALID_NAME */;
		return;
	}

	switch (param) {
		case 0x1003 /* AL_PITCH */:
			if (src._pitch === value) return;
			src.pitch = value;
			_AL.updateSource(src);
			break;
		case 0x100A /* AL_GAIN */:
			src.gain.gain.value = value;
			break;
		case 0x100D /* AL_MIN_GAIN */:
			break;
		case 0x100E /* AL_MAX_GAIN */:
			break;
		case 0x1023 /* AL_MAX_DISTANCE */:
			src.maxDistance = value;
			break;
		case 0x1021 /* AL_ROLLOFF_FACTOR */:
			src.rolloffFactor = value;
			break;
		case 0x1022 /* AL_CONE_OUTER_GAIN */:
			src.coneOuterGain = value;
			break;
		case 0x1020 /* AL_REFERENCE_DISTANCE */:
			src.refDistance = value;
			break;
		case 0x1024 /* AL_SEC_OFFSET */:
			if (value < 0) return;
			if (src.secOffset === value) return;

			src.secOffset = value;
			src.byteOffset = -1;
			src.sampleOffset = -1;
			_AL.updateSource(src);
		default:
			_AL.currentContext.err = 0xA002 /* AL_INVALID_ENUM */;
		break;
	}
}

function alSourcefv(source, param, values) {
	alSource3f(source, param, values[0], values[1], values[2]);
}

function alSource3f(source, param, v1, v2, v3) {
	if (!_AL.currentContext) return;

	var src = _AL.currentContext.src[source];
	if (!src) {
		_AL.currentContext.err = 0xA001 /* AL_INVALID_NAME */;
		return;
	}

	switch (param) {
		case 0x1004 /* AL_POSITION */:
			src.position = [v1, v2, v3];
			if (!src.panner) _AL.createSourcePanner(src, 'equalpower', 'linear');
			break;
		case 0x1005 /* AL_DIRECTION */:
			src.direction = [v1, v2, v3];
			if (!src.panner) _AL.createSourcePanner(src, 'equalpower', 'linear');
			break;
		case 0x1006 /* AL_VELOCITY */:
			src.velocity = [v1, v2, v3];
			if (!src.panner) _AL.createSourcePanner(src, 'equalpower', 'linear');
			break;
		default:
			_AL.currentContext.err = 0xA002 /* AL_INVALID_ENUM */;
		break;
	}
}

function alSourcei(source, param, value) {
	if (!_AL.currentContext) return;

	var src = _AL.currentContext.src[source];
	if (!src) {
		_AL.currentContext.err = 0xA001 /* AL_INVALID_NAME */;
		return;
	}

	switch (param) {
		case 0x1001 /* AL_CONE_INNER_ANGLE */:
			src.coneInnerAngle = value;
			break;
		case 0x1002 /* AL_CONE_OUTER_ANGLE */:
			src.coneOuterAngle = value;
			break;
		case 0x1007 /* AL_LOOPING */:
			src.loop = (value === 1 /* AL_TRUE */);
			break;
		case 0x1009 /* AL_BUFFER */:
			var buffer = (value != 0) ? _AL.currentContext.buf[value - 1] : null;

			if (!buffer || !(buffer instanceof AudioBuffer)) {
				src.queue = [];
			} else {
				src.queue = [{ buffer: buffer }];
			}

			_AL.updateSource(src);
			break;
		case 0x202 /* AL_SOURCE_RELATIVE */:
			if (value === 1 /* AL_TRUE */ || value === 0 /* AL_FALSE */) {
				src.relative = value;

				if (!src.panner) {
					_AL.createSourcePanner(src);
				}
			} else {
				_AL.currentContext.err = 0xA003 /* AL_INVALID_VALUE */;
			}
			break;
		case 0x1025 /* AL_SAMPLE_OFFSET */:
			if (value < 0) return;
			if (src.sampleOffset === value) return;

			src.sampleOffset = value;
			src.byteOffset = -1;
			src.secOffset = -1;
			_AL.updateSource(src);
			break;
		case 0x1026 /* AL_BYTE_OFFSET */:
			if (value < 0) return;
			if (src.byteOffset === value) return;

			src.byteOffset = value;
			src.sampleOffset = -1;
			src.secOffset = -1;
			_AL.updateSource(src);
			break;
		default:
			_AL.currentContext.err = 0xA002 /* AL_INVALID_ENUM */;
			break;
	}
}

function alGetSourcef(source, param, value) {
    if (!_AL.currentContext) return;

	var src = _AL.currentContext.src[source];
	if (!src) {
		_AL.currentContext.err = 0xA001 /* AL_INVALID_NAME */;
		return;
	}

	switch (param) {
		case 0x1003 /* AL_PITCH */:
			value[0] = src.pitch;
			break;
		case 0x100A /* AL_GAIN */:
			value[0] = src.gain.gain.value;
			break;
		case 0x100D /* AL_MIN_GAIN */:
			value[0] = 0.0;
			break;
		case 0x100E /* AL_MAX_GAIN */:
			value[0] = 0.0;
			break;
		case 0x1023 /* AL_MAX_DISTANCE */:
			value[0] = src.maxDistance;
			break;
		case 0x1021 /* AL_ROLLOFF_FACTOR */:
			value[0] = src.rolloffFactor;
			break;
		case 0x1022 /* AL_CONE_OUTER_GAIN */:
			value[0] = src.coneOuterGain;
			break;
		case 0x1020 /* AL_REFERENCE_DISTANCE */:
			value[0] = src.refDistance;
			break;
		case 0x1024 /* AL_SEC_OFFSET */:
			if (src.state === 0x1012 /* AL_PLAYING */ || src.state === 0x1013 /* AL_PAUSED */) {
				var totalLength = 0.0;
				var currentPos = 0.0;

				if (!src.loop) {
					for (var i = 0; i < src.queue.length; i++) {
						totalLength += src.queue[i].buffer.duration * src.pitch;
					}

					for (var i = 0; i < src.buffersPlayed; i++) {
						currentPos += src.queue[i].buffer.duration * src.pitch;
					}
				} else {
					totalLength = src.queue[src.buffersPlayed].buffer.duration * src.pitch;
				}

				if (src.state === 0x1012 /* AL_PLAYING */) {
					currentPos += (_AL.currentContext.ctx.currentTime - src.bufferPosition) * src.pitch;
				} else {
					currentPos += src.bufferPosition;
				}

				value[0] = Math.min(currentPos, totalLength);
			} else {
				value[0] = 0.0;
			}
			break;
		default:
			_AL.currentContext.err = 0xA002 /* AL_INVALID_ENUM */;
			break;
	}
}

function alGetSourcefv(source, param, values) {
    if (!_AL.currentContext) return;

	var src = _AL.currentContext.src[source];
	if (!src) {
		_AL.currentContext.err = 0xA001 /* AL_INVALID_NAME */;
		return;
	}

	switch (param) {
		case 0x1003 /* AL_PITCH */:
		case 0x100A /* AL_GAIN */:
		case 0x100D /* AL_MIN_GAIN */:
		case 0x100E /* AL_MAX_GAIN */:
		case 0x1023 /* AL_MAX_DISTANCE */:
		case 0x1021 /* AL_ROLLOFF_FACTOR */:
		case 0x1022 /* AL_CONE_OUTER_GAIN */:
		case 0x1001 /* AL_CONE_INNER_ANGLE */:
		case 0x1002 /* AL_CONE_OUTER_ANGLE */:
		case 0x1020 /* AL_REFERENCE_DISTANCE */:
		case 0x1024 /* AL_SEC_OFFSET */:
		case 0x1025 /* AL_SAMPLE_OFFSET */:
		case 0x1026 /* AL_BYTE_OFFSET */:
			alGetSourcef(source, param, values);
			break;
		case 0x1004 /* AL_POSITION */:
			var position = src.position;
			values[0] = position[0];
			values[1] = position[1];
			values[2] = position[2];
			break;
		case 0x1005 /* AL_DIRECTION */:
			var direction = src.direction;
			values[0] = direction[0];
			values[1] = direction[1];
			values[2] = direction[2];
			break;
		case 0x1006 /* AL_VELOCITY */:
			var velocity = src.velocity;
			values[0] = velocity[0];
			values[1] = velocity[1];
			values[2] = velocity[2];
			break;
		default:
			_AL.currentContext.err = 0xA002 /* AL_INVALID_ENUM */;
			break;
	}
}

function alGetSourcei(source, param, value) {
	if (!_AL.currentContext) return;

	var src = _AL.currentContext.src[source];
	if (!src) {
		_AL.currentContext.err = 0xA001 /* AL_INVALID_NAME */;
		return;
	}

	switch (param) {
		case 0x202 /* AL_SOURCE_RELATIVE */:
			value[0] = src.relative;
		break;
		case 0x1001 /* AL_CONE_INNER_ANGLE */:
			value[0] = src.coneInnerAngle;
			break;
		case 0x1002 /* AL_CONE_OUTER_ANGLE */:
			value[0] = src.coneOuterAngle;
			break;
		case 0x1007 /* AL_LOOPING */:
			value[0] = src.loop;
			break;
		case 0x1009 /* AL_BUFFER */:
			if (!src.queue.length) {
				value[0] = 0;
			} else {
				if (src.queue[src.buffersPlayed]) {
					value[0] = src.queue[src.buffersPlayed].buffer.id;
				} else {
					value[0] = 0;
				}
			}
			break;
		case 0x1010 /* AL_SOURCE_STATE */:
			value[0] = src.state;
			break;
		case 0x1015 /* AL_BUFFERS_QUEUED */:
			value[0] = src.queue.length;
			break;
		case 0x1016 /* AL_BUFFERS_PROCESSED */:
			if (src.loop) {
				value[0] = 0;
			} else {
				value[0] = src.buffersPlayed;
			}
			break;
		case 0x1025 /* AL_SAMPLE_OFFSET */:
			if (src.state === 0x1012 /* AL_PLAYING */ || src.state === 0x1013 /* AL_PAUSED */) {
				var totalLength = 0;
				var currentPos = 0;

				if (!src.loop) {
					for (var i = 0; i < src.queue.length; i++) {
						totalLength += src.queue[i].buffer.length;
					}

					for (var i = 0; i < src.buffersPlayed; i++) {
						currentPos += src.queue[i].buffer.length;
					}
				} else {
					totalLength = src.queue[src.buffersPlayed].buffer.length;
				}

				if (src.state === 0x1012 /* AL_PLAYING */) {
					currentPos += _AL.secToSamples(_AL.currentContext.ctx.currentTime - src.bufferPosition, src.queue[src.buffersPlayed].buffer);
				} else {
					currentPos += _AL.secToSamples(src.bufferPosition / src.pitch, src.queue[src.buffersPlayed].buffer);
				}

				value[0] = Math.min(currentPos, totalLength - 1);
			} else {
				value[0] = 0;
			}
			break;
		case 0x1026 /* AL_BYTE_OFFSET */:
			if (src.state === 0x1012 /* AL_PLAYING */ || src.state === 0x1013 /* AL_PAUSED */) {
				var totalLength = 0;
				var currentPos = 0;
				var buffer = src.queue[src.buffersPlayed].buffer;

				if (!src.loop) {
					for (var i = 0; i < src.queue.length; i++) {
						var buffer = src.queue[i].buffer;
						totalLength += buffer.bytesPerSample * buffer.numberOfChannels * buffer.length;
					}

					for (var i = 0; i < src.buffersPlayed; i++) {
						var buffer = src.queue[i].buffer;
						currentPos += buffer.bytesPerSample * buffer.numberOfChannels * buffer.length;
					}
				} else {
					totalLength = buffer.bytesPerSample * buffer.numberOfChannels * buffer.length;
				}

				if (src.state === 0x1012 /* AL_PLAYING */) {
					currentPos += _AL.secToBytes(_AL.currentContext.ctx.currentTime - src.bufferPosition, buffer);
				} else {
					currentPos += _AL.secToBytes(src.bufferPosition / src.pitch, buffer);
				}

				value[0] = Math.min(currentPos, totalLength - buffer.bytesPerSample * buffer.numberOfChannels);
			} else {
				value[0] = 0;
			}
			break;
		default:
			_AL.currentContext.err = 0xA002 /* AL_INVALID_ENUM */;
			break;
	}
}

function alGetSourceiv(source, param, values) {
    if (!_AL.currentContext) return;

	var src = _AL.currentContext.src[source];
	if (!src) {
		_AL.currentContext.err = 0xA001 /* AL_INVALID_NAME */;
		return;
	}

	switch (param) {
		case 0x202 /* AL_SOURCE_RELATIVE */:
		case 0x1001 /* AL_CONE_INNER_ANGLE */:
		case 0x1002 /* AL_CONE_OUTER_ANGLE */:
		case 0x1007 /* AL_LOOPING */:
		case 0x1009 /* AL_BUFFER */:
		case 0x1010 /* AL_SOURCE_STATE */:
		case 0x1015 /* AL_BUFFERS_QUEUED */:
		case 0x1016 /* AL_BUFFERS_PROCESSED */:
			alGetSourcei(source, param, values);
			break;
		default:
			_AL.currentContext.err = 0xA002 /* AL_INVALID_ENUM */;
			break;
	}
}

function alSourcePlay(source) {
	if (!_AL.currentContext) return;

	var src = _AL.currentContext.src[source];
	if (!src) {
		_AL.currentContext.err = 0xA001 /* AL_INVALID_NAME */;
		return;
	}

	_AL.setSourceState(src, 0x1012 /* AL_PLAYING */);
}


function alSourcePlayv(count, sources) {
	if (!_AL.currentContext) return;

	for (var i = 0; i < count; ++i) {
		var src = _AL.currentContext.src[sources[i]];
		if (!src) {
			_AL.currentContext.err = 0xA001 /* AL_INVALID_NAME */;
			continue;
		}

		_AL.setSourceState(src, 0x1012 /* AL_PLAYING */);
	}
}

function alSourcePause(source) {
	if (!_AL.currentContext) return;

	var src = _AL.currentContext.src[source];
	if (!src) {
		_AL.currentContext.err = 0xA001 /* AL_INVALID_NAME */;
		return;
	}

	_AL.setSourceState(src, 0x1013 /* AL_PAUSED */);
}


function alSourcePausev(count, sources) {
	if (!_AL.currentContext) return;

	for (var i = 0; i < count; ++i) {
		var src = _AL.currentContext.src[sources[i]];
		if (!src) {
			_AL.currentContext.err = 0xA001 /* AL_INVALID_NAME */;
			continue;
		}

		_AL.setSourceState(src, 0x1013 /* AL_PAUSED */);
	}
}

function alSourceStop(source) {
	if (!_AL.currentContext) return;

	var src = _AL.currentContext.src[source];
	if (!src) {
		_AL.currentContext.err = 0xA001 /* AL_INVALID_NAME */;
		return;
	}

	_AL.setSourceState(src, 0x1014 /* AL_STOPPED */);
}

function alSourceStopv(count, sources) {
	if (!_AL.currentContext) return;

	for (var i = 0; i < count; ++i) {
		var src = _AL.currentContext.src[sources[i]];
		if (!src) {
			_AL.currentContext.err = 0xA001 /* AL_INVALID_NAME */;
			continue;
		}

		_AL.setSourceState(src, 0x1014 /* AL_STOPPED */);
	}
}

function alSourceRewind(source) {
	if (!_AL.currentContext) return;

	var src = _AL.currentContext.src[source];
	if (!src) {
		_AL.currentContext.err = 0xA001 /* AL_INVALID_NAME */;
		return;
	}

	_AL.setSourceState(src, 0x1014 /* AL_STOPPED */);
	_AL.setSourceState(src, 0x1011 /* AL_INITIAL */);
}

function alSourceRewindv(count, sources) {
	if (!_AL.currentContext) return;

	for (var i = 0; i < count; ++i) {
		var src = _AL.currentContext.src[sources[i]];
		if (!src) {
			_AL.currentContext.err = 0xA001 /* AL_INVALID_NAME */;
			continue;
		}

		_AL.setSourceState(src, 0x1014 /* AL_STOPPED */);
		_AL.setSourceState(src, 0x1011 /* AL_INITIAL */);
	}
}


function alSourceQueueBuffers(source, count, buffers) {
	if (!_AL.currentContext) return;

	var src = _AL.currentContext.src[source];
	if (!src) {
		_AL.currentContext.err = 0xA001 /* AL_INVALID_NAME */;
		return;
	}

	for (var i = 0; i < count; ++i) {
		if (buffers[i] > _AL.currentContext.buf.length) {
			_AL.currentContext.err = 0xA001 /* AL_INVALID_NAME */;
			return;
		}
	}

	for (var i = 0; i < count; ++i) {
		var buffer = _AL.currentContext.buf[buffers[i] - 1];
		src.queue.push({ buffer: buffer, src: null });
	}

	_AL.updateSource(src);
}

function alSourceUnqueueBuffers(source, count, buffers) {
	if (!_AL.currentContext) return;

	var src = _AL.currentContext.src[source];
	if (!src) {
		_AL.currentContext.err = 0xA001 /* AL_INVALID_NAME */;
		return;
	}

	for (var i = 0; i < count; ++i) {
		if (buffers[i] > _AL.currentContext.buf.length) {
			_AL.currentContext.err = 0xA001 /* AL_INVALID_NAME */;
			return;
		}
	}

	for (var i = 0; i < count; ++i) {
		var entry = src.queue.shift();
		buffers[i] = entry.buffer.id;
		src.buffersPlayed--;
	}

	_AL.updateSource(src);
}

function alListenerf(param, value) {
	if (!_AL.currentContext) return;

	switch (param) {
		case 0x100A /* AL_GAIN */:
			_AL.currentContext.gain.gain.value = value;
			break;
		default:
			_AL.currentContext.err = 0xA002 /* AL_INVALID_ENUM */;
	}
}

function alListener3f(param, v1, v2, v3) {
	if (!_AL.currentContext) return;

	switch (param) {
		case 0x1004 /* AL_POSITION */:
			_AL.currentContext.ctx.listener._position = [v1, v2, v3];
			_AL.currentContext.ctx.listener.setPosition(v1, v2, v3);

			_AL.updateSourcesPanner(_AL.currentContext);
			break;
		case 0x1006 /* AL_VELOCITY */:
			_AL.currentContext.ctx.listener._velocity = [v1, v2, v3];
			//_AL.currentContext.ctx.listener.setVelocity(v1, v2, v3);

			_AL.updateSourcesPanner(_AL.currentContext);
			break;
		default:
			_AL.currentContext.err = 0xA002 /* AL_INVALID_ENUM */;
	}
}

function alListenerfv(param, values) {
	if (!_AL.currentContext) return;

	switch (param) {
		case 0x1004 /* AL_POSITION */:
			_AL.currentContext.ctx.listener._position = [values[0], values[1], values[2]];
			_AL.currentContext.ctx.listener.setPosition(values[0], values[1], values[2]);

			_AL.updateSourcesPanner(_AL.currentContext);
			break;
		case 0x1006 /* AL_VELOCITY */:
			_AL.currentContext.ctx.listener._velocity = [values[0], values[1], values[2]];
			//_AL.currentContext.ctx.listener.setVelocity(values[0], values[1], values[2]);

			_AL.updateSourcesPanner(_AL.currentContext);
			break;
		case 0x100F /* AL_ORIENTATION */:
			_AL.currentContext.ctx.listener._orientation = [values[0], values[1], values[2], values[3], values[4], values[5]];
			_AL.currentContext.ctx.listener.setOrientation(values[0], values[1], values[2], values[3], values[4], values[5]);

			_AL.updateSourcesPanner(_AL.currentContext);
			break;
		default:
			_AL.currentContext.err = 0xA002 /* AL_INVALID_ENUM */;
	}
}

function alGetListenerf(param, value) {
	if (!_AL.currentContext) return;

	switch (param) {
		case 0x100A /* AL_GAIN */:
			value[0] = _AL.currentContext.gain.gain.value;
			break;
		default:
			_AL.currentContext.err = 0xA002 /* AL_INVALID_ENUM */;
	}
}

function alGetListenerfv(param, values) {
	if (!_AL.currentContext) return;

	var result = null;

	switch (param) {
		case 0x1004 /* AL_POSITION */:
			result = _AL.currentContext.ctx.listener._position || [0,0,0];
			break;
		case 0x1006 /* AL_VELOCITY */:
			result = _AL.currentContext.ctx.listener._velocity || [0,0,0];
			break;
		case 0x100F /* AL_ORIENTATION */:
			result = _AL.currentContext.ctx.listener._orientation || [0,0,-1,0,1,0];
			break;
		default:
			_AL.currentContext.err = 0xA002 /* AL_INVALID_ENUM */;
	}

	if (result) {
		for (var i = 0; i < result.length; ++i) {
			values[i] = result[i];
		}
	}
}

function alDistanceModel(model) {
	if (!_AL.currentContext) return;
	if (_AL.currentContext.distanceModel === model) return;

	switch (model) {
		case 0xD001:
		case 0xD002:
			_AL.currentContext._distanceModel = 'inverse';
			break;
		case 0xD003:
		case 0xD004:
			_AL.currentContext._distanceModel = 'linear';
			break;
		case 0xD005:
		case 0xD006:
			_AL.currentContext._distanceModel = 'exponential';
			break;
	}

	_AL.currentContext.distanceModel = model;

	//clear cache
	if (_AL.currentContext.ctx.listener._position) {
		var v = _AL.currentContext.ctx.listener._position;
		_AL.currentContext.ctx.listener.setPosition(v[0]+1, 0, 0);
		_AL.currentContext.ctx.listener.setPosition(v[0], v[1], v[2]);
	} else {
		_AL.currentContext.ctx.listener.setPosition(-1, 0, 0);
		_AL.currentContext.ctx.listener.setPosition(1, 0, 0);
	}

	_AL.updateSourcesPanner(_AL.currentContext);
}

function alGetFloatv(param, value) {
	if (!_AL.currentContext) return;

	switch (param) {
		case 0xC000 /* AL_DOPPLER_FACTOR */:
			value[0] = _AL.currentContext.ctx.listener.dopplerFactor;
			break;
		case 0xC001 /* AL_DOPPLER_VELOCITY */:
			value[0] = _AL.currentContext.ctx.listener.speedOfSound;
			break;
		case 0xC003 /* AL_SPEED_OF_SOUND */:
			value[0] = 343.29998779296875;
			break;
		default:
			_AL.currentContext.err = 0xA002 /* AL_INVALID_ENUM */;
	}
}

function alGetIntegerv(param, value) {
	if (!_AL.currentContext) return;

	switch (param) {
		case 0xD000 /* AL_DISTANCE_MODEL */:
			value[0] = _AL.currentContext.distanceModel;
			break;
		default:
			_AL.currentContext.err = 0xA002 /* AL_INVALID_ENUM */;
	}
}

function alGetString(param) {
	switch (param) {
		case 0 /* AL_NO_ERROR */:
			return 'No Error';
			break;
		case 0xA001 /* AL_INVALID_NAME */:
			return 'Invalid Name';
			break;
		case 0xA002 /* AL_INVALID_ENUM */:
			return 'Invalid Enum';
			break;
		case 0xA003 /* AL_INVALID_VALUE */:
			return 'Invalid Value';
			break;
		case 0xA004 /* AL_INVALID_OPERATION */:
			return 'Invalid Operation';
			break;
		case 0xA005 /* AL_OUT_OF_MEMORY */:
			return 'Out of Memory';
			break;
		case 0xB001 /* AL_VENDOR */:
			return 'Mungo';
			break;
		case 0xB002 /* AL_VERSION */:
			return '1.1';
			break;
		case 0xB003 /* AL_RENDERER */:
			return 'WebAudio';
			break;
		case 0xB004 /* AL_EXTENSIONS */:
			return '';
			break;
		default:
			_AL.currentContext.err = 0xA002 /* AL_INVALID_ENUM */;
			return 0;
	}
}

function alDopplerFactor(value) {
	_AL.currentContext.ctx.listener.dopplerFactor = value;
}

function alDopplerVelocity(value) {
	_AL.currentContext.ctx.listener.speedOfSound = value;
}

function alGetError() {
	if (!_AL.currentContext) {
		return 0xA004 /* AL_INVALID_OPERATION */;
	} else {
		// Reset error on get.
		var err = _AL.currentContext.err;
		_AL.currentContext.err = 0 /* AL_NO_ERROR */;
		return err;
	}
}

function alIsExtensionPresent(extension) {
	if (extension == "AL_EXT_float32") return 1;
	return 0;
}

function alGetEnumValue(enumName) {
	if (enumName == "AL_FORMAT_MONO_FLOAT32") return 0x10010;
	if (enumName == "AL_FORMAT_STEREO_FLOAT32") return 0x10011;

	_AL.currentContext.err = 0xA003 /* AL_INVALID_VALUE */;
	return 0;
}

function alcCreateContext(device) {
	if (!device) return null;
	return new _ALCcontext(device);
}

function alcMakeContextCurrent(context) {
	if (context) {
		_AL.currentContext = _AL.contexts[context._context - 1];
		return true;
	}

	_AL.currentContext = null;
	return false;
}

function alcProcessContext(context) {
	if (context && _AL.contexts[context._context - 1]) {
		var context = _AL.contexts[context._context - 1];

		if (context.ctx.state === 'suspended' && typeof context.ctx.resume === 'function') {
			context.ctx.resume();
		} else {
			var oldContext = _AL.currentContext;
			_AL.currentContext = context;

			for (var srcId in context.src) {
				var src = context.src[srcId];
				if (src.state == 0x1013 /* AL_PAUSED */) {
					_AL.setSourceState(src, 0x1012 /* AL_PLAYING */);
				}
			}

			_AL.currentContext = oldContext;
		}
	}
}

function alcSuspendContext(context) {
	if (context && _AL.contexts[context._context - 1]) {
		var context = _AL.contexts[context._context - 1];

		if (context.ctx.state === 'running' && typeof context.ctx.suspend === 'function') {
			context.ctx.suspend();
		} else {
			var oldContext = _AL.currentContext;
			_AL.currentContext = context;

			for (var srcId in context.src) {
				var src = context.src[srcId];
				if (src.state == 0x1012 /* AL_PLAYING */) {
					_AL.setSourceState(src, 0x1013 /* AL_PAUSED */);
				}

			}

			_AL.currentContext = oldContext;
		}
	}
}

function alcDestroyContext(context) {
	if (context && _AL.contexts[context._context - 1]) {
		var context = _AL.contexts[context._context - 1];
		_AL.stopSources(context);
		context.gain.disconnect();
		if (typeof context.ctx.close === 'function') {
			context.ctx.close();
		}
		_AL.contexts[context._context - 1] = null;
		return 0;
	}

	return 0xA002 /* AL_INVALID_ENUM */;
}

function alcOpenDevice(deviceSpecifier) {
	if (typeof AudioContext !== 'undefined') return new _ALCdevice(AudioContext);
	if (typeof webkitAudioContext !== 'undefined') return new _ALCdevice(webkitAudioContext);
	return null;
}

function alcCloseDevice(device) {
	for (var i = 0; i < _AL.contexts.length; i++) {
		if (_AL.contexts[i]) alcDestroyContext(_AL.contexts[i]);
	}
}

function alcInitDevice() {
	var wa = window['wa'];
	if (!wa) return;

	var unlock = wa.createBufferSource();
	unlock.buffer = wa.createBuffer(1, 1, 22050);
	unlock.connect(wa.destination);
	unlock.start ? unlock.start(0) : unlock.noteOn(0);
}

function alcGetError() {
	var err = _AL.alcErr;
    _AL.alcErr = 0;
    return err;
}

function alcIsExtensionPresent(device, extension) {
	if (device) {
		return alIsExtensionPresent(extension);
	}

	return 0;
}

function alcGetEnumValue(device, enumName) {
	if (device) {
		return alcGetEnumValue(enumName);
	}

	return 0;
}

function alcGetString(device, param) {
    switch (param) {
		case 0 /* ALC_NO_ERROR */:
			return 'No Error';
			break;
		case 0xA001 /* ALC_INVALID_DEVICE */:
			return 'Invalid Device';
		break;
		case 0xA002 /* ALC_INVALID_CONTEXT */:
			return 'Invalid Context';
		break;
		case 0xA003 /* ALC_INVALID_ENUM */:
			return 'Invalid Enum';
		break;
		case 0xA004 /* ALC_INVALID_VALUE */:
			return 'Invalid Value';
		break;
		case 0xA005 /* ALC_OUT_OF_MEMORY */:
			return 'Out of Memory';
		break;
		case 0x1004 /* ALC_DEFAULT_DEVICE_SPECIFIER */:
			if (typeof(AudioContext) !== "undefined" ||
				typeof(webkitAudioContext) !== "undefined") {
				return 'Device';
			} else {
				return 0;
			}
			break;
		case 0x1005 /* ALC_DEVICE_SPECIFIER */:
			if (typeof(AudioContext) !== "undefined" ||
				typeof(webkitAudioContext) !== "undefined") {
				return 'Device\0';
			} else {
				return '\0';
			}
			break;
		case 0x311 /* ALC_CAPTURE_DEFAULT_DEVICE_SPECIFIER */:
			return 0;
			break;
		case 0x310 /* ALC_CAPTURE_DEVICE_SPECIFIER */:
			return '\0'
			break;
		case 0x1006 /* ALC_EXTENSIONS */:
			if (!device) {
				_AL.alcErr = 0xA001 /* ALC_INVALID_DEVICE */;
				return 0;
			}
			break;
		default:
			_AL.alcErr = 0xA003 /* ALC_INVALID_ENUM */;
			return 0;
	}
}
