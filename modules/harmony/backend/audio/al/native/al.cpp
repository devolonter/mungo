//http://repo.or.cz/openal-soft.git

class _ALCdevice : public Object {
public:

	_ALCdevice(ALCdevice *device);
	ALCdevice *ALDevice();
	
private:
	ALCdevice *_device;

};

class _ALCcontext : public Object {
public:

	_ALCcontext(ALCcontext *context);
	ALCcontext *ALContext();
	
private:
	ALCcontext *_context;

};

_ALCdevice::_ALCdevice(ALCdevice *device){
	_device = device;
}

ALCdevice *_ALCdevice::ALDevice() {
	return _device;
}

_ALCcontext::_ALCcontext(ALCcontext *context){
	_context = context;
}

ALCcontext *_ALCcontext::ALContext() {
	return _context;
}

unsigned char *_alUtilConvertAudioFormat(unsigned char *data, int srcFormat, int destFormat, int length, int *channels, int *format) {
	unsigned char *good;
	
	switch (destFormat) {
		case AL_FORMAT_MONO8:
			good = (unsigned char *)malloc(length);
			
			switch (srcFormat) {
				case AL_FORMAT_MONO16:
					for (int i = 0; i < length; i++) {
						good[i] = (*(unsigned short*)(data+(i<<1)) >> 8) & 0xFF;
					}					
					break;
					
				case AL_FORMAT_STEREO8:
					for (int i = 0; i < length; i++) {
						good[i] = *(unsigned char*)(data+(i<<1));
					}
					break;
					
				case AL_FORMAT_STEREO16:
					for (int i = 0; i < length; i++) {
						good[i] = (*(unsigned short*)(data+(i<<2)) >> 8) & 0xFF;
					}
					break;
#ifdef AL_EXT_float32
				case AL_FORMAT_MONO_FLOAT32:
					for (int i = 0; i < length; i++) {
						good[i] = (*(float*)(data+(i<<2))) * 0xFF;
					}
					break;
					
				case AL_FORMAT_STEREO_FLOAT32:
					for (int i = 0; i < length; i++) {
						good[i] = (*(float*)(data+(i<<3))) * 0xFF;
					}
					break;
#endif
			}
			
			*channels = 1;
			*format = 1;
			break;
			
		case AL_FORMAT_MONO16:
			good = (unsigned char *)malloc(length<<1);
			
			switch (srcFormat) {
				case AL_FORMAT_MONO8:
					for (int i = 0; i < length; i++) {
						*(unsigned short*)(good+(i<<1)) = (*(unsigned char*)(data+i) << 8) & 0xFFFF;
					}					
					break;
					
				case AL_FORMAT_STEREO8:
					for (int i = 0; i < length; i++) {
						*(unsigned short*)(good+(i<<1)) = (*(unsigned char*)(data+(i<<1)) << 8) & 0xFFFF;
					}
					break;
					
				case AL_FORMAT_STEREO16:
					for (int i = 0; i < length; i++) {
						*(unsigned short*)(good+(i<<1))= *(unsigned short*)(data+(i<<2));
					}
					break;
#ifdef AL_EXT_float32
				case AL_FORMAT_MONO_FLOAT32:
					for (int i = 0; i < length; i++) {
						*(unsigned short*)(good+(i<<1)) = (*(float*)(data+(i<<2))) * 0xFFFF;
					}
					break;
					
				case AL_FORMAT_STEREO_FLOAT32:
					for (int i = 0; i < length; i++) {
						*(unsigned short*)(good+(i<<1)) = (*(float*)(data+(i<<3))) * 0xFFFF;
					}
					break;
#endif
			}
			
			*channels = 1;
			*format = 2;
			break;
			
		case AL_FORMAT_STEREO8:
			good = (unsigned char *)malloc(length<<1);
			
			switch (srcFormat) {
				case AL_FORMAT_MONO8:
					for (int i = 0; i < length; i++) {
						good[i<<1] = *(unsigned char*)(data+(i<<1));
						good[(i<<1)+1] = good[i<<1];
					}					
					break;
			
				case AL_FORMAT_MONO16:
					for (int i = 0; i < length; i++) {
						good[i<<1] = (*(unsigned short*)(data+(i<<1)) >> 8) & 0xFF;
						good[(i+1)<<1] = good[i<<1];
					}					
					break;
					
				case AL_FORMAT_STEREO16:
					for (int i = 0; i < length; i++) {
						good[i<<1] = (*(unsigned short*)(data+(i<<2)) >> 8) & 0xFF;
						good[(i<<1)+1] = (*(unsigned short*)(data+(i<<2)+2) >> 8) & 0xFF;
					}
					break;
#ifdef AL_EXT_float32
				case AL_FORMAT_MONO_FLOAT32:
					for (int i = 0; i < length; i++) {
						good[i<<1] = (*(float*)(data+(i<<2))) * 0xFF;
						good[(i<<1)+1] = good[i<<1];
					}
					break;
					
				case AL_FORMAT_STEREO_FLOAT32:
					for (int i = 0; i < length; i++) {
						good[i<<1] = (*(float*)(data+(i<<3))) * 0xFF;
						good[(i<<1)+1] = (*(float*)(data+(i<<3)+4)) * 0xFF;
					}
					break;
#endif
			}
			
			*channels = 2;
			*format = 1;
			break;
			
		case AL_FORMAT_STEREO16:
			good = (unsigned char *)malloc(length<<2);
			
			switch (srcFormat) {
				case AL_FORMAT_MONO8:
					for (int i = 0; i < length; i++) {
						*(unsigned short*)(good+(i<<2)) = (*(unsigned char*)(data+i) << 8) & 0xFFFF;
						*(unsigned short*)(good+(i<<2)+2) = *(unsigned short*)(good+(i<<1));
					}					
					break;
					
				case AL_FORMAT_STEREO8:
					for (int i = 0; i < length; i++) {
						*(unsigned short*)(good+(i<<2)) = (*(unsigned char*)(data+(i<<1)) << 8) & 0xFFFF;
						*(unsigned short*)(good+(i<<2)+2) = (*(unsigned char*)(data+(i<<1)+1) << 8) & 0xFFFF;
					}
					break;
					
				case AL_FORMAT_MONO16:
					for (int i = 0; i < length; i++) {
						*(unsigned short*)(good+(i<<2))= *(unsigned short*)(data+(i<<1));
						*(unsigned short*)(good+(i<<2)+2)= *(unsigned short*)(data+(i<<1));
					}
					break;
#ifdef AL_EXT_float32
				case AL_FORMAT_MONO_FLOAT32:
					for (int i = 0; i < length; i++) {
						*(unsigned short*)(good+(i<<2)) = (*(float*)(data+(i<<2))) * 0xFFFF;
						*(unsigned short*)(good+(i<<2)+2) = (*(float*)(data+(i<<2)+4)) * 0xFFFF;
					}
					break;
					
				case AL_FORMAT_STEREO_FLOAT32:
					for (int i = 0; i < length; i++) {
						*(unsigned short*)(good+(i<<2)) = (*(float*)(data+(i<<3))) * 0xFFFF;
						*(unsigned short*)(good+(i<<2)+2) = (*(float*)(data+(i<<3)+8)) * 0xFFFF;
					}
					break;
#endif
			}
			
			*channels = 2;
			*format = 2;
			break;

#ifdef AL_EXT_float32			
		case AL_FORMAT_MONO_FLOAT32:
			good = (unsigned char *)malloc(length<<2);
		
			switch (srcFormat) {
				case AL_FORMAT_MONO8:
					for (int i = 0; i < length; i++) {
						*(float*)(good+(i<<2)) = (*(signed char*)(data+i)) / 128.0;
					}
					break;				
					
				case AL_FORMAT_STEREO8:
					for (int i = 0; i < length; i++) {
						*(float*)(good+(i<<2)) = (*(signed char*)(data+(i<<1))) / 128.0;
					}
					break;
					
				case AL_FORMAT_MONO16:
					for (int i = 0; i < length; i++) {
						*(float*)(good+(i<<2)) = (*(signed char*)(data+(i<<1))) / 32768.0;
					}
					break;
			
				case AL_FORMAT_STEREO16:
					for (int i = 0; i < length; i++) {
						*(float*)(good+(i<<2)) = (*(signed short*)(data+(i<<2))) / 32768.0;
					}
					break;
					
				case AL_FORMAT_STEREO_FLOAT32:
					for (int i = 0; i < length; i++) {
						*(float*)(good+(i<<2)) = *(float*)(data+(i<<3));
					}
					break;
			}
			
			*channels = 1;
			*format = 4;
			break;
			
		case AL_FORMAT_STEREO_FLOAT32:
			good = (unsigned char *)malloc(length<<3);
		
			switch (srcFormat) {
				case AL_FORMAT_MONO8:
					for (int i = 0; i < length; i++) {
						*(float*)(good+(i<<3)) = (*(signed char*)(data+i)) / 128.0;
						*(float*)(good+(i<<3)+4) = *(float*)(good+(i<<3));
					}
					break;				
					
				case AL_FORMAT_STEREO8:
					for (int i = 0; i < length; i++) {
						*(float*)(good+(i<<3)) = (*(signed char*)(data+(i<<1))) / 128.0;
						*(float*)(good+(i<<3)+4) = (*(signed char*)(data+(i<<1)+1)) / 128.0;
					}
					break;
					
				case AL_FORMAT_MONO16:
					for (int i = 0; i < length; i++) {
						*(float*)(good+(i<<3)) = (*(signed char*)(data+(i<<1))) / 32768.0;
						*(float*)(good+(i<<3)+4) = *(float*)(good+(i<<3));
					}
					break;
			
				case AL_FORMAT_STEREO16:
					for (int i = 0; i < length; i++) {
						*(float*)(good+(i<<3)) = (*(signed short*)(data+(i<<2))) / 32768.0;
						*(float*)(good+(i<<3)+4) = (*(signed short*)(data+(i<<2)+2)) / 32768.0;
					}
					break;
					
				case AL_FORMAT_MONO_FLOAT32:
					for (int i = 0; i < length; i++) {
						*(float*)(good+(i<<3)) = *(float*)(data+(i<<3));
						*(float*)(good+(i<<3)+4) = *(float*)(good+(i<<3));
					}
					break;
			}
			
			*channels = 2;
			*format = 4;
			break;
#endif
	}
	
	free(data);
	return good;
}

void _alGenBuffers(int count, Array<int> result) {
	alGenBuffers(count, (ALuint*)&result[0]);
}

int _alGenBuffer() {
	ALuint alBuffer;
	alGenBuffers(1, &alBuffer);
	return alBuffer;
}

void _alDeleteBuffers(int count, Array<int> buffers) {
	alDeleteBuffers(count, (ALuint*)&buffers[0]);
}

void _alDeleteBuffer(int buffer) {
	alDeleteBuffers(1, (const ALuint*)&buffer);
}

void _alBufferData(int buffer, int format, BBDataBuffer *data, int size, int freq) {
	alBufferData(buffer, format, data->ReadPointer(), size, freq);
}

void _alBufferData(int buffer, int format, BBDataBuffer *data, int size, int from, int freq) {
	alBufferData(buffer, format, data->ReadPointer(from), size, freq);
}

void _alUploadBufferData(String path, int buffer, BBDataBuffer *data, Object *listener, int requestedFormat, int freq, Array<int> info) {
	int length = 0;
	int channels = 0;
	int format = 0;
	int hertz = 0;

	unsigned char *decodedData = _alLoadAudioData(path, &length, &channels, &format, &hertz);
	if (!decodedData) return;	
	
	int alFormat = 0;
	if(format == 1 && channels == 1){
		alFormat = AL_FORMAT_MONO8;
	}else if(format == 1 && channels == 2){
		alFormat = AL_FORMAT_STEREO8;
	}else if(format == 2 && channels == 1){
		alFormat = AL_FORMAT_MONO16;
	}else if(format == 2 && channels == 2){
		alFormat = AL_FORMAT_STEREO16;
	}
	
#ifdef AL_EXT_float32
	if(format == 4 && channels == 1){
		alFormat = AL_FORMAT_MONO_FLOAT32;
	}else if(format == 4 && channels == 2){
		alFormat = AL_FORMAT_STEREO_FLOAT32;
	}
#endif
	
	if (requestedFormat != 0 && requestedFormat != alFormat) {
		decodedData = _alUtilConvertAudioFormat(decodedData, alFormat, requestedFormat, length, &channels, &format);
		alFormat = requestedFormat;
	}
	
	int size = length * channels * format;
	
	if (data) {
		data->Discard();
		data->_New(size);
		memcpy(data->WritePointer(), decodedData, size);
	}
	
	if (buffer) {
		if (alFormat) {
			alBufferData(buffer, alFormat, decodedData, size, freq ? freq : hertz);
#ifdef AL_SOFT_buffer_samples
		} else {
			if(format == 3 && channels == 1) {
				alBufferSamplesSOFT(buffer, freq ? freq : hertz, AL_MONO32F_SOFT, length, AL_MONO_SOFT, AL_BYTE3_SOFT, decodedData);
			} else if (format == 3 && channels == 2) {
				alBufferSamplesSOFT(buffer, freq ? freq : hertz, AL_STEREO32F_SOFT, length, AL_STEREO_SOFT, AL_BYTE3_SOFT, decodedData);
			}
#endif
		}
	} else if (info.Length() == 3) {
		info[0] = channels;
		info[1] = format;
		info[2] = freq ? freq : hertz;
	}
	
	free(decodedData);
}

void _alGetBufferf(int buffer, int param, Array<float> value) {
	alGetBufferf(buffer, param, &value[0]);
}

void _alGetBufferi(int buffer, int param, Array<int> value) {
	alGetBufferi(buffer, param, &value[0]);
}

void _alGenSources(int count, Array<int> result) {
	alGenSources(count, (ALuint*)&result[0]);
}

int _alGenSource() {
	ALuint alSource;
	alGenSources(1, &alSource);
	return alSource;
}

void _alDeleteSources(int count, Array<int> sources) {
	alDeleteSources(count, (ALuint*)&sources[0]);
}

void _alDeleteSource(int source) {
	alDeleteSources(1, (const ALuint*)&source);
}

void _alSourcefv(int source, int param, Array<float> values) {
	alSourcefv(source, param, (ALfloat*)&values[0]);
}

void _alGetSourcef(int source, int param, Array<float> value) {
	alGetSourcef(source, param, &value[0]);
}

void _alGetSourcefv(int source, int param, Array<float> values) {
	alGetSourcefv(source, param, &values[0]);
}

void _alGetSourcei(int source, int param, Array<int> value) {
	alGetSourcei(source, param, &value[0]);
}

void _alGetSourceiv(int source, int param, Array<int> values) {
	alGetSourceiv(source, param, &values[0]);
}

void _alSourcePlayv(int count, Array<int> sources) {
	alSourcePlayv(count, (ALuint*)&sources[0]);
}

void _alSourcePausev(int count, Array<int> sources) {
	alSourcePausev(count, (ALuint*)&sources[0]);
}

void _alSourceStopv(int count, Array<int> sources) {
	alSourceStopv(count, (ALuint*)&sources[0]);
}

void _alSourceRewindv(int count, Array<int> sources) {
	alSourceRewindv(count, (ALuint*)&sources[0]);
}

void _alSourceQueueBuffers(int source, int count, Array<int> buffers) {
	alSourceQueueBuffers(source, count, (ALuint*)&buffers[0]);
}

void _alSourceUnqueueBuffers(int source, int count, Array<int> buffers) {
	alSourceUnqueueBuffers(source, count, (ALuint*)&buffers[0]);
}

void _alListenerfv(int param, Array<float> values) {
	alListenerfv(param, (ALfloat*)&values[0]);
}

void _alGetListenerf(int param, Array<float> values) {
	alGetListenerf(param, &values[0]);
}

void _alGetListenerfv(int param, Array<float> values) {
	alGetListenerfv(param, (ALfloat*)&values[0]);
}

void _alGetListeneri(int param, Array<int> values) {
	alGetListeneri(param, &values[0]);
}

void _alGetBooleanv(int param, Array<char> values){
	alGetBooleanv(param, &values[0]);
}

void _alGetDoublev(int param, Array<float> values){
	ALdouble result;
	alGetDoublev(param, &result);
	values[0] = (float)result;
}

void _alGetFloatv(int param, Array<float> values){
	alGetFloatv(param, &values[0]);
}

void _alGetIntegerv(int param, Array<int> values){
	alGetIntegerv(param, &values[0]);
}

String _alGetString(int param) {
	return String(alGetString(param));
}

int _alIsExtensionPresent(String extension) {
	return alIsExtensionPresent(extension.ToCString<char>());
}

int _alGetProcAddress(String proc) {
	return *(int *)alGetProcAddress(proc.ToCString<char>());
}

int _alGetEnumValue(String enumName) {
	return alGetEnumValue(enumName.ToCString<char>());
}

_ALCcontext *_alcCreateContext(_ALCdevice *device) {
	if (!device) return NULL;
	
	ALCcontext *ctx = alcCreateContext(device->ALDevice(), 0);
	
	if (ctx) {
		return new _ALCcontext(ctx);
	}
	
	return NULL;
}

int _alcMakeContextCurrent(_ALCcontext *context) {
	return alcMakeContextCurrent(context ? context->ALContext() : NULL);
}

void _alcProcessContext(_ALCcontext *context) {
	if (context) {
		alcProcessContext(context->ALContext());
	}
}

void _alcSuspendContext(_ALCcontext *context) {
	if (context) {
		alcSuspendContext(context->ALContext());
	}
}

void _alcDestroyContext(_ALCcontext *context) {
	if (context) {
		alcDestroyContext(context->ALContext());
	}
}

int _alcGetCurrentContext() {
	return *(int *)alcGetCurrentContext();
}

_ALCdevice *_alcOpenDevice(String deviceSpecifier) {
	ALCdevice *device;

	if (deviceSpecifier.Length() == 0) {
		device = alcOpenDevice(0);
	} else {
		device = alcOpenDevice(deviceSpecifier.ToCString<char>());
	}
	
	if (device) {
		return new _ALCdevice(device);
	}
	
	return NULL;
}

void _alcPauseDevice(_ALCdevice *device) {
#ifdef ALC_SOFT_pause_device
	if (device) {
		alcDevicePauseSOFT(device->ALDevice());
	}
#endif
}

void _alcResumeDevice(_ALCdevice *device) {
#ifdef ALC_SOFT_pause_device
	if (device) {
		alcDeviceResumeSOFT(device->ALDevice());
	}
#endif
}

void _alcCloseDevice(_ALCdevice *device) {
	if (device) {
		alcCloseDevice(device->ALDevice());
	}
}

int _alcIsExtensionPresent(_ALCdevice *device, String extension) {
	if (device) {
		return alcIsExtensionPresent(device->ALDevice(), extension.ToCString<char>());
	}
	
	return AL_FALSE;
}

int _alcGetProcAddress(_ALCdevice *device, String proc) {
	if (device) {
		return *(int *)alcGetProcAddress(device->ALDevice(), proc.ToCString<char>());
	}
	
	return 0;
}

int _alcGetEnumValue(_ALCdevice *device, String enumName) {
	if (device) {
		return alcGetEnumValue(device->ALDevice(), enumName.ToCString<char>());
	}
	
	return 0;
}

String _alcGetString(_ALCdevice *device, int param) {
	if (device) {
		return String(alcGetString(device->ALDevice(), param));
	}
	
	return String("0");
}
