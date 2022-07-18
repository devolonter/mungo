
#GLFW_USE_MINGW=False

Import harmony.mojo
Import harmony.backend

Function Main()
	New AudioBufferSample()
End

Class AudioBufferSample Extends App Implements IOnLoadAudioBufferComplete

	Global DefaultOptions:AudioBufferOptions = New AudioBufferOptions(True, False, 11025)

	Field source:AudioSource<AudioBuffer>
	
	Field originBuffer:AudioBuffer
	Field slicedBuffer:AudioBuffer
	Field viewBuffer:AudioBufferView
	
	Field currentBuffer:AudioBuffer
	
	Field samples:Int[]
	
	Field loading:Int = 0
	
	Method OnCreate()			
		loading += 1
		originBuffer = New AudioBuffer("monkey://data/shoot_stereo.wav", Self, AUDIO_FORMAT_STEREO16, DefaultOptions)
		
		source = New AudioSource<AudioBuffer>()
		SetUpdateRate(0)
	End Method
	
	Method OnUpdate()
		If (loading <> 0) Return
		
		If (KeyHit(KEY_1)) Then
			ChangeBuffer(originBuffer)
		End If
		
		If (KeyHit(KEY_2)) Then
			ChangeBuffer(slicedBuffer)
		End If
		
		If (KeyHit(KEY_3)) Then
			ChangeBuffer(viewBuffer)
		End If
		
		If (KeyHit(KEY_SPACE)) Then
			source.Buffer = currentBuffer
			source.Play()
		End If
	End Method
	
	Method OnRender()
		If (loading <> 0) Return
	
		Cls()
		
		DrawChannel(0)
		
		If (currentBuffer.Channels = 2) Then
			DrawChannel(1)
		End If
	End Method
	
	Method ChangeBuffer:Void(newBuffer:AudioBuffer)
		If (newBuffer = currentBuffer) Return
	
		samples = samples.Resize(newBuffer.Length)
		newBuffer.ReadSamples(samples)
		
		currentBuffer = newBuffer
	End Method
	
	Method DrawChannel:Void(channel:Int)
		Local zeroY:Float
	
		Local channels:Int = currentBuffer.Channels 
		If (channels = 2) Then
			Select channel
				Case 0
					zeroY = DeviceHeight() / 4
				Case 1
					zeroY = DeviceHeight() - DeviceHeight() / 4
			End Select
		Else
			zeroY = DeviceHeight() / 2
		End If
		
		Local state:Int = source.State
		If (state = AUDIO_STATE_PLAYING Or state = AUDIO_STATE_PAUSED) Then
			Local prevY:Float = zeroY

			For Local i:Int = 0 Until DeviceWidth()
				Local offset:Int = source.Offset + i*channels + channel
				Local y:Float = zeroY
				
				If (offset < samples.Length()) Then
					y += (samples[offset] / 32768.0) * (DeviceWidth() / 5)
				End If
				
				If (Abs(prevY - y) > 1) Then
					DrawLine(i, prevY, i, y)
				Else
					DrawPoint(i, y)
				End If
				
				prevY = y
			Next
		Else
			For Local i:Int = 0 Until DeviceWidth()
				DrawPoint(i, zeroY)
			Next
		End If
	End Method
	
	Method OnLoadAudioBufferComplete:Void(buffer:AudioBuffer)		
		slicedBuffer = buffer.Slice(0, 250, AUDIO_SLICE_MODE_MILLISECS)
		viewBuffer = New AudioBufferView(buffer, 0, 250, AUDIO_SLICE_MODE_MILLISECS)
		
		ChangeBuffer(buffer)		
		loading -= 1
	End Method
	
End Class