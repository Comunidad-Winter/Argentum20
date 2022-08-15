Attribute VB_Name = "modUtils"
Option Explicit

Public Function FileExist(ByVal File As String, Optional FileType As VbFileAttribute = vbNormal) As Boolean
        '*****************************************************************
        'Se fija si existe el archivo
        '*****************************************************************
        
        On Error GoTo FileExist_Err
        
100     FileExist = LenB(Dir$(File, FileType)) <> 0

        
        Exit Function

FileExist_Err:
102     MsgBox "General.FileExist"
End Function

Function ReadField(ByVal Pos As Integer, ByRef Text As String, ByVal SepASCII As Byte) As String
        
        On Error GoTo ReadField_Err
        
        Dim i          As Long

        Dim LastPos    As Long

        Dim currentPos As Long

        Dim delimiter  As String * 1
    
100     delimiter = Chr$(SepASCII)
    
102     For i = 1 To Pos
104         LastPos = currentPos
106         currentPos = InStr(LastPos + 1, Text, delimiter, vbBinaryCompare)
108     Next i
    
110     If currentPos = 0 Then
112         ReadField = mid$(Text, LastPos + 1, Len(Text) - LastPos)
        Else
114         ReadField = mid$(Text, LastPos + 1, currentPos - LastPos - 1)

        End If

        
        Exit Function

ReadField_Err:
116     MsgBox "General.ReadField"
End Function
