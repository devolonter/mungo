
Friend harmony.backend.graphics.vertexbuffer
Friend harmony.backend.graphics.shaderprogram
Friend harmony.backend.graphics.texture
Friend harmony.backend.graphics.framebuffer
Friend mojo.app

Private

Interface RestorableResource

Protected

	Method Store:Void()

	Method Restore:Void()

End Interface

Class RestorableBundle

	Method New()
		resources = New List<RestorableResource>()
	End Method
	
	Method AddResource:Void(resource:RestorableResource)
		resources.AddLast(resource)
	End Method
	
	Method RemoveResource:Void(resource:RestorableResource)
		resources.Remove(resource)
	End Method
	
	Method RestoreAll()
		For Local r:= EachIn resources
			r.Restore()
		Next
	End Method
	
	Method StoreAll()
		For Local r:= EachIn resources
			r.Store()
		Next
	End Method
	
	Method Clear()
		resources.Clear()
	End Method
	
Private

	Field resources:List<RestorableResource>

End Class

Global RestorableResources:=New RestorableBundle()
