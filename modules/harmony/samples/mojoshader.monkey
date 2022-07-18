
'#HTML5_CANVAS_RESIZE_MODE = 2
#GLFW_USE_MINGW = False
'#GLFW_WINDOW_RESIZABLE = True

Import harmony.mojo

Function Main()
	New MojoShaderSample()
End

Class MojoShaderSample Extends App

	'Field distortion:DistortionShader
	'Field filter:InvertFilter
	'Field maskFilter:SpriteMaskFilter
	Field img:Image
	Field mask:Image
	Field canvas:Image
	'Field filterStack:Stack<Filter>
	
	Field angle:Float

	Method OnCreate()
		img = LoadImage("mungo.png")
		
		#Rem
		SetImageFilter(img, NearestImageFilter)
		SetImageWrap(img, RepeatImageWrap)
		
		filter = New InvertFilter()
		
		maskFilter = New SpriteMaskFilter()
		mask = LoadImage("mask.png")
		
		distortion = New DistortionShader()
		
		filterStack = New Stack<Filter>()
		filterStack.Push(filter)
		filterStack.Push(filter)
		
		'distortion.AddFilter(filter)		
		
		'filter.Invert = 1
		SetUpdateRate(60)
		#End
	End

	Method OnUpdate()
		#Rem
		If (KeyHit(KEY_SPACE)) Then
			distortion.PushFilter(filter)
			distortion.PushFilter(maskFilter)
		End If
		
		If (KeyHit(KEY_ESCAPE)) Then
			distortion.PopFilter()
		End If
		
		If (KeyHit(KEY_LEFT)) Then
			filter.Invert -= 0.1
		End If
		
		If (KeyHit(KEY_RIGHT)) Then
			filter.Invert += 0.1
		End If
		
		If (KeyHit(KEY_R)) Then
			canvas = CreateImage(DeviceWidth, DeviceHeight)
		End If
		
		angle += 1.0
		#End
	End

	Method OnRender()
		#Rem
		Cls(0, 0, 0)
		
		'maskFilter.Shader.SetFloatMat3("u_mf_sprite_mask_matrix", [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0])		
		distortion.SetFloat("uTime", Millisecs() / 1000.0)
		
		maskFilter.ResetMatrix()
		maskFilter.Translate(-0.5, -0.5)
		maskFilter.Rotate(-angle)
		maskFilter.Translate(0.5, 0.5)
		
		'SetBlend(AdditiveBlend)
		
		If (canvas) Then
			SetRenderTarget(canvas)
		End If
		
		PushFilter(filter)
		
		'SetShader(Null)
		DrawRect(10, 10, 100, 100)
		'SetShader(distortion)
		maskFilter.Mask = mask
		img.SetHandle(img.Width() * 0.5, img.Height() * 0.5)
		DrawImage(img, DeviceWidth() - 60, 60, angle, 100.0 / img.Width(), 100.0 / img.Height())
		'SetShader(Null)
		DrawRect(DeviceWidth() - 110, DeviceHeight() - 110, 100, 100)
		'SetShader(distortion)
		img.SetHandle(0, 0)
		'maskFilter.Mask = Null
		DrawImage(img, 10, DeviceHeight() - 110, 0, 100.0 / img.Width(), 100.0 / img.Height())
		
		'SetShader(Null)
		DrawImage(img, MouseX() - 50, MouseY() - 50, 0, 100.0 / img.Width(), 100.0 / img.Height())
		
		If (canvas) Then
			SetRenderTarget(Null)
			'SetShader(distortion)
			'DrawImageRect(canvas, 20, 20, 20, 20, DeviceWidth() - 40, DeviceHeight() - 40)
			DrawImage(canvas, 0, 0)
		End If
		
		PopFilter()
		#End
		
		#Rem
		Cls(0, 0, 0)
		
		PushFilter(filter)
		
		If (canvas) Then
			SetRenderTarget(canvas)
		End If
		
		DrawImage(img, MouseX() - 50, MouseY() - 50, 0, 100.0 / img.Width(), 100.0 / img.Height())
		
		If (canvas) Then
			SetRenderTarget(Null)
			DrawImage(canvas, 0, 0)
		End If
		
		PopFilter()
		#End
		
		Cls(0, 0, 0)
		'DrawImage(img, 10, 10)
		DrawPoly([10.0, 10.0, 256.0, 10.0, 256.0, 256.0])
		DrawPoly([DeviceWidth() - img.Width() - 10.0, 10.0, 0.0, 0.0, DeviceWidth() - 10.0, 10.0, img.Width(), 0.0, DeviceWidth() - 10.0, 10.0 + img.Height(), img.Width(), img.Height()], img)
	End
End

#Rem
Class DistortionShader Extends Shader

	Method FragmentShader:String() Property
		Define("EMPTY_MAIN")
		Return LoadString("distortion.frag")
	End Method

End Class
#End