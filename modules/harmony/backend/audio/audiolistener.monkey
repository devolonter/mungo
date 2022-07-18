Strict

Private

Import al

Public

Class AudioListener

	Method New(x:Float = 0, y:Float = 0, z:Float = 0)
		SetPosition(x, y, z)
	End Method

	Method SetPosition:Void(x:Float, y:Float, z:Float)
		alListener3f(AL_POSITION, x, y, z)
		Self.x = x
		Self.y = y
		Self.z = z
	End Method
	
	Method SetVelocity:Void(x:Float, y:Float, z:Float)
		alListener3f(AL_VELOCITY, x, y, z)
		Self.vx = x
		Self.vy = y
		Self.vz = z
	End Method
	
	Method SetOrientation:Void(x:Float, y:Float, z:Float)
		alListener3f(AL_ORIENTATION, x, y, z)
		Self.ox = x
		Self.oy = y
		Self.oz = z
	End Method

	Method X:Void(x:Float) Property
		alListener3f(AL_POSITION, x, y, z)
		Self.x = x
	End Method
	
	Method X:Float() Property
		Return x
	End Method
	
	Method Y:Void(y:Float) Property
		alListener3f(AL_POSITION, x, y, z)
		Self.y = y
	End Method
	
	Method Y:Float() Property
		Return y
	End Method
	
	Method Z:Void(z:Float) Property
		alListener3f(AL_POSITION, x, y, z)
		Self.z = z
	End Method
	
	Method Z:Float() Property
		Return z
	End Method
	
	Method VelocityX:Void(vx:Float) Property
		alListener3f(AL_VELOCITY, vx, vy, vz)
		Self.vx = vx
	End Method
	
	Method VelocityX:Float() Property
		Return vx
	End Method
	
	Method VelocityY:Void(vy:Float) Property
		alListener3f(AL_VELOCITY, vx, vy, vz)
		Self.vy = vy
	End Method
	
	Method VelocityY:Float() Property
		Return vy
	End Method
	
	Method VelocityZ:Void(vz:Float) Property
		alListener3f(AL_VELOCITY, vx, vy, vz)
		Self.vz = vz
	End Method
	
	Method VelocityZ:Float() Property
		Return vz
	End Method
	
	Method OrientationX:Void(ox:Float) Property
		alListener3f(AL_ORIENTATION, ox, oy, oz)
		Self.ox = ox
	End Method
	
	Method OrientationX:Float() Property
		Return ox
	End Method
	
	Method OrientationY:Void(oy:Float) Property
		alListener3f(AL_ORIENTATION, ox, oy, oz)
		Self.oy = dy
	End Method
	
	Method OrientationY:Float() Property
		Return oy
	End Method
	
	Method OrientationZ:Void(oz:Float) Property
		alListener3f(AL_ORIENTATION, ox, oy, oz)
		Self.oz = oz
	End Method
	
	Method OrientationZ:Float() Property
		Return oz
	End Method
	
	Method Gain:Void(gain:Float) Property
		alListenerf(AL_GAIN, gain)
	End Method
	
	Method Gain:Float() Property
		Return alGetListenerf(AL_GAIN)
	End Method
	
Private

	Field x:Float
	Field y:Float
	Field z:Float
	
	Field vx:Float
	Field vy:Float
	Field vz:Float
	
	Field ox:Float
	Field oy:Float
	Field oz:Float

End Class
