
Friend harmony.frontend.mojo.graphicsdevice
Friend harmony.frontend.mojo.filters

Private

Import graphicsdevice
Import shader
Import harmony.backend
Import harmony.backend.graphics.gl
Import harmony.backend.utils

Import brl.pool

Public

Class Renderer Extends Batch

	Const DRAW_GRAPHICS:Int = 1
	Const DRAW_SURFACE:Int = 2
	Const DRAW_SURFACE_POLY:Int = 4
	Const DRAW_ALL:Int = DRAW_GRAPHICS | DRAW_SURFACE | DRAW_SURFACE_POLY
	
	Method SetDeviceProjection:Void(x:Int, y:Int, width:Int, height:Int, flipY:Bool) Abstract

	Method SetMatrix:Void(ix:Float, iy:Float, jx:Float, jy:Float, tx:Float, ty:Float) Abstract
	Method GetMatrix:Void(matrix:Float[]) Abstract
	
	Method SetColor:Void(r:Int, g:Int, b:Int) Abstract
	Method GetColor:Void(colors:Int[]) Abstract
	
	Method SetAlpha:Void(a:Float) Abstract
	Method GetAlpha:Float() Abstract	
	
	Method DrawPoint:Void(x:Float, y:Float) Abstract
	Method DrawRect:Void(x:Float, y:Float, width:Float, height:Float) Abstract
	Method DrawLine:Void(x1:Float, y1:Float, x2:Float, y2:Float) Abstract
	Method DrawOval:Void(x:Float, y:Float, w:Float, h:Float) Abstract
	Method DrawPoly:Void(verts:Float[])	Abstract
	Method DrawPoly:Void(verts:Float[], surface:Surface, srcx:Int, srcy:Int) Abstract
	
	Method DrawSurface:Void(surface:Surface, x:Float, y:Float) Abstract
	Method DrawSurface:Void(surface:Surface, x:Float, y:Float, srcx:Int, srcy:Int, srcw:Int, srch:Int)	Abstract
	
	Method DrawSurfaceTransform:Void(surface:Surface, x:Float, y:Float, rotation:Float, scaleX:Float, scaleY:Float) Abstract
	Method DrawSurfaceTransform:Void(surface:Surface, x:Float, y:Float, srcx:Int, srcy:Int, srcw:Int, srch:Int, rotation:Float, scaleX:Float, scaleY:Float) Abstract
	
	Method Capabilities:Int() Abstract
	
Private

	Const DIRTY_NONE:Int = 0
	Const DIRTY_DEVICE_PROJECTION:Int = 1

	Field dirty:Int
	Field ignore:Bool
	
End Class

Private

Class FilterRenderer Extends SurfaceRenderer
	
	Method New(size:Int)
		Super.New(size)
		ignore = True
	End Method

End Class

Class SurfacedPolyRenderer Extends SurfaceRenderer

	Method New(size:Int)
		Super.New(size)
	End Method
	
	Method DrawPoly:Void(verts:Float[], surface:Surface, srcx:Int, srcy:Int)
		Local numVertices:Int = verts.Length() Shr 2
		Local numIndices:Int = (numVertices - 2) * 5
		
		If (lastVertex + numVertices > maxVertices Or lastIndex + numIndices > maxIndices) Flush()
		
		If (Not current Or current.surface <> surface) Then
			If (current) current.lastIndex = Self.lastIndex
		
			current = SurfaceRange.Pool.Allocate()
			current.firstIndex = Self.lastIndex
			current.surface = surface
			
			surfaces.PushLast(current)
		End If
		
		Local width:Int = surface.Width
		Local height:Int = surface.Height
		Local uScale:Float = surface.texture.UScale
		Local vScale:Float = surface.texture.VScale
		
		Local offset:Int = lastVertex * SIZE
		Local vertices:=Self.vertices, indices:=Self.indices
		Local ix:=ix, iy:=iy, jx:=jx, jy:=jy, tx:=tx, ty:=ty, color:=color, lastIndex:=lastIndex, indexValue:=indexValue
		
		Local i:Int = 0
		While(i < numVertices)
			Local vertIndex:Int = i Shl 2
			vertices[offset] = verts[vertIndex]; vertices[offset + 1] = verts[vertIndex + 1]
			
			vertices[offset + POSITION_SIZE] = ix
			vertices[offset + (POSITION_SIZE + 1)] = iy
			vertices[offset + (POSITION_SIZE + 2)] = jx
			vertices[offset + (POSITION_SIZE + 3)] = jy
			
			vertices[offset + (POSITION_SIZE + TRANSFORM_SIZE)] = tx
			vertices[offset + (POSITION_SIZE + TRANSFORM_SIZE + 1)] = ty
			
			vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE)] =  ((srcx + verts[vertIndex + 2]) / width) * uScale
			vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + 1)] =  ((srcy + verts[vertIndex + 3]) / height) * vScale
			
			vertices[offset + (SURFACE_UV_SIZE + TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE)] = color
			
			offset += SIZE
			i += 1
		Wend
		
		While(lastIndex < Self.lastIndex + numIndices)
			indices[lastIndex] = Self.indexValue
			indices[lastIndex + 1] = Self.indexValue
			indices[lastIndex + 2] = indexValue + 1
			indices[lastIndex + 3] = indexValue + 2
			indices[lastIndex + 4] = indexValue + 2

			lastIndex += 5
			indexValue += 1
		Wend
		
		lastVertex += numVertices
		Self.lastIndex += numIndices
		Self.indexValue = indexValue + 2
		
		Draw()
	End Method
	
	Method OnFlush:Void()
		If (HasRenderTarget())
			Select GetBlend()
				Case AlphaBlend
					glBlendFuncSeparate(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA, GL_ONE, GL_ONE_MINUS_SRC_ALPHA)
			End
		End
		
		current.lastIndex = Self.lastIndex
		buffer.SetIndices(indices, firstIndex, firstIndex, lastIndex - firstIndex)
		
		buffer.StreamOffset = firstVertex
		buffer.StreamSize = lastVertex - firstVertex
		
		Local l:Int = surfaces.Length
		Local range:SurfaceRange
		
		While(l > 0)
			range = surfaces.PopFirst()
			range.surface.texture.Bind(0)
			
			DrawArrays(DRAW_MODE_TRIANGLE_STRIP, range.firstIndex, range.lastIndex - range.firstIndex)
			
			l -= 1
			SurfaceRange.Pool.Free(range)
		Wend
		
		If (lastVertex > maxVertices Shr 1 Or lastIndex > maxIndices Shr 1) Then
			firstIndex = 0
			lastIndex = 0
			indexValue = 0
			lastVertex = 0
			firstVertex = 0
		Else
			firstVertex = lastVertex
			firstIndex = lastIndex
		End If
		
		current = Null
	End Method
	
	Method Capabilities:Int()
		Return DRAW_SURFACE_POLY
	End Method
	
Private

	Field firstIndex:Int
	Field lastIndex:Int
	
	Field indexValue:Int

End Class

Class SurfaceRenderer Extends BaseRenderer
	
	Const SURFACE_UV:String = "mojo_device_surface_uv"
	Const SURFACE_UV_SIZE:Int = 2
	Global SURFACE_UV_FORMAT:VertexFormat = VERTEX_ATTR_FLOAT2
	
	Const SIZE:Int = POSITION_SIZE + TRANSFORM_SIZE + TRANSLATE_SIZE + SURFACE_UV_SIZE + COLOR_SIZE
	
	Method New(size:Int)
		Super.New(size)
		surfaces = New Deque<SurfaceRange>()
		
		Local maxUnits:Int[1]
		glGetIntegerv(GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS, maxUnits)
		Self.maxUnits = maxUnits[0] - 1
	End Method
	
	Method Create:Void()
		buffer = New StreamingVertexBuffer(maxVertices, maxIndices, USAGE_STATIC, [POSITION, TRANSFORM, TRANSLATE, SURFACE_UV, COLOR], [POSITION_FORMAT, TRANSFORM_FORMAT, TRANSLATE_FORMAT, SURFACE_UV_FORMAT, COLOR_FORMAT])
		
		If (Not DefaultShader) Then
			Local mojoShader:Shader = New Shader()
			DefaultShader = mojoShader.Apply(Self)
		End If
		
		defaultShader = DefaultShader
		
		If (Not DefaultIndices Or DefaultIndices.Length() < maxIndices) Then
			DefaultIndices = New Int[maxIndices]
		
			For Local i:Int = 0 Until size
				DefaultIndices[i * INDICES_PER_ELEMENT] = i * VERTICES_PER_ELEMENT
				DefaultIndices[i * INDICES_PER_ELEMENT + 1] = i * VERTICES_PER_ELEMENT + 1
				DefaultIndices[i * INDICES_PER_ELEMENT + 2] = i * VERTICES_PER_ELEMENT + 2
				DefaultIndices[i * INDICES_PER_ELEMENT + 3] = i * VERTICES_PER_ELEMENT
				DefaultIndices[i * INDICES_PER_ELEMENT + 4] = i * VERTICES_PER_ELEMENT + 2
				DefaultIndices[i * INDICES_PER_ELEMENT + 5] = i * VERTICES_PER_ELEMENT + 3
			Next
		End If

		buffer.SetIndices(DefaultIndices, 0, 0, maxIndices)
	End Method
	
	Method OnFlush:Void()
		If (HasRenderTarget())
			Select GetBlend()
				Case AlphaBlend
					glBlendFuncSeparate(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA, GL_ONE, GL_ONE_MINUS_SRC_ALPHA)
			End
		End
		
		current.lastIndex = lastVertex * (INDICES_PER_ELEMENT / Float(VERTICES_PER_ELEMENT))
		
		buffer.StreamOffset = firstVertex
		buffer.StreamSize = lastVertex - firstVertex
		
		Local l:Int = surfaces.Length
		Local range:SurfaceRange
		
		While(l > 0)
			range = surfaces.PopFirst()
			
			If (range.unit <> 0)
				If (lastUnit <> range.unit) Then
					Shader.SetUniformi("mojo_device_surface", range.unit)
					range.surface.Texture.Bind(range.unit)
					lastUnit = range.unit
				End If
			Else
				If (lastUnit <> 0)
					Shader.SetUniformi("mojo_device_surface", 0)
					lastUnit = 0
				End
				
				range.surface.Texture.Bind(0)
			End
			
			DrawArrays(DRAW_MODE_TRIANGLES, range.firstIndex, range.lastIndex - range.firstIndex)
			
			l -= 1
			SurfaceRange.Pool.Free(range)
		Wend
		
		If (lastVertex > maxVertices Shr 1) Then
			Super.OnFlush()
		Else
			firstVertex = lastVertex
		End If
		
		current = Null
		lastUnit = -1
	End Method
	
	Method DrawSurface:Void(surface:Surface, x:Float, y:Float)
		If (lastVertex + VERTICES_PER_ELEMENT > maxVertices) Flush()
	
		If (Not current Or current.surface <> surface) Then
			If (current) current.lastIndex = lastVertex * (INDICES_PER_ELEMENT / Float(VERTICES_PER_ELEMENT))
		
			current = SurfaceRange.Pool.Allocate()
			current.firstIndex = lastVertex * (INDICES_PER_ELEMENT / Float(VERTICES_PER_ELEMENT))
			current.surface = surface
			current.unit = 0
			
			surfaces.PushLast(current)
		End If
		
		Local offset:Int = lastVertex * SIZE
		Local width:Int = surface.Width
		Local height:Int = surface.Height
		Local uScale:Float = surface.texture.UScale
		Local vScale:Float = surface.texture.VScale
		
		Local vertices := vertices
		Local ix := ix, iy := iy, jx := jx, jy := jy, tx := tx, ty := ty, color := color
		
		vertices[offset] = x; vertices[offset + 1] = y
		vertices[offset + SIZE] = x + width; vertices[offset + (SIZE + 1)] = y
		vertices[offset + (SIZE * 2)] = x + width; vertices[offset + (SIZE * 2 + 1)] = y + height
		vertices[offset + (SIZE * 3)] = x; vertices[offset + (SIZE * 3 + 1)] = y + height
		
		vertices[offset + POSITION_SIZE] = ix
		vertices[offset + (POSITION_SIZE + 1)] = iy
		vertices[offset + (POSITION_SIZE + 2)] = jx
		vertices[offset + (POSITION_SIZE + 3)] = jy
				
		vertices[offset + (POSITION_SIZE + SIZE)] = ix
		vertices[offset + (POSITION_SIZE + SIZE + 1)] = iy
		vertices[offset + (POSITION_SIZE + SIZE + 2)] = jx
		vertices[offset + (POSITION_SIZE + SIZE + 3)] = jy
		
		vertices[offset + (POSITION_SIZE + SIZE * 2)] = ix
		vertices[offset + (POSITION_SIZE + SIZE * 2 + 1)] = iy
		vertices[offset + (POSITION_SIZE + SIZE * 2 + 2)] = jx
		vertices[offset + (POSITION_SIZE + SIZE * 2 + 3)] = jy
		
		vertices[offset + (POSITION_SIZE + SIZE * 3)] = ix
		vertices[offset + (POSITION_SIZE + SIZE * 3 + 1)] = iy
		vertices[offset + (POSITION_SIZE + SIZE * 3 + 2)] = jx
		vertices[offset + (POSITION_SIZE + SIZE * 3 + 3)] = jy
		
		vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE)] = tx
		vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + 1)] = ty
		
		vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + SIZE)] = tx
		vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + SIZE + 1)] = ty
		
		vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + SIZE * 2)] = tx
		vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + SIZE * 2 + 1)] = ty
		
		vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + SIZE * 3)] = tx
		vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + SIZE * 3 + 1)] = ty
		
		vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE)] = 0
		vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + 1)] = 0
		
		vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE)] = uScale
		vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE + 1)] = 0
		
		vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE * 2)] = uScale
		vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE * 2 + 1)] = vScale
		
		vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE * 3)] = 0
		vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE * 3 + 1)] = vScale
		
		vertices[offset + (SURFACE_UV_SIZE + TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE)] = color
		vertices[offset + (SURFACE_UV_SIZE + TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE)] = color
		vertices[offset + (SURFACE_UV_SIZE + TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE * 2)] = color
		vertices[offset + (SURFACE_UV_SIZE + TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE * 3)] = color
		
		lastVertex += VERTICES_PER_ELEMENT
		Draw()
	End Method
	
	Method DrawSurface:Void(surface:Surface, x:Float, y:Float, srcx:Int, srcy:Int, srcw:Int, srch:Int)
		If (lastVertex + VERTICES_PER_ELEMENT > maxVertices) Flush()
	
		If (Not current Or current.surface <> surface) Then
			If (current) current.lastIndex = lastVertex * (INDICES_PER_ELEMENT / Float(VERTICES_PER_ELEMENT))
		
			current = SurfaceRange.Pool.Allocate()
			current.firstIndex = lastVertex * (INDICES_PER_ELEMENT / Float(VERTICES_PER_ELEMENT))
			current.surface = surface
			
			If (currentUnit < maxUnits) Then
				Local unit := usedTextures.Get(surface.Texture.InternalID)
				If (unit <> 0)
					current.unit = unit
				Else
					current.unit = currentUnit
					usedTextures.Set(surface.Texture.InternalID, currentUnit)
					currentUnit += 1
				End
			Else
				current.unit = 0
			End If

			surfaces.PushLast(current)
		End If
		
		Local offset:Int = lastVertex * SIZE
		Local width:Int = srcw
		Local height:Int = srch
		Local w:Float = surface.texture.Width
		Local h:Float = surface.texture.Height
		Local u0:Float = (srcx / w) * surface.texture.UScale
		Local v0:Float = (srcy / h) * surface.texture.VScale
		Local u1:Float = ((srcx + srcw) / w) * surface.texture.UScale
		Local v1:Float = ((srcy + srch) / h) * surface.texture.VScale
		
		Local vertices := vertices
		Local ix := ix, iy := iy, jx := jx, jy := jy, tx := tx, ty := ty, color := color
		
		vertices[offset] = x; vertices[offset + 1] = y
		vertices[offset + SIZE] = x + width; vertices[offset + (SIZE + 1)] = y
		vertices[offset + (SIZE * 2)] = x + width; vertices[offset + (SIZE * 2 + 1)] = y + height
		vertices[offset + (SIZE * 3)] = x; vertices[offset + (SIZE * 3 + 1)] = y + height
		
		vertices[offset + POSITION_SIZE] = ix
		vertices[offset + (POSITION_SIZE + 1)] = iy
		vertices[offset + (POSITION_SIZE + 2)] = jx
		vertices[offset + (POSITION_SIZE + 3)] = jy
				
		vertices[offset + (POSITION_SIZE + SIZE)] = ix
		vertices[offset + (POSITION_SIZE + SIZE + 1)] = iy
		vertices[offset + (POSITION_SIZE + SIZE + 2)] = jx
		vertices[offset + (POSITION_SIZE + SIZE + 3)] = jy
		
		vertices[offset + (POSITION_SIZE + SIZE * 2)] = ix
		vertices[offset + (POSITION_SIZE + SIZE * 2 + 1)] = iy
		vertices[offset + (POSITION_SIZE + SIZE * 2 + 2)] = jx
		vertices[offset + (POSITION_SIZE + SIZE * 2 + 3)] = jy
		
		vertices[offset + (POSITION_SIZE + SIZE * 3)] = ix
		vertices[offset + (POSITION_SIZE + SIZE * 3 + 1)] = iy
		vertices[offset + (POSITION_SIZE + SIZE * 3 + 2)] = jx
		vertices[offset + (POSITION_SIZE + SIZE * 3 + 3)] = jy
		
		vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE)] = tx
		vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + 1)] = ty
		
		vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + SIZE)] = tx
		vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + SIZE + 1)] = ty
		
		vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + SIZE * 2)] = tx
		vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + SIZE * 2 + 1)] = ty
		
		vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + SIZE * 3)] = tx
		vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + SIZE * 3 + 1)] = ty
		
		vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE)] = u0
		vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + 1)] = v0
		
		vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE)] = u1
		vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE + 1)] = v0
		
		vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE * 2)] = u1
		vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE * 2 + 1)] = v1
		
		vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE * 3)] = u0
		vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE * 3 + 1)] = v1
		
		vertices[offset + (SURFACE_UV_SIZE + TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE)] = color
		vertices[offset + (SURFACE_UV_SIZE + TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE)] = color
		vertices[offset + (SURFACE_UV_SIZE + TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE * 2)] = color
		vertices[offset + (SURFACE_UV_SIZE + TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE * 3)] = color
		
		lastVertex += VERTICES_PER_ELEMENT
		Draw()
	End Method
	
	Method DrawSurfaceTransform:Void(surface:Surface, x:Float, y:Float, rotation:Float, scaleX:Float, scaleY:Float)
		If (lastVertex + VERTICES_PER_ELEMENT > maxVertices) Flush()
		
			If (Not current Or current.surface <> surface) Then
				If (current) current.lastIndex = lastVertex * (INDICES_PER_ELEMENT / Float(VERTICES_PER_ELEMENT))
			
				current = SurfaceRange.Pool.Allocate()
				current.firstIndex = lastVertex * (INDICES_PER_ELEMENT / Float(VERTICES_PER_ELEMENT))
				current.surface = surface
				current.unit = 0
				
				surfaces.PushLast(current)
			End If
			
			Local offset:Int = lastVertex * SIZE
			Local width:Int = surface.Width
			Local height:Int = surface.Height
			Local uScale:Float = surface.texture.UScale
			Local vScale:Float = surface.texture.VScale
			
			Local cs := Cos(-rotation)
			Local sn := Sin(-rotation)
			Local t1 := cs/scaleX
			Local t2 := -sn/scaleX
			Local t3 := sn/scaleY
			Local t4 := cs/scaleY
			Local stx := uScale - uScale*surface.tx
			Local sty := vScale*surface.ty
			
			Local t_u0 := -stx
			Local t_u1 := uScale - stx
			Local t_v0 := -sty
			Local t_v1 := vScale - sty
			
			Local vertices := vertices
			Local ix := ix, iy := iy, jx := jx, jy := jy, tx := tx, ty := ty, color := color
			
			vertices[offset] = x; vertices[offset + 1] = y
			vertices[offset + SIZE] = x + width; vertices[offset + (SIZE + 1)] = y
			vertices[offset + (SIZE * 2)] = x + width; vertices[offset + (SIZE * 2 + 1)] = y + height
			vertices[offset + (SIZE * 3)] = x; vertices[offset + (SIZE * 3 + 1)] = y + height
			
			vertices[offset + POSITION_SIZE] = ix
			vertices[offset + (POSITION_SIZE + 1)] = iy
			vertices[offset + (POSITION_SIZE + 2)] = jx
			vertices[offset + (POSITION_SIZE + 3)] = jy
					
			vertices[offset + (POSITION_SIZE + SIZE)] = ix
			vertices[offset + (POSITION_SIZE + SIZE + 1)] = iy
			vertices[offset + (POSITION_SIZE + SIZE + 2)] = jx
			vertices[offset + (POSITION_SIZE + SIZE + 3)] = jy
			
			vertices[offset + (POSITION_SIZE + SIZE * 2)] = ix
			vertices[offset + (POSITION_SIZE + SIZE * 2 + 1)] = iy
			vertices[offset + (POSITION_SIZE + SIZE * 2 + 2)] = jx
			vertices[offset + (POSITION_SIZE + SIZE * 2 + 3)] = jy
			
			vertices[offset + (POSITION_SIZE + SIZE * 3)] = ix
			vertices[offset + (POSITION_SIZE + SIZE * 3 + 1)] = iy
			vertices[offset + (POSITION_SIZE + SIZE * 3 + 2)] = jx
			vertices[offset + (POSITION_SIZE + SIZE * 3 + 3)] = jy
			
			vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE)] = tx
			vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + 1)] = ty
			
			vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + SIZE)] = tx
			vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + SIZE + 1)] = ty
			
			vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + SIZE * 2)] = tx
			vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + SIZE * 2 + 1)] = ty
			
			vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + SIZE * 3)] = tx
			vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + SIZE * 3 + 1)] = ty
			
			vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE)] = t_u0*t1 + t_v0*t3 + stx
			vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + 1)] = t_u0*t2 + t_v0*t4 + sty
			
			vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE)] = t_u1*t1 + t_v0*t3 + stx
			vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE + 1)] = t_u1*t2 + t_v0*t4 + sty
			
			vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE * 2)] = t_u1*t1 + t_v1*t3 + stx
			vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE * 2 + 1)] = t_u1*t2 + t_v1*t4 + sty
			
			vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE * 3)] = t_u0*t1 + t_v1*t3 + stx
			vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE * 3 + 1)] = t_u0*t2 + t_v1*t4 + sty
			
			vertices[offset + (SURFACE_UV_SIZE + TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE)] = color
			vertices[offset + (SURFACE_UV_SIZE + TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE)] = color
			vertices[offset + (SURFACE_UV_SIZE + TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE * 2)] = color
			vertices[offset + (SURFACE_UV_SIZE + TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE * 3)] = color
			
			lastVertex += VERTICES_PER_ELEMENT
			Draw()
	End Method
	
	Method DrawSurfaceTransform:Void(surface:Surface, x:Float, y:Float, srcx:Int, srcy:Int, srcw:Int, srch:Int, rotation:Float, scaleX:Float, scaleY:Float)
		If (lastVertex + VERTICES_PER_ELEMENT > maxVertices) Flush()
		
			If (Not current Or current.surface <> surface) Then
				If (current) current.lastIndex = lastVertex * (INDICES_PER_ELEMENT / Float(VERTICES_PER_ELEMENT))
			
				current = SurfaceRange.Pool.Allocate()
				current.firstIndex = lastVertex * (INDICES_PER_ELEMENT / Float(VERTICES_PER_ELEMENT))
				current.surface = surface
				
				If (currentUnit <= maxUnits) Then
					Local unit := usedTextures.Get(surface.Texture.InternalID)
					If (unit <> 0)
						current.unit = unit
					Else
						current.unit = currentUnit
						usedTextures.Set(surface.Texture.InternalID, currentUnit)
						currentUnit += 1
					End
				Else
					current.unit = 0
				End If
				
				surfaces.PushLast(current)
			End If
			
			Local offset:Int = lastVertex * SIZE
			Local width:Int = srcw
			Local height:Int = srch
			Local w:Float = surface.texture.Width
			Local h:Float = surface.texture.Height
			Local u0:Float = (srcx / w) * surface.texture.UScale
			Local v0:Float = (srcy / h) * surface.texture.VScale
			Local u1:Float = ((srcx + srcw) / w) * surface.texture.UScale
			Local v1:Float = ((srcy + srch) / h) * surface.texture.VScale
			
			Local cs := Cos(-rotation)
			Local sn := Sin(-rotation)
			Local t1 := cs/scaleX
			Local t2 := -sn/scaleX
			Local t3 := sn/scaleY
			Local t4 := cs/scaleY
			Local stx := u1 - (u1-u0)*surface.tx
			Local sty := v0 + (v1-v0)*surface.ty
			
			Local t_u0 := u0 - stx
			Local t_u1 := u1 - stx
			Local t_v0 := v0 - sty
			Local t_v1 := v1 - sty
			
			Local vertices := vertices
			Local ix := ix, iy := iy, jx := jx, jy := jy, tx := tx, ty := ty, color := color
			
			vertices[offset] = x; vertices[offset + 1] = y
			vertices[offset + SIZE] = x + width; vertices[offset + (SIZE + 1)] = y
			vertices[offset + (SIZE * 2)] = x + width; vertices[offset + (SIZE * 2 + 1)] = y + height
			vertices[offset + (SIZE * 3)] = x; vertices[offset + (SIZE * 3 + 1)] = y + height
			
			vertices[offset + POSITION_SIZE] = ix
			vertices[offset + (POSITION_SIZE + 1)] = iy
			vertices[offset + (POSITION_SIZE + 2)] = jx
			vertices[offset + (POSITION_SIZE + 3)] = jy
					
			vertices[offset + (POSITION_SIZE + SIZE)] = ix
			vertices[offset + (POSITION_SIZE + SIZE + 1)] = iy
			vertices[offset + (POSITION_SIZE + SIZE + 2)] = jx
			vertices[offset + (POSITION_SIZE + SIZE + 3)] = jy
			
			vertices[offset + (POSITION_SIZE + SIZE * 2)] = ix
			vertices[offset + (POSITION_SIZE + SIZE * 2 + 1)] = iy
			vertices[offset + (POSITION_SIZE + SIZE * 2 + 2)] = jx
			vertices[offset + (POSITION_SIZE + SIZE * 2 + 3)] = jy
			
			vertices[offset + (POSITION_SIZE + SIZE * 3)] = ix
			vertices[offset + (POSITION_SIZE + SIZE * 3 + 1)] = iy
			vertices[offset + (POSITION_SIZE + SIZE * 3 + 2)] = jx
			vertices[offset + (POSITION_SIZE + SIZE * 3 + 3)] = jy
			
			vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE)] = tx
			vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + 1)] = ty
			
			vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + SIZE)] = tx
			vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + SIZE + 1)] = ty
			
			vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + SIZE * 2)] = tx
			vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + SIZE * 2 + 1)] = ty
			
			vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + SIZE * 3)] = tx
			vertices[offset + (TRANSFORM_SIZE + POSITION_SIZE + SIZE * 3 + 1)] = ty
			
			vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE)] = t_u0*t1 + t_v0*t3 + stx
			vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + 1)] = t_u0*t2 + t_v0*t4 + sty
			
			vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE)] = t_u1*t1 + t_v0*t3 + stx
			vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE + 1)] = t_u1*t2 + t_v0*t4 + sty
			
			vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE * 2)] = t_u1*t1 + t_v1*t3 + stx
			vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE * 2 + 1)] = t_u1*t2 + t_v1*t4 + sty
			
			vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE * 3)] = t_u0*t1 + t_v1*t3 + stx
			vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE * 3 + 1)] = t_u0*t2 + t_v1*t4 + sty
			
			vertices[offset + (SURFACE_UV_SIZE + TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE)] = color
			vertices[offset + (SURFACE_UV_SIZE + TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE)] = color
			vertices[offset + (SURFACE_UV_SIZE + TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE * 2)] = color
			vertices[offset + (SURFACE_UV_SIZE + TRANSLATE_SIZE + TRANSFORM_SIZE + POSITION_SIZE + SIZE * 3)] = color
			
			lastVertex += VERTICES_PER_ELEMENT
			Draw()
	End Method
	
	Method DrawPoint:Void(x:Float, y:Float)
	End Method
	
	Method DrawLine:Void(x1:Float, y1:Float, x2:Float, y2:Float)
	End Method
	
	Method DrawRect:Void(x:Float, y:Float, width:Float, height:Float)
	End Method
	
	Method DrawOval:Void(x:Float, y:Float, w:Float, h:Float)
	End Method
	
	Method DrawPoly:Void(verts:Float[])
	End Method
	
	Method DrawPoly:Void(verts:Float[], surface:Surface, srcx:Int, srcy:Int)
	End Method
	
	Method Capabilities:Int()
		Return DRAW_SURFACE
	End Method
	
Private

	Global DefaultShader:ShaderProgram
	Global DefaultIndices:Int[]
	
	Field surfaces:Deque<SurfaceRange>
	Field usedTextures := New IntMap<Int>()
	Field current:SurfaceRange
	
	Field maxUnits:Int
	Field currentUnit:Int = 1
	Field lastUnit:Int = -1

End Class

Class GraphicsRenderer Extends BaseRenderer

	Const SIZE:Int = POSITION_SIZE + TRANSFORM_SIZE + TRANSLATE_SIZE + COLOR_SIZE
	
	Method New(size:Int)
		Super.New(size)
	End Method
	
	Method Create:Void()
		buffer = New StreamingVertexBuffer(maxVertices, maxIndices, USAGE_DYNAMIC, [POSITION, TRANSFORM, TRANSLATE, COLOR], [POSITION_FORMAT, TRANSFORM_FORMAT, TRANSLATE_FORMAT, COLOR_FORMAT])
		
		If (Not DefaultShader) Then
			Local mojoShader:Shader = New Shader()
			DefaultShader = mojoShader.Apply(Self)
		End If
		
		defaultShader = DefaultShader
	End Method
	
	Method OnFlush:Void()
		If (HasRenderTarget())
			Select GetBlend()
				Case AlphaBlend
					glBlendFuncSeparate(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA, GL_ONE, GL_ONE_MINUS_SRC_ALPHA)
			End
		End
		
		buffer.StreamOffset = firstVertex
		buffer.StreamSize = lastVertex-firstVertex
		
		buffer.SetIndices(indices, firstIndex, firstIndex, lastIndex - firstIndex)
		DrawArrays(DRAW_MODE_TRIANGLE_STRIP, firstIndex, lastIndex - firstIndex)
		
		If (lastVertex > maxVertices Shr 1 Or lastIndex > maxIndices Shr 1) Then
			lastIndex = 0
			firstIndex = 0
			indexValue = 0
			
			Super.OnFlush()
		Else
			firstIndex = lastIndex
			firstVertex = lastVertex
		End If
	End Method
	
	Method DrawPoint:Void(x:Float, y:Float)
		DrawRect(x, y, 1, 1)
	End Method
	
	Method DrawRect:Void(x:Float, y:Float, width:Float, height:Float)
		If (lastVertex + VERTICES_PER_ELEMENT > maxVertices Or lastIndex + INDICES_PER_ELEMENT > maxIndices) Flush()
		
		Local offset:Int = lastVertex * SIZE
		
		vertices[offset] = x; vertices[offset+1] = y
		vertices[offset + SIZE] = x + width; vertices[offset + (SIZE + 1)] = y
		vertices[offset + SIZE * 2] = x; vertices[offset + (SIZE * 2 + 1)] = y + height
		vertices[offset + SIZE * 3] = x + width; vertices[offset + (SIZE * 3 + 1)] = y + height

		CompleteDrawQuad(offset + POSITION_SIZE)
	End Method
	
	Method DrawLine:Void(x1:Float, y1:Float, x2:Float, y2:Float)
		If (lastVertex + VERTICES_PER_ELEMENT > maxVertices Or lastIndex + INDICES_PER_ELEMENT > maxIndices) Flush()

		x1 += 0.5; x2 += 0.5; y1 += 0.5; y2 += 0.5		
		Local offset:Int = lastVertex * SIZE
		
		Local tmpX:Float = -(y1 - y2)
		Local tmpY:Float = x1 - x2
	
		Local dist:Float = Sqrt(tmpX*tmpX + tmpY*tmpY)
		tmpX /= dist
		tmpY /= dist
		tmpX *= 0.5
		tmpY *= 0.5
		
		vertices[offset] = x1 - tmpX; vertices[offset+1] = y1 - tmpY
		vertices[offset + SIZE] = x1 + tmpX; vertices[offset + (SIZE + 1)] = y1 + tmpY
		vertices[offset + SIZE * 2] = x2 - tmpX; vertices[offset + (SIZE * 2 + 1)] = y2 - tmpY
		vertices[offset + SIZE * 3] = x2 + tmpX; vertices[offset + (SIZE * 3 + 1)] = y2 + tmpY
	
		CompleteDrawQuad(offset + POSITION_SIZE)
	End Method
	
	Method DrawOval:Void(x:Float, y:Float, w:Float, h:Float)
		Const VERTICES_PER_OVAL:Int = 82
		Const INDICES_PER_OVAL:Int = 84
	
		If (lastVertex + VERTICES_PER_OVAL > maxVertices Or lastIndex + INDICES_PER_OVAL > maxIndices) Flush()

		w /= 2
		h /= 2
		x += w
		y += h
		
		Local offset:Int = lastVertex * SIZE
		Local vertices:=Self.vertices, indices:=Self.indices
		Local ix:=ix, iy:=iy, jx:=jx, jy:=jy, tx:=tx, ty:=ty, color:=color, lastIndex:=lastIndex, indexValue:=indexValue
		
		Local i:Int = 0
		While (i < VERTICES_PER_OVAL / 2)
			vertices[offset] = x; vertices[offset + 1] = y
			vertices[offset + SIZE] = x + Sinr((PI * 2.0) / (VERTICES_PER_OVAL / 2 - 1) * i) * w; vertices[offset + (SIZE + 1)] = y + Cosr((PI * 2.0) / (VERTICES_PER_OVAL / 2 - 1) * i) * h
			
			vertices[offset + POSITION_SIZE] = ix
			vertices[offset + (POSITION_SIZE + 1)] = iy
			vertices[offset + (POSITION_SIZE + 2)] = jx
			vertices[offset + (POSITION_SIZE + 3)] = jy
			vertices[offset + (POSITION_SIZE + SIZE)] = ix
			vertices[offset + (POSITION_SIZE + SIZE + 1)] = iy
			vertices[offset + (POSITION_SIZE + SIZE + 2)] = jx
			vertices[offset + (POSITION_SIZE + SIZE + 3)] = jy
			
			vertices[offset + (POSITION_SIZE + TRANSFORM_SIZE)] = tx
			vertices[offset + (POSITION_SIZE + TRANSFORM_SIZE + 1)] = ty
			vertices[offset + (POSITION_SIZE + TRANSFORM_SIZE + SIZE)] = tx
			vertices[offset + (POSITION_SIZE + TRANSFORM_SIZE + SIZE + 1)] = ty
			
			vertices[offset + (POSITION_SIZE + TRANSLATE_SIZE + TRANSFORM_SIZE)] = color
			vertices[offset + (POSITION_SIZE + TRANSLATE_SIZE + TRANSFORM_SIZE + SIZE)] = color
		
			i += 1
			offset += SIZE * 2
		Wend
				
		i = 1
		indices[lastIndex] = indexValue
		indexValue -= 1
				
		While (i < (INDICES_PER_OVAL - 1))
			indices[lastIndex + i] = indexValue + i
			i += 1
		Wend
		
		indices[lastIndex + i] = indexValue + (i - 1)
		
		lastVertex += VERTICES_PER_OVAL
		Self.lastIndex += INDICES_PER_OVAL
		Self.indexValue = indexValue + i
			
		Draw()
	End Method
	
	Method DrawPoly:Void(verts:Float[])
		Local numVertices:Int = verts.Length() Shr 1
		Local numIndices:Int = (numVertices - 2) * 5
		
		If (lastVertex + numVertices > maxVertices Or lastIndex + numIndices > maxIndices) Flush()
		
		Local offset:Int = lastVertex * SIZE
		Local vertices:=Self.vertices, indices:=Self.indices
		Local ix:=ix, iy:=iy, jx:=jx, jy:=jy, tx:=tx, ty:=ty, color:=color, lastIndex:=lastIndex, indexValue:=indexValue
		
		Local i:Int = 0
		While(i < numVertices)
			vertices[offset] = verts[i * 2]; vertices[offset + 1] = verts[i * 2 + 1]
			
			vertices[offset + POSITION_SIZE] = ix
			vertices[offset + (POSITION_SIZE + 1)] = iy
			vertices[offset + (POSITION_SIZE + 2)] = jx
			vertices[offset + (POSITION_SIZE + 3)] = jy
			
			vertices[offset + (POSITION_SIZE + TRANSFORM_SIZE)] = tx
			vertices[offset + (POSITION_SIZE + TRANSFORM_SIZE + 1)] = ty
			
			vertices[offset + (POSITION_SIZE + TRANSLATE_SIZE + TRANSFORM_SIZE)] = color
			
			offset += SIZE
			i += 1
		Wend
		
		While(lastIndex < Self.lastIndex + numIndices)
			indices[lastIndex] = Self.indexValue
			indices[lastIndex + 1] = Self.indexValue
			indices[lastIndex + 2] = indexValue + 1
			indices[lastIndex + 3] = indexValue + 2
			indices[lastIndex + 4] = indexValue + 2

			lastIndex += 5
			indexValue += 1
		Wend
		
		lastVertex += numVertices
		Self.lastIndex += numIndices
		Self.indexValue = indexValue + 2
		
		Draw()
	End Method
	
	Method CompleteDrawQuad:Void(offset:Int)
		Local vertices:=Self.vertices, indices:=Self.indices
		Local ix:=ix, iy:=iy, jx:=jx, jy:=jy, tx:=tx, ty:=ty, color:=color, indexValue:=indexValue
	
		vertices[offset] = ix
		vertices[offset + 1] = iy
		vertices[offset + 2] = jx
		vertices[offset + 3] = jy
				
		vertices[offset + SIZE] = ix
		vertices[offset + (SIZE + 1)] = iy
		vertices[offset + (SIZE + 2)] = jx
		vertices[offset + (SIZE + 3)] = jy
		
		vertices[offset + SIZE * 2] = ix
		vertices[offset + (SIZE * 2 + 1)] = iy
		vertices[offset + (SIZE * 2 + 2)] = jx
		vertices[offset + (SIZE * 2 + 3)] = jy
		
		vertices[offset + SIZE * 3] = ix
		vertices[offset + (SIZE * 3 + 1)] = iy
		vertices[offset + (SIZE * 3 + 2)] = jx
		vertices[offset + (SIZE * 3 + 3)] = jy
		
		vertices[offset + TRANSFORM_SIZE] = tx
		vertices[offset + (TRANSFORM_SIZE + 1)] = ty
		
		vertices[offset + (TRANSFORM_SIZE + SIZE)] = tx
		vertices[offset + (TRANSFORM_SIZE + SIZE + 1)] = ty
		
		vertices[offset + (TRANSFORM_SIZE + SIZE * 2)] = tx
		vertices[offset + (TRANSFORM_SIZE + SIZE * 2 + 1)] = ty
		
		vertices[offset + (TRANSFORM_SIZE + SIZE * 3)] = tx
		vertices[offset + (TRANSFORM_SIZE + SIZE * 3 + 1)] = ty
		
		vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE)] = color
		vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + SIZE)] = color
		vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + SIZE * 2)] = color
		vertices[offset + (TRANSLATE_SIZE + TRANSFORM_SIZE + SIZE * 3)] = color
		
		indices[lastIndex] = indexValue
		indices[lastIndex + 1] = indexValue
		indices[lastIndex + 2] = indexValue + 1
		indices[lastIndex + 3] = indexValue + 2
		indices[lastIndex + 4] = indexValue + 3
		indices[lastIndex + 5] = indexValue + 3
		
		lastVertex += VERTICES_PER_ELEMENT
		lastIndex += INDICES_PER_ELEMENT
		Self.indexValue += VERTICES_PER_ELEMENT
		
		Draw()
	End Method
	
	Method DrawPoly:Void(verts:Float[], surface:Surface, srcx:Int, srcy:Int)
	End Method
	
	Method DrawSurface:Void(surface:Surface, x:Float, y:Float)
	End Method
	
	Method DrawSurface:Void(surface:Surface, x:Float, y:Float, srcx:Int, srcy:Int, srcw:Int, srch:Int)
	End Method
	
	Method DrawSurfaceTransform:Void(surface:Surface, x:Float, y:Float, rotation:Float, scaleX:Float, scaleY:Float)
	End Method
	
	Method DrawSurfaceTransform:Void(surface:Surface, x:Float, y:Float, srcx:Int, srcy:Int, srcw:Int, srch:Int, rotation:Float, scaleX:Float, scaleY:Float)
	End Method
	
	Method Capabilities:Int()
		Return DRAW_GRAPHICS
	End Method
	
Private

	Global DefaultShader:ShaderProgram
	
	Field firstIndex:Int
	Field lastIndex:Int
	
	Field indexValue:Int

End Class

Class BaseRenderer Extends Renderer Abstract

	Const POSITION:String = "mojo_device_position"
	Const POSITION_SIZE:Int = 2
	Global POSITION_FORMAT:VertexFormat = VERTEX_ATTR_FLOAT2
	
	Const TRANSFORM:String = "mojo_device_transform"
	Const TRANSFORM_SIZE:Int = 4
	Global TRANSFORM_FORMAT:VertexFormat = VERTEX_ATTR_FLOAT4
	
	Const TRANSLATE:String = "mojo_device_translate"
	Const TRANSLATE_SIZE:Int = 2
	Global TRANSLATE_FORMAT:VertexFormat = VERTEX_ATTR_FLOAT2
	
	Const COLOR:String = "mojo_device_color"
	Const COLOR_SIZE:Int = 1
	Global COLOR_FORMAT:VertexFormat = VERTEX_ATTR_UBYTE4N
	
	Const PROJECTION:String = "mojo_device_projection"

	Const VERTICES_PER_ELEMENT:Int = 4
	Const INDICES_PER_ELEMENT:Int = 6
	
	Method Create:Void() Abstract

	Method New(size:Int)
		If (WHITE = 0) Then
			Converter.PokeInt(0, $FEFFFFFF)
			WHITE = Converter.PeekFloat(0)
		End If
	
		Self.size = size
		maxVertices = size * VERTICES_PER_ELEMENT
		maxIndices = size * INDICES_PER_ELEMENT
		
		Create()
		
		vertices = buffer.Stream
		indices = indices.Resize(maxIndices)
	End Method
	
	Method OnStart:Void()
	End Method
	
	Method GetVertexBuffer:VertexBuffer()
		Return buffer
	End Method
	
	Method GetDefaultShader:ShaderProgram()
		Return defaultShader
	End Method
	
	Method OnFlush:Void()
		lastVertex = 0
		firstVertex = 0
	End Method
	
	Method OnFinish:Void()
	End Method
	
	Method SetDeviceProjection:Void(x:Int, y:Int, width:Int, height:Int, flipY:Bool)
		Local shader := Shader
		If (px = x And py = y And pw = width And ph = height And pf = flipY And lastShader = shader) Return
		
		Local fy:Float = 1.0
		If (flipY) fy = -1.0
	
		shader.Bind()
		shader.SetUniformf(PROJECTION, width / 2.0, fy * height / 2.0, 1.0, fy)
		px = x; py = y; pw = width; ph = height; pf = flipY
		lastShader = shader
	End Method
	
	Method SetMatrix:Void(ix:Float, iy:Float, jx:Float, jy:Float, tx:Float, ty:Float)
		Self.ix = ix
		Self.iy = iy
		Self.jx = jx
		Self.jy = jy
		Self.tx = tx
		Self.ty = ty
	End Method
	
	Method GetMatrix:Void(matrix:Float[])
		matrix[0] = ix
		matrix[1] = iy
		matrix[2] = jx
		matrix[3] = jy
		matrix[4] = tx
		matrix[5] = ty
	End Method
	
	Method SetColor:Void(r:Int, g:Int, b:Int)
		If (r = Self.r And b = Self.b And g = Self.g) Return
			
		Converter.PokeInt(0, ((a Shl 24) | (b Shl 16) | (g Shl 8) | r) & $FEFFFFFF)
		color = Converter.PeekFloat(0)
		
		Self.r = r
		Self.g = g
		Self.b = b
	End Method
	
	Method GetColor:Void(colors:Int[])
		colors[0] = r
		colors[1] = g
		colors[2] = b
	End Method
	
	Method SetAlpha:Void(a:Float)
		Local alpha:Int = a * 255
		If (alpha = Self.a) Return
		
		Converter.PokeByte(3, alpha & $FE)
		color = Converter.PeekFloat(0)
		
		Self.a = alpha
	End Method
	
	Method GetAlpha:Float()
		Return a / 255.0
	End Method

Private

	Global WHITE:Float
	Global Converter:DataBuffer = New DataBuffer(4)
	
	Field size:Int
	Field maxVertices:Int
	Field maxIndices:Int
	
	Field defaultShader:ShaderProgram
	
	Field firstVertex:Int
	Field lastVertex:Int
	
	Field vertices:Float[]
	Field indices:Int[]
	Field buffer:StreamingVertexBuffer
	
	Field ix:Float
	Field iy:Float
	Field jx:Float
	Field jy:Float
	Field tx:Float
	Field ty:Float
	
	Field color:Float
	Field r:Int
	Field g:Int
	Field b:Int
	Field a:Int
	
	Field px:Int, py:Int, pw:Int, ph:Int, pf:Bool
	Field lastShader:ShaderProgram

End Class

Class EmptyRenderer Extends Renderer

	Method GetVertexBuffer:VertexBuffer()
		Return Null
	End Method
	
	Method GetDefaultShader:ShaderProgram()
		Return Null
	End Method
	
	Method OnStart:Void()
	End Method
	
	Method OnFlush:Void()
	End Method
	
	Method OnFinish:Void()
		r = 255
		g = 255
		b = 255
		a = 1.0
		
		ix = 1
		iy = 0
		jx = 0
		jy = 1
		tx = 0
		ty = 0
	End Method
	
	Method SetDeviceProjection:Void(x:Int, y:Int, width:Int, height:Int, flipY:Bool)
	End Method

	Method SetMatrix:Void(ix:Float, iy:Float, jx:Float, jy:Float, tx:Float, ty:Float)
		Self.ix = ix
		Self.iy = iy
		Self.jx = jx
		Self.jy = jy
		Self.tx = tx
		Self.ty = ty
	End Method
	
	Method GetMatrix:Void(matrix:Float[])
		matrix[0] = ix
		matrix[1] = iy
		matrix[2] = jx
		matrix[3] = jy
		matrix[4] = tx
		matrix[5] = ty
	End Method
	
	Method SetColor:Void(r:Int, g:Int, b:Int)
		Self.r = r
		Self.g = g
		Self.b = b
	End Method
	
	Method GetColor:Void(colors:Int[])
		colors[0] = r
		colors[1] = g
		colors[2] = b
	End Method
	
	Method SetAlpha:Void(a:Float)
		Self.a = a
	End Method
	
	Method GetAlpha:Float()
		Return a
	End Method
	
	Method DrawPoint:Void(x:Float, y:Float)	
	End Method
	
	Method DrawLine:Void(x1:Float, y1:Float, x2:Float, y2:Float)
	End Method
	
	Method DrawRect:Void(x:Float, y:Float, width:Float, height:Float)
	End Method
	
	Method DrawOval:Void(x:Float, y:Float, w:Float, h:Float)
	End Method
	
	Method DrawPoly:Void(verts:Float[])
	End Method
	
	Method DrawPoly:Void(verts:Float[], surface:Surface, srcx:Int, srcy:Int)
	End Method
	
	Method DrawSurface:Void(surface:Surface, x:Float, y:Float)
	End Method
	
	Method DrawSurface:Void(surface:Surface, x:Float, y:Float, srcx:Int, srcy:Int, srcw:Int, srch:Int)
	End Method
	
	Method DrawSurfaceTransform:Void(surface:Surface, x:Float, y:Float, rotation:Float, scaleX:Float, scaleY:Float)
	End Method
	
	Method DrawSurfaceTransform:Void(surface:Surface, x:Float, y:Float, srcx:Int, srcy:Int, srcw:Int, srch:Int, rotation:Float, scaleX:Float, scaleY:Float)
	End Method
	
	Method Capabilities:Int()
		Return DRAW_ALL
	End Method

Private

	Field ix:Float
	Field iy:Float
	Field jx:Float
	Field jy:Float
	Field tx:Float
	Field ty:Float

	Field r:Int
	Field g:Int
	Field b:Int
	Field a:Float
	
End Class

Private

Class SurfaceRange

	Global Pool:Pool<SurfaceRange> = New Pool<SurfaceRange>()
	
	Field firstIndex:Int
	Field lastIndex:Int
	Field surface:Surface
	Field unit:Int

End Class
