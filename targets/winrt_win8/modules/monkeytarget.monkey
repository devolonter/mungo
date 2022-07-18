
#WINRT_TABLET=True
#BRL_GAMETARGET_IMPLEMENTED=True

Import brl.gametarget

Import "native/winrtgame.cpp"
Import "native/monkeytargetbase.cpp"

#If Not OPENGL_GLES20_ENABLED

Import "native/monkeytarget.cpp"

#Else

Import "native/monkeytarget.gles20.cpp"
	
#End
