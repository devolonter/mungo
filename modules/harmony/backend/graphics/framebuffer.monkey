Strict

Import texture
Import harmony.mojo

Private

Import gl
Import harmony.backend.graphics.exports
Import harmony.backend.utils
Import harmony.backend.restorable

Public

Class FrameBuffer Implements RestorableResource
	
	Method New(withDepth:Bool=False)
		Init(withDepth)
	End Method

	Method Init:Void(withDepth:Bool)
		If (Not managed) Then
			RestorableResources.AddResource(Self)
			managed = True
		End If

		If (DefaultFrameBufferID < 0)
			Local params:Int[1]
			glGetIntegerv(GL_FRAMEBUFFER_BINDING, params)
			DefaultFrameBufferID = params[0]
		End If
		
		frameBuffer = glCreateFramebuffer()

		withDepthBuffer = withDepth
		If (withDepthBuffer)
			depthBuffer = glCreateRenderbuffer()
		Endif
	End Method 
	
	Method Discard:Void()
		Dispose()

		If (managed) Then
			RestorableResources.RemoveResource(Self)
			managed = False
		End If
	End Method
	
	Method SetColorTarget:Void(texture:Texture2D, level:Int = 0)
		If (texture = colorTexture) Return
		
		texture.Bind()
		glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer)
		glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, texture.ID, level)

		If (withDepthBuffer)
			glBindRenderbuffer(GL_RENDERBUFFER, depthBuffer)
			glRenderbufferStorage(GL_RENDERBUFFER, $84F9, texture.Width, texture.Height)
			glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_STENCIL_ATTACHMENT, GL_RENDERBUFFER, depthBuffer)
		Endif

#If CONFIG="debug"
		Local result:Int = glCheckFramebufferStatus(GL_FRAMEBUFFER)
#End		
		
		glBindRenderbuffer(GL_RENDERBUFFER, 0)				
		texture.Unbind()
		glBindFramebuffer(GL_FRAMEBUFFER, DefaultFrameBufferID)
		
#If CONFIG="debug"		
		If (result <> GL_FRAMEBUFFER_COMPLETE)
			Print "Setup color target failed! Error code: " + result
			Return
		End If
#End		

		colorTexture = texture
	End Method
	
	Method Bind:Void()
		If (LatestActiveFrameBuffer = Self) Return		
		glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer)		
		LatestActiveFrameBuffer = Self
	End Method
	
	Method Unbind:Void()
		If (LatestActiveFrameBuffer <> Self) Return
		glBindFramebuffer(GL_FRAMEBUFFER, DefaultFrameBufferID)
		LatestActiveFrameBuffer = Null
	End Method
	
	Method Start:Void()
		Bind()
		glViewport(0, 0, colorTexture.Width, colorTexture.Height)
	End Method
	
	Method Finish:Void()		
		If (colorTexture.options.writeable) Then
			glReadPixels(0, 0, colorTexture.width, colorTexture.height, colorTexture.textureFormat.format, colorTexture.textureFormat.type, colorTexture.pixmap.data)
		End If
		
		Unbind()		
		glViewport(0, 0, BBGame.Game().GetDeviceWidth(), BBGame.Game().GetDeviceHeight())
	End Method
	
	Method Clear:Void()
		Bind()
		SetClearColor(0, 0, 0, 0)
		ClearScreen(CLEAR_MASK_COLOR)
	End Method	
	
	Method Width:Int() Property
		If (Not colorTexture) Return 0
		Return colorTexture.Width
	End Method
	
	Method Height:Int() Property
		If (Not colorTexture) Return 0
		Return colorTexture.Height
	End Method
	
Private

	Global DefaultFrameBufferID:Int = -1
	Global LatestActiveFrameBuffer:FrameBuffer
	
	Field frameBuffer:Int

	Field withDepthBuffer:Bool
	Field depthBuffer:Int
	
	Field colorTexture:Texture2D

	Field managed:Bool

	Method Dispose:Void()
		If (LatestActiveFrameBuffer = Self) Then
			LatestActiveFrameBuffer.Unbind()
			LatestActiveFrameBuffer = Null
		End If
	
		glDeleteFramebuffer(frameBuffer)
		If withDepthBuffer
			glDeleteRenderbuffer(depthBuffer)
		Endif
		frameBuffer = 0
		depthBuffer = 0
	End Method

	Method Store:Void()
	End Method
	
	Method Restore:Void()
		Dispose()
		
		Init(withDepthBuffer)
		
		If colorTexture
			Local t:Texture2D = colorTexture
			colorTexture = Null
			SetColorTarget(t)
		Endif
	End Method

End Class
