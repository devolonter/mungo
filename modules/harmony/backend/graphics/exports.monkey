Strict

Private

Import gl

Public

Alias EnableMode = glEnable
Alias DisableMode = glDisable
Alias IsModeEnabled = glIsEnabled
Alias DepthMask = glDepthMask
Alias ColorMask = glColorMask
Alias StencilMask = glStencilMask

Alias ClearScreen = glClear
Alias SetClearColor = glClearColor

Alias SetViewport = glViewport
Alias SetScissorRect = glScissor

Alias CullFace = glCullFace
Alias DepthFunc = glDepthFunc
Alias StencilFunc = glStencilFunc
Alias StencilOp = glStencilOp

Function SetBlendFunc:Void(srcFactor:Int, dstFactor:Int)
	glBlendEquation(BLEND_FUNC_ADD)
	glBlendFunc(srcFactor, dstFactor)
End Function

Function SetBlendFunc:Void(mode:Int, srcFactor:Int, dstFactor:Int)
	glBlendEquation(mode)
	glBlendFunc(srcFactor, dstFactor)
End Function

Const MODE_STENCIL_TEST:Int = GL_STENCIL_TEST
Const MODE_SCISSOR_TEST:Int = GL_SCISSOR_TEST
Const MODE_CULL_FACE:Int = GL_CULL_FACE
Const MODE_BLEND:Int = GL_BLEND
Const MODE_DEPTH_TEST:Int = GL_DEPTH_TEST
Const MODE_DEPTH_CLAMP:Int = GL_DEPTH_CLAMP
Const MODE_POLYGON_OFFSET_FILL:Int = GL_POLYGON_OFFSET_FILL

Const CLEAR_MASK_COLOR:Int = GL_COLOR_BUFFER_BIT
Const CLEAR_MASK_DEPTH:Int = GL_DEPTH_BUFFER_BIT
Const CLEAR_MASK_STENCIL:Int = GL_STENCIL_BUFFER_BIT
Const CLEAR_MASK_ALL:Int = CLEAR_MASK_COLOR | CLEAR_MASK_DEPTH | CLEAR_MASK_STENCIL

Const CULL_FACE_FRONT:Int = GL_FRONT
Const CULL_FACE_BACK:Int = GL_BACK
Const CULL_FACE_FRONT_AND_BACK:Int = GL_FRONT_AND_BACK

Const BLEND_FUNC_ADD:Int = GL_FUNC_ADD
Const BLEND_FUNC_SUBTRACT:Int = GL_FUNC_SUBTRACT
Const BLEND_FUNC_REVERSE_SUBTRACT:Int = GL_FUNC_REVERSE_SUBTRACT

Const BLEND_FACTOR_ZERO:Int = GL_ZERO
Const BLEND_FACTOR_ONE:Int = GL_ONE
Const BLEND_FACTOR_SRC_COLOR:Int = GL_SRC_COLOR
Const BLEND_FACTOR_ONE_MINUS_SRC_COLOR:Int = GL_ONE_MINUS_SRC_COLOR
Const BLEND_FACTOR_SRC_ALPHA:Int = GL_SRC_ALPHA
Const BLEND_FACTOR_ONE_MINUS_SRC_ALPHA:Int = GL_ONE_MINUS_SRC_ALPHA
Const BLEND_FACTOR_DST_COLOR:Int = GL_DST_COLOR
Const BLEND_FACTOR_ONE_MINUS_DST_COLOR:Int = GL_ONE_MINUS_DST_COLOR
Const BLEND_FACTOR_DST_ALPHA:Int = GL_DST_ALPHA
Const BLEND_FACTOR_ONE_MINUS_DST_ALPHA:Int = GL_ONE_MINUS_DST_ALPHA
Const BLEND_FACTOR_SRC_ALPHA_SATURATE:Int = GL_SRC_ALPHA_SATURATE
