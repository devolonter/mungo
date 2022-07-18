Strict

Import brl.gametarget
Import brl.filepath
Import brl.databuffer

Private

Import gl
Import harmony.backend.restorable

Public

#SHADER_FILES += "*.vert|*.frag"

Const SHADER_ATTRIBUTE_NONE:Int = GL_NONE
Const SHADER_ATTRIBUTE_FLOAT:Int = GL_FLOAT
Const SHADER_ATTRIBUTE_FLOAT_VEC2:Int = GL_FLOAT_VEC2
Const SHADER_ATTRIBUTE_FLOAT_VEC3:Int = GL_FLOAT_VEC3
Const SHADER_ATTRIBUTE_FLOAT_VEC4:Int = GL_FLOAT_VEC4

Const SHADER_UNIFORM_NONE:Int = GL_NONE
Const SHADER_UNIFORM_BOOL:Int = GL_BOOL
Const SHADER_UNIFORM_INT:Int = GL_INT
Const SHADER_UNIFORM_FLOAT:Int = GL_FLOAT
Const SHADER_UNIFORM_FLOAT_VEC2:Int = GL_FLOAT_VEC2
Const SHADER_UNIFORM_FLOAT_VEC3:Int = GL_FLOAT_VEC3
Const SHADER_UNIFORM_FLOAT_VEC4:Int = GL_FLOAT_VEC4
Const SHADER_UNIFORM_INT_VEC2:Int = GL_INT_VEC2
Const SHADER_UNIFORM_INT_VEC3:Int = GL_INT_VEC3
Const SHADER_UNIFORM_INT_VEC4:Int = GL_INT_VEC4
Const SHADER_UNIFORM_BOOL_VEC2:Int = GL_BOOL_VEC2
Const SHADER_UNIFORM_BOOL_VEC3:Int = GL_BOOL_VEC3
Const SHADER_UNIFORM_BOOL_VEC4:Int = GL_BOOL_VEC4
Const SHADER_UNIFORM_FLOAT_MAT2:Int = GL_FLOAT_MAT2
Const SHADER_UNIFORM_FLOAT_MAT3:Int = GL_FLOAT_MAT3
Const SHADER_UNIFORM_FLOAT_MAT4:Int = GL_FLOAT_MAT4
Const SHADER_UNIFORM_SAMPLER_2D:Int = GL_SAMPLER_2D
Const SHADER_UNIFORM_SAMPLER_CUBE:Int = GL_SAMPLER_CUBE

Function LoadShaderProgram:ShaderProgram(shaderName:String)
	Return New ShaderProgram(BBGame.Game().LoadString("monkey://data/" + shaderName + ".vert"), BBGame.Game().LoadString("monkey://data/" + shaderName + ".frag"))
End Function

Function CreateShaderProgram:ShaderProgram(vertexShaderSource:String, fragmentShaderSource:String)
	Return New ShaderProgram(vertexShaderSource, fragmentShaderSource)
End Function

Class ShaderProgram Implements RestorableResource Final
	
	Method New(vertexShader:String, fragmentShader:String)
		attributes = New StringMap<ShaderAttribute>()
		uniforms = New ShaderUniforms()
		
		Self.vertexShader = vertexShader
		Self.fragmentShader = fragmentShader
		
		Init()
	End Method
	
	Method Discard:Void()
		If (managed) Then
			RestorableResources.RemoveResource(Self)
			managed = False
		End If
	
		Dispose()
		uniforms.Clear()
		attributes.Clear()
	End Method
	
	
	Method Bind:Void()
		If (LastActiveProgram = program) Return
		glUseProgram(program)
		LastActiveProgram = program
	End Method
	
	Method Unbind:Void()
		If (LastActiveProgram <> program) Return
		LastActiveProgram = 0
	End Method
	
	Method EnableVertexAttribute:Void(location:Int)
		glEnableVertexAttribArray(location)
	End Method
	
	Method DisableVertexAttribute:Void(location:Int)
		glDisableVertexAttribArray(location)
	End Method
	
	Method SetUniform1fv:Void(location:Int, values:Float[], offset:Int, length:Int)
		If (offset = 0)
			glUniform1fv(location, length, values)
		Else
			glUniform1fv(location, length, values[offset..])
		End If
	End Method
	
	Method SetUniform2fv:Void(location:Int, values:Float[], offset:Int, length:Int)
		If (offset = 0)
			glUniform2fv(location, length / 2, values)
		Else
			glUniform2fv(location, length / 2, values[offset..])
		End If
	End Method
	
	Method SetUniform3fv:Void(location:Int, values:Float[], offset:Int, length:Int)
		If (offset = 0)
			glUniform3fv(location, length / 3, values)
		Else
			glUniform3fv(location, length / 3, values[offset..])
		End If
	End Method
	
	Method SetUniform4fv:Void(location:Int, values:Float[], offset:Int, length:Int)
		If (offset = 0)
			glUniform4fv(location, length / 4, values)
		Else
			glUniform4fv(location, length / 4, values[offset..])
		End If
	End Method
	
	Method SetUniformf:Void(location:Int, value:Float)
		glUniform1f(location, value)
	End Method
	
	Method SetUniformf:Void(location:Int, value1:Float, value2:Float)
		glUniform2f(location, value1, value2)
	End Method
	
	Method SetUniformf:Void(location:Int, value1:Float, value2:Float, value3:Float)
		glUniform3f(location, value1, value2, value3)
	End Method
	
	Method SetUniformf:Void(location:Int, value1:Float, value2:Float, value3:Float, value4:Float)
		glUniform4f(location, value1, value2, value3, value4)
	End Method
	
	Method SetUniform1iv:Void(location:Int, values:Int[], offset:Int, length:Int)
		If (offset = 0)
			glUniform1iv(location, length, values)
		Else
			glUniform1iv(location, length, values[offset..])
		End If
	End Method
	
	Method SetUniform2iv:Void(location:Int, values:Int[], offset:Int, length:Int)
		If (offset = 0)
			glUniform2iv(location, length / 2, values)
		Else
			glUniform2iv(location, length / 2, values[offset..])
		End If
	End Method
	
	Method SetUniform3iv:Void(location:Int, values:Int[], offset:Int, length:Int)
		If (offset = 0)
			glUniform3iv(location, length / 3, values)
		Else
			glUniform3iv(location, length / 3, values[offset..])
		End If
	End Method
	
	Method SetUniform4iv:Void(location:Int, values:Int[], offset:Int, length:Int)
		If (offset = 0)
			glUniform4iv(location, length / 4, values)
		Else
			glUniform4iv(location, length / 4, values[offset..])
		End If
	End Method
	
	Method SetUniformi:Void(location:Int, value:Int)
		glUniform1i(location, value)
	End Method
	
	Method SetUniformi:Void(location:Int, value1:Int, value2:Int)
		glUniform2i(location, value1, value2)
	End Method
	
	Method SetUniformi:Void(location:Int, value1:Int, value2:Int, value3:Int)
		glUniform3i(location, value1, value2, value3)
	End Method
	
	Method SetUniformi:Void(location:Int, value1:Int, value2:Int, value3:Int, value4:Int)
		glUniform4i(location, value1, value2, value3, value4)
	End Method
	
	Method SetUniformMatrix2fv:Void(location:Int, value:Float[], count:Int, transpose:Bool = False)
		glUniformMatrix2fv(location, count / 4, transpose, value)
	End Method

	Method SetUniformMatrix3fv:Void(location:Int, value:Float[], count:Int, transpose:Bool = False)
		glUniformMatrix3fv(location, count / 9, transpose, value)
	End Method
	
	Method SetUniformMatrix4fv:Void(location:Int, value:Float[], count:Int, transpose:Bool = False)
		glUniformMatrix4fv(location, count / 16, transpose, value)
	End Method
	
	Method SetAttributef:Void(location:Int, value:Float)
		glVertexAttrib1f(location, value)
	End Method
	
	Method SetAttributef:Void(location:Int, value1:Int, value2:Int)
		glVertexAttrib2f(location, value1, value2)
	End Method
	
	Method SetAttributef:Void(location:Int, value1:Int, value2:Int, value3:Int)
		glVertexAttrib3f(location, value1, value2, value3)
	End Method
	
	Method SetAttributef:Void(location:Int, value1:Int, value2:Int, value3:Int, value4:Int)
		glVertexAttrib4f(location, value1, value2, value3, value4)
	End Method
	
	Method SetVertexAttribute:Void(location:Int, size:Int, type:Int, normalize:Bool, stride:Int, offset:Int)
		glVertexAttribPointer(location, size, type, normalize, stride, offset)
	End Method
	
	Method EnableVertexAttribute:Void(name:String)
		Local shaderAttribute:ShaderAttribute = attributes.Get(name)
		If (shaderAttribute) EnableVertexAttribute(shaderAttribute.location)
	End Method
	
	Method DisableVertexAttribute:Void(name:String)
		Local shaderAttribute:ShaderAttribute = attributes.Get(name)
		If (shaderAttribute) DisableVertexAttribute(shaderAttribute.location)
	End Method
	
	Method SetUniform1fv:Void(location:Int, values:Float[], length:Int)
		SetUniform1fv(location, values, 0, length)
	End Method
	
	Method SetUniform1fv:Void(location:Int, values:Float[])
		SetUniform1fv(location, values, 0, values.Length())
	End Method
	
	Method SetUniform1fv:Void(name:String, values:Float[], offset:Int, length:Int)
		Local uniform:ShaderUniform = uniforms.Get(name)
		If (uniform) SetUniform1fv(uniform.location, values, offset, length)
	End Method
	
	Method SetUniform1fv:Void(name:String, values:Float[], length:Int)
		SetUniform1fv(name, values, 0, length)
	End Method
	
	Method SetUniform1fv:Void(name:String, values:Float[])
		SetUniform1fv(name, values, 0, values.Length())
	End Method
	
	Method SetUniform2fv:Void(location:Int, values:Float[], length:Int)
		SetUniform2fv(location, values, 0, length)
	End Method
	
	Method SetUniform2fv:Void(location:Int, values:Float[])
		SetUniform2fv(location, values, 0, values.Length())
	End Method
	
	Method SetUniform2fv:Void(name:String, values:Float[], offset:Int, length:Int)
		Local uniform:ShaderUniform = uniforms.Get(name)
		If (uniform) SetUniform2fv(uniform.location, values, offset, length)
	End Method
	
	Method SetUniform2fv:Void(name:String, values:Float[], length:Int)
		SetUniform2fv(name, values, 0, length)
	End Method
	
	Method SetUniform2fv:Void(name:String, values:Float[])
		SetUniform2fv(name, values, 0, values.Length())
	End Method
	
	Method SetUniform3fv:Void(location:Int, values:Float[], length:Int)
		SetUniform3fv(location, values, 0, length)
	End Method
	
	Method SetUniform3fv:Void(location:Int, values:Float[])
		SetUniform3fv(location, values, 0, values.Length())
	End Method
	
	Method SetUniform3fv:Void(name:String, values:Float[], offset:Int, length:Int)
		Local uniform:ShaderUniform = uniforms.Get(name)
		If (uniform) SetUniform3fv(uniform.location, values, offset, length)
	End Method
	
	Method SetUniform3fv:Void(name:String, values:Float[], length:Int)
		SetUniform3fv(name, values, 0, length)
	End Method
	
	Method SetUniform3fv:Void(name:String, values:Float[])
		SetUniform3fv(name, values, 0, values.Length())
	End Method
	
	Method SetUniform4fv:Void(location:Int, values:Float[], length:Int)
		SetUniform4fv(location, values, 0, length)
	End Method
	
	Method SetUniform4fv:Void(location:Int, values:Float[])
		SetUniform4fv(location, values, 0, values.Length())
	End Method
	
	Method SetUniform4fv:Void(name:String, values:Float[], offset:Int, length:Int)
		Local uniform:ShaderUniform = uniforms.Get(name)
		If (uniform) SetUniform4fv(uniform.location, values, offset, length)
	End Method
	
	Method SetUniform4fv:Void(name:String, values:Float[], length:Int)
		SetUniform4fv(name, values, 0, length)
	End Method
	
	Method SetUniform4fv:Void(name:String, values:Float[])
		SetUniform4fv(name, values, 0, values.Length())
	End Method
	
	Method SetUniformf:Void(name:String, value:Float)
		Local uniform:ShaderUniform = uniforms.Get(name)
		If (uniform) SetUniformf(uniform.location, value)
	End Method
	
	Method SetUniformf:Void(name:String, value1:Float, value2:Float)
		Local uniform:ShaderUniform = uniforms.Get(name)
		If (uniform) SetUniformf(uniform.location, value1, value2)
	End Method
	
	Method SetUniformf:Void(name:String, value1:Float, value2:Float, value3:Float)
		Local uniform:ShaderUniform = uniforms.Get(name)
		If (uniform) SetUniformf(uniform.location, value1, value2, value3)
	End Method
	
	Method SetUniformf:Void(name:String, value1:Float, value2:Float, value3:Float, value4:Float)
		Local uniform:ShaderUniform = uniforms.Get(name)
		If (uniform) SetUniformf(uniform.location, value1, value2, value3, value4)
	End Method
	
	Method SetUniform1iv:Void(location:Int, values:Int[], length:Int)
		SetUniform1iv(location, values, 0, length)
	End Method
	
	Method SetUniform1iv:Void(location:Int, values:Int[])
		SetUniform1iv(location, values, 0, values.Length())
	End Method
	
	Method SetUniform1iv:Void(name:String, values:Int[], offset:Int, length:Int)
		Local uniform:ShaderUniform = uniforms.Get(name)
		If (uniform) SetUniform1iv(uniform.location, values, offset, length)
	End Method
	
	Method SetUniform1iv:Void(name:String, values:Int[], length:Int)
		SetUniform1iv(name, values, 0, length)
	End Method
	
	Method SetUniform1iv:Void(name:String, values:Int[])
		SetUniform1iv(name, values, 0, values.Length())
	End Method
	
	Method SetUniform2iv:Void(location:Int, values:Int[], length:Int)
		SetUniform2iv(location, values, 0, length)
	End Method
	
	Method SetUniform2iv:Void(location:Int, values:Int[])
		SetUniform2iv(location, values, 0, values.Length())
	End Method
	
	Method SetUniform2iv:Void(name:String, values:Int[], offset:Int, length:Int)
		Local uniform:ShaderUniform = uniforms.Get(name)
		If (uniform) SetUniform2iv(uniform.location, values, offset, length)
	End Method
	
	Method SetUniform2iv:Void(name:String, values:Int[], length:Int)
		SetUniform2iv(name, values, 0, length)
	End Method
	
	Method SetUniform2iv:Void(name:String, values:Int[])
		SetUniform2iv(name, values, 0, values.Length())
	End Method
	
	Method SetUniform3iv:Void(location:Int, values:Int[], length:Int)
		SetUniform3iv(location, values, 0, length)
	End Method
	
	Method SetUniform3iv:Void(location:Int, values:Int[])
		SetUniform3iv(location, values, 0, values.Length())
	End Method
	
	Method SetUniform3iv:Void(name:String, values:Int[], offset:Int, length:Int)
		Local uniform:ShaderUniform = uniforms.Get(name)
		If (uniform) SetUniform3iv(uniform.location, values, offset, length)
	End Method
	
	Method SetUniform3iv:Void(name:String, values:Int[], length:Int)
		SetUniform3iv(name, values, 0, length)
	End Method
	
	Method SetUniform3iv:Void(name:String, values:Int[])
		SetUniform3iv(name, values, 0, values.Length())
	End Method
	
	Method SetUniform4iv:Void(location:Int, values:Int[], length:Int)
		SetUniform4iv(location, values, 0, length)
	End Method
	
	Method SetUniform4iv:Void(location:Int, values:Int[])
		SetUniform4iv(location, values, 0, values.Length())
	End Method
	
	Method SetUniform4iv:Void(name:String, values:Int[], offset:Int, length:Int)
		Local uniform:ShaderUniform = uniforms.Get(name)
		If (uniform) SetUniform4iv(uniform.location, values, offset, length)
	End Method
	
	Method SetUniform4iv:Void(name:String, values:Int[], length:Int)
		SetUniform4iv(name, values, 0, length)
	End Method
	
	Method SetUniform4iv:Void(name:String, values:Int[])
		SetUniform4iv(name, values, 0, values.Length())
	End Method
	
	Method SetUniformi:Void(name:String, value:Int)
		Local uniform:ShaderUniform = uniforms.Get(name)
		If (uniform) SetUniformi(uniform.location, value)
	End Method
	
	Method SetUniformi:Void(name:String, value1:Int, value2:Int)
		Local uniform:ShaderUniform = uniforms.Get(name)
		If (uniform) SetUniformi(uniform.location, value1, value2)
	End Method
	
	Method SetUniformi:Void(name:String, value1:Int, value2:Int, value3:Int)
		Local uniform:ShaderUniform = uniforms.Get(name)
		If (uniform) SetUniformi(uniform.location, value1, value2, value3)
	End Method
	
	Method SetUniformi:Void(name:String, value1:Int, value2:Int, value3:Int, value4:Int)
		Local uniform:ShaderUniform = uniforms.Get(name)
		If (uniform) SetUniformi(uniform.location, value1, value2, value3, value4)
	End Method
	
	Method SetUniformMatrix2fv:Void(location:Int, value:Float[], transpose:Bool = False)
		SetUniformMatrix2fv(location, value, value.Length(), transpose)
	End Method
	
	Method SetUniformMatrix2fv:Void(name:String, value:Float[], count:Int, transpose:Bool = False)
		Local uniform:ShaderUniform = uniforms.Get(name)
		If (uniform) SetUniformMatrix2fv(uniform.location, value, count, transpose)
	End Method
	
	Method SetUniformMatrix2fv:Void(name:String, value:Float[], transpose:Bool = False)
		Local uniform:ShaderUniform = uniforms.Get(name)
		If (uniform) SetUniformMatrix2fv(uniform.location, value, transpose)
	End Method
	
	Method SetUniformMatrix3fv:Void(location:Int, value:Float[], transpose:Bool = False)
		SetUniformMatrix3fv(location, value, value.Length(), transpose)
	End Method
	
	Method SetUniformMatrix3fv:Void(name:String, value:Float[], count:Int, transpose:Bool = False)
		Local uniform:ShaderUniform = uniforms.Get(name)
		If (uniform) SetUniformMatrix3fv(uniform.location, value, count, transpose)
	End Method
	
	Method SetUniformMatrix3fv:Void(name:String, value:Float[], transpose:Bool = False)
		Local uniform:ShaderUniform = uniforms.Get(name)
		If (uniform) SetUniformMatrix3fv(uniform.location, value, transpose)
	End Method
	
	Method SetUniformMatrix4fv:Void(location:Int, value:Float[], transpose:Bool = False)
		SetUniformMatrix4fv(location, value, value.Length(), transpose)
	End Method
	
	Method SetUniformMatrix4fv:Void(name:String, value:Float[], count:Int, transpose:Bool = False)
		Local uniform:ShaderUniform = uniforms.Get(name)
		If (uniform) SetUniformMatrix4fv(uniform.location, value, count, transpose)
	End Method
	
	Method SetUniformMatrix4fv:Void(name:String, value:Float[], transpose:Bool = False)
		Local uniform:ShaderUniform = uniforms.Get(name)
		If (uniform) SetUniformMatrix4fv(uniform.location, value, transpose)
	End Method
	
	Method SetAttributef:Void(name:String, value:Float)
		Local attribute:ShaderAttribute = attributes.Get(name)
		If (attribute) SetAttributef(attribute.location, value)
	End Method
	
	Method SetAttributef:Void(name:String, value1:Int, value2:Int)
		Local attribute:ShaderAttribute = attributes.Get(name)
		If (attribute) SetAttributef(attribute.location, value1, value2)
	End Method
	
	Method SetAttributef:Void(name:String, value1:Int, value2:Int, value3:Int)
		Local attribute:ShaderAttribute = attributes.Get(name)
		If (attribute) SetAttributef(attribute.location, value1, value2, value3)
	End Method
	
	Method SetAttributef:Void(name:String, value1:Int, value2:Int, value3:Int, value4:Int)
		Local attribute:ShaderAttribute = attributes.Get(name)
		If (attribute) SetAttributef(attribute.location, value1, value2, value3, value4)
	End Method
	
	Method SetVertexAttribute:Void(name:String, size:Int, type:Int, normalize:Bool, stride:Int, offset:Int)
		Local attribute:ShaderAttribute = attributes.Get(name)
		If (attribute) SetVertexAttribute(attribute.location, size, type, normalize, stride, offset)
	End Method
	
	Method Attributes:MapValues<String, ShaderAttribute>()
		Return attributes.Values()
	End Method
	
	Method GetAttribute:ShaderAttribute(name:String)
		Return attributes.Get(name)
	End Method
	
	Method HasAttribute:Bool(name:String)
		Return attributes.Contains(name)
	End Method
	
	Method Uniforms:MapValues<String, ShaderUniform>()
		Return uniforms.Values()
	End Method
	
	Method GetUniform:ShaderUniform(name:String)
		Return uniforms.Get(name)
	End Method
	
	Method HasUniform:Bool(name:String)
		Return uniforms.Contains(name)
	End Method
	
	Method CopyUniformValuesFrom:Void(shaderProgram:ShaderProgram)
		Local program:Int = shaderProgram.program
		glUseProgram(program)
		For Local uniform:ShaderUniform = EachIn shaderProgram.uniforms.Values()
			If (Not uniform.storage) uniform.storage = New ShaderUniformStorage(uniform)
			uniform.storage.Store(program)
		Next
		
		glUseProgram(Self.program)
		For Local u := EachIn shaderProgram.uniforms
			Local uniform:ShaderUniform = uniforms.Get(u.Key)
			If (uniform) Then
				u.Value.storage.Restore(uniform.location)
			End If
		Next
	End Method
	
	Method IsCompiled:Bool()
		Return isCompiled
	End Method
	
	Method VertexShader:String() Property
		Return vertexShader
	End Method
	
	Method FragmentShader:String() Property
		Return fragmentShader
	End Method
	
Private

	Global LastActiveProgram:Int
	
	Field program:Int
	Field isCompiled:Bool
	
	Field vertexShader:String	
	Field fragmentShader:String
	
	Field attributes:StringMap<ShaderAttribute>	
	Field uniforms:ShaderUniforms
	
	Field managed:Bool
	
	Method Init:Void()
		If (Not managed) Then
			RestorableResources.AddResource(Self)
			managed = True
		End If
	
		Compile()
		
		If (isCompiled)
			InitAttributes()
			InitUniforms()
		End If
	End Method
	
	Method Compile:Void()
		Local vertextShader:Int = CompileShader(GL_VERTEX_SHADER, Self.vertexShader)
		Local fragmentShader:Int = CompileShader(GL_FRAGMENT_SHADER, Self.fragmentShader)
		
		If (vertextShader = -1 Or fragmentShader = -1)
			isCompiled = False
			Return
		End If
		
		program = glCreateProgram()
		If (program = 0) Then
			isCompiled = False
			Return
		End If
		
		glAttachShader(program, vertextShader)
		glAttachShader(program, fragmentShader)
		glDeleteShader(vertextShader)
		glDeleteShader(fragmentShader)
		
		glLinkProgram(program)
		
		Local result:Int[1]
		glGetProgramiv(program, GL_LINK_STATUS, result)
		
		If (result[0] = 0)
#If CONFIG = "debug"
			Print glGetProgramInfoLog(program)
#End
			isCompiled = False
			Return
		End If
		
		isCompiled = True
	End Method
	
	Method InitAttributes:Void()
		If (attributes.Count() > 0) Return
		
		Local result:Int[1], size:Int[1], type:Int[1], name:String[1]
		
		attributes.Clear()
		glGetProgramiv(program, GL_ACTIVE_ATTRIBUTES, result)
		
		For Local i:Int = 0 Until result[0]
			glGetActiveAttrib(program, i, size, type, name)
			
			Local attribute:ShaderAttribute = New ShaderAttribute(name[0], type[0], size[0]) 
			attribute.location = glGetAttribLocation(program, attribute.name)
			
			attributes.Insert(attribute.name, attribute)
		Next
	End Method
	
	Method InitUniforms:Void()
		If (uniforms.Count() > 0) Return
		
		Local result:Int[1], size:Int[1], type:Int[1], name:String[1]
		
		uniforms.Clear()
		glGetProgramiv(program, GL_ACTIVE_UNIFORMS, result)
		
		For Local i:Int = 0 Until result[0]
			glGetActiveUniform(program, i, size, type, name)
			
			Local uniform:ShaderUniform = New ShaderUniform(name[0], type[0], size[0])
			uniform.location = glGetUniformLocation(program, uniform.name)
			
			If (uniform.name.EndsWith("[0]"))
				uniforms.aliases.Insert(uniform.name, uniform)
			
				uniform.name = uniform.name[..-3]
				uniforms.Insert(uniform.name, uniform)
			Else
				uniforms.Insert(uniform.name, uniform)
			End If
		Next
	End Method
	
	Method Dispose:Void()
		glUseProgram(0)
		glDeleteProgram(program)
		program = 0
		LastActiveProgram = 0
		isCompiled = False
	End Method
	
	Method Store:Void()		
		For Local uniform:ShaderUniform = EachIn uniforms.Values()
			If (Not uniform.storage) uniform.storage = New ShaderUniformStorage(uniform)
			uniform.storage.Store(program)
		Next
	End Method
	
	Method Restore:Void()	
		Dispose()
		Init()
		
		glUseProgram(program)
		For Local uniform:ShaderUniform = EachIn uniforms.Values()
			If (uniform.storage) uniform.storage.Restore(uniform.location)
		Next
		glUseProgram(0)
	End Method
	
	Function CompileShader:Int(type:Int, source:String)
		Local shader:Int = glCreateShader(type)
		
		glShaderSource(shader, source)
		glCompileShader(shader)
		
		Local result:Int[1]
		glGetShaderiv(shader, GL_COMPILE_STATUS, result)
		
		If result[0] = 0
#If CONFIG = "debug"
			Print glGetShaderInfoLog(shader)
#End
			Return -1
		End If
		
		Return shader
	End Function	

End Class

Class ShaderAttribute Extends ShaderParamInt
	
	Method New(name:String, type:Int, size:Int)
		Super.New(name, type, size)
	End Method

End Class

Class ShaderUniform Extends ShaderParamInt
	
	Method New(name:String, type:Int, size:Int)
		Super.New(name, type, size)
	End Method
	
Private

	Field storage:ShaderUniformStorage

End Class

Private

Class ShaderParamInt Extends ShaderParam<Int>
	
	Method New(name:String, type:Int, size:Int)
		Super.New(name, size)
		Self.type = type
	End Method
	
	Method Type:Int() Property
		Return type
	End Method
	
	Private

	Field type:Int

End Class

Class ShaderUniformStorage
	
	Method New(uniform:ShaderUniform)
		Self.uniform = uniform
	
		Select uniform.type
			Case SHADER_UNIFORM_BOOL, SHADER_UNIFORM_INT, SHADER_UNIFORM_SAMPLER_2D
				iv = New Int[uniform.size]
				
			Case SHADER_UNIFORM_FLOAT
				fv = New Float[uniform.size]
				
			Case SHADER_UNIFORM_FLOAT_VEC2
				fv = New Float[uniform.size*2]
			
			Case SHADER_UNIFORM_INT_VEC2, SHADER_UNIFORM_BOOL_VEC2
				iv = New Int[uniform.size*2]
				
			Case SHADER_UNIFORM_FLOAT_VEC3
				fv = New Float[uniform.size*3]
			
			Case SHADER_UNIFORM_INT_VEC3, SHADER_UNIFORM_BOOL_VEC3
				iv = New Int[uniform.size*3]
				
			Case SHADER_UNIFORM_FLOAT_VEC4
				fv = New Float[uniform.size*4]
			
			Case SHADER_UNIFORM_INT_VEC4, SHADER_UNIFORM_BOOL_VEC4
				iv = New Int[uniform.size*4]
				
			Case SHADER_UNIFORM_FLOAT_MAT2
				fv = New Float[uniform.size*4]
				
			Case SHADER_UNIFORM_FLOAT_MAT3
				fv = New Float[uniform.size*9]
				
			Case SHADER_UNIFORM_FLOAT_MAT4
				fv = New Float[uniform.size*16]
		End Select
	End Method
	
	Method Store:Void(program:Int)
		Select uniform.type
			Case SHADER_UNIFORM_FLOAT, SHADER_UNIFORM_FLOAT_VEC2, SHADER_UNIFORM_FLOAT_VEC3, SHADER_UNIFORM_FLOAT_VEC4, SHADER_UNIFORM_FLOAT_MAT2, SHADER_UNIFORM_FLOAT_MAT3, SHADER_UNIFORM_FLOAT_MAT4
				glGetUniformfv(program, uniform.location, fv)
			Default
				glGetUniformiv(program, uniform.location, iv)
		End Select
	End Method

	Method Restore:Void(location:Int)
		Select uniform.type
			Case SHADER_UNIFORM_BOOL, SHADER_UNIFORM_INT, SHADER_UNIFORM_SAMPLER_2D
				glUniform1iv(location, iv.Length(), iv)
				
			Case SHADER_UNIFORM_FLOAT
				glUniform1fv(location, fv.Length(), fv)
				
			Case SHADER_UNIFORM_FLOAT_VEC2
				glUniform2fv(location, fv.Length() / 2, fv)
			
			Case SHADER_UNIFORM_INT_VEC2, SHADER_UNIFORM_BOOL_VEC2
				glUniform2iv(location, iv.Length() / 2, iv)
				
			Case SHADER_UNIFORM_FLOAT_VEC3
				glUniform3fv(location, fv.Length() / 3, fv)
			
			Case SHADER_UNIFORM_INT_VEC3, SHADER_UNIFORM_BOOL_VEC3
				glUniform3iv(location, iv.Length() / 3, iv)
				
			Case SHADER_UNIFORM_FLOAT_VEC4
				glUniform4fv(location, fv.Length() / 4, fv)
			
			Case SHADER_UNIFORM_INT_VEC4, SHADER_UNIFORM_BOOL_VEC4
				glUniform4iv(location, iv.Length() / 4, iv)
				
			Case SHADER_UNIFORM_FLOAT_MAT2
				glUniformMatrix2fv(location, fv.Length() / 4, False, fv)
				
			Case SHADER_UNIFORM_FLOAT_MAT3
				glUniformMatrix3fv(location, fv.Length() / 9, False, fv)
				
			Case SHADER_UNIFORM_FLOAT_MAT4
				glUniformMatrix4fv(location, fv.Length() / 16, False, fv)
		End Select
	End Method
	
Private

	Field uniform:ShaderUniform
	Field fv:Float[]
	Field iv:Int[]
	
End Class

Class ShaderParam<T>
	
	Method New(name:String, size:Int)
		Self.name = name
		Self.size = size
	End Method
	
	Method Name:String() Property
		Return name
	End Method
	
	Method Type:T() Property Abstract
	
	Method Size:Int() Property
		Return size
	End Method
	
	Method Location:Int() Property
		Return location
	End Method

Private

	Field name:String
	
	Field location:Int

	Field size:Int

End Class

Class ShaderProgramAbstract Implements RestorableResource Abstract
	
	Method Bind:Void() Abstract
	
	Method Unbind:Void() Abstract
	
	Method EnableVertexAttribute:Void(location:Int) Abstract
	
	Method DisableVertexAttribute:Void(location:Int) Abstract
	
	Method SetUniform1fv:Void(location:Int, values:Float[], offset:Int, length:Int) Abstract
	
	Method SetUniform2fv:Void(location:Int, values:Float[], offset:Int, length:Int) Abstract
	
	Method SetUniform3fv:Void(location:Int, values:Float[], offset:Int, length:Int) Abstract
	
	Method SetUniform4fv:Void(location:Int, values:Float[], offset:Int, length:Int) Abstract
	
	Method SetUniformf:Void(location:Int, value:Float) Abstract
	
	Method SetUniformf:Void(location:Int, value1:Float, value2:Float) Abstract
	
	Method SetUniformf:Void(location:Int, value1:Float, value2:Float, value3:Float) Abstract
	
	Method SetUniformf:Void(location:Int, value1:Float, value2:Float, value3:Float, value4:Float) Abstract
	
	Method SetUniformi:Void(location:Int, value:Int) Abstract
	
	Method SetUniformi:Void(location:Int, value1:Int, value2:Int) Abstract
	
	Method SetUniformi:Void(location:Int, value1:Int, value2:Int, value3:Int) Abstract
	
	Method SetUniformi:Void(location:Int, value1:Int, value2:Int, value3:Int, value4:Int) Abstract
	
	Method SetUniformMatrix3fv:Void(location:Int, value:Float[], count:Int, transpose:Bool = False) Abstract
	
	Method SetUniformMatrix4fv:Void(location:Int, value:Float[], count:Int, transpose:Bool = False) Abstract
	
	Method SetAttributef:Void(location:Int, value:Float) Abstract
	
	Method SetAttributef:Void(location:Int, value1:Int, value2:Int) Abstract
	
	Method SetAttributef:Void(location:Int, value1:Int, value2:Int, value3:Int) Abstract
	
	Method SetAttributef:Void(location:Int, value1:Int, value2:Int, value3:Int, value4:Int) Abstract
	
	Method SetVertexAttribute:Void(location:Int, size:Int, type:Int, normalize:Bool, stride:Int, offset:Int) Abstract
	
	Method Compile:Void() Abstract
	
	Method Dispose:Void() Abstract
	
	Method Store:Void() Abstract
	
	Method Restore:Void() Abstract
	
	Method InitAttributes:Void() Abstract
	
	Method InitUniforms:Void() Abstract
	
End Class

Class ShaderUniforms Extends StringMap<ShaderUniform>

	Field aliases:StringMap<ShaderUniform> = New StringMap<ShaderUniform>()

	Method Contains:Bool(key:String)
		If (Super.Contains(key))
			Return True
		End If
		
		Return aliases.Contains(key)
	End Method
	
	Method Get:ShaderUniform(key:String)
		Local r:ShaderUniform = Super.Get(key)
		If (r) Return r
		
		Return aliases.Get(key)
	End Method

End Class
