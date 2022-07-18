Strict

Friend harmony.frontend.mojo.filters

Import "shaders/mojo_shader.vert"
Import "shaders/mojo_shader.frag"

Import mojo.graphics
Import harmony.backend.graphics.shaderprogram
Import harmony.backend.graphics.texture
Import filters

Private

Import harmony.frontend.mojo.renderers
Import mojo.app

Public

Class Shader

	Method New()
		If (Not MojoVertexShader) Then
			MojoVertexShader = LoadString("mojo_shader.vert")
		End If
		
		If (Not MojoFragmentShader) Then
			MojoFragmentShader = LoadString("mojo_shader.frag")
		End If
		
		uniforms = New StringMap<ShaderUniformValue>()
		filters = New Stack<Filter>
		
		SetSampler2D("mojo_device_surface", Null)
	End Method
	
	Method SetFloat:Void(name:String, value:Float) Final
		Local uniform := GetFloat(name, SHADER_UNIFORM_FLOAT, 1)
		uniform.fv[0] = value
		SetValue(uniform)
	End Method
	
	Method SetInt:Void(name:String, value:Int) Final
		Local uniform := GetInt(name, SHADER_UNIFORM_INT, 1)
		uniform.iv[0] = value
		SetValue(uniform)
	End Method
	
	Method SetBool:Void(name:String, value:Bool) Final
		SetInt(name, value)
	End Method
	
	Method SetSampler2D:Void(name:String, value:Image) Final
		GetSetSampler2D(name, value)
	End Method
	
	Method SetFloatVec2:Void(name:String, v1:Float, v2:Float) Final
		Local uniform := GetFloat(name, SHADER_UNIFORM_FLOAT_VEC2, 2)
		uniform.fv[0] = v1
		uniform.fv[1] = v2
		SetValue(uniform)
	End Method
	
	Method SetFloatVec3:Void(name:String, v1:Float, v2:Float, v3:Float) Final
		Local uniform := GetFloat(name, SHADER_UNIFORM_FLOAT_VEC3, 3)
		uniform.fv[0] = v1
		uniform.fv[1] = v2
		uniform.fv[2] = v3
		SetValue(uniform)
	End Method
	
	Method SetFloatVec4:Void(name:String, v1:Float, v2:Float, v3:Float, v4:Float) Final
		Local uniform := GetFloat(name, SHADER_UNIFORM_FLOAT_VEC4, 4)
		Local fv := uniform.fv
		fv[0] = v1
		fv[1] = v2
		fv[2] = v3
		fv[3] = v4
		SetValue(uniform)
	End Method
	
	Method SetIntVec2:Void(name:String, v1:Int, v2:Int) Final
		Local uniform := GetInt(name, SHADER_UNIFORM_INT_VEC2, 2)
		uniform.iv[0] = v1
		uniform.iv[1] = v2
		SetValue(uniform)
	End Method
	
	Method SetIntVec3:Void(name:String, v1:Int, v2:Int, v3:Int) Final
		Local uniform := GetInt(name, SHADER_UNIFORM_INT_VEC3, 3)
		uniform.iv[0] = v1
		uniform.iv[1] = v2
		uniform.iv[2] = v3
		SetValue(uniform)
	End Method
	
	Method SetIntVec4:Void(name:String, v1:Int, v2:Int, v3:Int, v4:Int) Final
		Local uniform := GetInt(name, SHADER_UNIFORM_INT_VEC4, 4)
		Local iv := uniform.iv
		iv[0] = v1
		iv[1] = v2
		iv[2] = v3
		iv[3] = v4
		SetValue(uniform)
	End Method
	
	Method SetBoolVec2:Void(name:String, v1:Bool, v2:Bool) Final
		SetIntVec2(name, v1, v2)
	End Method
	
	Method SetBoolVec3:Void(name:String, v1:Bool, v2:Bool, v3:Bool) Final
		SetIntVec3(name, v1, v2, v3)
	End Method
	
	Method SetBoolVec4:Void(name:String, v1:Bool, v2:Bool, v3:Bool, v4:Bool) Final
		SetIntVec4(name, v1, v2, v3, v4)
	End Method
	
	Method SetFloatMat2:Void(name:String, value:Float[]) Final
		Local uniform := GetFloat(name, SHADER_UNIFORM_FLOAT_MAT2, 4)
		Local fv := uniform.fv
		fv[0] = value[0]
		fv[1] = value[1]
		fv[2] = value[2]
		fv[3] = value[3]
		SetValue(uniform)
	End Method
	
	Method SetFloatMat3:Void(name:String, value:Float[]) Final
		Local uniform := GetFloat(name, SHADER_UNIFORM_FLOAT_MAT3, 9)
		Local fv := uniform.fv
		For Local i:Int = 0 Until 9
			fv[i] = value[i]
		Next
		SetValue(uniform)
	End Method
	
	Method SetFloatMat4:Void(name:String, value:Float[]) Final
		Local uniform := GetFloat(name, SHADER_UNIFORM_FLOAT_MAT4, 16)
		Local fv := uniform.fv
		For Local i:Int = 0 Until 16
			fv[i] = value[i]
		Next
		SetValue(uniform)
	End Method
	
	Method GetFloat:Float(name:String) Final
		Return GetFloat(name, SHADER_UNIFORM_FLOAT, 1).fv[0]
	End Method
	
	Method GetInt:Int(name:String) Final
		Return GetInt(name, SHADER_UNIFORM_INT, 1).iv[0]
	End Method
	
	Method GetBool:Bool(name:String) Final
		Return Bool(GetInt(name))
	End Method
	
	Method GetSampler2D:Int(name:String) Final
		Return GetSetSampler2D(name, Null)
	End Method
	
	Method GetFloatVec2:Void(name:String, result:Float[]) Final
		Local fv := GetFloat(name, SHADER_UNIFORM_FLOAT_VEC2, 2).fv
		For Local i:Int = 0 Until 2
			result[i] = fv[i]
		Next
	End Method
	
	Method GetFloatVec3:Void(name:String, result:Float[]) Final
		Local fv := GetFloat(name, SHADER_UNIFORM_FLOAT_VEC3, 3).fv
		For Local i:Int = 0 Until 3
			result[i] = fv[i]
		Next
	End Method
	
	Method GetFloatVec4:Void(name:String, result:Float[]) Final
		Local fv := GetFloat(name, SHADER_UNIFORM_FLOAT_VEC4, 4).fv
		For Local i:Int = 0 Until 4
			result[i] = fv[i]
		Next
	End Method
	
	Method GetIntVec2:Void(name:String, result:Int[]) Final
		Local iv := GetFloat(name, SHADER_UNIFORM_INT_VEC2, 2).iv
		For Local i:Int = 0 Until 2
			result[i] = iv[i]
		Next
	End Method
	
	Method GetIntVec3:Void(name:String, result:Int[]) Final
		Local iv := GetFloat(name, SHADER_UNIFORM_INT_VEC3, 3).iv
		For Local i:Int = 0 Until 3
			result[i] = iv[i]
		Next
	End Method
	
	Method GetIntVec4:Void(name:String, result:Int[]) Final
		Local iv := GetFloat(name, SHADER_UNIFORM_INT_VEC4, 4).iv
		For Local i:Int = 0 Until 4
			result[i] = iv[i]
		Next
	End Method
	
	Method GetBoolVec2:Void(name:String, result:Bool[]) Final
		Local iv := GetFloat(name, SHADER_UNIFORM_BOOL_VEC2, 2).iv
		For Local i:Int = 0 Until 2
			result[i] = Bool(iv[i])
		Next
	End Method
	
	Method GetBoolVec3:Void(name:String, result:Bool[]) Final
		Local iv := GetFloat(name, SHADER_UNIFORM_BOOL_VEC3, 3).iv
		For Local i:Int = 0 Until 3
			result[i] = Bool(iv[i])
		Next
	End Method
	
	Method GetBoolVec4:Void(name:String, result:Bool[]) Final
		Local iv := GetFloat(name, SHADER_UNIFORM_BOOL_VEC4, 4).iv
		For Local i:Int = 0 Until 4
			result[i] = Bool(iv[i])
		Next
	End Method
	
	Method GetFloatMat2:Void(name:String, result:Float[]) Final
		Local fv := GetFloat(name, SHADER_UNIFORM_FLOAT_MAT2, 4).fv
		For Local i:Int = 0 Until 4
			result[i] = fv[i]
		Next
	End Method
	
	Method GetFloatMat3:Void(name:String, result:Float[]) Final
		Local fv := GetFloat(name, SHADER_UNIFORM_FLOAT_MAT3, 9).fv
		For Local i:Int = 0 Until 9
			result[i] = fv[i]
		Next
	End Method
	
	Method GetFloatMat4:Void(name:String, result:Float[]) Final
		Local fv := GetFloat(name, SHADER_UNIFORM_FLOAT_MAT4, 16).fv
		For Local i:Int = 0 Until 16
			result[i] = fv[i]
		Next
	End Method
	
	Method Define:Void(var:String) Final
		userDefs += "#define " + var + "~n"
	End Method
	
	Method Define:Void(var:String, value:Int) Final
		userDefs += "#define " + var + " " + value + "~n"
	End Method
	
	Method PushFilter:Void(filter:Filter) Final
		filters.Push(filter)
		ApplyFilter(filter)
	End Method
	
	Method PopFilter:Void() Final
		If (Not filters.Length) Return
		RemoveFilter(filters.Pop())
	End Method
	
	Method GetProgram:ShaderProgram()
		If (renderer.Capabilities() & Renderer.DRAW_SURFACE Or renderer.Capabilities() & Renderer.DRAW_SURFACE_POLY) Then
			Return programs[SURFACE_PROGRAM]
		Else
			Return programs[GRAPHICS_PROGRAM]
		End
	End
	
	Method Apply:ShaderProgram(renderer:Renderer) Final
		If (Self.renderer = renderer) Return Null
	
		If (Not renderer) Then
			Self.renderer.SetShader(Self.renderer.GetDefaultShader())
			Self.renderer = Null
			Return Null
		End If
	
		Self.renderer = renderer
		Local primaryProgram:Int, secondaryProgram:Int
	
		If (renderer.Capabilities() & Renderer.DRAW_SURFACE Or renderer.Capabilities() & Renderer.DRAW_SURFACE_POLY) Then
			primaryProgram = SURFACE_PROGRAM
			secondaryProgram = GRAPHICS_PROGRAM			
		Else		
			primaryProgram = GRAPHICS_PROGRAM
			secondaryProgram = SURFACE_PROGRAM			
		End If
		
		If (Not programs[primaryProgram]) Then
			renderer.Flush()
			renderer.SetShader(Build(primaryProgram))
				
		ElseIf (dirty & DIRTY_SHADER_SOURCE)
			renderer.Flush()
			renderer.SetShader(Build(primaryProgram, programs[primaryProgram]))

			If (programs[secondaryProgram]) Then
				Build(secondaryProgram, programs[secondaryProgram])
				programs[secondaryProgram].CopyUniformValuesFrom(programs[primaryProgram])
			End If
			
			dirty = DIRTY_NONE
		Else
			renderer.SetShader(programs[primaryProgram])
			
			If (dirty & DIRTY_SHADER_UNIFORMS) Then
				programs[primaryProgram].Bind()
				Local hasDirty:Bool
			
				For Local uniform := EachIn uniforms.Values()
					If (uniform.dirty) uniform.Apply(programs[primaryProgram])
					hasDirty = (hasDirty Or uniform.dirty <> 0)
				Next
				
				If (Not hasDirty) Then
					dirty = DIRTY_NONE
				End If
			End If
		End If
		
		Return programs[primaryProgram]
	End Method
	
	Method IsDirty:Bool() Final
		Return dirty <> DIRTY_NONE	
	End Method
	
	Method VertexShader:String() Property
		Return ""
	End Method
	
	Method FragmentShader:String() Property
		Return ""
	End Method

Private

	Const DIRTY_NONE:Int = 0
	Const DIRTY_SHADER_UNIFORMS:Int = 1
	Const DIRTY_SHADER_SOURCE:Int = 2

	Const GRAPHICS_PROGRAM:Int = 0
	Const SURFACE_PROGRAM:Int = 1
	
	Const VERTEX_SHADER:Int = 1
	Const FRAGMENT_SHADER:Int = 2

	Global MojoVertexShader:String
	Global MojoFragmentShader:String
	
	Field programs:ShaderProgram[2]
	Field renderer:Renderer
	
	Field defs:String
	Field userDefs:String
	
	Field dirty:Int
	
	Field filters:Stack<Filter>
	
	Field uniforms:StringMap<ShaderUniformValue>
	Field textureCount:Int
	
	Method BuildSource:String(source:String, base:String)
		Local defs:String
		
		If (source) Then
			defs += "#define CUSTOM_SHADER~n"
		End If
		
		source = Self.defs + userDefs + defs + base.Replace("${SHADER}", source)
		userDefs = ""
		
		Return source		
	End Method
	
	Method AddFiltersToSource:String(source:String, type:Int)
		If (filters.Length) Then
			Local filtersEmbeded := New StringSet()
			Local filtersSource := New StringStack()
			Local filterFunctions := New StringStack()
			Local l:Int = filters.Length
			Local data:Filter[] = filters.Data
			
			For Local i:Int = 0 Until l
				If (data[i]) Then				
					Local filterSource:String
				
					Select type
						Case VERTEX_SHADER
							filterSource = data[i].VertexShader
						
						Case FRAGMENT_SHADER
							filterSource = data[i].FragmentShader
					End Select
				
					If (filterSource) Then
						If (Not filtersEmbeded.Contains(data[i].Name)) Then
							filtersSource.Push(filterSource)
							filtersEmbeded.Insert(data[i].Name)
						End If
							
						filterFunctions.Push(data[i].Name)
					End If
				End If
			Next
			
			If (filterFunctions.Length) Then
				source = source.Replace("${FILTERS}", filtersSource.Join("~n") + "~n")
				source = source.Replace("${FILTERS()}", filterFunctions.Join("();~n") + "();~n")
			Else
				source = source.Replace("${FILTERS}", "").Replace("${FILTERS()}", "")
			End If
		Else
			source = source.Replace("${FILTERS}", "").Replace("${FILTERS()}", "")
		End If

		Return source
	End Method
	
	Method Build:ShaderProgram()		
		Local shader:ShaderProgram = New ShaderProgram(
			AddFiltersToSource(BuildSource(VertexShader, MojoVertexShader), VERTEX_SHADER), 
			AddFiltersToSource(BuildSource(FragmentShader, MojoFragmentShader), FRAGMENT_SHADER))
		
		shader.Bind()
		Self.defs = ""
		
		Return shader
	End Method
	
	Method Build:ShaderProgram(type:Int, oldProgram:ShaderProgram = Null)		
		If (type = SURFACE_PROGRAM) Then
			Self.defs = "#define SURFACE_RENDERER~n"
		End If
			
		programs[type] = Build()
		
		If (renderer.GetDefaultShader()) Then
			programs[type].CopyUniformValuesFrom(renderer.GetDefaultShader())
		 End If
			
		If (oldProgram) Then
			programs[type].CopyUniformValuesFrom(oldProgram)
			oldProgram.Discard()
		End If
		
		If (uniforms.Count()) Then				
			For Local uniform := EachIn uniforms.Values()
				If (uniform.dirty) uniform.Apply(programs[type])
			Next
		End If
		
		Return programs[type]
	End Method
	
	Method GetFloat:ShaderUniformValue(name:String, type:Int, size:Int)
		Local uniform:ShaderUniformValue = uniforms.Get(name)
		
		If (Not uniform) Then
			uniform = New ShaderUniformValue(name, type)
			uniforms.Add(name, uniform)
		End If	
	
		If (uniform.fv.Length() < size) Then
			uniform.fv = uniform.fv.Resize(size)
		End If
		
		Return uniform
	End Method	
	
	Method GetInt:ShaderUniformValue(name:String, type:Int, size:Int)
		Local uniform:ShaderUniformValue = uniforms.Get(name)
		
		If (Not uniform) Then
			uniform = New ShaderUniformValue(name, type)
			uniforms.Add(name, uniform)
		End If
	
		If (uniform.iv.Length() < size) Then
			uniform.iv = uniform.iv.Resize(size)
		End If
		
		Return uniform
	End Method
	
	Method GetSetSampler2D:Int(name:String, sampler2d:Image)
		Local uniform:ShaderUniformValue = uniforms.Get(name)
		
		If (Not uniform) Then
			uniform = New ShaderUniformValue(name, SHADER_UNIFORM_SAMPLER_2D)
			uniform.iv = [textureCount]
			
			uniforms.Add(name, uniform)
			textureCount += 1
			
			SetValue(uniform)
		End If
		
		If (sampler2d) Then
			sampler2d.surface.texture.Bind(uniform.iv[0])
		End If
		
		Return uniform.iv[0]
	End Method
	
	Method SetValue:Void(uniform:ShaderUniformValue)
		uniform.dirty = programs.Length()
	
		If (Not renderer) Then
			dirty |= DIRTY_SHADER_UNIFORMS
		Else
			uniform.Apply(renderer.Shader)
		End If	
	End Method
	
	Method RemoveFilter:Void(filter:Filter)
		If (Not filter) Return
		
		Local filterRemained:Bool
		Local l:Int = filters.Length
		Local data:Filter[] = filters.Data
		
		For Local i:Int = 0 Until l
			If (data[i] And data[i].Name = filter.Name) Then
				filterRemained = True
				Exit
			End If
		Next
		
		If (Not filterRemained) Then		
			For Local uniform := EachIn filter.shader.uniforms.Values()
				uniforms.Remove(uniform.name)
			Next
			
			filter.Detach()
		End If
		
		ApplyFilter(Null)
	End Method
	
	Method ApplyFilter:Void(filter:Filter)
		If (filter) Then
			filter.Apply(Self)
		End If
		
		dirty |= DIRTY_SHADER_SOURCE
	End Method
	

End Class

Private

Class ShaderUniformValue
	
	Field iv:Int[]
	Field fv:Float[]
	
	Field name:String
	Field type:Int
	Field dirty:Int
	
	Method New(name:String, type:Int)
		Self.name=  name
		Self.type = type
	End Method
	
	Method Apply:Void(program:ShaderProgram)
		dirty -= 1

		Local unifrom:ShaderUniform = program.GetUniform(name)
		If (Not unifrom) Return

		program.Bind()
		Local location:Int = unifrom.Location

		Select type
			Case SHADER_UNIFORM_BOOL, SHADER_UNIFORM_INT, SHADER_UNIFORM_SAMPLER_2D
				program.SetUniform1iv(location, iv, 0, iv.Length())
				
			Case SHADER_UNIFORM_FLOAT
				program.SetUniform1fv(location, fv, 0, fv.Length())
				
			Case SHADER_UNIFORM_FLOAT_VEC2
				program.SetUniform2fv(location, fv, 0, fv.Length())
			
			Case SHADER_UNIFORM_INT_VEC2, SHADER_UNIFORM_BOOL_VEC2
				program.SetUniform2iv(location, iv, 0, iv.Length())
				
			Case SHADER_UNIFORM_FLOAT_VEC3
				program.SetUniform3fv(location, fv, 0, fv.Length())
			
			Case SHADER_UNIFORM_INT_VEC3, SHADER_UNIFORM_BOOL_VEC3
				program.SetUniform3iv(location, iv, 0, iv.Length())
				
			Case SHADER_UNIFORM_FLOAT_VEC4
				program.SetUniform4fv(location, fv, 0, fv.Length())
			
			Case SHADER_UNIFORM_INT_VEC4, SHADER_UNIFORM_BOOL_VEC4
				program.SetUniform4iv(location, iv, 0, iv.Length())
				
			Case SHADER_UNIFORM_FLOAT_MAT2
				program.SetUniformMatrix2fv(location, fv, fv.Length(), False)
				
			Case SHADER_UNIFORM_FLOAT_MAT3
				program.SetUniformMatrix3fv(location, fv, fv.Length(), False)
				
			Case SHADER_UNIFORM_FLOAT_MAT4
				program.SetUniformMatrix3fv(location, fv, fv.Length(), False)
		End Select
	End Method

End Class
