#tag Module
Protected Module FolderItems
	#tag Method, Flags = &h1
		Protected Function ProfilesDirectory() As FolderItem
		  return SpecialFolder.UserLibrary.Child("MobileDevice").Child("Provisioning Profiles")
		End Function
	#tag EndMethod


End Module
#tag EndModule
