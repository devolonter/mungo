#If TARGET = "html5"

Import "native/utils.${TARGET}.${LANG}"

Extern

Function IsMojoAssetExists:Bool(path:String)

#Else

Import brl.filesystem
Import mojo.data

Function IsMojoAssetExists:Bool(path:String)
	Return FileType(FixDataPath(path)) = FILETYPE_FILE
End Function

#End
