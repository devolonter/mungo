Strict

Import exports
Import shaderprogram
Import vertexbuffer

Interface BatchStreamListener<T>
	
	Method OnBatchSwitch:Void(oldBatch:T, newBatch:T)

End Interface

Interface IBatchStream

	Method Start:Void(batch:Batch)	
	Method Finish:Void()
	Method Flush:Void()

End Interface

Class BatchStream<T> Implements IBatchStream

	Method New(listener:BatchStreamListener<T> = Null)
		Self.listener = listener
	End Method

	Method Start:Void(batch:T)
		If (currentBatch = batch And currentBatch <> Null) Return
	
		If (currentBatch) Then
			Local wasDrawing:Bool = currentBatch.drawing
		
			If (wasDrawing) currentBatch.Finish(False, (currentBatch.shader <> batch.shader Or currentBatch.GetDefaultShader() <> batch.GetDefaultShader()))
			currentBatch.stream = Null
			
			batch.blendingEnabled = currentBatch.blendingEnabled
			batch.blendSrcFunc = currentBatch.blendSrcFunc
			batch.blendDstFunc = currentBatch.blendDstFunc
			
			batch.scissorX = currentBatch.scissorX
			batch.scissorY = currentBatch.scissorY
			batch.scissorWidth = currentBatch.scissorWidth
			batch.scissorHeight = currentBatch.scissorHeight
			batch.scissorEnabled = currentBatch.scissorEnabled
			
			batch.dirtyScissor = currentBatch.dirtyScissor
			batch.dirtyBlending = currentBatch.dirtyBlending
			
			If (listener) listener.OnBatchSwitch(currentBatch, batch)			
			If (wasDrawing) batch.Start()
		Else
			batch.Start()
		End If
		
		currentBatch = batch
		currentBatch.stream = Self
	End Method
	
	Method Finish:Void(unbindBuffer:Bool = False, unbindShader:Bool = False)
		If (Not currentBatch) Return
		
		currentBatch.stream = Null
		currentBatch.Finish(unbindBuffer, unbindShader)
		
		currentBatch = Null
	End Method
	
	Method Flush:Void()
		If (Not currentBatch) Return
		currentBatch.Flush()
	End Method
	
	Method CurrentBatch:T() Property
		Return currentBatch
	End Method
	
Private

	Field currentBatch:T
	Field listener:BatchStreamListener<T>

End Class

Public

Class Batch Abstract

	Method GetVertexBuffer:VertexBuffer() Abstract
	Method GetDefaultShader:ShaderProgram() Abstract
	
	Method OnStart:Void() Abstract
	Method OnFinish:Void() Abstract
	Method OnFlush:Void() Abstract
	
	Method Discard:Void()
		Dispose()
	End Method

	Method Start:Void() Final
		If (drawing) Return		
		renderCalls = 0
		
		If (shader) Then
			shader.Bind()
			GetVertexBuffer().Bind(shader)
		Else
			GetDefaultShader().Bind()
			GetVertexBuffer().Bind(GetDefaultShader())
		End If
				
		OnStart()
		drawing = True
	End Method
	
	Method Finish:Void(unbindBuffer:Bool = False, unbindShader:Bool = False) Final
		If (Not drawing) Return
		If (drawCalls > 0) Flush()
		
		If (Not stream) Then
			OnFinish()
		
			'If (blendingEnabled) DisableMode(MODE_BLEND)
			'If (scissorEnabled) DisableMode(MODE_SCISSOR_TEST)
			
			'dirtyBlending = DIRTY_STATE | DIRTY_VALUE
			'dirtyScissor = DIRTY_STATE | DIRTY_VALUE
			
			If (shader) Then
					If (unbindBuffer) GetVertexBuffer().Unbind(shader)
					If (unbindShader) shader.Unbind()
				Else
					If (unbindBuffer) GetVertexBuffer().Unbind(GetDefaultShader())
					If (unbindShader) GetDefaultShader().Unbind()
				End If
		End If
		
		drawing = False
	End Method
	
	Method Flush:Void() Final
		If (drawCalls = 0) Then 
			Return
		End If
		
		renderCalls += 1
		
		If (dirtyBlending) Then
			If (blendingEnabled) Then
				If (dirtyBlending & DIRTY_STATE) EnableMode(MODE_BLEND)
				If (dirtyBlending & DIRTY_VALUE) exports.SetBlendFunc(blendSrcFunc, blendDstFunc)
				
				dirtyBlending = DIRTY_NONE
			ElseIf (dirtyBlending & DIRTY_STATE)
				DisableMode(MODE_BLEND)
				dirtyBlending = DIRTY_VALUE
			End If
		End If
		
		If (dirtyScissor) Then
			If (scissorEnabled) Then
				If (dirtyScissor & DIRTY_STATE) EnableMode(MODE_SCISSOR_TEST)
				If (dirtyScissor & DIRTY_VALUE) SetScissorRect(scissorX, scissorY, scissorWidth, scissorHeight)
				
				dirtyScissor = DIRTY_NONE
			ElseIf (dirtyScissor & DIRTY_STATE)
				DisableMode(MODE_SCISSOR_TEST)
				dirtyScissor = DIRTY_VALUE
			End If
		End If
		
		OnFlush()
		drawCalls = 0
	End Method
	
	Method Clear:Void() Final
		If (dirtyScissor) Then
			If (scissorEnabled) Then
				If (dirtyScissor & DIRTY_STATE) EnableMode(MODE_SCISSOR_TEST)
				If (dirtyScissor & DIRTY_VALUE) SetScissorRect(scissorX, scissorY, scissorWidth, scissorHeight)
				
				dirtyScissor = DIRTY_NONE
			ElseIf (dirtyScissor & DIRTY_STATE)
				DisableMode(MODE_SCISSOR_TEST)
				dirtyScissor = DIRTY_VALUE
			End If
		End If
		
		drawCalls = 0
	End Method
	
	Method Draw:Void() Final
		drawCalls += 1
	End Method
	
	Method DisableBlending:Void() Final
		If (Not blendingEnabled) Return
		If (drawing) Flush()
		
		blendingEnabled = False
		dirtyBlending |= DIRTY_STATE
	End Method
	
	Method EnableBlending:Void() Final
		If (blendingEnabled) Return
		If (drawing) Flush()
		
		blendingEnabled = True
		dirtyBlending |= DIRTY_STATE
	End Method
	
	Method InvalidateBlending:Void(onlyValue:Bool = True) Final
		dirtyBlending |= DIRTY_VALUE
		If (Not onlyValue) dirtyBlending |= DIRTY_STATE
	End Method

	Method SetBlendFunc:Void(srcFactor:Int, dstFactor:Int) Final
		If (blendSrcFunc = srcFactor And blendDstFunc = dstFactor) Return
		If (drawing) Flush()
		
		blendSrcFunc = srcFactor
		blendDstFunc = dstFactor
		
		dirtyBlending |= DIRTY_VALUE
	End Method
	
	Method DisableScissor:Void() Final
		If (Not scissorEnabled) Return
		If (drawing) Flush()
		
		scissorEnabled = False
		dirtyScissor |= DIRTY_STATE
	End Method
	
	Method EnableScissor:Void() Final
		If (scissorEnabled) Return
		If (drawing) Flush()
		
		scissorEnabled = True
		dirtyScissor |= DIRTY_STATE
	End Method
	
	Method SetScissor:Void(x:Int, y:Int, width:Int, height:Int) Final
		If (scissorX = x And scissorY = y And scissorWidth = width And scissorHeight = height) Return
		If (drawing) Flush()
		
		scissorX = x
		scissorY = y
		scissorWidth = width
		scissorHeight = height
		
		dirtyScissor |= DIRTY_VALUE
	End Method
	
	Method SetShader:Void(shader:ShaderProgram) Final
		If (Self.shader = shader) Return
		
		If (drawing) Then
			Flush()
			
			If (Self.shader) Then
				Self.shader.Unbind()
			Else
				GetDefaultShader().Unbind()
			End If
		End If
		
		Self.shader = shader

		If (shader <> Null) Then
			shader.Bind()
			GetVertexBuffer().Bind(shader)
		Else
			GetDefaultShader().Bind()
			GetVertexBuffer().Bind(GetDefaultShader())
		End If		
	End Method
	
	Method IsBlendingEnabled:Bool() Final
		Return blendingEnabled
	End Method
	
	Method IsScissorEnabled:Bool() Final
		Return scissorEnabled
	End Method
	
	Method IsDrawing:Bool() Final
		Return drawing
	End Method
	
	Method Shader:ShaderProgram() Property Final
		If (shader) Then
			Return shader
		Else
			Return GetDefaultShader()
		End If
	End Method
	
Private

	Const DIRTY_NONE:Int = 0
	Const DIRTY_STATE:Int = 1
	Const DIRTY_VALUE:Int = 2
	
	Field blendingEnabled:Bool = True
	Field blendSrcFunc:=BLEND_FACTOR_SRC_ALPHA
	Field blendDstFunc:=BLEND_FACTOR_ONE_MINUS_SRC_ALPHA
	
	Field scissorEnabled:Bool = False
	Field scissorX:Int
	Field scissorY:Int
	Field scissorWidth:Int
	Field scissorHeight:Int
	
	Field dirtyBlending:Int = DIRTY_STATE | DIRTY_VALUE
	Field dirtyScissor:Int = DIRTY_STATE | DIRTY_VALUE
	
	Field shader:ShaderProgram
	
	Field renderCalls:Int
	Field drawCalls:Int
	Field drawing:Bool
	
	Field stream:IBatchStream
	
	Method Dispose:Void()		
	End Method

End Class
