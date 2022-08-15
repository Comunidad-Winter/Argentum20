Attribute VB_Name = "Extra"
Option Explicit

Public Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationname As String, ByVal lpKeyname As Any, ByVal lpdefault As String, ByVal lpreturnedstring As String, ByVal nSize As Long, ByVal lpfilename As String) As Long

Function GetVar(ByVal File As String, ByVal Main As String, ByVal Var As String, Optional EmptySpaces As Long = 1024) As String
        
    Dim sSpaces  As String ' This will hold the input that the program will retrieve
    Dim szReturn As String ' This will be the defaul value if the string is not found
    
    szReturn = vbNullString
    
    sSpaces = Space$(EmptySpaces) ' This tells the computer how long the longest string can be
    
    GetPrivateProfileString Main, Var, szReturn, sSpaces, EmptySpaces, File
    
    GetVar = RTrim$(sSpaces)
    GetVar = Left$(GetVar, Len(GetVar) - 1)

End Function

Public Sub LogDatabaseError(Desc As String)
        '***************************************************
        'Author: Juan Andres Dalmasso (CHOTS)
        'Last Modification: 09/10/2018
        '***************************************************

        On Error GoTo ErrHandler

        Dim nfile As Integer

100     nfile = FreeFile ' obtenemos un canal
    
102     Open App.Path & "\Errores.log" For Append Shared As #nfile
104     Print #nfile, Date & " " & Time & " - " & Desc
106     Close #nfile
     
108     Debug.Print "Error en la BD: " & Desc & vbNewLine & _
            "Fecha y Hora: " & Date$ & "-" & Time$ & vbNewLine
            
        Exit Sub
    
ErrHandler:

End Sub

