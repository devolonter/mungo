
#HTML5_OPTIMIZE_OUTPUT=True
#HTML5_OPTIMIZATION_LEVEL="advanced"

Import harmony.backend.graphics
Import harmony.mojo

#GLFW_USE_MINGW=False
#HTML5_CANVAS_WIDTH=640
#HTML5_CANVAS_HEIGHT=480

Class HarmonyApp Extends App Implements IOnLoadTextureComplete

	Field basicProgram:ShaderProgram
	Field distortionProgram:ShaderProgram
	
	Field group:TextureGroup
	
	Field vertexBuffer:VertexBuffer
	
	Field loading:Int
	
	Field fullscreen:=False
	
	Method ToggleFullscreen:Void()
		fullscreen=Not fullscreen
		If fullscreen
			SetDeviceWindow 1024,768,1
			SetSwapInterval 1			'I reckon there's a 98% chance this will give us 60fps on YOUR PC!
			SetUpdateRate 0
		Else
			SetDeviceWindow 640,480,0
			SetSwapInterval 0			'As for windowed mode...
			SetUpdateRate 60
		Endif
	End

	Method OnCreate()
		SetUpdateRate(60)		
		
		loading += 1
		Local bgPattern:= New Texture2D("bg.png", Self, TEXTURE_FORMAT_RGB565) 
		bgPattern.SetWrap(TEXTURE_WRAP_REPEAT)
		
		loading += 1
		Local mungoLogo:= New Texture2D("mungo.png", Self, TEXTURE_FORMAT_RGBA4444)
		
		group = New TextureGroup()		
		group.AddTexture(0, bgPattern)
		group.AddTexture(1, mungoLogo)
		
		'load shaders
		basicProgram = LoadShaderProgram("basic")
		distortionProgram = LoadShaderProgram("distortion")
		
		'setup projection
		basicProgram.Bind()
		basicProgram.SetUniformf("uProjection", DeviceWidth() / 2.0, DeviceHeight() / 2.0)
		
		distortionProgram.Bind()
		distortionProgram.SetUniformf("uProjection", DeviceWidth() / 2.0, DeviceHeight() / 2.0)
		distortionProgram.SetUniformi("uSampler", 1)
		
		'set vertices
		Local left:Float = (DeviceWidth() - mungoLogo.Width) * 0.5
		Local right:Float = left + mungoLogo.Width
		
		Local top:Float = (DeviceHeight() - mungoLogo.Height) * 0.5
		Local bottom:Float = top + mungoLogo.Height
		
		#Rem
		Local verts:Float[] = [0.0, 0.0, 0.0, 0.0, Float(DeviceWidth()), 0.0, 3.0, 0.0, Float(DeviceWidth()), Float(DeviceHeight()), 3.0, 3.0, 0.0, Float(DeviceHeight()), 0.0, 3.0, left, top, 0.0, 0.0, right, top, 1.0, 0.0, right, bottom, 1.0, 1.0, left, bottom, 0.0, 1.0]
		#End
		
		vertexBuffer = New StaticVertexBuffer(8, ["aVertexPosition", "aTextureCoord"], [VERTEX_ATTR_SHORT2, VERTEX_ATTR_UBYTE2])
		vertexBuffer.Bind(basicProgram)
		
		'bg
		vertexBuffer.SetVertices(0, [0.0, 0.0, Float(DeviceWidth()), 0.0, Float(DeviceWidth()), Float(DeviceHeight()), 0.0, Float(DeviceHeight())])
		vertexBuffer.SetVertices(1, [0.0, 0.0, 3.0, 0.0, 3.0, 3.0, 0.0, 3.0])
		
		'logo
		vertexBuffer.SetVertices(0, [left, top, right, top, right, bottom, left, bottom], 4, 0, 4)
		vertexBuffer.SetVertices(1, [0.0, 0.0, 1.0, 0.0, 1.0, 1.0, 0.0, 1.0], 4, 0, 4)
		
		SuspendMojoRender()
	End Method
	
	Method OnUpdate()
		If KeyHit( KEY_SPACE ) ToggleFullscreen
	End Method
	
	Method OnRender()
		EnableMode(MODE_BLEND)
		SetBlendFunc(BLEND_FACTOR_SRC_ALPHA, BLEND_FACTOR_ONE_MINUS_SRC_ALPHA)
	
		If (loading) Return		
		group.Bind()
	
		'clear
		SetClearColor(1.0, 1.0, 1.0, 1.0)
		ClearScreen(CLEAR_MASK_COLOR)
		
		'draw tiled bg	
		group.Activate(0)
		basicProgram.Bind()		
		vertexBuffer.Bind(basicProgram)
			
		DrawArrays(DRAW_MODE_TRIANGLE_FAN, 0, 4)
		
		'draw logo
		group.Activate(1)
		distortionProgram.Bind()		
		vertexBuffer.Bind(distortionProgram)
		
		distortionProgram.SetUniformf("uTime", Millisecs() / 1000.0)		
		DrawArrays(DRAW_MODE_TRIANGLE_FAN, 4, 4)
	End Method
	
	Method OnLoadTextureComplete:Void(texture:Texture)	
		loading -= 1
	End Method

End Class

Function Main()
	New HarmonyApp()
End Function
