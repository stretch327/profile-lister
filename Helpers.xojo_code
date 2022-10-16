#tag Module
Protected Module Helpers
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
