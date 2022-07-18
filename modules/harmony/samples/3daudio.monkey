
#HTML5_WEBAUDIO_ENABLED=False
#GLFW_USE_MINGW=False

Import harmony.mojo
Import harmony.backend.audio

Function Main()
	New Audio3DSample()
End

Class Audio3DSample Extends App

	Field audioSource:AudioSource3D<AudioBuffer>

	Method OnCreate()
		AudioContext.GetCurrent().DistanceModel = DISTANCE_MODEL_LINEAR
		AudioContext.GetCurrent().Listener.SetPosition(DeviceWidth() / 4, DeviceHeight() / 4, 0)
		
		audioSource = New AudioSource3D<AudioBuffer>()
		audioSource.Buffer = New AudioBuffer(4 * 22050, 22050, AUDIO_FORMAT_MONO16)
		
		Local samples:Int[audioSource.Buffer.Length / 2]
		
		For Local i:Int = 0 Until samples.Length()
			samples[i] = 32760 * Sinr((2.0 * PI * 440.0) / 22050 * i)
		Next
		
		audioSource.Buffer.WriteSamples(samples)
		audioSource.Loop = True
		audioSource.MaxDistance = DeviceHeight() / 2
		audioSource.SetPosition(DeviceWidth() / 2, DeviceHeight() / 2, 0)
		audioSource.Play()
		
		SetUpdateRate(0)
	End
	
	Method OnUpdate()	
		If (KeyHit(KEY_0)) Then
			AudioContext.GetCurrent().DistanceModel = DISTANCE_MODEL_NONE
		End If
		
		If (KeyHit(KEY_1)) Then
			AudioContext.GetCurrent().DistanceModel = DISTANCE_MODEL_LINEAR
		End If
		
		If (KeyHit(KEY_2)) Then
			AudioContext.GetCurrent().DistanceModel = DISTANCE_MODEL_EXPONENT
			AudioContext.GetCurrent().Listener.X = AudioContext.GetCurrent().Listener.X
		End If
		
		If (KeyHit(KEY_3)) Then
			AudioContext.GetCurrent().DistanceModel = DISTANCE_MODEL_INVERSE
		End If
	
		If (KeyDown(KEY_LEFT)) Then
			AudioContext.GetCurrent().Listener.X -= 1
		End If
		
		If (KeyDown(KEY_RIGHT)) Then
			AudioContext.GetCurrent().Listener.X += 1
		End If
		
		If (KeyDown(KEY_UP)) Then
			AudioContext.GetCurrent().Listener.Y -= 1
		End If
		
		If (KeyDown(KEY_DOWN)) Then
			AudioContext.GetCurrent().Listener.Y += 1
		End If
	End
	
	Method OnRender()
		Cls()
		
		SetColor(255, 0, 0)
		DrawCircle(audioSource.X, audioSource.Y, 10)
		SetAlpha(0.25)
		DrawCircle(audioSource.X, audioSource.Y, audioSource.MaxDistance)
		
		SetColor(255, 255 , 255)
		SetAlpha(1.0)
		DrawRect(AudioContext.GetCurrent().Listener.X - 5, AudioContext.GetCurrent().Listener.Y - 5, 10, 10)
		
		Local modelName:String
		Select (AudioContext.GetCurrent().DistanceModel)
			Case DISTANCE_MODEL_NONE
				modelName = "none"
				
			Case DISTANCE_MODEL_LINEAR
				modelName = "linear"
			
			Case DISTANCE_MODEL_EXPONENT
				modelName = "exponent"
			
			Case DISTANCE_MODEL_INVERSE
				modelName = "inverse"
		End Select
		
		DrawText("DistanceModel: " + modelName, 10, 10)
	End

End