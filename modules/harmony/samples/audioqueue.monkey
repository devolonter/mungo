
Import harmony.mojo

Function Main()
	New AudioQueueSample()
End

Class AudioQueueSample Extends App Implements IOnLoadAudioBufferComplete

	Global DefaultOptions:AudioBufferOptions = New AudioBufferOptions(False, False, 11025)

	Field source:AudioSource<AudioBuffersQueue>

	Field simpleQueue:AudioBuffersQueue
	Field multifileQueue:AudioBuffersQueue
	Field audioAtlas:AudioBuffersQueue
	
	Field loading:Int = 0
	
	Method OnCreate()				
		loading += 1
		simpleQueue = New AudioBuffersQueue("monkey://data/shoot_stereo.wav", 2, Self, AUDIO_FORMAT_DEFAULT, DefaultOptions)
		
		loading += 1
		multifileQueue = New AudioBuffersQueue(["monkey://data/shoot_stereo.wav", "monkey://data/shoot_mono.wav"], Self, AUDIO_FORMAT_STEREO16, DefaultOptions)
		
		loading += 1
		audioAtlas = New AudioBuffersQueue("monkey://data/shoot_stereo.wav", [0, 500, 1000, 1500, 2000, 2500], 3, Self, AUDIO_FORMAT_STEREO16, DefaultOptions)
		
		source = New AudioSource<AudioBuffersQueue>()
		SetUpdateRate(0)	
	End Method
	
	Method OnUpdate()
		If (loading <> 0) Return
		
		If (KeyHit(KEY_1)) Then
			source.Buffer = simpleQueue
			source.Play()
		End If
		
		If (KeyHit(KEY_2)) Then
			source.Buffer = multifileQueue
			source.Play()
		End If
		
		If (KeyHit(KEY_3)) Then
			source.Buffer = audioAtlas
			source.Play()
		End If
	End Method
	
	Method OnLoadAudioBufferComplete:Void(buffer:AudioBuffer)
		loading -= 1
	End Method
	
End Class
