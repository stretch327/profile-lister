#tag Class
Protected Class AppleJWT
	#tag Method, Flags = &h21
		Private Sub Constructor(validMinutes as integer = 2)
		  mIssuer = prefs.Value("issuer")
		  mKeyFile = prefs.Value("keyfilepath")
		  mKeyID = prefs.Value("keyid")
		  mMinutes = validMinutes
		  Reset
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Create() As AppleJWT
		  If Not prefs.HasKey("issuer") Or Not prefs.HasKey("keyid") Or Not prefs.HasKey("keyfilepath") Then
		    Return Nil
		  End If
		  
		  If mSharedInstance = Nil Then
		    mSharedInstance = New AppleJWT(2)
		  End If
		  
		  Return mSharedInstance
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Header() As String
		  Dim js As New JSONItem
		  
		  js.Value("alg") = "ES256"
		  js.Value("kid") = mKeyID
		  js.Value("typ") = "JWT"
		  
		  Return js.ToString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Payload() As String
		  Dim js As New JSONItem
		  
		  Dim nowSeconds As Double = mCreateTime.SecondsFrom1970
		  Dim expSeconds As Double = mExpireTime.SecondsFrom1970
		  js.Value("iss") = mIssuer
		  js.Value("iat") = nowSeconds
		  js.Value("exp") = expSeconds
		  js.Value("aud") = "appstoreconnect-v1"
		  
		  return js.ToString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Reset()
		  mCreateTime = DateTime.Now
		  
		  Dim expDelta As Integer = mMinutes * 60
		  mExpireTime = New DateTime(mCreateTime.SecondsFrom1970 + expDelta)
		  
		  mToken = ""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SignedToken() As String
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib "Foundation" (name As cfstringref) As ptr
		    
		    // @property(class, readonly, strong) NSBundle *mainBundle;
		    Declare Function getMainBundle Lib "Foundation" Selector "mainBundle" (cls As ptr) As Ptr
		    
		    // - (NSString *)pathForAuxiliaryExecutable:(NSString *)executableName;
		    Declare Function pathForAuxiliaryExecutable_ Lib "Foundation" Selector "pathForAuxiliaryExecutable:" (obj As ptr, executableName As CFStringRef) As CFStringRef
		    // @property(readonly, copy) NSString *bundlePath;
		    Declare Function getBundlePath Lib "Foundation" Selector "bundlePath" (obj As ptr) As CFStringRef
		    
		    Dim mainBundle As ptr = getMainBundle(NSClassFromString("NSBundle"))
		    
		    Dim jwtPath As String = getBundlePath(mainBundle) + "/Contents/Helpers/jwtsign"
		    
		    Dim cmd As String = param("""" + jwtPath + """ -header '%1' -payload '%2' -key ""%3""", header, payload, mKeyFile)
		    
		    Dim sh As New Shell
		    
		    sh.Execute(cmd)
		    If sh.ErrorCode = 0 Then
		      Return Trim(sh.Result)
		    End If
		  #EndIf
		  
		  Return ""
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return (DateTime.Now.SecondsFrom1970 > mExpireTime.SecondsFrom1970)
			End Get
		#tag EndGetter
		Expired As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mCreateTime As DateTime
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mExpireTime As DateTime
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIssuer As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mKeyFile As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mKeyID As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMinutes As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared mSharedInstance As AppleJWT
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mToken As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If Expired Then
			    Reset
			  End If
			  
			  If mToken = "" Then
			    mToken = SignedToken
			  End If
			  
			  Return mToken
			End Get
		#tag EndGetter
		Token As String
	#tag EndComputedProperty


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
			Name="Expired"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Token"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
