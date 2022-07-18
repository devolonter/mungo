
Import os

#GLFW_USE_MINGW=False

Function ReplaceBlock$( text$,startTag$,endTag$,repText$ )

	'Find *first* start tag
	Local i=text.Find( startTag )
	If i=-1 Return text
	i+=startTag.Length
	While i<text.Length And text[i-1]<>10
		i+=1
	Wend
	'Find *last* end tag
	Local i2=text.Find( endTag,i )
	If i2=-1 Return text
	While i2>0 And text[i2]<>10
		i2-=1
	Wend
	'replace text!
	Return text[..i]+repText+text[i2..]
End

Function MakeGL()

	Local kludge_common_cpp,kludge_glfw,kludge_android,kludge_ios,kludge_html5

	Local const_decls:=New StringStack
	Local common_cpp_decls:=New StringStack
	Local glfw_decls:=New StringStack
	Local android_decls:=New StringStack
	Local ios_decls:=New StringStack
	Local html5_decls:=New StringStack

	Print "Parsing gl_src.txt"
		
	Local src:= LoadString("gl_src.txt")
	
	Local lines:=src.Split( "~n" )
	
	Local last_id$,rep_id
	
	For Local line:String=Eachin lines
	
		line=line.Trim()
		
		If line.StartsWith( "Const " )
		
			const_decls.Push( line )
			
		Else If line.StartsWith( "Kludge " )
		
			kludge_common_cpp=False
			kludge_glfw=False
			kludge_android=False
			kludge_ios=False
			kludge_html5=False

			If line.Contains( "all" )
				kludge_common_cpp=True
				kludge_android=True
				kludge_html5=True
			Else
				If line.Contains( "cpp" ) kludge_common_cpp=True
				If line.Contains( "glfw" ) kludge_glfw=True
				If line.Contains( "android" ) kludge_android=True
				If line.Contains( "ios" ) kludge_ios=True
				If line.Contains( "html5" ) kludge_html5=True
			Endif

		Else If line.StartsWith( "Function " )
			Local is_native:= line.Contains("Native ")
			if (is_native) line = line.Replace("Native ", "")
		
			Local i=line.Find( "(" )
			If i<>-1
				Local id$=line[9..i]
				Local i2=id.Find( ":" )
				If i2<>-1 id=id[..i2]
				
				If kludge_common_cpp
					common_cpp_decls.Push line+"=~q_"+id+"~q"
				Else
					common_cpp_decls.Push line
				End If
				
				'GLFW!
				If kludge_glfw
					glfw_decls.Push line+"=~q_"+id+"~q"
				Endif
				
				'ios!
				If kludge_ios
					ios_decls.Push line+"=~q_"+id+"~q"
				Endif
				
				'Android!
				If kludge_android
					If Not is_native
						android_decls.Push line+"=~qHGL."+id+"~q"
					Else
						android_decls.Push line+"=~qNHGL."+id+"~q"
					Endif
				Else
					android_decls.Push line+"=~qGLES20."+id+"~q"
				Endif
				
				'html5!
				If kludge_html5
					If id=last_id
						rep_id+=1
						html5_decls.Push line+"=~q_"+id+rep_id+"~q"
					Else
						last_id=id
						rep_id=1
						html5_decls.Push line+"=~q_"+id+"~q"
					Endif
				Else
					last_id=""
					html5_decls.Push line+"=~qgl."+id[2..3].ToLower()+id[3..]+"~q"
				Endif
				
			Endif
		Endif
		
	Next
	
	Print "Updating gl.monkey..."
	
	Local dst:= LoadString("gl.monkey")
	
	dst=ReplaceBlock( dst,"'${CONST_DECLS}","'${END}",const_decls.Join( "~n" ) )
	dst=ReplaceBlock( dst,"'${COMMON_CPP_DECLS}","'${END}",common_cpp_decls.Join( "~n" ) )
	dst=ReplaceBlock( dst,"'${GLFW_DECLS}","'${END}",glfw_decls.Join( "~n" ) )
	dst=ReplaceBlock( dst,"'${ANDROID_DECLS}","'${END}",android_decls.Join( "~n" ) )
	dst=ReplaceBlock( dst,"'${IOS_DECLS}","'${END}",ios_decls.Join( "~n" ) )
	dst=ReplaceBlock( dst,"'${HTML5_DECLS}","'${END}",html5_decls.Join( "~n" ) )

'	Print dst	
	Print dst
	SaveString dst,"gl.monkey"

	Print "Done!"
End

Function Toke$( text$ )
	Local i=text.Find( " " )
	If i=-1 Return text
	Return text[..i]
End

Function Bump$( text$ )
	Local i=text.Find( " " )
	If i=-1 Return ""
	Return text[i+1..].Trim()
End

Function MakeGLExts()

	Local gl:= LoadString("gl.h")
	Local gl2:=LoadString( "gles20.h" )

	Local decls:=New StringStack
	Local inits:=New StringStack
	
	decls.Push "typedef char GLchar;"
	decls.Push "typedef size_t GLintptr;"
	decls.Push "typedef size_t GLsizeiptr;"
	decls.Push "#define INIT_GL_EXTS 1"
		
	For Local line:=Eachin gl2.Split( "~n" )
	
		line=line.Trim()
		If Not line Continue
		
		Local tline:=line
		
		If Toke( line )="#define"
			line=Bump( line )
			Local id:=Toke( line )
			If gl.Find( "#define "+id )=-1
				line=Bump( line )
				Local val:=Toke( line )
				decls.Push "#define "+id+" "+val
			Else
				'Print "//"+tline
			Endif
		Else If Toke( line )="GL_APICALL"
			line=Bump( line )
			Local ret:=Toke( line )
			line=Bump( line )
			If Toke( line )="GL_APIENTRY"
				line=Bump( line )
				Local id:=Toke( line )
				If gl.Find( "APIENTRY "+id )=-1
					line=Bump( line )
					Local args:=line
					
					decls.Push ret+"(__stdcall*"+id+")"+args
					inits.Push "(void*&)"+id+"=(void*)wglGetProcAddress(~q"+id+"~q);"

				Else
					'Print "//"+tline
				Endif
			Endif
		Endif
	Next
	
	Local t:="#if _WIN32~n"+decls.Join("~n")+"~nvoid Init_GL_Exts(){~n~t"+inits.Join( "~n~t" )+"~n}~n#endif~n"
	
	SaveString t, "native/gl.glfw.winnt.cpp"
		
End

Function Main()

	ChangeDir "../../"

	Print "MakeGL..."
	MakeGL()
	
	Print "MakeGlExts..."
	MakeGLExts()

	Print "Done!"
		
End
