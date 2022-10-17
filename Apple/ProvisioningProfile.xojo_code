#tag Class
Class ProvisioningProfile
	#tag Method, Flags = &h0
		Shared Function CreateFromPlist(plistData as string) As ProvisioningProfile
		  Try
		    // Strip off any signature info that we got
		    Dim rx As New RegEx
		    rx.SearchPattern = "(?msi-U)(<\?xml.*</plist>)"
		    rx.Options.LineEndType = 4
		    Dim rm As RegExMatch = rx.Search(plistData)
		    If rm = Nil Then
		      Return Nil
		    End If
		    
		    Dim data As String = rm.SubExpressionString(1)
		    
		    // make sure it's a valid plist file
		    Dim xml As New XmlDocument
		    xml.LoadXml(data)
		    
		    // extract the parts we want
		    Dim p As New ProvisioningProfile
		    p.AppIDName = FindKeyValuePair(plistdata, "AppIDName")
		    Dim appID As String = FindKeyValuePair(plistdata, "application-identifier")
		    If appID = "" Then
		      appID = FindKeyValuePair(plistdata,"com.apple.application-identifier")
		    End If
		    
		    p.ApplicationIdentifier = appID
		    p.ApplicationIdentifierPrefix = FindKeyValuePair(plistdata, "ApplicationIdentifierPrefix")
		    p.CreationDate = FindKeyValuePair(plistdata, "CreationDate").StringValue.ConvertUTCDate
		    p.ExpirationDate = FindKeyValuePair(plistdata, "ExpirationDate").StringValue.ConvertUTCDate
		    p.Name = FindKeyValuePair(plistdata, "name")
		    p.Platform = FindKeyValuePair(plistdata, "platform")
		    p.TeamIDs = FindKeyValuePair(plistdata, "TeamIdentifier")
		    p.TeamName = FindKeyValuePair(plistdata, "teamName")
		    p.TimeToLive = FindKeyValuePair(plistdata, "timeToLive")
		    p.UUID = FindKeyValuePair(plistdata, "UUID")
		    p.Version = FindKeyValuePair(plistdata, "version")
		    p.XcodeManaged = FindKeyValuePair(plistdata, "IsXcodeManaged")
		    Dim device As String = FindKeyValuePair(plistdata, "ProvisionedDevices")
		    If device = "" Then
		      p.DevProfile = False
		    Else
		      p.DevProfile = True
		    End If
		    
		    Return p
		  Catch ex As XmlException
		    
		  End Try
		  
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Filename() As String
		  Dim sa() As String
		  sa.add UUID
		  sa.Add "."
		  If Platform = "OSX" Then
		    sa.add "provisionprofile"
		  Else
		    sa.Add "mobileprovision"
		  End If
		  
		  return join(sa,"")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ListboxData() As String()
		  Dim arr() As String
		  arr.Add name
		  arr.add ApplicationIdentifier
		  If AppleStatus<>"" And AppleStatus<>"ACTIVE" Then
		    arr.Add AppleStatus
		  Else
		    arr.Add ExpirationDate.SQLDateTime
		  End If
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
		AppleID As String = "#kNonAppleID"
	#tag EndProperty

	#tag Property, Flags = &h0
		AppleStatus As String
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

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return Apple.ProfilesDirectory.Child(Self.Filename)
			End Get
		#tag EndGetter
		file As FolderItem
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		FileData As String
	#tag EndProperty

	#tag Property, Flags = &h0
		HelpTag As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return AppleStatus = "INVALID"
			End Get
		#tag EndGetter
		Invalid As Boolean
	#tag EndComputedProperty

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
		Valid As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		Version As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		XcodeManaged As Boolean
	#tag EndProperty


	#tag Constant, Name = kNonAppleID, Type = String, Dynamic = False, Default = \"-", Scope = Public
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
		#tag ViewProperty
			Name="AppleID"
			Visible=false
			Group="Behavior"
			InitialValue="No Apple Connection"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AppleStatus"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FileData"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HelpTag"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Valid"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Invalid"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
