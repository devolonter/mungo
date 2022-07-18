
//${METADATA_BEGIN}
//${METADATA_END}

var PRELOADER_CACHE = {
	IMAGES: {},
	AUDIO: {},
	TEXT: {}
};

(function () {
	var deviceiOS = /iP[ao]d|iPhone/i.test(navigator.userAgent);

	var canvas = document.getElementById('GameCanvas');
	var parent = canvas.parentNode;
	parent.removeChild(canvas);

	var preloader = document.createElement('div');
	preloader.id = 'GameCanvas';
	preloader.style.position = 'relative';
	parent.appendChild(preloader);

	if (CANVAS_RESIZE_MODE === 0 || CANVAS_RESIZE_MODE === 2) {
		preloader.updateSize = function () {
			this.style.width = this.width + 'px';
			this.style.height = this.height + 'px';
		}
	} else if (CANVAS_RESIZE_MODE === 1) {
		preloader.updateSize = function () {
			this.style.width = this.width * (this.clientHeight / this.height) + 'px';
		};
	}

	var progressWrapper = document.getElementById('GameLoadingProgressWrapper');
	var progress = document.getElementById('GameLoadingProgress');

	if (!progressWrapper) {
		progressWrapper = document.createElement('div');
		progressWrapper.id = 'GameLoadingProgressWrapper';

		preloader.appendChild(progressWrapper);
	}

	if (!progress) {
		progress = document.createElement('div');
		progress.id = 'GameLoadingProgress';

		progressWrapper.appendChild(progress);
	}

	var oldOnLoad = window.onload;
	window.onload = null;

	var webAudio = false;

	var totalBytes = PRELOADER_METADATA.MAINJS_FILESIZE;
	var loadedBytes = 0;
	var files = [];

	function updateProgress(file) {
		if (file.complete) return;

		loadedBytes += file.size;
		progress.style.width = ((loadedBytes / totalBytes) * 100) + '%';
		file.complete = true;

		if (loadedBytes >= totalBytes) {
			parent.removeChild(preloader);

			canvas.style.background = 'none';
			parent.appendChild(canvas);

			if (deviceiOS) {
				window.wa = null;
			}

			if (oldOnLoad) oldOnLoad();
			BBMonkeyGame.Main(canvas);
		}
	}

	function loadFile(file) {
		switch (file.type) {
			case 'image':
				var img = new Image();

				img.onload = function () {
					PRELOADER_CACHE.IMAGES[file.url] = this;
					updateProgress(file);
				};

				img.onerror = function () {
					updateProgress(file);
				};

				img.src = file.url;
				break;

			case 'audio':
				if (webAudio) {
					if (!window.wa) {
						if (window.AudioContext) {
							window.wa = new AudioContext();
						} else {
							window.wa = new webkitAudioContext();
						}

					}

					var loadProcess = new XMLHttpRequest();

					loadProcess.open('GET', file.url, true);
					loadProcess.responseType = 'arraybuffer';

					loadProcess.onload = function () {
						if (!window.wa || !window.wa.decodeAudioData) {
							updateProgress(file);
							return;
						}

						var that = this;

						window.wa.decodeAudioData(
							that.response,
							function (buffer) {
								PRELOADER_CACHE.AUDIO[file.url] = buffer;
								updateProgress(file);
							},
							function () {
								updateProgress(file);
							}
						);
					};

					loadProcess.onerror = function () {
						updateProgress(file);
					};

					loadProcess.send();
				} else {
					var audio = new Audio();

					if (!audio) {
						updateProgress(file);
						return;
					}

					var success = function (e) {
						PRELOADER_CACHE.AUDIO[file.url] = audio;
						updateProgress(file);
						audio.removeEventListener('canplaythrough', success, false);
						audio.removeEventListener('error', error, false);
					}

					var error = function (e) {
						updateProgress(file);
						audio.removeEventListener('canplaythrough', success, false);
						audio.removeEventListener('error', error, false);
					}

					audio.addEventListener('canplaythrough', success, false);
					audio.addEventListener('error', error, false);

					audio.src = file.url;
					audio.preload = 'auto';

					var timer = setInterval(function () {
						if (file.complete) {
							clearInterval(timer);
						}
					}, 200);

					audio.load();
				}

				break;

			case 'text':
				var loadProcess = new XMLHttpRequest();

				loadProcess.onload = function () {
					PRELOADER_CACHE.TEXT[file.url] = this.responseText;
					updateProgress(file);
				};

				loadProcess.onerror = function () {
					updateProgress(file);
				};

				loadProcess.open('GET', file.url, true);
				loadProcess.send();

			default:
				var loadProcess = new XMLHttpRequest();

				loadProcess.onload = function () {
					updateProgress(file);
				};

				loadProcess.onerror = function () {
					updateProgress(file);
				};

				loadProcess.open('GET', file.url, true);
				loadProcess.send();
		}
	}

	function excludeAudio(arr) {
		return arr.filter(function (element) {
			return element.type !== 'audio';
		});
	}

	document.addEventListener('DOMContentLoaded', function (event) {
		document.removeEventListener('DOMContentLoaded', this);
		if (oldOnLoad) oldOnLoad();

		var bootstrap = document.createElement('script');
		bootstrap.setAttribute('type', "text/javascript");
		bootstrap.setAttribute('src', 'main.js');
		document.getElementsByTagName('head')[0].appendChild(bootstrap);

		bootstrap.onload = function () {
			var ctx = window.AudioContext;

			if (!ctx) {
				ctx = window.webkitAudioContext;
			}

			webAudio = (window.CFG_HTML5_WEBAUDIO_ENABLED == "1" && ctx && (ctx.prototype.createGain || ctx.prototype.createGainNode)) ? true : false;

			var data = META_DATA.split('\n');
			var tmp_files = [];

			for (var i = 0, l = data.length; i < l; i++) {
				if (data[i].trim() == '') continue;

				var meta = data[i].split(';');

				var file = {
					url: 'data/' + meta[0].substr(1, meta[0].length - 2),
					type: '',
					size: 0,
					complete: false
				};

				for (var j = meta.length - 1; j >= 0; j--) {
					if (meta[j].indexOf('size=') == 0) {
						file.size = parseInt(meta[j].substr(5), 10);

					} else if (meta[j].indexOf('type=') == 0) {
						if (meta[j].indexOf('type=image') == 0) {
							file.type = 'image';
						} else if (meta[j].indexOf('type=audio') == 0) {
							file.type = 'audio';
						} else if (meta[j].indexOf('type=text') == 0) {
							file.type = 'text';
						}
					}
				}

				if (file.size > 0) {
					tmp_files.push(file);
				}
			}

			if (!window.CFG_HTML5_SOUND_PRELOADING_ORDER || window.CFG_HTML5_SOUND_PRELOADING_ORDER.trim() === '') {
				tmp_files = excludeAudio(tmp_files);
			} else {
				var audio = new Audio();

				if (audio && audio.canPlayType) {
					var formats = window.CFG_HTML5_SOUND_PRELOADING_ORDER.replace('|', ',').split(',');
					var found = false;

					for (var i = 0, l = formats.length; i < l; i++) {
						var ext = formats[i].trim();
						var format = 'audio/' + ext;

						if ((audio.canPlayType(format) != 'no' && audio.canPlayType(format) != '')) {
							tmp_files = tmp_files.filter(function (element) {
								return element.type !== 'audio' || element.url.lastIndexOf(ext) > 0;
							});

							found = true;
							break;
						}
					}

					if (!found) {
						tmp_files = excludeAudio(tmp_files);
					}
				} else {
					tmp_files = excludeAudio(tmp_files);
				}
			}

			for (var i = 0, l = tmp_files.length; i < l; i++) {
				totalBytes += tmp_files[i].size;
				files.push(tmp_files[i]);
			}

			loadedBytes += PRELOADER_METADATA.MAINJS_FILESIZE;
			progress.style.width = ((loadedBytes / totalBytes) * 100) + '%';

			for (var i = 0, l = files.length; i < l; i++) {
				loadFile(files[i]);
			}
		};
	});
}).call(this);
