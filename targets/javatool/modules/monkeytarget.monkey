
Import brl.gametarget

Import "native/javatoolhelper.java"

#JAVATOOL_WINDOW_WIDTH=640
#JAVATOOL_WINDOW_HEIGHT=480

#JAVATOOL_BRL_OS=True
#JAVATOOL_BRL_FILESYSTEM=True
#JAVATOOL_BRL_HTTPREQUEST=True
#JAVATOOL_BRL_THREAD=True
#JAVATOOL_BRL_GAMETARGET=False

#If JAVATOOL_BRL_FILESYSTEM
	#BRL_OS_IMPLEMENTED=True
	Import "native/os.java"
#EndIf

#If JAVATOOL_BRL_FILESYSTEM
	#BRL_FILESYSTEM_IMPLEMENTED=True
	Import "native/filesystem.java"
#EndIf

#If JAVATOOL_BRL_HTTPREQUEST
	#BRL_HTTPREQUEST_IMPLEMENTED=True
	#JAVATOOL_BRL_THREAD=True
	Import "native/httprequest.java"
#EndIf

#If JAVATOOL_BRL_THREAD
	#BRL_THREAD_IMPLEMENTED=True
	' BBHttpRequest requires BBThread
	Import "../../../modules/brl/native/thread.java"
#EndIf

#If JAVATOOL_BRL_GAMETARGET
	#BRL_GAMETARGET_IMPLEMENTED=True
	#MOJO_DRIVER_IMPLEMENTED=True
	Import "native/mojo.java"
	Import "native/monkeytarget.java"
#Else
	Import "native/monkeytargetstub.java"
#EndIf
