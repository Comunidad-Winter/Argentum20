Attribute VB_Name = "modInvisibles"

Option Explicit

' 0 = viejo
' 1 = nuevo
#Const MODO_INVISIBILIDAD = 0

' cambia el estado de invisibilidad a 1 o 0 dependiendo del modo: true o false
'
Public Sub PonerInvisible(ByVal userindex As Integer, ByVal estado As Boolean)
        
        On Error GoTo PonerInvisible_Err
        
        #If MODO_INVISIBILIDAD = 0 Then

100         UserList(userindex).flags.invisible = IIf(estado, 1, 0)
102         UserList(userindex).flags.Oculto = IIf(estado, 1, 0)
104         UserList(userindex).Counters.Invisibilidad = 0

106         Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageSetInvisible(UserList(userindex).Char.CharIndex, Not estado))

        #Else

            Dim EstadoActual As Boolean

            ' Está invisible ?
108         EstadoActual = (UserList(userindex).flags.invisible = 1)

            'If EstadoActual <> Modo Then
110         If Modo = True Then
                ' Cuando se hace INVISIBLE se les envia a los
                ' clientes un Borrar Char
112             UserList(userindex).flags.invisible = 1
                '        'Call SendData(SendTarget.ToMap, 0, UserList(UserIndex).Pos.Map, "NOVER" & UserList(UserIndex).Char.CharIndex & ",1")
114             Call SendData(SendTarget.toMap, UserList(userindex).Pos.Map, PrepareMessageCharacterRemove(1, UserList(userindex).Char.CharIndex, True))
            Else
        
            End If

            'End If

        #End If

        
        Exit Sub

PonerInvisible_Err:
116     Call TraceError(Err.Number, Err.Description, "modInvisibles.PonerInvisible", Erl)

        
End Sub

