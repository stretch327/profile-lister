#tag Class
Protected Class profile
	#tag Method, Flags = &h0
		Function AllData() As String()
		  Dim arr() As String
		  arr.Add name
		  arr.add ApplicationIdentifier
		  arr.Add ExpirationDate.SQLDateTime
		  arr.Add Platform
		  arr.Add TeamName
		  arr.Add TimeToLive.ToString + " Days"
		  arr.Add UUID
		  arr.Add If(DevProfile, "Dev", "Dist")
		  arr.add if(XcodeManaged, "Y", "N")
		  Return arr
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		AppIDName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ApplicationIdentifier As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ApplicationIdentifierPrefix As String
	#tag EndProperty

	#tag Property, Flags = &h0
		CreationDate As DateTime
	#tag EndProperty

	#tag Property, Flags = &h0
		DevProfile As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		Entitlements As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		ExpirationDate As DateTime
	#tag EndProperty

	#tag Property, Flags = &h0
		file As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0
		Name As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Platform As String
	#tag EndProperty

	#tag Property, Flags = &h0
		TeamIDs As String
	#tag EndProperty

	#tag Property, Flags = &h0
		TeamName As String
	#tag EndProperty

	#tag Property, Flags = &h0
		TimeToLive As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		UUID As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Version As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		XcodeManaged As Boolean
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
		#tag ViewProperty
			Name="TeamIDs"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TeamName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TimeToLive"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="UUID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Version"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="XcodeManaged"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Platform"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ApplicationIdentifierPrefix"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AppIDName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ApplicationIdentifier"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DevProfile"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
