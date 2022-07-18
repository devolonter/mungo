Import mojo
Import darwin.graphics

#HTML5_PRELOADER_ENABLED = True

Function Main()
	New ResizeExample()
End

Global scrollX:Int, scrollY:Int
Global windowWidth:Int, windowHeight:Int
Global graphicsWidth:Int, graphicsHeight:Int

Class WindowHandler Extends WindowDelegate
	
	Method OnResize:Void()
		Resize()
	End
	
	Method OnScroll:Void()
		scrollX = WindowScrollX()
		scrollY = WindowScrollY()
	End
	
End

Function Resize()
	windowWidth = WindowWidth()
	windowHeight = WindowHeight()
	
	graphicsWidth = 1200
	graphicsHeight = 600
	SetGraphics(graphicsWidth, graphicsHeight, windowWidth, windowHeight)
End

Class ResizeExample Extends App
	
	Field back:Image
	
	Method OnCreate()
		Resize()
		SetWindowDelegate(New WindowHandler())
		
		back = LoadImage("mainback.jpg")
	End
	
	Method OnUpdate()
	End
	
	Method OnRender()
		Cls()
		
		#Rem
		Local scale := windowHeight / Float(back.Height())
		
		If (windowHeight > windowWidth)
			scale = windowWidth / Float(back.Width())
		End
		
		Local offsetX = (graphicsWidth - back.Width()*scale) * 0.5
		Local offsetY = (graphicsHeight - back.Height()*scale) * 0.5
		
		PushMatrix()
		Translate(offsetX, offsetY)
		Scale(scale, scale)
		
		DrawImage(back, 0, 0)
		
		PopMatrix()
		#End
		
		DrawImage(back, 0, 0)
		
		PushMatrix()
		Scale(WindowPixelRatio(), WindowPixelRatio())
		
		
		DrawText("DeviceWidth: " + DeviceWidth(), 10, 10)
		DrawText("DeviceHeight: " + DeviceHeight(), 10, 30)
		DrawText("WindowWidth: " + WindowWidth(), 10, 50)
		DrawText("WindowHeight: " + WindowHeight(), 10, 70)
		DrawText("WindowPixelRatio: " + WindowPixelRatio(), 10, 90)
		DrawText("ScreenWidth: " + ScreenWidth(), 10, 110)
		DrawText("ScreenHeight: " + ScreenHeight(), 10, 130)
		
		PopMatrix()
	End
	
End