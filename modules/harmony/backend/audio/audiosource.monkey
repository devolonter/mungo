Strict

Friend harmony.backend.audio.audiobuffer

Import audiobuffer

Private

Import al

Public

Const AUDIO_STATE_INITIAL:Int = AL_INITIAL
Const AUDIO_STATE_PLAYING:Int = AL_PLAYING
Const AUDIO_STATE_PAUSED:Int = AL_PAUSED
Const AUDIO_STATE_STOPPED:Int = AL_STOPPED

Class AudioSource3D<T> Extends AudioSource<T>
	
	Method New(x:Float = 0, y:Float = 0, z:Float = 0)
		Init()
		SetPosition(x, y, z)
	End Method
	
	Method New(buffer:T, x:Float = 0, y:Float = 0, z:Float = 0)
		Init()
		Buffer = buffer
		SetPosition(x, y, z)
	End Method
	
	Method SetPosition:Void(x:Float, y:Float, z:Float)
		alSource3f(source, AL_POSITION, x, y, z)
		Self.x = x
		Self.y = y
		Self.z = z
	End Method
	
	Method SetVelocity:Void(x:Float, y:Float, z:Float)
		alSource3f(source, AL_VELOCITY, x, y, z)
		Self.vx = x
		Self.vy = y
		Self.vz = z
	End Method
	
	Method SetDirection:Void(x:Float, y:Float, z:Float)
		alSource3f(source, AL_DIRECTION, x, y, z)
		Self.dx = x
		Self.dy = y
		Self.dz = z
	End Method
	
	Method X:Void(x:Float) Property
		alSource3f(source, AL_POSITION, x, y, z)
		Self.x = x
	End Method
	
	Method X:Float() Property
		Return x
	End Method
	
	Method Y:Void(y:Float) Property
		alSource3f(source, AL_POSITION, x, y, z)
		Self.y = y
	End Method
	
	Method Y:Float() Property
		Return y
	End Method
	
	Method Z:Void(z:Float) Property
		alSource3f(source, AL_POSITION, x, y, z)
		Self.z = z
	End Method
	
	Method Z:Float() Property
		Return z
	End Method
	
	Method VelocityX:Void(vx:Float) Property
		alSource3f(source, AL_VELOCITY, vx, vy, vz)
		Self.vx = vx
	End Method
	
	Method VelocityX:Float() Property
		Return vx
	End Method
	
	Method VelocityY:Void(vy:Float) Property
		alSource3f(source, AL_VELOCITY, vx, vy, vz)
		Self.vy = vy
	End Method
	
	Method VelocityY:Float() Property
		Return vy
	End Method
	
	Method VelocityZ:Void(vz:Float) Property
		alSource3f(source, AL_VELOCITY, vx, vy, vz)
		Self.vz = vz
	End Method
	
	Method VelocityZ:Float() Property
		Return vz
	End Method
	
	Method DirectionX:Void(dx:Float) Property
		alSource3f(source, AL_DIRECTION, dx, dy, dz)
		Self.dx = dx
	End Method
	
	Method DirectionX:Float() Property
		Return dx
	End Method
	
	Method DirectionY:Void(dy:Float) Property
		alSource3f(source, AL_DIRECTION, dx, dy, dz)
		Self.dy = dy
	End Method
	
	Method DirectionY:Float() Property
		Return dy
	End Method
	
	Method DirectionZ:Void(dz:Float) Property
		alSource3f(source, AL_DIRECTION, dx, dy, dz)
		Self.dz = dz
	End Method
	
	Method DirectionZ:Float() Property
		Return dz
	End Method
	
	Method MaxDistance:Void(maxDistance:Float) Property
		alSourcef(source, AL_MAX_DISTANCE, maxDistance)
	End Method
	
	Method MaxDistance:Float() Property
		Return alGetSourcef(source, AL_MAX_DISTANCE)
	End Method
	
	Method RolloffFactor:Void(rolloffFactor:Float) Property
		alSourcef(source, AL_ROLLOFF_FACTOR, rolloffFactor)
	End Method
	
	Method RolloffFactor:Float() Property
		Return alGetSourcef(source, AL_ROLLOFF_FACTOR)
	End Method
	
	Method ConeOuterGain:Void(coneOuterGain:Float) Property
		alSourcef(source, AL_CONE_OUTER_GAIN, coneOuterGain)
	End Method
	
	Method ConeOuterGain:Float() Property
		Return alGetSourcef(source, AL_CONE_OUTER_GAIN)
	End Method	
	
	Method ReferenceDistance:Void(refDistance:Float) Property
		alSourcef(source, AL_REFERENCE_DISTANCE, refDistance)
	End Method
	
	Method ReferenceDistance:Float() Property
		Return alGetSourcef(source, AL_REFERENCE_DISTANCE)
	End Method
	
	Method ConeInnerAngle:Void(coneInnerAngle:Int) Property
		alSourcei(source, AL_CONE_INNER_ANGLE, coneInnerAngle)
	End Method
	
	Method ConeInnerAngle:Float() Property
		Return alSourcei(source, AL_CONE_INNER_ANGLE)
	End Method
	
	Method ConeOuterAngle:Void(coneOuterAngle:Int) Property
		alSourcei(source, AL_CONE_OUTER_ANGLE, coneOuterAngle)
	End Method
	
	Method ConeOuterAngle:Float() Property
		Return alGetSourcei(source, AL_CONE_OUTER_ANGLE, coneOuterAngle)
	End Method
	
	Method Relative:Void(relative:Bool) Property
		alSourcei(source, AL_SOURCE_RELATIVE, relative)
	End Method
	
	Method Relative:Bool() Property
		Return (alGetSourcei(source, AL_SOURCE_RELATIVE) = AL_TRUE)
	End Method
	
Private

	Field x:Float
	Field y:Float
	Field z:Float
	
	Field vx:Float
	Field vy:Float
	Field vz:Float
	
	Field dx:Float
	Field dy:Float
	Field dz:Float
	
	Method SetDefaults:Void()
		alSourcei(source, AL_SOURCE_RELATIVE, AL_FALSE)
	End Method

End Class

Class AudioSource<T> Implements IAudioSource

	Method New()
		Init()
	End Method

	Method New(buffer:T)
		Init()
		Buffer = buffer
	End Method
	
	Method Discard:Void()
		Dispose()
	End Method
	
	Method Play:Void()
		alSourceStop(source)
		alSourcePlay(source)
	End Method
	
	Method Stop:Void()
		alSourceStop(source)
	End Method
	
	Method Pause:Void()
		alSourcePause(source)
	End Method
	
	Method Resume:Void()
		If (alGetSourcei(source, AL_SOURCE_STATE) = AUDIO_STATE_PAUSED) Then
			alSourcePlay(source)
		End If
	End Method
	
	Method Buffer:Void(audioBuffer:T) Property
		If (audioBuffer <> Null And buffer = audioBuffer) Return
			
		If (buffer) Then
			alSourceStop(source)
			buffer.DetachFromSource(Self)
			buffer = Null
		End If
	
		If (audioBuffer) Then			
			audioBuffer.AttachToSource(Self)
			buffer = audioBuffer	
		End If
	End Method
	
	Method Buffer:T() Property
		Return buffer
	End Method
	
	Method Volume:Void(volume:Float) Property
		alSourcef(source, AL_GAIN, volume)
	End Method
	
	Method Volume:Float() Property
		Return alGetSourcef(source, AL_GAIN)
	End Method
	
	Method Pan:Void(pan:Float) Property		
		alSource3f(source, AL_POSITION, Sinr(pan*HALFPI), 0, -Cosr(pan*HALFPI))
		Self.pan = pan
	End Method
	
	Method Pan:Float() Property
		Return pan
	End Method
	
	Method Pitch:Void(pitch:Float) Property
		alSourcef(source, AL_PITCH, pitch)
	End Method
	
	Method Pitch:Float() Property
		Return alGetSourcef(source, AL_PITCH)
	End Method
	
	Method Loop:Void(loop:Bool) Property
		alSourcei(source, AL_LOOPING, loop)
	End Method
	
	Method Loop:Bool() Property
		Return alGetSourcei(source, AL_LOOPING) = AL_TRUE
	End Method
	
	Method State:Int() Property
		Return alGetSourcei(source, AL_SOURCE_STATE)
	End Method
	
	Method Offset:Void(offset:Int) Property
		alSourcei(source, offset, AL_SAMPLE_OFFSET)
	End Method
	
	Method Offset:Int() Property
		If (Not buffer) Return 0
	
		If (buffer.format.channels = 2) Then
			Local result:Int = alGetSourcei(source, AL_SAMPLE_OFFSET)
			result += (result & 1)
			Return result
		Else
			Return alGetSourcei(source, AL_SAMPLE_OFFSET)
		End If		
	End Method
	
	Method ByteOffset:Void(offset:Int) Property
		alSourcei(source, AL_BYTE_OFFSET, offset)
	End Method
	
	Method ByteOffset:Int() Property
		Return alGetSourcei(source, AL_BYTE_OFFSET)
	End Method
	
	Method SecOffset:Void(offset:Float) Property
		alSourcef(source, AL_SEC_OFFSET, offset)
	End Method
	
	Method SecOffset:Float() Property
		Return alGetSourcef(source, AL_SEC_OFFSET)
	End Method
	
	Method ALSource:Int()
		Return source
	End Method
	
Private

	Field source:Int
	
	Field buffer:T
	
	Field pan:Float
	
	Method Init:Void()
		source = alGenSource()
		SetDefaults()
	End Method
	
	Method SetDefaults:Void()
		alSourcei(source, AL_SOURCE_RELATIVE, AL_TRUE)
	End Method
	
	Method Dispose:Void()
		alSourcei(source, AL_BUFFER, 0)		
		source = 0
	End Method

End Class

Interface IAudioSource
	
	Method Discard:Void()
	Method Play:Void()
	Method Stop:Void()
	Method Pause:Void()
	Method Resume:Void()
	Method Buffer:Void(audioBuffer:AudioBuffer)
	Method Buffer:AudioBuffer()
	Method Loop:Void(loop:Bool)
	Method Loop:Bool()
	Method State:Int()
	Method Offset:Void(offset:Int)
	Method Offset:Int()
	Method ByteOffset:Void(offset:Int)
	Method ByteOffset:Int()
	Method ALSource:Int()

End Interface
