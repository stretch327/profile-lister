#tag Module
Protected Module Prefs
	#tag Method, Flags = &h1
		Protected Function HasKey(name as String) As Boolean
		  If mJSONData = Nil Then
		    Return False
		  End If
		  
		  Return mJSONData.HasKey(name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Load()
		  mJSONData = New JSONItem
		  
		  Try
		    Dim f As FolderItem = PrefFile
		    If f = nil or Not f.Exists Then
		      Return
		    End If
		    
		    Dim tis As TextInputStream = TextInputStream.Open(f)
		    Dim data As String = tis.ReadAll
		    tis.Close
		    
		    mJSONData = new JSONItem(data)
		  Catch ex As RuntimeException
		    MsgBox "An error occurred while trying to read the prefs file."
		    
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function PrefFile() As FolderItem
		  Try
		    Dim f As FolderItem = SpecialFolder.ApplicationData.Child(kAppID)
		    
		    If f.Exists = False Then
		      f.CreateFolder
		    End If
		    
		    f = f.Child("prefs.conf")
		    
		    return f
		  Catch ex As RuntimeException
		    MsgBox "An error occurred trying to access the prefs file: " + ex.Message
		  End Try
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Save()
		  If mJSONData= Nil or mJSONData.Count = 0 then
		    Return
		  End If
		  
		  Dim f As FolderItem = PrefFile
		  
		  Dim tos As TextOutputStream = TextOutputStream.Create(f)
		  tos.write mJSONData.ToString
		  tos.Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Value(name as string) As Variant
		  return mJSONData.Lookup(name,"")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Value(name as string, assigns value as variant)
		  mJSONData.Value(name) = value
		  
		  prefs.Save
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mJSONData As JSONItem
	#tag EndProperty


	#tag Constant, Name = kAppID, Type = String, Dynamic = False, Default = \"com.stretchedout.apple-profile-lister", Scope = Protected
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
