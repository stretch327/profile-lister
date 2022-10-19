#tag Module
Protected Module Helpers
	#tag Method, Flags = &h0
		Function MonospacedFont() As String
		  #If TargetMacOS
		    Declare Function NSClassFromString Lib "Foundation" (name As cfstringref) As ptr
		    
		    // + (NSFont *)monospacedSystemFontOfSize:(CGFloat)fontSize weight:(NSFontWeight)weight;
		    Declare Function monospacedSystemFontOfSize_weight_ Lib "Foundation" Selector "monospacedSystemFontOfSize:weight:" (cls As ptr, fontSize As Double, weight As Double) As Ptr
		    
		    // @property(nullable, readonly, copy) NSString *displayName;
		    Declare Function getDisplayName Lib "Foundation" Selector "displayName" (obj As ptr) As CFStringRef
		    
		    Static MonospacedFontName As String
		    
		    If MonospacedFontName="" Then
		      If System.Version >= "10.15" Then
		        Dim NSFont As ptr = NSClassFromString("NSFont")
		        Dim Font As ptr = monospacedSystemFontOfSize_weight_(NSFont, 12, 0.0)
		        MonospacedFontName = getDisplayName(Font)
		      Else
		        // Otherwise we'll use "Courier" or the first font we find with "Mono" in the name
		        Dim names() As String
		        For i As Integer = 0 To System.FontCount-1
		          Dim s As String = System.FontAt(i)
		          If s.Left(6) = "Courier" Or s.IndexOf("Mono") > 0 Then
		            MonospacedFontName = s
		            Exit For i
		          End If
		        Next
		        If MonospacedFontName = "" Then
		          MonospacedFontName = "System"
		        End If
		      End If
		    End If
		    
		    Return MonospacedFontName
		    
		  #EndIf
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MsgBoxPlus(parentWindow as DesktopWIndow, message as string, altMessage as string = "", ActionButtonCaption as string = "OK", CancelButtonCaption as string = "Cancel", AltButtonCaption as string = "") As String
		  Dim md As New MessageDialog
		  md.Message = message
		  md.Explanation = altMessage
		  
		  md.ActionButton.Caption = ActionButtonCaption
		  md.ActionButton.Visible = ActionButtonCaption<>""
		  
		  md.CancelButton.Caption = CancelButtonCaption
		  md.CancelButton.Visible = CancelButtonCaption<>""
		  
		  md.AlternateActionButton.Caption = AltButtonCaption
		  md.AlternateActionButton.Visible = AltButtonCaption<>""
		  
		  Dim mdb As MessageDialogButton = md.ShowModal(parentWindow)
		  Return mdb.Caption
		End Function
	#tag EndMethod


End Module
#tag EndModule
