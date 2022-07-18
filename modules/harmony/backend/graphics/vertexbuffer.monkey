Strict

Import shaderprogram
Import brl.databuffer

Private

Import gl
Import harmony.backend.utils
Import harmony.backend.restorable

Public

Global VERTEX_ATTR_FLOAT:VertexFormat = New VertexFormat(1, False, GL_FLOAT)
Global VERTEX_ATTR_FLOAT2:VertexFormat = New VertexFormat(2, False, GL_FLOAT)
Global VERTEX_ATTR_FLOAT3:VertexFormat = New VertexFormat(3, False, GL_FLOAT)
Global VERTEX_ATTR_FLOAT4:VertexFormat = New VertexFormat(4, False, GL_FLOAT)

Global VERTEX_ATTR_SHORT:VertexFormat = New VertexFormat(1, False, GL_SHORT)
Global VERTEX_ATTR_SHORT2:VertexFormat = New VertexFormat(2, False, GL_SHORT)
Global VERTEX_ATTR_SHORT3:VertexFormat = New VertexFormat(3, False, GL_SHORT)
Global VERTEX_ATTR_SHORT4:VertexFormat = New VertexFormat(4, False, GL_SHORT)

Global VERTEX_ATTR_SHORTN:VertexFormat = New VertexFormat(1, True, GL_SHORT)
Global VERTEX_ATTR_SHORT2N:VertexFormat = New VertexFormat(2, True, GL_SHORT)
Global VERTEX_ATTR_SHORT3N:VertexFormat = New VertexFormat(3, True, GL_SHORT)
Global VERTEX_ATTR_SHORT4N:VertexFormat = New VertexFormat(4, True, GL_SHORT)

Global VERTEX_ATTR_USHORT:VertexFormat = New VertexFormat(1, False, GL_UNSIGNED_SHORT)
Global VERTEX_ATTR_USHORT2:VertexFormat = New VertexFormat(2, False, GL_UNSIGNED_SHORT)
Global VERTEX_ATTR_USHORT3:VertexFormat = New VertexFormat(3, False, GL_UNSIGNED_SHORT)
Global VERTEX_ATTR_USHORT4:VertexFormat = New VertexFormat(4, False, GL_UNSIGNED_SHORT)

Global VERTEX_ATTR_USHORTN:VertexFormat = New VertexFormat(1, True, GL_UNSIGNED_SHORT)
Global VERTEX_ATTR_USHORT2N:VertexFormat = New VertexFormat(2, True, GL_UNSIGNED_SHORT)
Global VERTEX_ATTR_USHORT3N:VertexFormat = New VertexFormat(3, True, GL_UNSIGNED_SHORT)
Global VERTEX_ATTR_USHORT4N:VertexFormat = New VertexFormat(4, True, GL_UNSIGNED_SHORT)

Global VERTEX_ATTR_BYTE:VertexFormat = New VertexFormat(1, False, GL_BYTE)
Global VERTEX_ATTR_BYTE2:VertexFormat = New VertexFormat(2, False, GL_BYTE)
Global VERTEX_ATTR_BYTE3:VertexFormat = New VertexFormat(3, False, GL_BYTE)
Global VERTEX_ATTR_BYTE4:VertexFormat = New VertexFormat(4, False, GL_BYTE)

Global VERTEX_ATTR_BYTEN:VertexFormat = New VertexFormat(1, True, GL_BYTE)
Global VERTEX_ATTR_BYTE2N:VertexFormat = New VertexFormat(2, True, GL_BYTE)
Global VERTEX_ATTR_BYTE3N:VertexFormat = New VertexFormat(3, True, GL_BYTE)
Global VERTEX_ATTR_BYTE4N:VertexFormat = New VertexFormat(4, True, GL_BYTE)

Global VERTEX_ATTR_UBYTE:VertexFormat = New VertexFormat(1, False, GL_UNSIGNED_BYTE)
Global VERTEX_ATTR_UBYTE2:VertexFormat = New VertexFormat(2, False, GL_UNSIGNED_BYTE)
Global VERTEX_ATTR_UBYTE3:VertexFormat = New VertexFormat(3, False, GL_UNSIGNED_BYTE)
Global VERTEX_ATTR_UBYTE4:VertexFormat = New VertexFormat(4, False, GL_UNSIGNED_BYTE)

Global VERTEX_ATTR_UBYTEN:VertexFormat = New VertexFormat(1, True, GL_UNSIGNED_BYTE)
Global VERTEX_ATTR_UBYTE2N:VertexFormat = New VertexFormat(2, True, GL_UNSIGNED_BYTE)
Global VERTEX_ATTR_UBYTE3N:VertexFormat = New VertexFormat(3, True, GL_UNSIGNED_BYTE)
Global VERTEX_ATTR_UBYTE4N:VertexFormat = New VertexFormat(4, True, GL_UNSIGNED_BYTE)

Const DRAW_MODE_POINTS:Int = GL_POINTS
Const DRAW_MODE_LINES:Int = GL_LINES
Const DRAW_MODE_LINE_STRIP:Int = GL_LINE_STRIP
Const DRAW_MODE_TRIANGLES:Int = GL_TRIANGLES
Const DRAW_MODE_TRIANGLE_STRIP:Int = GL_TRIANGLE_STRIP
Const DRAW_MODE_TRIANGLE_FAN:Int = GL_TRIANGLE_FAN

Const USAGE_DYNAMIC:Int = GL_DYNAMIC_DRAW
Const USAGE_STATIC:Int = GL_STATIC_DRAW

Class StreamingVertexBuffer Extends VertexBuffer
	
	Method New(vertexCount:Int, aliases:String[], formats:VertexFormat[])
		hasStream = True
		Init(vertexCount, 0, aliases, formats)
	End Method
	
	Method New(vertexCount:Int, indexCount:Int, aliases:String[], formats:VertexFormat[])
		hasStream = True
		Init(vertexCount, indexCount, aliases, formats)
	End Method
	
	Method New(vertexCount:Int, indexCount:Int, indicesUsage:Int, aliases:String[], formats:VertexFormat[])
		Self.indicesUsage = indicesUsage
		hasStream = True
		Init(vertexCount, indexCount, aliases, formats)
	End Method
	
	Method SetVertices:Void(vertices:Float[])
		'note: TODO Error
	End Method
	
	Method SetVertices:Void(vertices:Float[], _to:Int, from:Int, count:Int)
		'note: TODO Error
	End Method
	
	Method SetVertices:Void(stream:Int, vertices:Float[])
		'note: TODO Error
	End Method
	
	Method SetVertices:Void(stream:Int, vertices:Float[], _to:Int, from:Int, count:Int)
		'note: TODO Error
	End Method
	
	Method SetPackedVertices:Void(stream:Int, vertices:Int[])
		'note: TODO Error
	End Method
	
	Method SetPackedVertices:Void(stream:Int, vertices:Int[], _to:Int, from:Int, count:Int)
		'note: TODO Error
	End Method
	
	Method SetVertices:Void(vertices:DataBuffer)
		'note: TODO Error
	End Method
	
	Method SetVertices:Void(vertices:DataBuffer, _to:Int, from:Int, count:Int)
		'note: TODO Error
	End Method

	Method Stream:Float[]() Property
		Return stream
	End Method
	
	Method Stream:Void(stream:Float[]) Property
		'note: TODO Error
	End Method
	
	Method Stream:Void(stream:Object) Property
		'note: TODO Error
	End Method
	
	Method Usage:Void(usage:Int) Property
		IndicesUsage = usage
	End Method
	
	Method VerticesUsage:Void(usage:Int) Property
		'note: TODO Error
	End Method

End Class

Class StaticVertexBuffer Extends VertexBuffer

	Method New(vertexCount:Int, aliases:String[], formats:VertexFormat[])
		Init(vertexCount, 0, aliases, formats)
	End Method
	
	Method New(vertexCount:Int, indexCount:Int, aliases:String[], formats:VertexFormat[])
		Init(vertexCount, indexCount, aliases, formats)
	End Method
	
	Method Init:Void(vertexCount:Int, indexCount:Int, aliases:String[], formats:VertexFormat[])
		verticesUsage = USAGE_STATIC
		indicesUsage = USAGE_STATIC
		
		Super.Init(vertexCount, indexCount, aliases, formats)
	End Method
	
	Method Usage:Void(usage:Int) Property
		'note: TODO Error
	End Method
	
	Method VerticesUsage:Void(usage:Int) Property
		'note: TODO Error
	End Method
	
	Method IndicesUsage:Void(usage:Int) Property
		'note: TODO Error
	End Method
	
	Method Stream:Float[]() Property
		'note: TODO Error
		Return []
	End Method
	
	Method Stream:Void(stream:Float[]) Property
		'note: TODO Error
	End Method
	
	Method Stream:Void(stream:Object) Property
		'note: TODO Error
	End Method

End Class

Class DynamicVertexBuffer Extends VertexBuffer

	Method New(vertexCount:Int, aliases:String[], formats:VertexFormat[])
		Init(vertexCount, 0, aliases, formats)
	End Method
	
	Method New(vertexCount:Int, indexCount:Int, aliases:String[], formats:VertexFormat[])
		Init(vertexCount, indexCount, aliases, formats)
	End Method
	
	Method Init:Void(vertexCount:Int, indexCount:Int, aliases:String[], formats:VertexFormat[])
		verticesUsage = USAGE_DYNAMIC
		indicesUsage = USAGE_DYNAMIC
		
		Super.Init(vertexCount, indexCount, aliases, formats)
	End Method

End Class

Class VertexBuffer Implements RestorableResource

	Method New(vertexCount:Int, aliases:String[], formats:VertexFormat[])
		Init(vertexCount, 0, aliases, formats)
	End Method
	
	Method New(vertexCount:Int, indexCount:Int, aliases:String[], formats:VertexFormat[])
		Init(vertexCount, indexCount, aliases, formats)
	End Method

	Method Discard:Void()
		If (managed) Then
			RestorableResources.RemoveResource(Self)
			managed = False
		End If
	
		Dispose()
		If (verticesData) verticesData.Discard()
		If (indiciesData) indiciesData.Discard()
		verticesData = Null
		indiciesData = Null
	End Method
	
	Method Bind:Void(program:ShaderProgram)
		Local dirty:Bool = False
	
		If (ActiveBuffer <> Self Or ActiveBuffer = Null) Then
			If (ActiveBuffer <> Null) ActiveBuffer.isBound = False
		
			glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer)
	
	#If TARGET<>"winrt"		
			If (indiciesData)
				glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer)
			End If
	#End
			
			isBound = True
			dirty = True
		End If
		
		If (Not dirty And LastActiveShader = program) Return
		
		Local mLocation:Int = -1
		
		For Local i:Int = 0 Until aliases.Length
			Local attr:ShaderAttribute = program.GetAttribute(aliases[i])
			If (Not attr) Continue
			
			Local l:Int = attr.Location
			
			If (Not EnabledLocations[l])
				program.EnableVertexAttribute(l)
				EnabledLocations[l] = True
			End If

			mLocation = Max(mLocation, l)
			
			Local f:VertexFormat = formats[i]			
			If (dirty Or Not EnabledFormats[l] Or Not EnabledFormats[l].Equals(f))
				program.SetVertexAttribute(l, f.numComponents, f.type, f.normalized, vertexSize, f.offset)
				EnabledFormats[l] = f
				dirty = True
			End If
		Next
		
		If (mLocation >= 0) Then
			Local l:Int = EnabledLocations.Length()
			mLocation += 1
			
			While(mLocation < l And EnabledLocations[mLocation])
				program.DisableVertexAttribute(mLocation)
				EnabledLocations[mLocation] = False
				mLocation += 1
			Wend
		End If
		
		ActiveBuffer = Self
		LastActiveShader = program
	End Method
	
	Method Unbind:Void(program:ShaderProgram)
		If (ActiveBuffer <> Self) Then
			isBound = False
			Return
		End If
	
		For Local i:Int = 0 Until aliases.Length
			Local attr:ShaderAttribute = program.GetAttribute(aliases[i])
			If (Not attr) Continue
			
			Local l:Int = attr.Location
			
			If (EnabledLocations[l])
				program.DisableVertexAttribute(attr.Location)
				EnabledLocations[l] = False
			End If
		Next
	
		glBindBuffer(GL_ARRAY_BUFFER, 0)

	#If TARGET <> "winrt"		
		If (indiciesData)
			glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0)
		End If
	#End
		
		isBound = False
		ActiveBuffer = Null
	End Method
	
	Method SetVertices:Void(vertices:Float[])
		isVerticesDirty |= DIRTY_DATA
	
		If Not mixedFormats Then
			CopyFloatsToDatabuffer(vertices, verticesData)
		Else
			Local countStreams:Int = formats.Length(), format:VertexFormat
						
			For Local stream:Int = 0 Until countStreams
				format = formats[stream]
				
				Select format.type
					Case GL_FLOAT
						CopyFloatsToDatabuffer(vertices, verticesData, format.offset, format.componentsOffset, vertices.Length(), format.numComponents, numComponents, vertexSize)
				
					Case GL_UNSIGNED_BYTE
						CopyUBytesToDatabuffer(vertices, verticesData, format.offset, format.componentsOffset, vertices.Length(), format.numComponents, numComponents, vertexSize)
			
					Case GL_BYTE
						CopyBytesToDatabuffer(vertices, verticesData, format.offset, format.componentsOffset, vertices.Length(), format.numComponents, numComponents, vertexSize)
			
					Case GL_SHORT
						CopyShortsToDatabuffer(vertices, verticesData, format.offset, format.componentsOffset, vertices.Length(),  format.numComponents, numComponents, vertexSize)
			
					Case GL_UNSIGNED_SHORT
						CopyUShortsToDatabuffer(vertices, verticesData, format.offset, format.componentsOffset, vertices.Length(), format.numComponents, numComponents, vertexSize)
							
				End Select
			Next
		End If
		
		verticesDirtyRange.start = 0
		verticesDirtyRange.stop = Max((vertices.Length() / numComponents) * vertexSize, verticesDirtyRange.stop)
		
		If (verticesUsage = USAGE_STATIC) UpdateBuffers()
	End Method
	
	Method SetVertices:Void(vertices:Float[], _to:Int, from:Int, count:Int)
		isVerticesDirty |= DIRTY_DATA
				
		Local offset:Int = _to*vertexSize
		
		If Not mixedFormats Then
			CopyFloatsToDatabuffer(vertices, verticesData, offset, from * numComponents, count * numComponents)
		Else
			Local countStreams:Int = formats.Length(), format:VertexFormat
			Local componentsOffset:Int = from * numComponents
			Local componentsToCopy:Int = count * numComponents
						
			For Local stream:Int = 0 Until countStreams
				format = formats[stream]
				
				Select format.type
					Case GL_FLOAT
						CopyFloatsToDatabuffer(vertices, verticesData, offset + format.offset, componentsOffset + format.componentsOffset, componentsToCopy, format.numComponents, numComponents, vertexSize)
				
					Case GL_UNSIGNED_BYTE
						CopyUBytesToDatabuffer(vertices, verticesData, offset + format.offset, componentsOffset + format.componentsOffset, componentsToCopy, format.numComponents, numComponents, vertexSize)
			
					Case GL_BYTE
						CopyBytesToDatabuffer(vertices, verticesData, offset + format.offset, componentsOffset + format.componentsOffset, componentsToCopy, format.numComponents, numComponents, vertexSize)
			
					Case GL_SHORT
						CopyShortsToDatabuffer(vertices, verticesData, offset + format.offset, componentsOffset + format.componentsOffset, componentsToCopy,  format.numComponents, numComponents, vertexSize)
			
					Case GL_UNSIGNED_SHORT
						CopyUShortsToDatabuffer(vertices, verticesData, offset + format.offset, componentsOffset + format.componentsOffset, componentsToCopy, format.numComponents, numComponents, vertexSize)
							
				End Select
			Next
		End If
		
		verticesDirtyRange.start = Min(offset, verticesDirtyRange.start)
		verticesDirtyRange.stop = Max(offset + count * vertexSize, verticesDirtyRange.stop)
		
		If (verticesUsage = USAGE_STATIC) UpdateBuffers()
	End Method
	
	Method SetVertices:Void(stream:Int, vertices:Float[])
		isVerticesDirty |= DIRTY_DATA
	
		Local format:VertexFormat = formats[stream]
		
		Select format.type
			Case GL_FLOAT
				CopyFloatsToDatabuffer(vertices, verticesData, format.offset, 0, vertices.Length(), format.numComponents, vertexSize)
				
			Case GL_UNSIGNED_BYTE
				CopyUBytesToDatabuffer(vertices, verticesData, format.offset, 0, vertices.Length(), format.numComponents, vertexSize)
			
			Case GL_BYTE
				CopyBytesToDatabuffer(vertices, verticesData, format.offset, 0, vertices.Length(), format.numComponents, vertexSize)
			
			Case GL_SHORT
				CopyShortsToDatabuffer(vertices, verticesData, format.offset, 0, vertices.Length(),  format.numComponents, vertexSize)
			
			Case GL_UNSIGNED_SHORT
				CopyUShortsToDatabuffer(vertices, verticesData, format.offset, 0, vertices.Length(), format.numComponents, vertexSize)
							
		End Select
		
		verticesDirtyRange.start = Min(format.offset, verticesDirtyRange.start)
		verticesDirtyRange.stop = Max((vertices.Length() / format.numComponents) * vertexSize, verticesDirtyRange.stop)
		
		If (verticesUsage = USAGE_STATIC) UpdateBuffers()
	End Method
	
	Method SetVertices:Void(stream:Int, vertices:Float[], _to:Int, from:Int, count:Int)
		isVerticesDirty |= DIRTY_DATA
		
		Local format:VertexFormat = formats[stream]
		Local offset:Int = _to*vertexSize + format.offset
		Local componentsToCopy:Int = count * format.numComponents
		Local componentsOffset:Int = from * format.numComponents		
		
		Select format.type
			Case GL_FLOAT
				CopyFloatsToDatabuffer(vertices, verticesData, offset, componentsOffset, componentsToCopy, format.numComponents, vertexSize)
				
			Case GL_UNSIGNED_BYTE
				CopyUBytesToDatabuffer(vertices, verticesData, offset, componentsOffset, componentsToCopy, format.numComponents, vertexSize)
			
			Case GL_BYTE
				CopyBytesToDatabuffer(vertices, verticesData, offset, componentsOffset, componentsToCopy, format.numComponents, vertexSize)
			
			Case GL_SHORT
				CopyShortsToDatabuffer(vertices, verticesData, offset, componentsOffset, componentsToCopy, format.numComponents, vertexSize)
			
			Case GL_UNSIGNED_SHORT
				CopyUShortsToDatabuffer(vertices, verticesData, offset, componentsOffset, componentsToCopy, format.numComponents, vertexSize)
							
		End Select
		
		verticesDirtyRange.start = Min(offset, verticesDirtyRange.start)
		verticesDirtyRange.stop = Max(offset - format.offset + count * vertexSize, verticesDirtyRange.stop)
		
		If (verticesUsage = USAGE_STATIC) UpdateBuffers()
	End Method
	
	Method SetPackedVertices:Void(stream:Int, vertices:Int[])
		isVerticesDirty |= DIRTY_DATA
	
		Local format:VertexFormat = formats[stream]
		Local numComponents:Int = Max(((format.size * format.numComponents) - .5) Shr 2, 1)
		
		CopyIntsToDatabuffer(vertices, verticesData, format.offset, 0, vertices.Length(), numComponents, vertexSize)
		
		verticesDirtyRange.start = Min(format.offset, verticesDirtyRange.start)
		verticesDirtyRange.stop = Max((vertices.Length() / format.numComponents) * vertexSize, verticesDirtyRange.stop)
		
		If (verticesUsage = USAGE_STATIC) UpdateBuffers()
	End Method
	
	Method SetPackedVertices:Void(stream:Int, vertices:Int[], _to:Int, from:Int, count:Int)
		isVerticesDirty |= DIRTY_DATA
	
		Local format:VertexFormat = formats[stream]
		Local offset:Int = _to*vertexSize + format.offset
		Local numComponents:Int = Max(((format.size * format.numComponents) - .5) Shr 2, 1)
		Local componentsToCopy:Int = count * numComponents
		Local componentsOffset:Int = from * numComponents
		
		CopyIntsToDatabuffer(vertices, verticesData, offset, componentsOffset, componentsToCopy, numComponents, vertexSize)
		
		verticesDirtyRange.start = Min(offset, verticesDirtyRange.start)
		verticesDirtyRange.stop = Max(offset - format.offset + count * vertexSize, verticesDirtyRange.stop)
		
		If (verticesUsage = USAGE_STATIC) UpdateBuffers()
	End Method
	
	Method SetVertices:Void(vertices:DataBuffer)
		isVerticesDirty |= DIRTY_DATA
		
		CopyDataBufferToDataBuffer(vertices, verticesData)
	
		verticesDirtyRange.start = 0
		verticesDirtyRange.stop = Max(vertices.Length, verticesDirtyRange.stop)
		
		If (verticesUsage = USAGE_STATIC) UpdateBuffers()
	End Method
	
	Method SetVertices:Void(vertices:DataBuffer, _to:Int, from:Int, count:Int)
		isVerticesDirty |= DIRTY_DATA
		
		_to *= vertexSize
		count *= vertexSize
		
		CopyDataBufferToDataBuffer(vertices, verticesData, _to, from * vertexSize, count)
	
		verticesDirtyRange.start = Min(_to, verticesDirtyRange.start)
		verticesDirtyRange.stop = Max(_to + count, verticesDirtyRange.stop)
		
		If (verticesUsage = USAGE_STATIC) UpdateBuffers()
	End Method
	
	Method SetIndices:Void(indices:Int[])
		isIndicesDirty |= DIRTY_DATA
		
		CopyUShortsToDatabuffer(indices, indiciesData, 0, 0, indices.Length())

		indicesDirtyRange.start = 0
		indicesDirtyRange.stop = Max(indices.Length() Shl 1, indicesDirtyRange.stop)

		If (indicesUsage = USAGE_STATIC) UpdateBuffers()
	End Method
	
	Method SetIndices:Void(indices:Int[], _to:Int, from:Int, count:Int)
		isIndicesDirty |= DIRTY_DATA
		_to Shl=1 
		
		CopyUShortsToDatabuffer(indices, indiciesData, _to, from, count)

		indicesDirtyRange.start = _to
		indicesDirtyRange.stop = Max(_to + (count Shl 1), indicesDirtyRange.stop)

		If (indicesUsage = USAGE_STATIC) UpdateBuffers()
	End Method
	
	Method SetIndices:Void(indices:DataBuffer)
		isIndicesDirty |= DIRTY_DATA
		
		CopyDataBufferByteToByte(indices, indiciesData)
	
		indicesDirtyRange.start = 0
		indicesDirtyRange.stop = Max(indices.Length, indicesDirtyRange.stop)
		
		If (indicesUsage = USAGE_STATIC) UpdateBuffers()
	End Method
	
	Method SetIndices:Void(indices:DataBuffer, _to:Int, from:Int, count:Int)
		isIndicesDirty |= DIRTY_DATA
		_to Shl=1
		count Shl=1
		
		CopyDataBufferByteToByte(indices, indiciesData, _to, from Shl 1, count)
		
		indicesDirtyRange.start = Min(_to, indicesDirtyRange.start)
		indicesDirtyRange.stop = Max(_to + count, indicesDirtyRange.stop)	
		
		If (indicesUsage = USAGE_STATIC) UpdateBuffers()
	End Method
	
	Method Stream:Float[]() Property
		If (Not hasStream) Return []
		Return stream
	End Method
	
	Method Stream:Void(stream:Float[]) Property
		If (verticesUsage <> USAGE_DYNAMIC) Then
			'note: TODO Error
			Return
		End If
	
		hasStream = True
		Self.stream = stream
		
		streamOffset = 0
		streamSize = -1
	End Method
	
	Method Stream:Void(stream:Object) Property
		hasStream = False
		Self.stream = []
		streamOffset = 0
		streamSize = -1
	End Method
	
	Method StreamOffset:Void(offset:Int) Property
		streamOffset = offset * alignedNumComponents
		isVerticesDirty |= DIRTY_DATA
	End Method
	
	Method StreamSize:Void(size:Int) Property
		streamSize = size * alignedNumComponents
		isVerticesDirty |= DIRTY_DATA
	End Method
	
	Method Usage:Void(usage:Int) Property
		Local dirty:Bool = False
	
		If usage <> Self.verticesUsage
			Self.verticesUsage = usage			
			isVerticesDirty |= DIRTY_USAGE
			
			dirty = True
		End If
		
		If usage <> Self.indicesUsage
			Self.indicesUsage = usage			
			isIndicesDirty |= DIRTY_USAGE
			
			dirty = True
		End If
		
		If (dirty) UpdateBuffers()
	End Method
	
	Method VerticesUsage:Void(usage:Int) Property
		If usage <> Self.verticesUsage
			Self.verticesUsage = usage
			isVerticesDirty |= DIRTY_USAGE
			
			UpdateBuffers()
		End If		
	End Method
	
	Method IndicesUsage:Void(usage:Int) Property
		If usage <> Self.indicesUsage
			Self.indicesUsage = usage
			isIndicesDirty |= DIRTY_USAGE
			
			UpdateBuffers()
		End If
	End Method
	
	Method VertexSize:Int() Property
		Return vertexSize
	End Method
	
	Method Stride:Int() Property
		Return numComponents
	End Method
	
	Method StreamStride:Int() Property
		Return alignedNumComponents
	End Method
	
	Private
	
	Const DIRTY_NONE:Int = 0
	Const DIRTY_DATA:Int = 1
	Const DIRTY_USAGE:Int = 2
	
	Global EnabledLocations:Bool[]
	Global EnabledFormats:VertexFormat[]
	Global LastActiveShader:ShaderProgram	
	
	Field vertexBuffer:Int = -1
	Field verticesData:DataBuffer
	
	Field indexBuffer:Int = -1
	Field indiciesData:DataBuffer
	
	Field verticesUsage:Int = USAGE_DYNAMIC
	Field indicesUsage:Int = USAGE_STATIC	
	
	Field isVerticesDirty:Int = DIRTY_NONE
	Field isIndicesDirty:Int = DIRTY_NONE
	
	Field stream:Float[]
	Field streamOffset:Int
	Field streamSize:Int
	Field hasStream:Bool
	
	Field isBound:Bool
	Field mixedFormats:Bool
	
	Field formats:VertexFormat[]
	Field aliases:String[]
	Field vertexSize:Int
	Field numComponents:Int
	Field alignedNumComponents:Int
	
	Field verticesDirtyRange:DataRange = New DataRange()
	Field indicesDirtyRange:DataRange = New DataRange()
	
	'for resource manager
	Field iCount:Int
	Field vCount:Int
	Field managed:Bool
	
	Method Init:Void(vertexCount:Int, indexCount:Int, aliases:String[], formats:VertexFormat[])
		If (Not managed) Then
			RestorableResources.AddResource(Self)
			managed = True
		End If
		
		Local size:Int[1]
		glGetIntegerv(GL_MAX_VERTEX_ATTRIBS, size)	
		EnabledLocations = New Bool[Max(size[0], EnabledLocations.Length())]
		EnabledFormats = New VertexFormat[Max(size[0], EnabledFormats.Length())]
		
		Self.formats = New VertexFormat[formats.Length]
		Self.aliases = New String[aliases.Length]
		
		Local padding:Int = 0
		
		vertexSize = 0
		numComponents = 0
		alignedNumComponents = 0
		
		For Local i:Int = 0 Until formats.Length()
			If (formats[i].type <> GL_FLOAT) mixedFormats = True
		
			Self.formats[i] = formats[i].Clone(vertexSize, numComponents)
			Self.aliases[i] = aliases[i]
			
			padding = Abs(4 - formats[i].size * formats[i].numComponents) Mod 4
			vertexSize += formats[i].size * formats[i].numComponents + padding
			
			numComponents += formats[i].numComponents			
			alignedNumComponents += Max(1, (formats[i].numComponents * formats[i].size) / 4)
		Next
		
		If (Not hasStream) Then
			If (Not verticesData) Then verticesData = New DataBuffer(vertexSize * vertexCount, True)
			verticesDirtyRange.start = verticesData.Length
			verticesDirtyRange.stop = 0
		Else
			If (Not stream) Then			
				stream = stream.Resize(vertexCount * alignedNumComponents)
				streamOffset = 0
				streamSize = -1
			End If
		End If
		
		vertexBuffer = CreateBuffer(GL_ARRAY_BUFFER)
		
		If (indexCount)
			If (Not indiciesData) Then indiciesData = New DataBuffer(indexCount*2, True)

	#If TARGET <> "winrt"
			indexBuffer = CreateBuffer(GL_ELEMENT_ARRAY_BUFFER)
	#End

			indicesDirtyRange.start = indiciesData.Length
			indicesDirtyRange.stop = 0
		End If
		
		iCount = indexCount
		vCount = vertexCount
	End Method

	Method Dispose:Void()
		LastActiveShader = Null
		ActiveBuffer = Null
		DeleteBuffers()
		isBound = False
	End Method
	
	Method DeleteBuffers:Void()
		If (indexBuffer <> -1) glDeleteBuffer(indexBuffer)
		If (vertexBuffer <> -1) glDeleteBuffer(vertexBuffer)
		vertexBuffer = -1
		indexBuffer = -1
	End Method
	
	Method Store:Void()
	End Method
	
	Method Restore:Void()	
		Invalidate()
		DeleteBuffers()
		Init(vCount, iCount, aliases, formats)
	End Method
	
	Method CreateBuffer:Int(target:Int)
		Local buffer:Int = glCreateBuffer()
		
		glBindBuffer(target, buffer)
		
		Select target
			Case GL_ARRAY_BUFFER				
				If (Not hasStream) Then
					glBufferData(target, verticesData.Length, verticesData, verticesUsage)
				Else
					glBufferData(target, stream.Length(), stream, verticesUsage)
				End If
				
			Case GL_ELEMENT_ARRAY_BUFFER
				glBufferData(target, indiciesData.Length, indiciesData, indicesUsage)
				
		End Select		
		
		If (ActiveBuffer And ActiveBuffer.isBound) Then
			Select target
				Case GL_ARRAY_BUFFER
					If (ActiveBuffer.vertexBuffer <> -1) Then
						glBindBuffer(target, ActiveBuffer.vertexBuffer)
					Else
						glBindBuffer(target, 0)
					End If
				
				Case GL_ELEMENT_ARRAY_BUFFER
					If (ActiveBuffer.indexBuffer <> -1) Then
						glBindBuffer(target, ActiveBuffer.indexBuffer)
					Else
						glBindBuffer(target, 0)
					End If
				
			End Select			
		Else
			glBindBuffer(target, 0)
		End If
		
			
		Return buffer
	End Method
	
	Method UpdateBuffers:Void()
		If Not isBound Return
		
		If (Not hasStream And isVerticesDirty)
			If (isVerticesDirty & DIRTY_DATA And Not(isVerticesDirty & DIRTY_USAGE))
				glBufferSubData(GL_ARRAY_BUFFER, verticesDirtyRange.start, verticesDirtyRange.stop - verticesDirtyRange.start, verticesDirtyRange.start, verticesData)
					
			ElseIf (isVerticesDirty & DIRTY_USAGE)
				glBufferData(GL_ARRAY_BUFFER, verticesData.Length, verticesData, verticesUsage)
			End If
				
			verticesDirtyRange.stop = 0
			verticesDirtyRange.start = verticesData.Length
				
			isVerticesDirty = DIRTY_NONE
		End If
			
	#If TARGET <> "winrt"
		If indiciesData
			If (isIndicesDirty)
				If (isIndicesDirty & DIRTY_DATA And Not(isIndicesDirty & DIRTY_USAGE))
					glBufferSubData(GL_ELEMENT_ARRAY_BUFFER, indicesDirtyRange.start, indicesDirtyRange.stop - indicesDirtyRange.start, indicesDirtyRange.start, indiciesData)
					
				ElseIf (isIndicesDirty & DIRTY_USAGE)
					glBufferData(GL_ELEMENT_ARRAY_BUFFER, indiciesData.Length, indiciesData, indicesUsage)
				End If
					
				indicesDirtyRange.stop = 0
				indicesDirtyRange.start = indiciesData.Length
					
				isIndicesDirty = DIRTY_NONE
			End If
		End If
	#End
	End Method
	
	Method Invalidate:Void()
		If (ActiveBuffer = Self) Then
			ActiveBuffer.isBound = False
			ActiveBuffer = Null
		Else
			isBound = False
		End If
	
		isVerticesDirty |= DIRTY_USAGE
		
		If (indiciesData) Then
			isIndicesDirty |= DIRTY_USAGE
		End If
	End Method

	Method DebugVerticesData:Void()
		Local result:StringStack = New StringStack()
		Local countStreams:Int = formats.Length(), format:VertexFormat
		
		Local offset:Int = 0, l:Int = verticesData.Length
		
		While(offset < l)
			For Local stream:Int = 0 Until countStreams
				format = formats[stream]
			
				Select format.type
					Case GL_FLOAT
						For Local i:Int = 0 Until format.numComponents
							result.Push(verticesData.PeekFloat(offset+format.offset+i*format.size))
						Next						
				
					Case GL_UNSIGNED_BYTE, GL_BYTE
						For Local i:Int = 0 Until format.numComponents
							result.Push(verticesData.PeekByte(offset+format.offset+i*format.size))
						Next
				
					Case GL_SHORT, GL_UNSIGNED_SHORT
						For Local i:Int = 0 Until format.numComponents
							result.Push(verticesData.PeekShort(offset+format.offset+i*format.size))
						Next
							
				End Select				
			Next
			
			offset += vertexSize
		Wend
		
		Print result.Join(",")
	End Method

End Class

Function DrawArrays:Void(mode:Int, first:Int, count:Int)
	If (Not ActiveBuffer) Return
	
	If (ActiveBuffer.hasStream) Then
		If (ActiveBuffer.isVerticesDirty) Then		
			If (ActiveBuffer.streamOffset = 0 And ActiveBuffer.streamSize < 0) Then
				glBufferSubData(GL_ARRAY_BUFFER, 0, ActiveBuffer.stream.Length(), ActiveBuffer.stream)
			Else
				glBufferSubData(GL_ARRAY_BUFFER, ActiveBuffer.streamOffset Shl 2, ActiveBuffer.streamSize, ActiveBuffer.streamOffset, ActiveBuffer.stream)
			End If
			
			ActiveBuffer.isVerticesDirty = VertexBuffer.DIRTY_NONE
		End If
		 
	ElseIf (ActiveBuffer.isVerticesDirty) Then
		If (ActiveBuffer.isVerticesDirty & VertexBuffer.DIRTY_USAGE) Then
			glBufferData(GL_ARRAY_BUFFER, ActiveBuffer.verticesData.Length, ActiveBuffer.verticesData, ActiveBuffer.verticesUsage)
			
		ElseIf (ActiveBuffer.verticesDirtyRange.stop - ActiveBuffer.verticesDirtyRange.start < ActiveBuffer.verticesData.Length Shr 1)
			glBufferSubData(GL_ARRAY_BUFFER, ActiveBuffer.verticesDirtyRange.start, ActiveBuffer.verticesDirtyRange.stop - ActiveBuffer.verticesDirtyRange.start, ActiveBuffer.verticesDirtyRange.start, ActiveBuffer.verticesData)
		Else
			glBufferSubData(GL_ARRAY_BUFFER, 0, ActiveBuffer.verticesData.Length, ActiveBuffer.verticesData)
		End If
		
		ActiveBuffer.isVerticesDirty = VertexBuffer.DIRTY_NONE
		ActiveBuffer.verticesDirtyRange.stop = 0
		ActiveBuffer.verticesDirtyRange.start = ActiveBuffer.verticesData.Length
	End If

	If (ActiveBuffer.indiciesData)
		If (ActiveBuffer.isIndicesDirty) Then		
			If (ActiveBuffer.isIndicesDirty & VertexBuffer.DIRTY_USAGE) Then
				glBufferData(GL_ELEMENT_ARRAY_BUFFER, ActiveBuffer.indiciesData.Length, ActiveBuffer.indiciesData, ActiveBuffer.indicesUsage)
			
			ElseIf (ActiveBuffer.indicesDirtyRange.stop - ActiveBuffer.indicesDirtyRange.start < ActiveBuffer.indiciesData.Length Shr 1)
				glBufferSubData(GL_ELEMENT_ARRAY_BUFFER, ActiveBuffer.indicesDirtyRange.start, ActiveBuffer.indicesDirtyRange.stop - ActiveBuffer.indicesDirtyRange.start, ActiveBuffer.indicesDirtyRange.start, ActiveBuffer.indiciesData)
			
			Else
				glBufferSubData(GL_ELEMENT_ARRAY_BUFFER, 0, ActiveBuffer.indiciesData.Length, ActiveBuffer.indiciesData)
			End If
		
			ActiveBuffer.isIndicesDirty = VertexBuffer.DIRTY_NONE
			ActiveBuffer.indicesDirtyRange.stop = 0
			ActiveBuffer.indicesDirtyRange.start = ActiveBuffer.indiciesData.Length
		End If
	
#If TARGET <> "winrt"
		glDrawElements(mode, count, GL_UNSIGNED_SHORT, first Shl 1)

#Else
		glDrawElements(mode, count, GL_UNSIGNED_SHORT, ActiveBuffer.indiciesData, first Shl 1)
#End
	Else
		glDrawArrays(mode, first, count)
	End If
End Function

Class VertexFormat
	
	Method NumComponents:Int() Property
		Return numComponents
	End Method
	
	Method Size:Int() Property
		Return size
	End Method
	
Private

	Method New(numComponents:Int, normalized:Bool, type:Int, offset:Int = 0, componentsOffset:Int = 0)
		Self.numComponents = numComponents
		Self.normalized = normalized
		Self.type = type
		Self.offset = offset
		Self.componentsOffset = componentsOffset
		
		Select type
			Case GL_FLOAT
				size = 4
			Case GL_SHORT, GL_UNSIGNED_SHORT
				size = 2
			Case GL_BYTE, GL_UNSIGNED_BYTE
				size = 1
		End Select
		
		hash = 1
		hash = 31 * hash + numComponents
		hash = 31 * hash + Int(normalized)
		hash = 31 * hash + type
		hash = 31 * hash + offset
	End Method

	Method Clone:VertexFormat(offset:Int, componentsOffset:Int)
		Return New VertexFormat(numComponents, normalized, type, offset, componentsOffset)
	End Method
	
	Method Equals:Bool(format:VertexFormat)
		Return hash = format.hash
	End Method

	Field numComponents:Int
	
	Field componentsOffset:Int
	
	Field normalized:Bool
	
	Field type:Int
	
	Field offset:Int
	
	Field size:Int
	
	Field hash:Int

End Class

Private

Class DataRange
	
	Field start:Int
	
	Field stop:Int

End Class

Global ActiveBuffer:VertexBuffer
