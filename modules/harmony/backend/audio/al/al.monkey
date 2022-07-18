
#JS_USE_TYPED_ARRAYS=True
#OPENAL_ENABLED = True

Import "native/al.${TARGET}.${LANG}"

#If LANG = "cpp"

Import "native/al.${LANG}"

#End

Private

Import brl.databuffer

#If TARGET = "html5"
	
Import dom

#End

Public

Const AL_NONE:Int = 0
Const AL_FALSE:Int = 0
Const AL_TRUE:Int = 1
Const AL_SOURCE_RELATIVE:Int = $202
Const AL_CONE_INNER_ANGLE:Int = $1001
Const AL_CONE_OUTER_ANGLE:Int = $1002
Const AL_PITCH:Int = $1003
  
Const AL_POSITION:Int = $1004
  
Const AL_DIRECTION:Int = $1005
  
Const AL_VELOCITY:Int = $1006
Const AL_LOOPING:Int = $1007
Const AL_BUFFER:Int = $1009
  
Const AL_GAIN:Int = $100A
Const AL_MIN_GAIN:Int = $100D
Const AL_MAX_GAIN:Int = $100E
Const AL_ORIENTATION:Int = $100F
Const AL_SOURCE_STATE:Int = $1010
Const AL_INITIAL:Int = $1011
Const AL_PLAYING:Int = $1012
Const AL_PAUSED:Int = $1013
Const AL_STOPPED:Int = $1014
Const AL_BUFFERS_QUEUED:Int = $1015
Const AL_BUFFERS_PROCESSED:Int = $1016
Const AL_SEC_OFFSET:Int = $1024
Const AL_SAMPLE_OFFSET:Int = $1025
Const AL_BYTE_OFFSET:Int = $1026
Const AL_SOURCE_TYPE:Int = $1027
Const AL_STATIC:Int = $1028
Const AL_STREAMING:Int = $1029
Const AL_UNDETERMINED:Int = $1030
Const AL_FORMAT_MONO8:Int = $1100
Const AL_FORMAT_MONO16:Int = $1101
Const AL_FORMAT_MONO_FLOAT32:Int = $10010
Const AL_FORMAT_STEREO8:Int = $1102
Const AL_FORMAT_STEREO16:Int = $1103
Const AL_FORMAT_STEREO_FLOAT32:Int = $10011
Const AL_REFERENCE_DISTANCE:Int = $1020
Const AL_ROLLOFF_FACTOR:Int = $1021
Const AL_CONE_OUTER_GAIN:Int = $1022
Const AL_MAX_DISTANCE:Int = $1023
Const AL_FREQUENCY:Int = $2001
Const AL_BITS:Int = $2002
Const AL_CHANNELS:Int = $2003
Const AL_SIZE:Int = $2004
Const AL_UNUSED:Int = $2010
Const AL_PENDING:Int = $2011
Const AL_PROCESSED:Int = $2012
Const AL_NO_ERROR:Int = AL_FALSE
Const AL_INVALID_NAME:Int = $A001
Const AL_INVALID_ENUM:Int = $A002
Const AL_INVALID_VALUE:Int = $A003
Const AL_INVALID_OPERATION:Int = $A004
  
Const AL_OUT_OF_MEMORY:Int = $A005
Const AL_VENDOR:Int = $B001
Const AL_VERSION:Int = $B002
Const AL_RENDERER:Int = $B003
Const AL_EXTENSIONS:Int = $B004
Const AL_DOPPLER_FACTOR:Int = $C000
Const AL_DOPPLER_VELOCITY:Int = $C001
Const AL_SPEED_OF_SOUND:Int = $C003
Const AL_DISTANCE_MODEL:Int = $D000
Const AL_INVERSE_DISTANCE:Int = $D001
Const AL_INVERSE_DISTANCE_CLAMPED:Int = $D002
Const AL_LINEAR_DISTANCE:Int = $D003
Const AL_LINEAR_DISTANCE_CLAMPED:Int = $D004
Const AL_EXPONENT_DISTANCE:Int = $D005
Const AL_EXPONENT_DISTANCE_CLAMPED:Int = $D006
Const AL_PRIORITY:Int = $E001
Const AL_PRIORITY_SLOTS:Int = $E002

Extern

#If LANG = "cpp"

'BUFFER-RELATED
Function alGenBuffers:Void(count:Int, result:Int[]) = "_alGenBuffers"
Function alGenBuffer:Int() = "_alGenBuffer"
Function alDeleteBuffers:Void(count:Int, buffers:Int[]) = "_alDeleteBuffers"
Function alDeleteBuffer:Void(buffer:Int) = "_alDeleteBuffer"
Function alIsBuffer:Int(buffer:Int)
Function alBufferData:Void(buffer:Int, format:Int, data:DataBuffer, size:Int, freq:Int) = "_alBufferData"
Function alBufferData:Void(buffer:Int, format:Int, data:DataBuffer, size:Int, from:Int, freq:Int) = "_alBufferData"
Function alUploadBufferData:Void(path:String, buffer:Int, data:DataBuffer, listener:Object = Null, format:Int = 0, freq:Int = 0, info:Int[] = []) = "_alUploadBufferData"
Function alGetBufferf:Void(buffer:Int, param:Int, value:Float[]) = "_alGetBufferf"
Function alGetBufferi:Void(buffer:Int, param:Int, value:Int[]) = "_alGetBufferi"

'SOURCE-RELATED
Function alGenSources:Void(count:Int, reslut:Int[]) = "_alGenSources"
Function alGenSource:Int() = "_alGenSource"
Function alDeleteSources:Void(count:Int, sources:Int[]) = "_alDeleteSources"
Function alDeleteSource:Void(source:Int) = "_alDeleteSource"
Function alIsSource:Int(source:Int)
Function alSourcef:Int(source:Int, param:Int, value:Float)
Function alSourcefv:Int(source:Int, param:Int, values:Float[]) = "_alSourcefv"
Function alSource3f:Int(source:Int, param:Int, v1:Float, v2:Float, v3:Float)
Function alSourcei:Void(source:Int, param:Int, value:Int)
Function alGetSourcef:Void(source:Int, param:Int, value:Float[]) = "_alGetSourcef"
Function alGetSourcefv:Void(source:Int, param:Int, value:Float[]) = "_alGetSourcefv"
Function alGetSourcei:Void(source:Int, param:Int, value:Int[]) = "_alGetSourcei"
Function alGetSourceiv:Void(source:Int, param:Int, value:Int[]) = "_alGetSourceiv"
Function alSourcePlay:Void(source:Int)
Function alSourcePlayv:Void(count:Int, sources:Int[]) = "_alSourcePlayv"
Function alSourcePause:Void(source:Int)
Function alSourcePausev:Void(count:Int, sources:Int[]) = "_alSourcePausev"
Function alSourceStop:Void(source:Int)
Function alSourceStopv:Void(count:Int, sources:Int[]) = "_alSourceStopv"
Function alSourceRewind:Void(source:Int)
Function alSourceRewindv:Void(count:Int, sources:Int[]) = "_alSourceRewindv"
Function alSourceQueueBuffers:Void(source:Int, count:Int, buffers:Int[]) = "_alSourceQueueBuffers"
Function alSourceUnqueueBuffers:Void(source:Int, count:Int, buffers:Int[]) = "_alSourceUnqueueBuffers"

'LISTENER-RELATED
Function alListenerf:Void(param:Int, value:Float)
Function alListener3f:Void(param:Int, v1:Float, v2:Float, v3:Float)
Function alListenerfv:Void(param:Int, values:Float[]) = "_alListenerfv"
Function alListeneri:Void(param:Int, value:Int)
Function alGetListenerf:Float(param:Int, value:Float[]) = "_alGetListenerf"
Function alGetListenerfv:Void(param:Int, values:Float[]) = "_alGetListenerfv"
Function alGetListeneri:Void(param:Int, value:Int[]) = "_alGetListeneri"

'STATE-RELATED
Function alEnable:Void(param:Int)
Function alDisable:Void(param:Int)
Function alIsEnabled:Int(param:Int)
Function alGetBooleanv:Void(param:Int, value:Int[]) = "_alGetBooleanv"
Function alGetDoublev:Void(param:Int, value:Float[]) = "_alGetDoublev"
Function alGetFloatv:Void(param:Int, value:Float[]) = "_alGetFloatv"
Function alGetIntegerv:Void(param:Int, value:Int[]) = "_alGetIntegerv"
Function alGetString:String(param:Int) = "_alGetString"
Function alDistanceModel:Void(model:Int)
Function alDopplerFactor:Void(value:Float)
Function alDopplerVelocity:Void(value:Float)

'ERROR-RELATED
Function alGetError:Int()

'EXTENSION-RELATED
Function alIsExtensionPresent:Int(extension:String) = "_alIsExtensionPresent"
Function alGetProcAddress:Int(porc:String) = "_alGetProcAddress"
Function alGetEnumValue:Int(enum:String) = "_alGetEnumValue"

'ALC FUNCTIONS
Function alcCreateContext:ALCcontext(device:ALCdevice) = "_alcCreateContext"
Function alcMakeContextCurrent:Int(context:ALCcontext) = "_alcMakeContextCurrent"
Function alcProcessContext:Void(context:ALCcontext) = "_alcProcessContext"
Function alcSuspendContext:Void(context:ALCcontext) = "_alcSuspendContext"
Function alcDestroyContext:Int(context:ALCcontext) = "_alcDestroyContext"
Function alcGetError:Int()
'Function alcGetCurrentContext:Int() = "_alcGetCurrentContext" 'note: TODO
Function alcOpenDevice:ALCdevice(deviceSpecifier:String="") = "_alcOpenDevice"
Function alcPauseDevice:Void(device:ALCdevice) = "_alcPauseDevice"
Function alcResumeDevice:Void(device:ALCdevice) = "_alcResumeDevice"
Function alcCloseDevice:Void(device:ALCdevice) = "_alcCloseDevice"
Function alcIsExtensionPresent:Int(device:ALCdevice, extension:String) = "_alcIsExtensionPresent"
Function alcGetProcAddress:Int(device:ALCdevice, extension:String) = "_alcGetProcAddress"
Function alcGetEnumValue:Int(device:ALCdevice, extension:String) = "_alcGetEnumValue"
Function alcGetString:String(device:ALCdevice, param:Int) = "_alcGetString"
'Function alcGetIntegerv 'note: TODO

#Else

'BUFFER-RELATED
Function alGenBuffers:Void(count:Int, result:Int[])
Function alGenBuffer:Int()
Function alDeleteBuffers:Void(count:Int, buffers:Int[])
Function alDeleteBuffer:Void(buffer:Int)
Function alIsBuffer:Int(buffer:Int)
Function alBufferData:Void(buffer:Int, format:Int, data:DataBuffer, size:Int, freq:Int)
Function alBufferData:Void(buffer:Int, format:Int, data:DataBuffer, size:Int, from:Int, freq:Int) = "alBufferData2"
Function alUploadBufferData:Void(path:String, buffer:Int, data:DataBuffer, listener:EventListener, format:Int = 0, freq:Int = 0, info:Int[] = [])
Function alGetBufferf:Void(buffer:Int, param:Int, value:Float[])
Function alGetBufferi:Void(buffer:Int, param:Int, value:Int[])

'SOURCE-RELATED
Function alGenSources:Void(count:Int, reslut:Int[])
Function alGenSource:Int()
Function alDeleteSources:Void(count:Int, sources:Int[])
Function alDeleteSource:Void(source:Int)
Function alIsSource:Int(source:Int)
Function alSourcef:Int(source:Int, param:Int, value:Float)
Function alSourcefv:Int(source:Int, param:Int, values:Float[])
Function alSource3f:Int(source:Int, param:Int, v1:Float, v2:Float, v3:Float)
Function alSourcei:Void(source:Int, param:Int, value:Int)
Function alGetSourcef:Void(source:Int, param:Int, value:Float[])
Function alGetSourcefv:Void(source:Int, param:Int, value:Float[])
Function alGetSourcei:Void(source:Int, param:Int, value:Int[])
Function alGetSourceiv:Void(source:Int, param:Int, value:Int[])
Function alSourcePlay:Void(source:Int)
Function alSourcePlayv:Void(count:Int, sources:Int[])
Function alSourcePause:Void(source:Int)
Function alSourcePausev:Void(count:Int, sources:Int[])
Function alSourceStop:Void(source:Int)
Function alSourceStopv:Void(count:Int, sources:Int[])
Function alSourceRewind:Void(source:Int)
Function alSourceRewindv:Void(count:Int, sources:Int[])
Function alSourceQueueBuffers:Void(source:Int, count:Int, buffers:Int[])
Function alSourceUnqueueBuffers:Void(source:Int, count:Int, buffers:Int[])

'LISTENER-RELATED
Function alListenerf:Void(param:Int, value:Float)
Function alListener3f:Void(param:Int, v1:Float, v2:Float, v3:Float)
Function alListenerfv:Void(param:Int, values:Float[])
Function alListeneri:Void(param:Int, value:Int) = "_alEmptyFunction"
Function alGetListenerf:Float(param:Int, value:Float[])
Function alGetListenerfv:Void(param:Int, values:Float[])
Function alGetListeneri:Void(param:Int, value:Int[]) = "_alEmptyFunction"

'STATE-RELATED
Function alEnable:Void(param:Int) = "_alEmptyErrorFunction"
Function alDisable:Void(param:Int) = "_alEmptyErrorFunction"
Function alIsEnabled:Int(param:Int) = "_alEmptyErrorFunction"
Function alGetBooleanv:Void(param:Int, value:Bool[]) = "_alEmptyErrorFunction"
Function alGetDoublev:Void(param:Int, value:Float[]) = "_alEmptyErrorFunction"
Function alGetFloatv:Void(param:Int, value:Float[])
Function alGetIntegerv:Void(param:Int, value:Int[])
Function alGetString:String(param:Int)
Function alDistanceModel:Void(model:Int)
Function alDopplerFactor:Void(value:Float)
Function alDopplerVelocity:Void(value:Float)

'ERROR-RELATED
Function alGetError:Int()

'EXTENSION-RELATED
Function alIsExtensionPresent:Int(extension:String)
Function alGetProcAddress:Int(porc:String) = "_alEmptyFunction"
Function alGetEnumValue:Int(enum:String)

'ALC FUNCTIONS
Function alcCreateContext:ALCcontext(device:ALCdevice)
Function alcMakeContextCurrent:ALCcontext(context:ALCcontext)
Function alcProcessContext:Void(context:ALCcontext)
Function alcSuspendContext:Void(context:ALCcontext)
Function alcDestroyContext:Int(context:ALCcontext)
Function alcGetError:Int()
'Function alcGetCurrentContext:Int() = "_alcGetCurrentContext" 'note: TODO
Function alcOpenDevice:ALCdevice(deviceSpecifier:String="")
Function alcPauseDevice:Void(device:ALCdevice) = "_alEmptyFunction"
Function alcResumeDevice:Void(device:ALCdevice) = "_alEmptyFunction"
Function alcCloseDevice:Void(device:ALCdevice)
Function alcIsExtensionPresent:Int(device:ALCdevice, extension:String)
Function alcGetProcAddress:Int(device:ALCdevice, extension:String) = "_alEmptyFunction"
Function alcGetEnumValue:Int(device:ALCdevice, extension:String)
Function alcGetString:String(device:ALCdevice, param:Int)
'Function alcGetIntegerv 'note: TODO


#End

#If TARGET = "html5"

'kludge:(
'note: TODO remove alcInitDevice kludge
Function alcInitDevice:Void()

#End

Class ALCdevice = "_ALCdevice"

End Class

Class ALCcontext = "_ALCcontext"

End Class

Public

'Helpers
Function alGetBufferf:Float(buffer:Int, param:Int)
	alGetBufferf(buffer, param, Resultf)
	Return Resultf[0]
End Function

Function alGetBufferi:Int(buffer:Int, param:Int)
	alGetBufferi(buffer, param, Resulti)
	Return Resulti[0]
End Function

Function alGetSourcef:Float(source:Int, param:Int)
	alGetSourcef(source, param, Resultf)
	Return Resultf[0]
End Function

Function alGetSourcei:Int(source:Int, param:Int)
	alGetSourcei(source, param, Resulti)
	Return Resulti[0]
End Function

Function alGetListenerf:Float(param:Int)
	alGetListenerf(param, Resultf)
	Return Resultf[0]
End Function

Function alGetListener3f:Void(param:Int, v1:Float[], v2:Float[], v3:Float[])
	alGetListenerfv(param, Resultf)
	v1[0] = Resultf[0]
	v2[0] = Resultf[1]
	v3[0] = Resultf[2]
End Function

Function alGetListeneri:Float(param:Int)
	alGetListeneri(param, Resulti)
	Return Resulti[0]
End Function

Function alGetBoolean:Bool(param:Int)
	alGetBooleanv(param, Resultb)
	Return Resultb[0]
End Function

Function alGetDouble:Float(param:Int)
	alGetDoublev(param, Resultf)
	Return Resultf[0]
End Function

Function alGetFloat:Float(param:Int)
	alGetFloatv(param, Resultf)
	Return Resultf[0]
End Function

Function alGetInteger:Int(param:Int)
	alGetIntegerv(param, Resulti)
	Return Resulti[0]
End Function

Private

Global Resultb:Bool[3]
Global Resulti:Int[3]
Global Resultf:Float[3]
