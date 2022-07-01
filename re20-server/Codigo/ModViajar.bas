Attribute VB_Name = "ModViajar"

'
Public Sub IniciarTransporte(ByVal userindex As Integer)
        
        On Error GoTo IniciarTransporte_Err
        

        Dim destinos As Byte

100     destinos = NpcList(UserList(userindex).flags.TargetNPC).NumDestinos

        
        Exit Sub

IniciarTransporte_Err:
102     Call TraceError(Err.Number, Err.Description, "ModViajar.IniciarTransporte", Erl)
104
        
End Sub
