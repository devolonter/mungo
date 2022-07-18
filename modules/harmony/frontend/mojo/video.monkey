Strict

Import "native/video.${TARGET}.${LANG}"

Private

Import harmony.backend
Import brl.databuffer

Extern Private

Class MojoVideoDelegate
	
	Method Playing:Void(video:DataBuffer)
	Method Timeupdate:Void(video:DataBuffer)

End

Class VideoClip = "MojoVideoClip"
	
	Method Load(path:String)
	
Private
	
	Field autoplay:Bool
	Field muted:Bool
	Field loop:Bool
	
	Method SetDelegate:Void(delegate:VideoDelegate)

Private

Class VideoDelegate Extends MojoVideoDelegate

	Field pixmap:PixmapContainer
	
	Method New(texture:Texture2D)
		pixmap = New PixmapContainer(texture.Width, texture.Height)
	End
	
	Method Playing:Void(video:DataBuffer)
		pixmap.SetData(video)
	End
	
	Method Timeupdate:Void(video:DataBuffer)
		pixmap.SetData(video)
	End
	
End

Public

Class Video Extends VideoClip
	
	Method New(path:String, image:Image)
		Self.image = image
		delegate = New VideoDelegate(image.surface.texture)
		
		autoplay = True
		muted = True
		loop = True
		
		Load(path, delegate)
	End
	
	Method Render:Void()
		image.surface.texture.Draw(delegate.pixmap, 0, 0)
	End
	
Private

	Field delegate:VideoDelegate
	Field image:Image
	
End