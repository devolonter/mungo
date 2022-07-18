Strict

Import brl.databuffer
Import audiolistener

Private

Import al

Public

Const DISTANCE_MODEL_NONE:Int = AL_NONE
Const DISTANCE_MODEL_INVERSE:Int = AL_INVERSE_DISTANCE
Const DISTANCE_MODEL_LINEAR:Int = AL_LINEAR_DISTANCE
Const DISTANCE_MODEL_EXPONENT:Int = AL_EXPONENT_DISTANCE

Class AudioContext

	Method New(context:ALCcontext)
		Self.context = context
		listener = New AudioListener()
		
		If (Not Contexts) Then
			Contexts = New Stack<AudioContext>()
		End If
		
		Contexts.Push(Self)
	End Method
	
	Method Discard:Void()
		If (context) alcDestroyContext(context)
		If (CurrentContext = Self) CurrentContext = Null
		Contexts.RemoveFirst(Self)
	End Method
	
	Method Pause:Void()
		If (context) alcSuspendContext(context)
	End Method
	
	Method Resume:Void()
		If (context) alcProcessContext(context)
	End Method
	
	Method DistanceModel:Void(model:Int) Property
		alDistanceModel(model)
	End Method
	
	Method DistanceModel:Int() Property
		Return alGetInteger(AL_DISTANCE_MODEL)
	End Method
	
	Method Listener:AudioListener() Property
		Return listener
	End Method
	
	Function Create:AudioContext()
		If (Not AudioDevice)
			AudioDevice = alcOpenDevice()
		
			If (Not AudioDevice) Then
				AudioDevice = alcOpenDevice("Generic Hardware")
				If (Not AudioDevice) Then
					AudioDevice = alcOpenDevice("Generic Software")
				End If
			End If
		
			If (Not AudioDevice) Then
				If (MakeCurrent(New AudioContext(Null))) Then
					Return GetCurrent()
				End If
			End If
		End If
		
		If (MakeCurrent(New AudioContext(alcCreateContext(AudioDevice)))) Then			
			Return GetCurrent()
		End If
		
		Return Null
	End Function
	
	Function MakeCurrent:Bool(audioContext:AudioContext)
		If (audioContext = CurrentContext) Return True
		
		If (Not audioContext.context) Then
			CurrentContext = audioContext
			Return True
		End If
	
		If (alcMakeContextCurrent(audioContext.context)) Then
			CurrentContext = audioContext
			Return True
		End If
		
		Return False
	End Function
	
	Function GetCurrent:AudioContext()
		If (Not CurrentContext) AudioContext.Create()
		Return CurrentContext
	End Function
	
	Function DestroyAll:Void()
		alcMakeContextCurrent(Null)
	
		If (Contexts) Then
			For Local ctx:AudioContext = EachIn Contexts
				If (ctx.context) alcDestroyContext(ctx.context)
			Next
			
			Contexts.Clear()
		End If
		
		If (AudioDevice) alcCloseDevice(AudioDevice)
	End Function
	
	Function PauseAll:Void()
		If (CurrentContext) Then
			alcMakeContextCurrent(Null)
			If (CurrentContext.context) alcSuspendContext(CurrentContext.context)
		End If
		
		If (AudioDevice) alcPauseDevice(AudioDevice)
	End Function
	
	Function ResumeAll:Void()
		If (AudioDevice) alcResumeDevice(AudioDevice)
	
		If (CurrentContext And CurrentContext.context) Then
			alcMakeContextCurrent(CurrentContext.context)
			alcProcessContext(CurrentContext.context)
		End If
	End Function
	
Private

	Global Contexts:Stack<AudioContext>

	Field listener:AudioListener
	Field context:ALCcontext

End Class

Private

Global AudioDevice:ALCdevice
Global CurrentContext:AudioContext
