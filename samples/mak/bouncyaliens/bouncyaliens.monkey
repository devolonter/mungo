
Import mojo

Public

Const WIDTH#=320
Const HEIGHT#=240

Class Sprite

	Field x#,vx#
	Field y#,vy#
	Field f#,vf#
	
	Method New()
		x=Rnd( WIDTH )
		y=Rnd( HEIGHT )
		vx=Rnd(1,2);If Rnd(1)>=.5 vx=-vx
		vy=Rnd(1,2);If Rnd(1)>=.5 vy=-vy
		vf=Rnd( .5,1.5 )
	End

	Method Update()
		x+=vx;If x<0 Or x>=WIDTH vx=-vx
		y+=vy;If y<0 Or y>=HEIGHT vy=-vy
		f+=vf;If f>=8 f-=8
	End
	
End

Class MyApp Extends App

	Field utime,uframes,ufps
	Field rtime,rframes,rfps
	
	Field image:Image
	Field image1:Image
	Field image2:Image
	Field sprites:=New Stack<Sprite>
	
	Field rot#
	
	Field ums

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
	
		Print "Display modes:"
		For Local mode:=Eachin DisplayModes()
			Print mode.Width+","+mode.Height
		Next

		image1=LoadImage( "alien1.png",8,Image.MidHandle )
		image2=LoadImage( "alien2.png",8,Image.MidHandle )
		
		For Local i=0 Until 100
			sprites.Push New Sprite
		Next

		SetSwapInterval 0
		SetUpdateRate 60
		
		utime=Millisecs()
		rtime=utime
	End
	
	Method OnUpdate()
	
		If KeyHit( KEY_SPACE ) ToggleFullscreen
	
		ums=Millisecs

		uframes+=1
		Local e=Millisecs-utime
		If e>=1000
			ufps=uframes
			uframes=0
			utime+=e
		Endif
	
		If MouseHit(0)
		
			If MouseX()<DeviceWidth/3
				For Local i=0 Until 25
					If Not sprites.IsEmpty() sprites.Pop
				Next
			Else If MouseX()>DeviceWidth*2/3
				For Local i=0 Until 25
					sprites.Push New Sprite
				Next
			Else
				If fullscreen ToggleFullscreen			
				OpenUrl "http://www.blitzbasic.com"
			Endif
		Endif
	
		For Local sprite:=Eachin sprites
			sprite.Update
		Next
		
		rot+=1
		
		ums=Millisecs-ums;

 	End
 	
 	Field paused:Bool
	
	Method OnRender()
	
		rframes+=1
		Local e=Millisecs-rtime
		If e>=1000
			rfps=rframes
			rframes=0
			rtime+=e
		Endif
	
		Cls 128,0,255
		
		PushMatrix
				
		Scale DeviceWidth/WIDTH,DeviceHeight/HEIGHT
		
		Local r:=rot
		Local image:=image1
		Local i,n=sprites.Length()/10	'ie: simulate 10 render state changes
		random.Seed=1234
		For Local sprite:=Eachin sprites
			i+=1
			If i Mod n=0
				If image=image1 image=image2 Else image=image1
			End
			r+=Rnd(360)
			DrawImage image,sprite.x,sprite.y,r,Rnd(1,2),Rnd(1,2),sprite.f
		Next
		
		PopMatrix
				
		DrawText "[<<]",0,8,0,.5
		DrawText "imgs="+sprites.Length()+", ufps="+ufps+", rfps="+rfps+", last update="+ums,DeviceWidth/2,8,.5,.5
		DrawText "[>>]",DeviceWidth,8,1,.5
		
		If paused

			SetAlpha .5
			SetColor 0,0,0
			DrawRect 0,0,DeviceWidth,DeviceHeight
			SetAlpha 1
			SetColor 255,255,255
			DrawText "Suspended",DeviceWidth/2,DeviceHeight/2,.5,.5
		Endif

	End
	
	Method OnSuspend()
		Print "BouncyAliens: OnSuspend"
		paused=True
	End

	Method OnResume()
		Print "BouncyAliens: OnResume"
		paused=False
	End

End

Function Main()

	New MyApp
	
End
