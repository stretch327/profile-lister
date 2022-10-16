#tag DesktopWindow
Begin DesktopWindow Window1
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   True
   HasMinimizeButton=   True
   Height          =   400
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   15990783
   MenuBarVisible  =   False
   MinimumHeight   =   400
   MinimumWidth    =   800
   Resizeable      =   True
   Title           =   "Profiles"
   Type            =   0
   Visible         =   True
   Width           =   800
   Begin DesktopListBox ListBox1
      AllowAutoDeactivate=   True
      AllowAutoHideScrollbars=   True
      AllowExpandableRows=   False
      AllowFocusRing  =   False
      AllowResizableColumns=   True
      AllowRowDragging=   False
      AllowRowReordering=   False
      Bold            =   False
      ColumnCount     =   9
      ColumnWidths    =   "*,*,100,40,*,70,*,50,50"
      DefaultRowHeight=   -1
      DropIndicatorVisible=   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      GridLineStyle   =   0
      HasBorder       =   True
      HasHeader       =   True
      HasHorizontalScrollbar=   False
      HasVerticalScrollbar=   True
      HeadingIndex    =   -1
      Height          =   400
      Index           =   -2147483648
      InitialValue    =   "Name	AppID	Exp Date	OS	Team	TTL	UUID	Type	Xcode"
      Italic          =   False
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      RequiresSelection=   False
      RowSelectionType=   1
      Scope           =   2
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   0
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   800
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Sub Opening()
		  RefreshProfileList
		End Sub
	#tag EndEvent


	#tag MenuHandler
		Function EditPreferences() As Boolean Handles EditPreferences.Action
			Dim w As New PrefsWindow
			w.ShowModal(self)
			Return True
			
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ProfilesCleanup() As Boolean Handles ProfilesCleanup.Action
		  // find all of the expired profiles and remove them
		  
		  Dim md As New MessageDialog
		  md.CancelButton.Visible = True
		  md.Message = "Are you sure you want to remove all expired profiles?"
		  Dim btn As MessageDialogButton = md.ShowModal(Self)
		  Dim now As Double = DateTime.Now.SecondsFrom1970
		  If btn = md.ActionButton Then
		    For i As Integer = 0 To UBound(mProfiles)
		      If mProfiles(i).ExpirationDate.SecondsFrom1970 < now Then
		        Try
		          mProfiles(i).file.MoveTo SpecialFolder.Trash
		        Catch ex As IOException
		          mProfiles(i).file.Delete
		        End Try
		      End If
		    Next
		    RefreshProfileList
		  End If
		  Return True
		  
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function ProfilesRefresh() As Boolean Handles ProfilesRefresh.Action
		  RefreshProfileList
		  Return True
		  
		End Function
	#tag EndMenuHandler


	#tag Method, Flags = &h21
		Private Sub RefreshProfileList()
		  Try
		    Dim f As FolderItem = SpecialFolder.UserLibrary.Child("MobileDevice").Child("Provisioning Profiles")
		    
		    Redim mProfiles(-1)
		    Dim sortOrder() As Integer
		    
		    For Each child As FolderItem In f.Children
		      Try
		        Dim tis As TextInputStream = TextInputStream.Open(child)
		        Dim data As String = tis.ReadAll(encodings.UTF8)
		        tis.Close
		        
		        data = DefineEncoding(data, encodings.ASCII)
		        
		        Dim rx As New RegEx
		        rx.SearchPattern = "(?msi-U)(<\?xml.*</plist>)"
		        rx.Options.LineEndType = 4
		        Dim rm As RegExMatch = rx.Search(data)
		        If rm = Nil Then
		          Continue
		        End If
		        
		        Dim plistdata As String = rm.SubExpressionString(1)
		        
		        // make sure it's a valid plist file
		        Dim xml As New XmlDocument
		        xml.LoadXml(plistdata)
		        
		        // extract the parts we want
		        Dim p As New profile
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
		        p.TeamIDs = FindKeyValuePair(plistdata, "teamids")
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
		        p.file = child
		        mProfiles.Add p
		        
		        sortOrder.Add p.ExpirationDate.SecondsFrom1970
		      Catch ex As NilObjectException
		        
		      Catch ex As IOException
		        
		      Catch ex As OutOfBoundsException
		        
		      End Try
		    Next
		    
		    sortOrder.SortWith(mProfiles)
		    
		    listbox1.RemoveAllRows
		    
		    For i As Integer = 0 To UBound(mProfiles)
		      listbox1.AddRow ""
		      Dim datum() As String = mProfiles(i).AllData
		      For j As Integer = 0 To  UBound(datum)
		        listbox1.CellTextAt(listbox1.LastAddedRowIndex, j) = datum(j)
		      Next
		      listbox1.RowTagAt(listbox1.LastAddedRowIndex) = mProfiles(i).file
		    Next
		  Catch ex As NilObjectException
		    
		  End Try
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mProfiles() As profile
	#tag EndProperty


	#tag Constant, Name = kDateColumn, Type = Double, Dynamic = False, Default = \"2", Scope = Private
	#tag EndConstant


#tag EndWindowCode

#tag Events ListBox1
	#tag Event
		Function ConstructContextualMenu(base As DesktopMenuItem, x As Integer, y As Integer) As Boolean
		  Dim row As Integer = Me.RowFromXY(x,y)
		  If row = -1 Then
		    Return False
		  End If
		  
		  If Me.SelectedRowCount = 1 Then
		    base.AddMenu(New DesktopMenuItem(strings.kShowInFinder))
		  End If
		  base.AddMenu(New DesktopMenuItem("-"))
		  base.AddMenu(New DesktopMenuItem(strings.kRemove))
		  
		  Return True
		End Function
	#tag EndEvent
	#tag Event
		Function ContextualMenuItemSelected(selectedItem As DesktopMenuItem) As Boolean
		  Select Case selectedItem.Text
		  Case strings.kRemove
		    Dim c As Integer = Me.SelectedRowCount
		    If c > 0 Then
		      For i As Integer = Me.RowCount-1 DownTo 0
		        If Me.RowSelectedAt(i) Then
		          Dim row As Integer = i
		          Dim f As FolderItem = Me.RowTagAt(row)
		          If f= Nil Then
		            Return False
		          End If
		          
		          f.MoveTo SpecialFolder.Trash
		          
		          Me.RemoveRowAt(row)
		        End If
		      Next
		    End If
		  Case strings.kShowInFinder
		    Dim row As Integer = Me.SelectedRowIndex
		    If row = -1 Then
		      Return False
		    End If
		    
		    Dim f As FolderItem = Me.RowTagAt(row)
		    
		    Declare Function NSClassFromString Lib "Foundation" (name As cfstringref) As ptr
		    // @property(class, readonly, strong) NSWorkspace *sharedWorkspace;
		    Declare Function getSharedWorkspace Lib "Foundation" Selector "sharedWorkspace" (obj As ptr) As Ptr
		    
		    Dim sharedWorkspace As ptr = getSharedWorkspace(NSClassFromString("NSWorkspace"))
		    
		    // - (BOOL)selectFile:(NSString *)fullPath inFileViewerRootedAtPath:(NSString *)rootFullPath;
		    Declare Function selectFile_inFileViewerRootedAtPath_ Lib "Foundation" Selector "selectFile:inFileViewerRootedAtPath:" ( obj As ptr , fullPath As CFStringRef , rootFullPath As CFStringRef ) As Boolean
		    
		    call selectFile_inFileViewerRootedAtPath_(sharedWorkspace, f.NativePath, "")
		  Case Else
		    Return False
		  End Select
		  
		  
		  Return True
		End Function
	#tag EndEvent
	#tag Event
		Function PaintCellText(g as Graphics, row as Integer, column as Integer, x as Integer, y as Integer) As Boolean
		  Dim txt As String = Me.CellTextAt(row, column)
		  Dim changed As Boolean = False
		  
		  g.DrawingColor = TextColor
		  
		  Dim tzgmt As New TimeZone(0)
		  Dim itemDate As DateTime = DateTime.FromString(Me.CellTextAt(row, kDateColumn), Nil, tzgmt)
		  
		  // items expiring in the next week should be orange
		  Dim nextWeek As Double = DateTime.Now.SecondsFrom1970 + 86400 * 7
		  If itemDate.SecondsFrom1970 < nextWeek Then
		    g.DrawingColor = ColorGroup.NamedColor("systemOrangeColor")
		  End If
		  
		  // items already expired should be red
		  If (txt.IndexOf("*") > -1) or itemDate.SecondsFrom1970 < DateTime.Now.SecondsFrom1970 then
		    g.DrawingColor = ColorGroup.NamedColor("systemRedColor")
		    changed = True
		  End If
		  
		  Select Case column
		  Case 8 // xcode
		    g.Bold = (txt = "Y")
		    changed = True
		    
		  Case 7 // Dev/Dist
		    g.Bold = (txt = "Dist")
		    changed = True
		    
		  End Select
		  
		  // lastly, if the row is selected then make the text the right color
		  If Me.RowSelectedAt(row) Then
		    g.DrawingColor = ColorGroup.NamedColor("selectedMenuItemTextColor")
		  End If
		  
		  If changed = True Then
		    g.DrawText txt, x, y
		  End If
		  
		  Return changed
		  
		  
		  
		End Function
	#tag EndEvent
#tag EndEvents
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
		Name="Interfaces"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
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
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Metal Window"
			"11 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=false
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="2"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Windows Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&cFFFFFF"
		Type="ColorGroup"
		EditorType="ColorGroup"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Menus"
		InitialValue=""
		Type="DesktopMenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Deprecated"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
