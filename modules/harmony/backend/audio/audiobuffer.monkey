Strict

Friend harmony.backend.audio.audiocontext
Friend harmony.backend.audio.audiosource

Import brl.databuffer
Import audiosource

Private

Import al
Import harmony.backend.utils

#If TARGET = "html5"

Import dom

#End

Public

Global AUDIO_FORMAT_DEFAULT:AudioFormat = Null
Global AUDIO_FORMAT_MONO8:AudioFormat = New AudioFormat(1, 1)
Global AUDIO_FORMAT_MONO16:AudioFormat = New AudioFormat(2, 1)
Global AUDIO_FORMAT_STEREO8:AudioFormat = New AudioFormat(1, 2)
Global AUDIO_FORMAT_STEREO16:AudioFormat = New AudioFormat(2, 2)
Global AUDIO_FORMAT_MONO32:AudioFormat = New AudioFormat(4, 1, True)
Global AUDIO_FORMAT_STEREO32:AudioFormat = New AudioFormat(4, 2, True)

Const AUDIO_FREQUENCY_DEFAULT:Int = 0

Const AUDIO_SLICE_MODE_BYTES:Int = 0
Const AUDIO_SLICE_MODE_SAMPLES:Int = 1
Const AUDIO_SLICE_MODE_MILLISECS:Int = 2

Interface IOnLoadAudioBufferComplete
	
	Method OnLoadAudioBufferComplete:Void(buffer:AudioBuffer)

End Interface

Class AudioBufferOptions
	
	Field readable:Bool
	Field writeable:Bool
	Field frequency:Int
	
	Method New(readable:Bool = False, writeable:Bool = False, frequency:Int = AUDIO_FREQUENCY_DEFAULT)
		Init(readable, writeable, frequency)
	End Method
	
	Method New(options:AudioBufferOptions)
		Init(options.readable, options.writeable, options.frequency)
	End Method
	
Private

	Method Init:Void(readable:Bool, writeable:Bool, frequency:Int)
		Self.readable = readable
		Self.writeable = writeable
		Self.frequency = frequency
	End Method

End Class

Class AudioBufferView Extends AudioBuffer
	
	Method New(buffer:AudioBuffer, start:Int, _end:Int, mode:Int = AUDIO_SLICE_MODE_SAMPLES)
		If (Not buffer.data) Then
			Error("Buffer must be readeable or writeable")
		End If
	
		If (Not buffer.loaded) Then
			Error("Attempt to create view for not loaded buffer")
		End If
		
		Init()
		
		format = buffer.format
		options = buffer.options
		data = buffer.data
		
		Select (mode)
			Case AUDIO_SLICE_MODE_SAMPLES
				If (_end <> 0) _end *= format.bytes * format.channels
				start *= format.bytes * format.channels
				
			Case AUDIO_SLICE_MODE_MILLISECS
				If (_end <> 0) _end = SecToBytes(_end / 1000.0, format.channels, format.bytes, options.frequency)
				start = SecToBytes(start / 1000.0, format.channels, format.bytes, options.frequency)
		End Select
		
		If (_end = 0) Then
			_end = buffer.data.Length
		End If
		
		rangeStart = start
		rangeEnd = _end
		
		alBufferData(Self.buffer, format.internalFormat, data, _end - start, start, options.frequency)
		Complete()
	End Method
	
	Method Discard:Void()
		Dispose()
	End Method
	
	Method WriteSamples:Void(samples:Int[])
		Super.WriteSamples(samples, rangeStart / (format.bytes * format.channels), 0, samples.Length())
	End Method
	
	Method WriteSamples:Void(samples:Int[], _to:Int, from:Int, count:Int)
		Super.WriteSamples(samples, _to + (rangeStart / (format.bytes * format.channels)), from, count)
	End Method
	
	Method WriteSamples:Void(samples:Float[])
		Super.WriteSamples(samples, rangeStart / (format.bytes * format.channels), 0, samples.Length())
	End Method
	
	Method WriteSamples:Void(samples:Float[], _to:Int, from:Int, count:Int)
		Super.WriteSamples(samples, _to + (rangeStart / (format.bytes * format.channels)), from, count)
	End Method
	
	Method WriteSamples:Void(samples:DataBuffer)
		Super.WriteSamples(samples, rangeStart / (format.bytes * format.channels), 0, samples.Length())
	End Method
	
	Method WriteSamples:Void(samples:DataBuffer, _to:Int, from:Int, count:Int)
		Super.WriteSamples(samples, _to + (rangeStart / (format.bytes * format.channels)), from, count)
	End Method
	
	Method ReadSamples:Void(samples:Int[])
		Super.ReadSamples(samples, 0, rangeStart / (format.bytes * format.channels), samples.Length())
	End Method
	
	Method ReadSamples:Void(samples:Int[], _to:Int, from:Int, count:Int)
		Super.ReadSamples(samples, _to, from + (rangeStart / (format.bytes * format.channels)), count)
	End Method
	
	Method ReadSamples:Void(samples:Float[])
		Super.ReadSamples(samples, 0, rangeStart / (format.bytes * format.channels), samples.Length())
	End Method
	
	Method ReadSamples:Void(samples:Float[], _to:Int, from:Int, count:Int)
		Super.ReadSamples(samples, _to, from + (rangeStart / (format.bytes * format.channels)), count)
	End Method
	
	Method ReadSamples:Void(samples:DataBuffer)
		Super.ReadSamples(samples, 0, rangeStart / (format.bytes * format.channels), samples.Length())
	End Method
	
	Method ReadSamples:Void(samples:DataBuffer, _to:Int, from:Int, count:Int)
		Super.ReadSamples(samples, _to, from + (rangeStart / (format.bytes * format.channels)), count)
	End Method
	
Private
	
	Field rangeStart:Int	
	Field rangeEnd:Int
	
	Method UpdateInfo:Void()
		size = rangeEnd - rangeStart
		length = size / (format.bytes * format.channels)
	End Method
	
	Method UpdateBuffer:Void()
		UnlockBuffer()
		alBufferData(buffer, format.internalFormat, data, rangeEnd - rangeStart, rangeStart, options.frequency)
		LockBuffer()
	End Method

End Class

'note: TODO:
' - To fix Lock/Unlock buffer
' - To add Queue/Unqueue buffers
' - To add Push/Pop buffers
' - To add Proceed/Queued buffers to source. In source maybe?
Class AudioBuffersQueue Extends AudioBuffer

	Method New(lengths:Int[], frequency:Int = AUDIO_FREQUENCY_DEFAULT, format:AudioFormat = AUDIO_FORMAT_DEFAULT)
		If (frequency = AUDIO_FREQUENCY_DEFAULT) frequency = AUDIO_FREQUENCY_DEFAULT_VALUE
		If (format = AUDIO_FORMAT_DEFAULT) format = AUDIO_FORMAT_STEREO16
		options = New AudioBufferOptions(True, True, frequency)		
		Self.format = New AudioFormat(format)
		
		InitQueue(lengths.Length())
		InitBuffersInfo(lengths)
		CalcDuration()
	End Method
	
	Method New(length:Int, count:Int, frequency:Int = AUDIO_FREQUENCY_DEFAULT, format:AudioFormat = AUDIO_FORMAT_DEFAULT)
		If (frequency = AUDIO_FREQUENCY_DEFAULT) frequency = AUDIO_FREQUENCY_DEFAULT_VALUE
		If (format = AUDIO_FORMAT_DEFAULT) format = AUDIO_FORMAT_STEREO16
		options = New AudioBufferOptions(True, True, frequency)
		Self.format = New AudioFormat(format)
		
		Local lengths:Int[count]
		For Local i:Int = 0 Until count
			lengths[i] = length	
		Next
		
		InitQueue(lengths.Length())
		InitBuffersInfo(lengths)
		CalcDuration()
	End Method
	
	Method New(filenames:String[], listener:IOnLoadAudioBufferComplete = Null, format:AudioFormat = Null, options:AudioBufferOptions = Null)
		If (Not options) options = DefaultOptions
		
		Self.options = New AudioBufferOptions(options)
		If (format) Self.format = New AudioFormat(format)
		
		InitQueue(filenames.Length())
		UploadBuffersData(filenames, [], 0, listener)
	End Method
	
	Method New(filename:String, count:Int, listener:IOnLoadAudioBufferComplete = Null, format:AudioFormat = Null, options:AudioBufferOptions = Null)
		If (Not options) options = DefaultOptions
		
		Self.options = New AudioBufferOptions(options)
		If (format) Self.format = New AudioFormat(format)
		
		InitQueue(count)
		UploadBuffersData([filename], [], count, listener)
	End Method
	
	Method New(filename:String, ranges:Int[], listener:IOnLoadAudioBufferComplete = Null, format:AudioFormat = Null, options:AudioBufferOptions = Null)
		If (Not options) options = DefaultOptions
		
		Self.options = New AudioBufferOptions(options)
		If (format) Self.format = New AudioFormat(format)
		
		InitQueue(ranges.Length())
		UploadBuffersData([filename], ranges, 0, listener)
	End Method
	
	Method New(filename:String, ranges:Int[], count:Int, listener:IOnLoadAudioBufferComplete = Null, format:AudioFormat = Null, options:AudioBufferOptions = Null)
		If (Not options) options = DefaultOptions
		
		Self.options = New AudioBufferOptions(options)
		If (format) Self.format = New AudioFormat(format)
		
		InitQueue(count)
		UploadBuffersData([filename], ranges, count, listener)
	End Method
	
	Method Discard:Void()
		If (options.writeable Or options.readable) Then
			For Local info:BufferInfo = EachIn Self.info.Data
				If (Not info) Exit				
				info.data.Discard()
			Next
		End If
		
		buffer = 0
		data = Null
		
		Super.Discard()
	End Method
	
	Method WriteSamples:Void(buffer:Int, samples:Int[])
		Self.buffer = buffers[buffer]
		Self.data = info.Get(buffer).data
		Super.WriteSamples(samples)
		Self.buffer = 0
		Self.data = Null
	End Method
	
	Method WriteSamples:Void(buffer:Int, samples:Int[], _to:Int, from:Int, count:Int)
		Self.buffer = buffers[buffer]
		Self.data = info.Get(buffer).data
		Super.WriteSamples(samples, _to, from, count)
		Self.buffer = 0
		Self.data = Null
	End Method
	
	Method WriteSamples:Void(buffer:Int, samples:Float[])
		Self.buffer = buffers[buffer]
		Self.data = info.Get(buffer).data
		Super.WriteSamples(samples)
		Self.buffer = 0
		Self.data = Null
	End Method
	
	Method WriteSamples:Void(buffer:Int, samples:Float[], _to:Int, from:Int, count:Int)
		Self.buffer = buffers[buffer]
		Self.data = info.Get(buffer).data
		Super.WriteSamples(samples, _to, from, count)
		Self.buffer = 0
		Self.data = Null
	End Method
	
	Method WriteSamples:Void(buffer:Int, samples:DataBuffer)
		Self.buffer = buffers[buffer]
		Self.data = info.Get(buffer).data
		Super.WriteSamples(samples)
		Self.buffer = 0
		Self.data = Null
	End Method
	
	Method WriteSamples:Void(buffer:Int, samples:DataBuffer, _to:Int, from:Int, count:Int)
		Self.buffer = buffers[buffer]
		Self.data = info.Get(buffer).data
		Super.WriteSamples(samples, _to, from, count)
		Self.buffer = 0
		Self.data = Null
	End Method
	
	Method ReadSamples:Void(buffer:Int, samples:Int[])
		Self.buffer = buffers[buffer]
		Self.data = info.Get(buffer).data
		Super.ReadSamples(samples)
		Self.buffer = 0
		Self.data = Null
	End Method
	
	Method ReadSamples:Void(buffer:Int, samples:Int[], _to:Int, from:Int, count:Int)
		Self.buffer = buffers[buffer]
		Self.data = info.Get(buffer).data
		Super.ReadSamples(samples, _to, from, count)
		Self.buffer = 0
		Self.data = Null
	End Method
	
	Method ReadSamples:Void(buffer:Int, samples:Float[])
		Self.buffer = buffers[buffer]
		Self.data = info.Get(buffer).data
		Super.ReadSamples(samples)
		Self.buffer = 0
		Self.data = Null
	End Method
	
	Method ReadSamples:Void(buffer:Int, samples:Float[], _to:Int, from:Int, count:Int)
		Self.buffer = buffers[buffer]
		Self.data = info.Get(buffer).data
		Super.ReadSamples(samples, _to, from, count)
		Self.buffer = 0
		Self.data = Null
	End Method
	
	Method ReadSamples:Void(buffer:Int, samples:DataBuffer)
		Self.buffer = buffers[buffer]
		Self.data = info.Get(buffer).data
		Super.ReadSamples(samples)
		Self.buffer = 0
		Self.data = Null
	End Method
	
	Method ReadSamples:Void(buffer:Int, samples:DataBuffer, _to:Int, from:Int, count:Int)
		Self.buffer = buffers[buffer]
		Self.data = info.Get(buffer).data
		Super.ReadSamples(samples, _to, from, count)
		Self.buffer = 0
		Self.data = Null
	End Method
	
Private

	Field buffers:Int[]
	Field info:Stack<BufferInfo>
	
	Field loading:Int = 0
	
	Method InitQueue:Void(length:Int)
		buffers = buffers.Resize(length)
		info = New Stack<BufferInfo>()
		
		alGenBuffers(length, buffers)
	End Method
	
	Method InitBuffersInfo:Void(lengths:Int[])
		length = 0
		size = 0
	
		For Local length:Int = EachIn lengths
			Local info:BufferInfo = New BufferInfo()
			info.data = New DataBuffer(length * format.channels * format.bytes, True)
			info.length = length
			info.size = info.data.Length
						
			Self.info.Push(info)
			Self.length += length
			size += info.size			
		Next
		
		loaded = True
	End Method
	
	Method Dispose:Void()
		Super.Dispose()
		alDeleteBuffers(buffers.Length(), buffers)
	End Method
	
	Method AttachToSource:Void(source:IAudioSource)
		PushSource(source)
		alSourceQueueBuffers(source.ALSource(), buffers.Length(), buffers)
	End Method
	
	Method DetachFromSource:Void(source:IAudioSource)
		alSourceUnqueueBuffers(source.ALSource(), buffers.Length(), buffers)
		RemoveSource(source)
	End Method
	
	Method UploadBuffersData:Void(filenames:String[], ranges:Int[], count:Int, listener:IOnLoadAudioBufferComplete)
		Local freq:Int = GetUploadFrequency()
		Local internalFormat:Int = GetUploadFormat()
		Local needData:Bool = (options.writeable Or options.readable)
		
		If (count = 0 And ranges.Length() = 0) Then		
			For Local filename:String = EachIn filenames
				Local info:BufferInfo = New BufferInfo()
				If (needData) info.data = New DataBuffer(0, True)
				Self.info.Push(info)
				
				loading += 1
			Next
			
			Local i:Int = 0
			For Local filename:String = EachIn filenames
				DoUploadBufferData(filename, buffers[i], Self.info.Data[i].data, listener, internalFormat, freq)
				i += 1
			Next
		Else
			If (ranges.Length() = 0) Then
				For Local i:Int = 0 Until count
					Local info:BufferInfo = New BufferInfo()
					If (needData) info.data = New DataBuffer(0, True)
					Self.info.Push(info)
				Next
			Else
				Local st:Int = 1
				If (count > 0 And ranges.Length() / count = 2) st = 2
				Local i:Int = 0
				Local l:Int = ranges.Length()
				
				Local lastOffset:Int
				
				While(i<l)
					Local info:BufferInfo = New BufferInfo()
					If (needData) info.data = New DataBuffer(0, True)
				
					If (st = 1) Then
						info.offset = lastOffset
						info.length = ranges[i] - lastOffset
						lastOffset = ranges[i]
					Else
						info.offset = ranges[i]
						info.length = ranges[i+1]
					End If
				
					Self.info.Push(info)
					i += st
				Wend
			End If
		
			loading += 1
			data = New DataBuffer(0, True)
			DoUploadBufferData(filenames[0], 0, data, listener, internalFormat, freq)
		End If
	End Method
	
	Method UpdateInfo:Void()		
		If (data) Then
			If (Not format) format = New AudioFormat(bufferInfo[1], bufferInfo[0])
			options.frequency = bufferInfo[2]
		
			Local j:Int = 0
		
			For Local info:BufferInfo = EachIn Self.info.Data
				If (Not info) Exit
			
				If (info.length = 0) Then
					alBufferData(buffers[j], format.internalFormat, data, data.Length, options.frequency)
				Else
					alBufferData(buffers[j], format.internalFormat, data, info.length * format.bytes * format.channels, info.offset * format.bytes * format.channels, options.frequency)
				End If
				
				j += 1
			Next
			
			data = Null
		Else
			If (Not format) format = New AudioFormat(alGetBufferi(buffers[0], AL_BITS) / 8, alGetBufferi(buffers[0], AL_CHANNELS))
			options.frequency = alGetBufferi(buffers[0], AL_FREQUENCY)
		End If
		
		size = 0
		length = 0
	
		Local i:Int = 0
		For Local info:BufferInfo = EachIn Self.info.Data
			If (Not info) Exit
		
			Local size:Int
		
			If (info.data) Then
				size = info.data.Length
			Else
				size = alGetBufferi(buffers[i], AL_SIZE)
			End If
	
			info.size = size
			info.length = size / (format.bytes * format.channels)
			
			Self.size += info.size
			Self.length += info.length
			
			i += 1
		Next
	End Method
	
	Method CalcDuration:Void()
		duration = 0

		For Local info:BufferInfo = EachIn Self.info.Data
			If (Not info) Exit
		
			info.duration = info.size / Float(options.frequency * format.channels * format.bytes)
			duration += info.duration
		Next
	End Method
	
	Method IsLoadComplete:Bool()
		loading -= 1
		Return (loading = 0)
	End Method

End Class

'note: TODO
' - To add Wrire/Read samples from/to specified channel
Class AudioBuffer
	
	Method New(length:Int, frequency:Int = AUDIO_FREQUENCY_DEFAULT, format:AudioFormat = AUDIO_FORMAT_DEFAULT)
		If (frequency = AUDIO_FREQUENCY_DEFAULT) frequency = AUDIO_FREQUENCY_DEFAULT_VALUE
		If (format = AUDIO_FORMAT_DEFAULT) format = AUDIO_FORMAT_STEREO16	
		options = New AudioBufferOptions(True, True, frequency)
		Init()
		
		data = New DataBuffer(length * format.channels * format.bytes, True)
		alBufferData(buffer, format.internalFormat, data, data.Length, frequency)
		
		Self.format = New AudioFormat(format)
		Self.length = length
		Self.size = data.Length
		loaded = True
		CalcDuration()
	End Method

	Method New(filename:String, listener:IOnLoadAudioBufferComplete = Null, format:AudioFormat = AUDIO_FORMAT_DEFAULT, options:AudioBufferOptions = Null)
		If (Not options) options = DefaultOptions		
		
		Self.options = New AudioBufferOptions(options)
		If (format) Self.format = New AudioFormat(format)
			
		Init()
		UploadBufferData(filename, listener)
	End Method
	
	Method New(buffer:AudioBuffer, start:Int, _end:Int, mode:Int = AUDIO_SLICE_MODE_SAMPLES)
		If (Not buffer.data) Then
			Error("Buffer must be readeable or writeable")	
		End If
	
		If (Not buffer.loaded) Then
			Error("Attempt to copy not loaded buffer")
		End If
	
		options = New AudioBufferOptions(buffer.options)
		format = New AudioFormat(buffer.format)
		
		Init()
		
		Select (mode)		
			Case AUDIO_SLICE_MODE_SAMPLES
				If (_end <> 0) _end *= format.bytes * format.channels
				start *= format.bytes * format.channels
				
			Case AUDIO_SLICE_MODE_MILLISECS
				If (_end <> 0) _end = SecToBytes(_end / 1000.0, format.channels, format.bytes, options.frequency)
				start = SecToBytes(start / 1000.0, format.channels, format.bytes, options.frequency)
		End Select
		
		If (_end = 0) Then
			_end = buffer.data.Length
		End If
		
		data = New DataBuffer(_end - start, True)
		CopyDataBufferByteToByte(buffer.data, data, 0, start, _end - start)
		
		alBufferData(Self.buffer, format.internalFormat, data, data.Length, options.frequency)
		Complete()
	End Method
	
	Method Discard:Void()
		If (data) Then
			data.Discard()
		End If
		
		Dispose()
	End Method
	
	Method WriteSamples:Void(samples:Int[])
		If (Not options.writeable) Return
		
		Select (format.bytes)
			Case 1			
				CopyBytesToDatabuffer(samples, data)				
			Case 2
				CopyShortsToDatabuffer(samples, data)				
			Case 4
				CopyIntsToDatabuffer(samples, data)
		End Select

		UpdateBuffer()
	End Method
	
	Method WriteSamples:Void(samples:Int[], _to:Int, from:Int, count:Int)
		If (Not options.writeable) Return
	
		Select (format.bytes)
			Case 1
				CopyBytesToDatabuffer(samples, data, _to, from, count)			
			Case 2
				CopyShortsToDatabuffer(samples, data, _to Shl 1, from, count)				
			Case 4
				CopyIntsToDatabuffer(samples, data, _to Shl 2, from, count)
		End Select
		
		UpdateBuffer()
	End Method
	
	Method WriteSamples:Void(samples:Float[])
		If (Not options.writeable) Return
		If (format.bytes <> 4) Return
		
		CopyFloatsToDatabuffer(samples, data)
		UpdateBuffer()
	End Method
	
	Method WriteSamples:Void(samples:Float[], _to:Int, from:Int, count:Int)
		If (Not options.writeable) Return
		If (format.bytes <> 4) Return
	
		CopyFloatsToDatabuffer(samples, data, _to Shl 2, from, count)		
		UpdateBuffer()
	End Method
	
	Method WriteSamples:Void(samples:DataBuffer)
		If (Not options.writeable) Return
		
		CopyDataBufferToDataBuffer(samples, data)		
		UpdateBuffer()
	End Method
	
	Method WriteSamples:Void(samples:DataBuffer, _to:Int, from:Int, count:Int)
		If (Not options.writeable) Return
		
		Select (format.bytes)
			Case 2
				_to Shl= 1
				from Shl= 1
				count Shl= 1
			Case 4
				_to Shl= 2
				from Shl= 2
				count Shl= 2
		End Select
		
		CopyDataBufferToDataBuffer(samples, data, _to, from, count)		
		UpdateBuffer()
	End Method
	
	Method ReadSamples:Void(samples:Int[])
		If (Not options.readable) Return
		
		Select (format.bytes)
			Case 1
				CopyBytesFromDataBuffer(data, samples)
			Case 2
				CopyShortsFromDataBuffer(data, samples)
			Case 4
				CopyIntsFromDataBuffer(data, samples)
		End Select
	End Method
	
	Method ReadSamples:Void(samples:Int[], _to:Int, from:Int, count:Int)
		If (Not options.readable) Return
		
		Select (format.bytes)
			Case 1
				CopyBytesFromDataBuffer(data, samples, _to, from, count)
			Case 2
				CopyShortsFromDataBuffer(data, samples, _to, from Shl 1, count)
			Case 4
				CopyIntsFromDataBuffer(data, samples, _to, from Shl 2, count)
		End Select
	End Method
	
	Method ReadSamples:Void(samples:Float[])
		If (Not options.readable) Return
		If (format.bytes <> 4) Return
		CopyFloatsFromDataBuffer(data, samples)
	End Method
	
	Method ReadSamples:Void(samples:Float[], _to:Int, from:Int, count:Int)
		If (Not options.readable) Return
		If (format.bytes <> 4) Return
		
		CopyFloatsFromDataBuffer(data, samples, _to, from Shl 2, count)
	End Method
	
	Method ReadSamples:Void(samples:DataBuffer)
		If (Not options.readable) Return
		CopyDataBufferToDataBuffer(data, samples)
	End Method
	
	Method ReadSamples:Void(samples:DataBuffer, _to:Int, from:Int, count:Int)
		If (Not options.readable) Return
		
		Select (format.bytes)
			Case 2
				_to Shl= 1
				from Shl= 1
				count Shl= 1
			Case 4
				_to Shl= 2
				from Shl= 2
				count Shl= 2
		End Select
		
		CopyDataBufferToDataBuffer(data, samples)
	End Method
	
	Method Slice:AudioBuffer(start:Int, _end:Int, mode:Int = AUDIO_SLICE_MODE_SAMPLES)
		Return New AudioBuffer(Self, start, _end, mode)
	End Method

	Method Loaded:Bool() Property
		Return loaded
	End Method
	
	Method Frequency:Int() Property
		If (Not loaded) Return 0
		Return options.frequency
	End Method
	
	Method Channels:Int() Property
		If (Not loaded) Return 0
		Return format.channels
	End Method
	
	Method Size:Int() Property
		If (Not loaded) Return 0
		Return size
	End Method
	
	Method Length:Int() Property
		If (Not loaded) Return 0
		Return length
	End Method
	
	Method Duration:Float() Property
		If (Not loaded) Return 0
		Return duration
	End Method

	Method ALBuffer:Int() Property
		Return buffer
	End Method	

Private

	Field buffer:Int
	Field data:DataBuffer
	
	Field loaded:Bool
	
	Field options:AudioBufferOptions	
	Field format:AudioFormat
	
	Field size:Int	
	Field length:Int	
	Field duration:Float
	
	Field sources:Stack<IAudioSource>	
	Field lockOffset:Int	
	Field lockState:Int
	
	Field bufferInfo:Int[3]
	
	Method Init:Void()
		buffer = alGenBuffer()
	End Method
	
	Method AttachToSource:Void(source:IAudioSource)
		PushSource(source)
		alSourcei(source.ALSource(), AL_BUFFER, buffer)		
	End Method
	
	Method DetachFromSource:Void(source:IAudioSource)
		alSourcei(source.ALSource(), AL_BUFFER, 0)
		RemoveSource(source)
	End Method
	
	Method PushSource:Void(source:IAudioSource)
		If (Not sources) Then
			sources = New Stack<IAudioSource>()
		End If
		
		If (Not sources.Contains(source)) Then
			sources.Push(source)
		End If
	End Method
	
	Method RemoveSource:Void(source:IAudioSource)
		sources.RemoveFirst(source)
	End Method
	
	Method UnlockBuffer:Void()
		If (sources) Then		
			For Local source:IAudioSource = EachIn sources
				lockOffset = source.ByteOffset()
				lockState = source.State()
				source.Stop()
				alSourcei(source.ALSource(), AL_BUFFER, 0)
			Next
		End If
	End Method
	
	Method LockBuffer:Void()
		If (sources) Then
			For Local source:IAudioSource = EachIn sources
				alSourcei(source.ALSource(), AL_BUFFER, buffer)				
				
				If (lockState = AUDIO_STATE_PLAYING) Then
					source.Play()
				End If
				
				source.ByteOffset(lockOffset)
			Next
		End If
	End Method
	
	Method UpdateBuffer:Void()
		UnlockBuffer()
		alBufferData(buffer, format.internalFormat, data, data.Length, options.frequency)
		LockBuffer()
	End Method
	
	Method Dispose:Void()
		If (sources) Then
			For Local source:IAudioSource = EachIn sources
				source.Buffer(Null)						
			Next
		End If
	
		If (buffer) Then
			alDeleteBuffer(buffer)
			buffer = 0
		End If
	End Method
	
	Method UploadBufferData:Void(filename:String, listener:IOnLoadAudioBufferComplete)
		If (options.readable Or options.writeable) Then
			data = New DataBuffer(0, True)
		End If

		DoUploadBufferData(filename, buffer, data, listener, GetUploadFormat(), GetUploadFrequency())	
	End Method
	
	Method DoUploadBufferData:Void(filename:String, buffer:Int, data:DataBuffer, listener:IOnLoadAudioBufferComplete, internalFormat:Int, freq:Int)
#If TARGET = "html5"
		alUploadBufferData(filename, buffer, data, New AudioBufferLoadListener(Self, listener), internalFormat, freq, bufferInfo)
#Else
		alUploadBufferData(filename, buffer, data, Null, internalFormat, freq, bufferInfo)
		If (IsLoadComplete()) Then
			Complete()
			If (listener) listener.OnLoadAudioBufferComplete(Self)
		End If
#End
	End Method
	
	Method Complete:Void()
		loaded = True
		UpdateInfo()
		CalcDuration()
	End Method
	
	Method UpdateInfo:Void() 
		If (Not format) format = New AudioFormat(alGetBufferi(buffer, AL_BITS) / 8, alGetBufferi(buffer, AL_CHANNELS))		
		If (format.bytes = 0 Or format.channels = 0) Error "Audio format is not supported!"
	
		Local size:Int
		
		If (data) Then
			size = data.Length
		Else
			size = alGetBufferi(buffer, AL_SIZE)
		End If
	
		Self.size = size
		length = size / (format.bytes * format.channels)
		options.frequency = alGetBufferi(buffer, AL_FREQUENCY)
	End Method
	
	Method CalcDuration:Void()
		duration = size / Float(options.frequency * format.channels * format.bytes)
	End Method
	
	Method IsLoadComplete:Bool()
		Return True
	End Method
	
	Method GetUploadFrequency:Int()
		If (options.frequency <> 0) Then
			Return options.frequency
		End If
		
		Return 0
	End Method
	
	Method GetUploadFormat:Int()
		If (format <> AUDIO_FORMAT_DEFAULT) Then
			Return format.internalFormat
		End If
		
		Return 0
	End Method

End Class

Class AudioFormat

	Method New(format:AudioFormat)
		If (supported < 0) Then
			Select (format.internalFormat)
				Case AL_FORMAT_MONO_FLOAT32, AL_FORMAT_STEREO_FLOAT32
					supported = Int(alIsExtensionPresent("AL_EXT_float32"))
			End Select
		End If
		
		If (Not supported) Then
			Error("Audio format is not supported!")
		End If
	
		Init(format.bytes, format.channels, format.internalFormat)
	End Method
	
	Method New(bytes:Int, channels:Int, needCheck:Bool = False)
		Init(bytes, channels)
		If (needCheck) supported = -1
	End Method
		
	Private

	Field supported:Int = 1

	Field bytes:Int
	
	Field channels:Int
	
	Field internalFormat:Int
	
	Method Init:Void(bytes:Int, channels:Int)
		Self.bytes = bytes
		Self.channels = channels
		
		Select (bytes)
			Case 1
				If (channels = 1) Then
					internalFormat = AL_FORMAT_MONO8
				Else
					internalFormat = AL_FORMAT_STEREO8
				End If

			Case 2
				If (channels = 1) Then
					internalFormat = AL_FORMAT_MONO16
				Else
					internalFormat = AL_FORMAT_STEREO16
				End If
			Case 3, 4
				If (channels = 1) Then
					internalFormat = AL_FORMAT_MONO_FLOAT32
				Else
					internalFormat = AL_FORMAT_STEREO_FLOAT32
				End If
		End Select
	End Method
	
	Method Init:Void(bytes:Int, channels:Int, internalFormat:Int)
		Self.bytes = bytes
		Self.channels = channels
		Self.internalFormat = internalFormat
	End Method

End Class

Private

Class BufferInfo

	Field data:DataBuffer
	Field size:Int
	Field length:Int
	Field offset:Int
	Field duration:Float

End Class

Const AUDIO_FREQUENCY_DEFAULT_VALUE:Int = 11025
Global DefaultOptions:AudioBufferOptions = New AudioBufferOptions()

Function SecToBytes:Int(sec:Float, channels:Int, bytes:Int, freq:Int)
	Local result:Int result = sec * channels * bytes * freq
	Local align:Int = bytes * channels
	
	If (align = 2)  Then
		result -= (result & 1);
	Else
		While (result Mod align)
			result -= (result Mod align)
		Wend
		
		If (result < 0) result = 0
	End If

	Return result
End Function

#If TARGET = "html5"

Class AudioBufferLoadListener Extends EventListener

	Field buffer:AudioBuffer
	
	Field listener:IOnLoadAudioBufferComplete

	Method New(buffer:AudioBuffer, listener:IOnLoadAudioBufferComplete)
		Self.buffer = buffer
		Self.listener = listener
	End Method

	
	Method handleEvent:Int(event:Event)		
		If (buffer.IsLoadComplete()) Then	
			buffer.Complete()
			If (listener) listener.OnLoadAudioBufferComplete(buffer)
		End If
		
		Return 0
	End Method

End Class

#End
