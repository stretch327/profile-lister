#tag Module
Protected Module Strings
	#tag Method, Flags = &h0
		Function ConvertUTCDate(extends datestr as string) As DateTime
		  
		  Dim rx As New RegEx
		  rx.SearchPattern = "(?Umsi)([0-9-]+)T([0-9:]+)Z"
		  rx.ReplacementPattern = "\1 \2"
		  
		  Dim rxOptions As RegExOptions = rx.Options
		  rxOptions.LineEndType = 4
		  rxOptions.ReplaceAllMatches = True
		  
		  Dim replacedText As String = rx.Replace( dateStr )
		  
		  
		  Dim dt As DateTime = DateTime.FromString(replacedText, nil, new TimeZone(0))
		  
		  Return dt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindKeyValuePair(xml as string, key as String) As Variant
		  Dim rx As New RegEx
		  rx.SearchPattern = "(?Umsi)<key>" + key + "</key>"
		  
		  Dim rm As RegExMatch = rx.Search(xml)
		  If rm = Nil Then
		    Return Nil
		  End If
		  
		  Dim p As Integer = rx.SearchStartPosition
		  
		  rx.SearchPattern = "(?Umsi)<(string|integer|date)>(.*)</\1>"
		  rm = rx.Search
		  
		  If rm = Nil Then
		    rx.SearchStartPosition = p
		    rx.SearchPattern = "(?Umsi)<(true|false)/>"
		    rm = rx.Search
		    
		    If rm = Nil Then
		      Return Nil
		    End If
		    
		    return rm.SubExpressionString(1) = "true"
		  End If
		  
		  Return rm.SubExpressionString(2)
		End Function
	#tag EndMethod


	#tag Constant, Name = kRemove, Type = String, Dynamic = False, Default = \"Remove", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kShowInFinder, Type = String, Dynamic = False, Default = \"Show In Finder", Scope = Protected
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
