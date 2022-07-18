
Friend mojo.audio

Private

Import harmony.backend.audio
Import harmony.backend.audio.al
Import mojo.data
Import utils

Public

Class AudioDevice
	
	Method New()
		Audio = Self
		AudioContext.Create()
		
		For Local i:Int =0 Until channels.Length()
			channels[i] = New AudioSource<AudioBuffer>()
		Next
		
		musicCache = New StringMap<MusicSample>()
	End Method
	
	Method Discard()
		AudioContext.DestroyAll()
	End Method
	
	Method Suspend()
		AudioContext.PauseAll()
	End Method
	
	Method Resume()
		AudioContext.ResumeAll()
	End Method
	
	Method LoadSample:Sample( path$ )
		If (Not IsMojoAssetExists(FixDataPath(path))) Return Null
		Local sample:Sample = New Sample()
		New AudioBuffer(path, sample)
		Return sample
	End Method
	
	Method CreateSample:Sample(length:Int, hertz:Int, format:AudioFormat)
		Local sample:Sample = New Sample()
		sample.buffer = New AudioBuffer(length, hertz, format)
		Return sample
	End Method
	
	Method PlaySample( sample:Sample,channel,flags )
		If (Not sample.buffer) Then
			sample.state = 1
			sample.channel = channel
			sample.flags = flags
			Return
		End If
			
		Local ch := channels[channel]
		
		ch.Buffer = sample.buffer
		ch.Stop()
		ch.Loop = (flags = 1)
		ch.Play()
	End Method
	
	Method StopChannel( channel )
		channels[channel].Stop()
	End Method
	
	Method PauseChannel( channel )
		channels[channel].Pause()
	End Method
	
	Method ResumeChannel( channel )
		channels[channel].Resume()
	End Method
	
	Method ChannelState( channel )
		If (channels[channel].State = AUDIO_STATE_PLAYING) Then
			Return 1
		ElseIf (channels[channel].State = AUDIO_STATE_PAUSED) Then
			Return 2
		End If
		
		Return 0
	End Method
	
	Method SetVolume( channel,volume# )
		channels[channel].Volume = volume
	End Method
	
	Method SetPan( channel,pan# )
		channels[channel].Pan = pan
	End Method
	
	Method SetRate( channel,rate# )
		channels[channel].Pitch = rate
	End Method
	
	Method PlayMusic( path$,flags )
		If (musicCache.Contains(path)) Then
			Local sample:MusicSample = musicCache.Get(path)
			
			If (sample.buffer) Then
				PlaySample(sample, MUSIC_CHANNEL, flags)
			Else
				sample.state = 1
				sample.flags = flags
			End If
			
			Return
		End If
		
		Local sample:MusicSample = New MusicSample()
		sample.flags = flags
		sample.state =  1
		
		New AudioBuffer(path, sample)
		musicCache.Set(path, sample)
	End Method
	
	Method StopMusic()
		StopChannel(MUSIC_CHANNEL)
	End Method
	
	Method PauseMusic()
		PauseChannel(MUSIC_CHANNEL)
	End Method
	
	Method ResumeMusic()
		ResumeChannel(MUSIC_CHANNEL)
	End Method
	
	Method MusicState()
		Return ChannelState(MUSIC_CHANNEL)
	End Method
	
	Method SetMusicVolume( volume# )
		SetVolume(MUSIC_CHANNEL, volume)
	End Method
	
	Method Html5ContextInit:Void()
	#If TARGET = "html5"
			If (isHtml5ContextInit) Return
			
			Resume()
			isHtml5ContextInit = True
	#End		
		End Method
	
	Method Html5Init:Void()
#If TARGET = "html5"
		If (isHtml5Init) Return
		
		alcInitDevice()
		isHtml5Init = True
#End		
	End Method
	
	Private

	Const MUSIC_CHANNEL:Int = 32

	Global DefaultOptions = New AudioBufferOptions()

	Field channels:AudioSource<AudioBuffer>[33]
	Field musicCache:StringMap<MusicSample>
	
	Field isHtml5Init:Bool
	Field isHtml5ContextInit:Bool

End Class

Class Sample Implements IOnLoadAudioBufferComplete

	Method Discard:Void()
		If (buffer.Loaded) Then
			buffer.Discard()
		End If
	End Method

	Private
	
	Field buffer:AudioBuffer
	
	Field state:Int
	Field channel:Int
	Field flags:Int
	
	Method OnLoadAudioBufferComplete:Void(buffer:AudioBuffer)
		Self.buffer = buffer
		
		If (state = 1) Then
			Audio.PlaySample(Self, channel, flags)
		End If
	End Method

End

Class MusicSample Extends Sample

	Method New()
		channel = AudioDevice.MUSIC_CHANNEL
	End Method

End Class

Private

Global Audio:AudioDevice
