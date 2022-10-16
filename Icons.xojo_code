#tag Module
Protected Module Icons
	#tag Method, Flags = &h1
		Protected Function GetIcon(name as string) As Picture
		  Dim suffixes() As String
		  If IsDarkMode Then
		    suffixes.Add "_dark"
		  End If
		  suffixes.Add ""
		  
		  If mIconCache = Nil Then
		    mIconCache = New Dictionary
		  End If
		  
		  Dim keyName As String = name + suffixes(0)
		  If mIconCache.HasKey(keyName) Then
		    Return mIconCache.Value(keyName)
		  End If
		  
		  For i As Integer = 0 To UBound(suffixes)
		    Dim filename As String = name + suffixes(i) + ".png"
		    
		    Dim f As FolderItem = SpecialFolder.Resources.Child(filename)
		    If f.Exists Then
		      Dim pics() As picture
		      For j As Integer = 1 To 2
		        filename = name + suffixes(i) + If(j=1,"", "@" + Str(j) + "x") + ".png"
		        
		        f = SpecialFolder.Resources.Child(filename)
		        If f.Exists Then
		          Dim p As Picture = picture.Open(f)
		          If p<>Nil Then
		            pics.add p
		          End If
		        End If
		      Next j
		      
		      Dim img As New Picture(pics(0).Width, pics(0).Height, pics)
		      mIconCache.Value(keyName) = img
		      Return img
		    End If
		  Next
		  
		  Return Nil
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mIconCache As Dictionary
	#tag EndProperty


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
