#HTML5_OPTIMIZE_OUTPUT=True
#HTML5_OPTIMIZATION_LEVEL="advanced"
#GLFW_USE_MINGW=False
'Simple graphics compatibility test
'
'Should behave the same on all targets

'#HTML5_OPTIMIZE_OUTPUT=True
#MOJO_AUTO_SUSPEND_ENABLED=False
#MOJO_IMAGE_FILTERING_ENABLED=True
#GLFW_WINDOW_RESIZABLE=True
#ANDROID_SCREEN_ORIENTATION="landscape"

Import harmony.mojo
Import harmony.backend.utils

'#HTML5_WEBGL_ENABLED = True
'Import mojo

'Import reflection
'#REFLECTION_FILTER="harmony*"

#If TARGET = "html5"
Import dom
#End

Class Test Extends App

	Field image:Image
	
	Field tx#,ty#

	Field c=7,r=255,g=255,b=255
	
	Method OnCreate()		
		SetUpdateRate(60)
		
		#Rem
		Local arr:Int[] = [1,99,998,9999]
		Local buffer:DataBuffer = New DataBuffer(8, True)
		CopyFloatsToDatabuffer(arr, buffer, 0, 2, 2)
		Print buffer.PeekFloat(0)
		Print buffer.PeekFloat(4)
		Error ""
		#End
		image=LoadImage("images/RedbrushAlpha.png",,Image.MidHandle)
	End
	
	Method OnUpdate()
		If KeyHit( KEY_LMB )
			c+=1
			If c=8 c=1
			r=(c&1)* 255
			g=(c&2) Shr 1 * 255
			b=(c&4) Shr 2 * 255
		Endif

	End


	Method OnRender()
	#If TARGET = "html5"
		FpsCounter.Update()
		FpsCounter.Render()
	#End
			
		Cls 0, 0, 128
	
		Local sz:Float = Sin(Millisecs*.1)*32
		Local sx=32+sz,sy=32,sw=DeviceWidth-(64+sz*2),sh=DeviceHeight-(64+sz)
		
		SetScissor sx,sy,sw,sh		
		Cls 255,32,0
		
		PushMatrix
		
		Scale DeviceWidth/640.0,DeviceHeight/480.0

		Translate 320,240
		Rotate Millisecs/1000.0*12
		Translate -320,-240
		
		SetColor 128,255,0
		DrawRect 32,32,640-64,480-64

		SetColor 255,255,0
		For Local y=0 Until 480
			For Local x=16 Until 640 Step 32
				SetAlpha Min( Abs( y-240.0 )/120.0,1.0 )
				DrawPoint x,y
			Next
		Next
		
		SetColor 0,128,255
		DrawOval 64,64,640-128,480-128
		
		SetColor 255,0,128
		DrawLine 32,32,640-32,480-32
		DrawLine 640-32,32,32,480-32
		
		SetColor r,g,b
		SetAlpha Sin(Millisecs*.3)*.5+.5
		PushMatrix
		Scale 1.0, 1.0
		DrawImage image, 320, 240, 0
		PopMatrix
		SetAlpha 1
		
		SetColor 255,0,128
		DrawPoly( [ 160.0,232.0, 320.0,224.0, 480.0,232.0, 480.0,248.0, 320.0,256.0, 160.0,248.0 ] )
		
		SetColor 128,128,128
		DrawText "The Quick Brown Fox Jumps Over The Lazy Dog",320,240,.5,.5

		PopMatrix
		
		SetScissor 0,0,DeviceWidth,DeviceHeight
		SetColor 128,0,0
		DrawRect 0,0,DeviceWidth,1
		DrawRect DeviceWidth-1,0,1,DeviceHeight
		DrawRect 0,DeviceHeight-1,DeviceWidth,1
		DrawRect 0,0,1,DeviceHeight-1
	End

End

Function Main()

	New Test

End

Class FpsCounter Final

	Global fpsCount:Int
	Global startTime:Int
	Global CurrentRate:Int
	
	Global fpsContainer:HTMLElement

	Function Update:Void()
		If (Not fpsContainer) Then
			fpsContainer = HTMLElement(document.createElement("div"))
			fpsContainer.setAttribute("style", "position: fixed; top: 0; left: 0; background-color: #000; font-weight: bold; font-size: 18px; padding: 10px; color: #fff")
			fpsContainer.innerHTML = "FPS"
			
			document.getElementsByTagName("body").item(0).appendChild(fpsContainer)
		End If
	
		If (Millisecs() - startTime) >= 1000
			CurrentRate = fpsCount
			fpsCount = 0
			startTime = Millisecs()
		Else
			fpsCount += 1
		End
	End
	
	Function Render:Void()
		If (fpsContainer) fpsContainer.innerHTML = "FPS: " + FpsCounter.CurrentRate
	End
	
End
