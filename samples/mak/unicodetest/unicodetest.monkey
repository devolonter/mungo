
#GLFW_APP_LABEL="SaveState"
#GLFW_APP_PUBLISHER="Devolonter"
#GLFW_USE_MINGW=False

Import harmony.mojo

Import os

Class MyApp Extends App

	Field strs$[8]
	Field ascii$
	
	Method OnCreate()
	    Local sa:=New String[8]
	    sa[0] = String.FromChar($1E6E)
	    sa[1] = String.FromChar($1E19)
	    sa[2] = String.FromChar($1E67)
	    sa[3] = String.FromChar($2020)
	    sa[4] = String.FromChar($1FFF)
	    sa[5] = String.FromChar($3FFF)
	    sa[6] = String.FromChar($7FFF)
	    sa[7] = String.FromChar($FFFF)

	    strs[0]="".Join( sa )
	
		SaveState strs[0]
		strs[1]=LoadState()
		
		strs[2]=app.LoadString( "str0.txt" )			'as saved by glfw code below
		strs[3]=app.LoadString( "str0_utf8.txt" )		'as saved by notepad++...
		strs[4]=app.LoadString( "str0_utf16be.txt" )
		strs[5]=app.LoadString( "str0_utf16le.txt" )
		
#if TARGET="glfw"
		os.SaveString strs[0],"str0.txt"
		strs[6]=os.LoadString( "str0.txt" )
#end
		ascii=app.LoadString( "ascii.txt" )
		
		SetUpdateRate 60
	End
	
	Method OnUpdate()
	End
	
	Method OnRender()
		Cls
		For Local j=0 Until 8
			For Local i=0 Until strs[j].Length
				DrawText strs[j][i],j*48,i*16
			Next
		Next
		Local y=8*16
		For Local t$=Eachin ascii.Split("~n")
			DrawText t,0,y
			y+=16
		Next
	End
	
End

Function Main()
	New MyApp
End
