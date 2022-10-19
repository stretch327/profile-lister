#tag Module
Protected Module ListboxExtensions
	#tag Method, Flags = &h0
		Function MeasureText(extends lb as DesktopListbox, aString as string) As Double
		  Static p As Picture
		  
		  If p = Nil Then
		    p = New Picture(1,1)
		  End If
		  
		  Dim g As Graphics = p.Graphics
		  
		  g.FontName = MonospacedFont
		  g.FontSize = lb.FontSize
		  
		  return g.TextWidth(aString)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetColumnWidthAt(extends lb as DesktopListBox, index as integer, width as Double)
		  Dim sa() As String = lb.ColumnWidths.Split(",")
		  
		  sa(index) = Str(width)
		  
		  lb.ColumnWidths = join(sa, ",")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetColumnWidthAt(extends lb as DesktopListBox, index as integer, width as String)
		  Dim sa() As String = lb.ColumnWidths.Split(",")
		  
		  sa(index) = Str(width)
		  
		  lb.ColumnWidths = join(sa, ",")
		End Sub
	#tag EndMethod


End Module
#tag EndModule
