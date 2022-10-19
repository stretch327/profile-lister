#tag Class
Protected Class Plist2JSON
Inherits XMLReader
	#tag Event
		Sub AttlistDecl(elname as String, attname as String, att_type as String, dflt as String, isrequired as Boolean)
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Characters(s as String)
		  mCurrentNodeContent = trim(mCurrentNodeContent + s)
		End Sub
	#tag EndEvent

	#tag Event
		Sub Comment(data as String)
		  // ignore comments
		End Sub
	#tag EndEvent

	#tag Event
		Sub Default(s as String)
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub ElementDecl(name as String, content as XmlContentModel)
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub EndCDATA()
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub EndDoctypeDecl()
		  //
		End Sub
	#tag EndEvent

	#tag Event
		Sub EndDocument()
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub EndElement(name as String)
		  If CurrentNode = Nil Then
		    Return
		  End If
		  
		  If CurrentNode.IsArray Then
		    Select Case name
		    Case "true"
		      CurrentNode.Add True
		    Case "false"
		      CurrentNode.add False
		    Case "array", "dict"
		      // take the element off the stack
		      Call mNodeStack.Pop
		    Case "real"
		      CurrentNode.Add Val(mCurrentNodeContent)
		    Case "integer"
		      CurrentNode.Add CType(Val(mCurrentNodeContent), Integer)
		    Case Else
		      CurrentNode.add mCurrentNodeContent
		    End Select
		  Else
		    Select Case name
		    Case "key"
		      mLastKeyName = mCurrentNodeContent
		      
		    Case "dict"
		      Call mNodeStack.Pop
		      
		    Case "array"
		      Call mNodeStack.Pop
		      
		    Case "true"
		      CurrentNode.Value(mLastKeyName) = True
		      
		    Case "false"
		      CurrentNode.Value(mLastKeyName) = False
		      
		    Case "real"
		      CurrentNode.Value(mLastKeyName) = Val(mCurrentNodeContent)
		      
		    Case "integer"
		      CurrentNode.Value(mLastKeyName) = CType(Val(mCurrentNodeContent), Integer)
		      
		    Case Else
		      CurrentNode.Value(mLastKeyName) = mCurrentNodeContent
		      
		    End Select
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub EndPrefixMapping(prefix as String)
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub EntityDecl(entityName as String, is_parameter_entity as Boolean, value as String, base as String, systemId as String, publicId as String, notationName as String)
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function ExternalEntityRef(context as String, base as String, systemId as String, publicId as String) As Boolean
		  return True
		End Function
	#tag EndEvent

	#tag Event
		Sub NotationDecl(notationName as String, base as String, systemId as String, publicId as String)
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function NotStandalone() As Boolean
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub ProcessingInstruction(target as String, data as String)
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub SkippedEntity(entityName as String, is_parameter_entity as Boolean)
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub StartCDATA()
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub StartDoctypeDecl(doctypeName as String, systemId as String, publicId as String, has_internal_subset as Boolean)
		  If publicId<>"-//Apple//DTD PLIST 1.0//EN" Then
		    
		  End If
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub StartDocument()
		  mJSONData = New JSONItem
		  
		  mNodeStack.add mJSONData
		End Sub
	#tag EndEvent

	#tag Event
		Sub StartElement(name as String, attributeList as XmlAttributeList)
		  mCurrentNodeContent = ""
		  If mLastKeyName <> "" Then
		    Select Case name
		    Case "array"
		      mNodeStack.Add CreateArray(CurrentNode, mLastKeyName)
		    Case "dict"
		      mNodeStack.Add create(CurrentNode, mLastKeyName)
		    End Select
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub StartPrefixMapping(prefix as String, uri as String)
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub XmlDecl(version as String, xmlEncoding as String, standalone as Boolean)
		  // ignore
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function Create(parent as JSONItem, name as String) As JSONItem
		  Dim js As New JSONItem
		  parent.Value(name) = js
		  Return js
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CreateArray(parent as JSONItem, name as String) As JSONItem
		  Dim js As New JSONItem("[]")
		  parent.Value(name) = js
		  Return js
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CurrentNode() As JSONItem
		  If UBound(mNodeStack) = -1 Then
		    Return Nil
		  End If
		  
		  Return mNodeStack(UBound(mNodeStack))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FirstNode() As JSONItem
		  Return mJSONData
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Parse(file As FolderItem)
		  // Calling the overridden superclass method.
		  Super.Parse(file)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Parse(file As FolderItem, isFinal As Boolean)
		  // Calling the overridden superclass method.
		  Super.Parse(file, isFinal)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Parse(s As String)
		  // Calling the overridden superclass method.
		  Super.Parse(s)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Parse(plistData as String) As JSONItem
		  // first we strip off any signature info
		  Dim rx As New RegEx
		  rx.SearchPattern = "(?msi-U)(<\?xml.*</plist>)"
		  rx.Options.LineEndType = 4
		  Dim rm As RegExMatch = rx.Search(plistData)
		  If rm = Nil Then
		    Raise New UnsupportedFormatException("The passed data did not contain a plist")
		    Return Nil
		  End If
		  
		  // Load into an XMLDocument to try for an error
		  Dim data As String = rm.SubExpressionString(1)
		  Dim xml As New XmlDocument
		  xml.LoadXml(data)
		  
		  // Do the conversion
		  Dim parser As New Plist2JSON
		  parser.Parse(data)
		  
		  parser.FirstNode.Compact = False
		  
		  Return parser.FirstNode
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Parse(s As String, isFinal As Boolean)
		  // Calling the overridden superclass method.
		  Super.Parse(s, isFinal)
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mCurrentNodeContent As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mJSONData As JSONItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastKeyName As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNodeParts As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNodeStack() As JSONItem
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
			InitialValue=""
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
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Base"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentLineNumber"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentColumnNumber"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentByteIndex"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentByteCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ErrorCode"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SetDefaultHandler"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SetDefaultHandlerExpand"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
