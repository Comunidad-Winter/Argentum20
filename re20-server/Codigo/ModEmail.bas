Attribute VB_Name = "ModCuentas"

Option Explicit

Public Function GetUserGuildIndex(ByVal UserName As String) As Integer
        
        On Error GoTo GetUserGuildIndex_Err

100     If InStrB(UserName, "\") <> 0 Then
102         UserName = Replace(UserName, "\", vbNullString)
        End If

104     If InStrB(UserName, "/") <> 0 Then
106         UserName = Replace(UserName, "/", vbNullString)
        End If

108     If InStrB(UserName, ".") <> 0 Then
110         UserName = Replace(UserName, ".", vbNullString)
        End If

116     GetUserGuildIndex = GetUserGuildIndexDatabase(UserName)

        Exit Function

GetUserGuildIndex_Err:
118     Call TraceError(Err.Number, Err.Description, "ModCuentas.GetUserGuildIndex", Erl)

End Function

Public Function ObtenerCriminal(ByVal name As String) As Byte

        On Error GoTo ErrorHandler
    
        Dim Criminal As Byte

102     Criminal = GetUserStatusDatabase(name)

106     If EsRolesMaster(name) Then
108         Criminal = 3
110     ElseIf EsConsejero(name) Then
112         Criminal = 4
114     ElseIf EsSemiDios(name) Then
116         Criminal = 5
118     ElseIf EsDios(name) Then
120         Criminal = 6
122     ElseIf EsAdmin(name) Then
124         Criminal = 7
        End If

126     ObtenerCriminal = Criminal

        Exit Function
ErrorHandler:
128     ObtenerCriminal = 1

End Function
