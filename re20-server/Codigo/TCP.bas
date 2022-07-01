Attribute VB_Name = "TCP"

'
'Argentum Online 0.11.6
'Copyright (C) 2002 Márquez Pablo Ignacio
'
'This program is free software; you can redistribute it and/or modify
'it under the terms of the Affero General Public License;
'either version 1 of the License, or any later version.
'
'This program is distributed in the hope that it will be useful,
'but WITHOUT ANY WARRANTY; without even the implied warranty of
'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'Affero General Public License for more details.
'
'You should have received a copy of the Affero General Public License
'along with this program; if not, you can find it at http://www.affero.org/oagpl.html
'
'Argentum Online is based on Baronsoft's VB6 Online RPG
'You can contact the original creator of ORE at aaron@baronsoft.com
'for more information about ORE please visit http://www.baronsoft.com/
'
'
'You can contact me at:
'morgolock@speedy.com.ar
'www.geocities.com/gmorgolock
'Calle 3 número 983 piso 7 dto A
'La Plata - Pcia, Buenos Aires - Republica Argentina
'Código Postal 1900
'Pablo Ignacio Márquez

Option Explicit

Sub DarCuerpo(ByVal userindex As Integer)
        
        On Error GoTo DarCuerpo_Err
        

        '*************************************************
        'Author: Nacho (Integer)
        'Last modified: 14/03/2007
        'Elije una cabeza para el usuario y le da un body
        '*************************************************
        Dim NewBody    As Integer

        Dim UserRaza   As Byte

        Dim UserGenero As Byte

100     UserGenero = UserList(userindex).genero
102     UserRaza = UserList(userindex).raza

104     Select Case UserGenero

            Case e_Genero.Hombre

106             Select Case UserRaza

                    Case e_Raza.Humano
108                     NewBody = 1

110                 Case e_Raza.Elfo
112                     NewBody = 2

114                 Case e_Raza.Drow
116                     NewBody = 3

118                 Case e_Raza.Enano
120                     NewBody = 300

122                 Case e_Raza.Gnomo
124                     NewBody = 300

126                 Case e_Raza.Orco
128                     NewBody = 582

                End Select

130         Case e_Genero.Mujer

132             Select Case UserRaza

                    Case e_Raza.Humano
134                     NewBody = 1

136                 Case e_Raza.Elfo
138                     NewBody = 2

140                 Case e_Raza.Drow
142                     NewBody = 3

144                 Case e_Raza.Gnomo
146                     NewBody = 300

148                 Case e_Raza.Enano
150                     NewBody = 300

152                 Case e_Raza.Orco
154                     NewBody = 581

                End Select

        End Select

156     UserList(userindex).Char.Body = NewBody

        
        Exit Sub

DarCuerpo_Err:
158     Call TraceError(Err.Number, Err.Description, "TCP.DarCuerpo", Erl)

        
End Sub

Sub RellenarInventario(ByVal userindex As String)
        
        On Error GoTo RellenarInventario_Err
        

100     With UserList(userindex)
        
            Dim NumItems As Integer

102         NumItems = 1
    
            ' Todos reciben pociones rojas
104         .Invent.Object(NumItems).ObjIndex = 1616 'Pocion Roja
106         .Invent.Object(NumItems).amount = 200
108         NumItems = NumItems + 1
        
            ' Magicas puras reciben más azules
110         Select Case .clase

                Case e_Class.Mage, e_Class.Druid
112                 .Invent.Object(NumItems).ObjIndex = 1617 ' Pocion Azul
114                 .Invent.Object(NumItems).amount = 300
116                 NumItems = NumItems + 1

            End Select
        
            ' Semi mágicas reciben menos
118         Select Case .clase

                Case e_Class.Bard, e_Class.Cleric, e_Class.Paladin, e_Class.Assasin, e_Class.Bandit
120                 .Invent.Object(NumItems).ObjIndex = 1617 ' Pocion Azul
122                 .Invent.Object(NumItems).amount = 100
124                 NumItems = NumItems + 1

            End Select

            ' Hechizos
126         Select Case .clase

                Case e_Class.Mage, e_Class.Cleric, e_Class.Druid, e_Class.Bard
128                 .Stats.UserHechizos(1) = 1 ' Dardo mágico
130                 .Stats.UserHechizos(2) = 11 ' Curar Veneno
132                 .Stats.UserHechizos(3) = 12 ' Curar Heridas Leves

            End Select
        
            ' Pociones amarillas y verdes
134         Select Case .clase

                Case e_Class.Assasin, e_Class.Bard, e_Class.Cleric, e_Class.Hunter, e_Class.Paladin, e_Class.Trabajador, e_Class.Warrior, e_Class.Bandit, e_Class.Pirat, e_Class.Thief
136                 .Invent.Object(NumItems).ObjIndex = 1618 ' Pocion Amarilla
138                 .Invent.Object(NumItems).amount = 50
140                 NumItems = NumItems + 1

142                 .Invent.Object(NumItems).ObjIndex = 1619 ' Pocion Verde
144                 .Invent.Object(NumItems).amount = 25
146                 NumItems = NumItems + 1

            End Select
            
            ' Poción violeta
148         .Invent.Object(NumItems).ObjIndex = 2332 ' Pocion violeta
150         .Invent.Object(NumItems).amount = 20
152         NumItems = NumItems + 1
        
            ' Armas
154         Select Case .clase

                Case e_Class.Cleric, e_Class.Paladin, e_Class.Trabajador, e_Class.Warrior, e_Class.Pirat
156                 .Invent.Object(NumItems).ObjIndex = 460 ' Daga (Newbies)
158                 .Invent.Object(NumItems).amount = 1
160                 NumItems = NumItems + 1
162                 .Invent.Object(NumItems).ObjIndex = 2085 ' Espada larga (newbies)
164                 .Invent.Object(NumItems).amount = 1
166                 NumItems = NumItems + 1

168             Case e_Class.Hunter
170                 .Invent.Object(NumItems).ObjIndex = 460 ' Daga (Newbies)
172                 .Invent.Object(NumItems).amount = 1
174                 NumItems = NumItems + 1
                    
176                 .Invent.Object(NumItems).ObjIndex = 1355 ' Arco simple (newbies)
178                 .Invent.Object(NumItems).amount = 1
180                 NumItems = NumItems + 1

182                 .Invent.Object(NumItems).ObjIndex = 1357 ' Flechas
184                 .Invent.Object(NumItems).amount = 300
186                 NumItems = NumItems + 1

188             Case e_Class.Thief, e_Class.Bandit
190                 .Invent.Object(NumItems).ObjIndex = 460 ' Daga (Newbies)
192                 .Invent.Object(NumItems).amount = 1
194                 NumItems = NumItems + 1
                    
196                 .Invent.Object(NumItems).ObjIndex = 1354 ' Nudillos (newbies)
198                 .Invent.Object(NumItems).amount = 1
200                 NumItems = NumItems + 1

202             Case e_Class.Mage
204                 .Invent.Object(NumItems).ObjIndex = 1356 ' Baston (newbies)
206                 .Invent.Object(NumItems).amount = 1
208                 NumItems = NumItems + 1
                
210             Case e_Class.Assasin, e_Class.Druid, e_Class.Bard
212                 .Invent.Object(NumItems).ObjIndex = 460 ' Daga (Newbies)
214                 .Invent.Object(NumItems).amount = 1
216                 NumItems = NumItems + 1
                    

            End Select
        
            
218         If .genero = e_Genero.Hombre Then
220             If .raza = Enano Or .raza = Gnomo Then
222                 .Invent.Object(NumItems).ObjIndex = 466 'Vestimentas de Bajo (Newbies)
                Else
                
224                 .Invent.Object(NumItems).ObjIndex = RandomNumber(463, 465) ' Vestimentas comunes (Newbies)
                End If
            Else
226             If .raza = Enano Or .raza = Gnomo Then
228                 .Invent.Object(NumItems).ObjIndex = 563 'Vestimentas de Baja (Newbies)
                Else
230                 .Invent.Object(NumItems).ObjIndex = RandomNumber(1283, 1285) ' Vestimentas de Mujer (Newbies)
                End If
            End If
            
            .Invent.Object(NumItems).Equipped = 0
            Call EquiparInvItem(userindex, NumItems)
                        
232         .Invent.Object(NumItems).amount = 1
234         .Invent.Object(NumItems).Equipped = 1
236         .Invent.ArmourEqpSlot = NumItems
238         .Invent.ArmourEqpObjIndex = .Invent.Object(NumItems).ObjIndex
240          NumItems = NumItems + 1

            ' Animación según raza
242          .Char.Body = ObjData(.Invent.ArmourEqpObjIndex).Ropaje
        
            ' Comida y bebida
244         .Invent.Object(NumItems).ObjIndex = 573 ' Manzana
246         .Invent.Object(NumItems).amount = 100
248         NumItems = NumItems + 1

250         .Invent.Object(NumItems).ObjIndex = 572 ' Agua
252         .Invent.Object(NumItems).amount = 100
254         NumItems = NumItems + 1

            ' Seteo la cantidad de items
256         .Invent.NroItems = NumItems
            
            .flags.ModificoInventario = True
            .flags.ModificoHechizos = True
            
        End With
   
        
        Exit Sub

RellenarInventario_Err:
258     Call TraceError(Err.Number, Err.Description, "TCP.RellenarInventario", Erl)

        
End Sub

Function AsciiValidos(ByVal cad As String) As Boolean
        
        On Error GoTo AsciiValidos_Err
        

        Dim car As Byte

        Dim i   As Integer

100     cad = LCase$(cad)

102     For i = 1 To Len(cad)
104         car = Asc(mid$(cad, i, 1))
    
106         If (car < 97 Or car > 122) And (car <> 255) And (car <> 32) Then
108             AsciiValidos = False
                Exit Function

            End If
    
110     Next i

112     AsciiValidos = True

        
        Exit Function

AsciiValidos_Err:
114     Call TraceError(Err.Number, Err.Description, "TCP.AsciiValidos", Erl)

        
End Function

Function DescripcionValida(ByVal cad As String) As Boolean
        
        On Error GoTo AsciiValidos_Err
        

        Dim car As Byte

        Dim i   As Integer

100     cad = LCase$(cad)

102     For i = 1 To Len(cad)
104         car = Asc(mid$(cad, i, 1))
    
106         If car < 32 Or car >= 126 Then
108             DescripcionValida = False
                Exit Function

            End If
    
110     Next i

112     DescripcionValida = True

        
        Exit Function

AsciiValidos_Err:
114     Call TraceError(Err.Number, Err.Description, "TCP.DescripcionValida", Erl)

        
End Function

Function Numeric(ByVal cad As String) As Boolean
        
        On Error GoTo Numeric_Err
        

        Dim car As Byte

        Dim i   As Integer

100     cad = LCase$(cad)

102     For i = 1 To Len(cad)
104         car = Asc(mid$(cad, i, 1))
    
106         If (car < 48 Or car > 57) Then
108             Numeric = False
                Exit Function

            End If
    
110     Next i

112     Numeric = True

        
        Exit Function

Numeric_Err:
114     Call TraceError(Err.Number, Err.Description, "TCP.Numeric", Erl)

        
End Function

Function NombrePermitido(ByVal nombre As String) As Boolean
        
        On Error GoTo NombrePermitido_Err
        

        Dim i As Integer

100     For i = 1 To UBound(ForbidenNames)

102         If LCase$(nombre) = ForbidenNames(i) Then
104             NombrePermitido = False
                Exit Function

            End If

106     Next i

108     NombrePermitido = True

        
        Exit Function

NombrePermitido_Err:
110     Call TraceError(Err.Number, Err.Description, "TCP.NombrePermitido", Erl)

        
End Function

Function Validate_Skills(ByVal userindex As Integer) As Boolean
        
        On Error GoTo Validate_Skills_Err
        

        Dim LoopC As Integer

100     For LoopC = 1 To NUMSKILLS

102         If UserList(userindex).Stats.UserSkills(LoopC) < 0 Then
                Exit Function

104             If UserList(userindex).Stats.UserSkills(LoopC) > 100 Then UserList(userindex).Stats.UserSkills(LoopC) = 100

            End If

106     Next LoopC

108     Validate_Skills = True
    
        
        Exit Function

Validate_Skills_Err:
110     Call TraceError(Err.Number, Err.Description, "TCP.Validate_Skills", Erl)

        
End Function

Function ConnectNewUser(ByVal userindex As Integer, ByRef name As String, ByVal UserRaza As e_Raza, ByVal UserSexo As e_Genero, ByVal UserClase As e_Class, ByVal Head As Integer, ByVal Hogar As e_Ciudad) As Boolean
        '*************************************************
        'Author: Unknown
        'Last modified: 20/4/2007
        'Conecta un nuevo Usuario
        '23/01/2007 Pablo (ToxicWaste) - Agregué ResetFaccion al crear usuario
        '24/01/2007 Pablo (ToxicWaste) - Agregué el nuevo mana inicial de los magos.
        '12/02/2007 Pablo (ToxicWaste) - Puse + 1 de const al Elfo normal.
        '20/04/2007 Pablo (ToxicWaste) - Puse -1 de fuerza al Elfo.
        '09/01/2008 Pablo (ToxicWaste) - Ahora los modificadores de Raza se controlan desde Balance.dat
        '*************************************************
        
        On Error GoTo ConnectNewUser_Err
        
100     With UserList(userindex)
        
            Dim LoopC As Long
        
102         If .flags.UserLogged Then
104             Call LogSecurity("El usuario " & .name & " ha intentado crear a " & name & " desde la IP " & .IP)
106             Call CloseSocketSL(userindex)
108             Call Cerrar_Usuario(userindex)
                Exit Function
            End If
            
            ' Nombre válido
            If Not ValidarNombre(name) Then
                Call LogSecurity("ValidarNombre failed in ConnectNewUser for " & name & " desde la IP " & .IP)
                Call CloseSocketSL(userindex)
                Exit Function
            End If
            
112         If Not NombrePermitido(name) Then
114             Call WriteShowMessageBox(userindex, "El nombre no está permitido.")
                Exit Function
            End If
    
            '¿Existe el personaje?
116         If PersonajeExiste(name) Then
118             Call WriteShowMessageBox(userindex, "Ya existe el personaje.")
                Exit Function
            End If
            
            ' Raza válida
120         If UserRaza <= 0 Or UserRaza > NUMRAZAS Then Exit Function
            
            ' Género válido
122         If UserSexo < Hombre Or UserSexo > Mujer Then Exit Function
            
            ' Ciudad válida
124         If Hogar <= 0 Or Hogar > NUMCIUDADES Then Exit Function
            
            ' Cabeza válida
126         If Not ValidarCabeza(UserRaza, UserSexo, Head) Then Exit Function
            
            'Prevenimos algun bug con dados inválidos
128         'If .Stats.UserAtributos(e_Atributos.Fuerza) = 0 Then Exit Function
        
130         .Stats.UserAtributos(e_Atributos.Fuerza) = 18 + ModRaza(UserRaza).Fuerza
132         .Stats.UserAtributos(e_Atributos.Agilidad) = 18 + ModRaza(UserRaza).Agilidad
134         .Stats.UserAtributos(e_Atributos.Inteligencia) = 18 + ModRaza(UserRaza).Inteligencia
136         .Stats.UserAtributos(e_Atributos.Constitucion) = 18 + ModRaza(UserRaza).Constitucion
138         .Stats.UserAtributos(e_Atributos.Carisma) = 18 + ModRaza(UserRaza).Carisma
            
            .Stats.UserAtributosBackUP(e_Atributos.Fuerza) = .Stats.UserAtributos(e_Atributos.Fuerza)
            .Stats.UserAtributosBackUP(e_Atributos.Agilidad) = .Stats.UserAtributos(e_Atributos.Agilidad)
            .Stats.UserAtributosBackUP(e_Atributos.Inteligencia) = .Stats.UserAtributos(e_Atributos.Inteligencia)
            .Stats.UserAtributosBackUP(e_Atributos.Constitucion) = .Stats.UserAtributos(e_Atributos.Constitucion)
            .Stats.UserAtributosBackUP(e_Atributos.Carisma) = .Stats.UserAtributos(e_Atributos.Carisma)
            
140         .flags.Muerto = 0
142         .flags.Escondido = 0
    
144         .flags.Casado = 0
146         .flags.Pareja = ""
    
148         .name = name

150         .clase = UserClase
152         .raza = UserRaza
        
154         .Char.Head = Head
        
156         .genero = UserSexo
158         .Hogar = Hogar
        
            '%%%%%%%%%%%%% PREVENIR HACKEO DE LOS SKILLS %%%%%%%%%%%%%
160         .Stats.SkillPts = 10
        
162         .Char.Heading = e_Heading.SOUTH
        
164         Call DarCuerpo(userindex) 'Ladder REVISAR
        
166         .OrigChar = .Char
    
168         .Char.WeaponAnim = NingunArma
170         .Char.ShieldAnim = NingunEscudo
172         .Char.CascoAnim = NingunCasco

            ' WyroX: Vida inicial
174         .Stats.MaxHp = .Stats.UserAtributos(e_Atributos.Constitucion)
176         .Stats.MinHp = .Stats.MaxHp

            ' WyroX: Maná inicial
178         .Stats.MaxMAN = .Stats.UserAtributos(e_Atributos.Inteligencia) * ModClase(.clase).ManaInicial
180         .Stats.MinMAN = .Stats.MaxMAN
        
            Dim MiInt As Integer
182         MiInt = RandomNumber(1, .Stats.UserAtributos(e_Atributos.Agilidad) \ 6)
    
184         If MiInt = 1 Then MiInt = 2
        
186         .Stats.MaxSta = 20 * MiInt
188         .Stats.MinSta = 20 * MiInt
        
190         .Stats.MaxAGU = 100
192         .Stats.MinAGU = 100
        
194         .Stats.MaxHam = 100
196         .Stats.MinHam = 100
    
202         .flags.VecesQueMoriste = 0
204         .flags.Montado = 0
    
206         .Stats.MaxHit = 2
208         .Stats.MinHIT = 1
        
210         .Stats.GLD = 0
        
212         .Stats.Exp = 0
214         .Stats.ELV = 1
        
216         Call RellenarInventario(userindex)
    
            #If ConUpTime Then
218             .LogOnTime = Now
220             .UpTime = 0
            #End If
        
            'Valores Default de facciones al Activar nuevo usuario
222         Call ResetFacciones(userindex)
        
224         .Faccion.Status = 1
        
226         .ChatCombate = 1
228         .ChatGlobal = 1
  
            Dim DungeonNewbieCoords(1 To 3) As t_WorldPos
            
234         With DungeonNewbieCoords(1)
236             .Map = 37: .X = 76: .Y = 82
            End With
            
238         With DungeonNewbieCoords(2)
240             .Map = 264: .X = 54: .Y = 70
            End With
            
242         With DungeonNewbieCoords(3)
244             .Map = 168: .X = 50: .Y = 70
            End With

            Dim RandomPosIndex As Byte
246         RandomPosIndex = RandomNumber(LBound(DungeonNewbieCoords), UBound(DungeonNewbieCoords))

248         .Pos.Map = DungeonNewbieCoords(RandomPosIndex).Map
250         .Pos.X = DungeonNewbieCoords(RandomPosIndex).X
252         .Pos.Y = DungeonNewbieCoords(RandomPosIndex).Y
        
254         UltimoChar = UCase$(name)
        
256         Call SaveNewUser(userindex)
    
258         ConnectNewUser = True
    
260         Call ConnectUser(userindex, name, False)

        End With
        
        Exit Function

ConnectNewUser_Err:
262     Call TraceError(Err.Number, Err.Description, "TCP.ConnectNewUser", Erl)

        
End Function

Sub CloseSocket(ByVal userindex As Integer)

    On Error GoTo ErrHandler

102     If userindex = LastUser Then

104         Do Until UserList(LastUser).flags.UserLogged
106             LastUser = LastUser - 1
108             If LastUser < 1 Then Exit Do
            Loop

        End If
    
110     With UserList(userindex)
    
            'Call SecurityIp.IpRestarConexion(api_inetaddr(.ip))

112         If .ConnIDValida Then Call CloseSocketSL(userindex)
    
            'Es el mismo user al que está revisando el centinela??
            'IMPORTANTE!!! hacerlo antes de resetear así todavía sabemos el nombre del user
            ' y lo podemos loguear
114         If Centinela.RevisandoUserIndex = userindex Then Call modCentinela.CentinelaUserLogout
    
            'mato los comercios seguros
116         If .ComUsu.DestUsu > 0 Then
        
118             If UserList(.ComUsu.DestUsu).flags.UserLogged Then
            
120                 If UserList(.ComUsu.DestUsu).ComUsu.DestUsu = userindex Then
                
122                     Call WriteConsoleMsg(.ComUsu.DestUsu, "Comercio cancelado por el otro usuario", e_FontTypeNames.FONTTYPE_TALK)
124                     Call FinComerciarUsu(.ComUsu.DestUsu)
                    
                    End If
    
                End If
    
            End If
    
128         If .flags.UserLogged Then
130             Call CloseUser(userindex)
        
132             If NumUsers > 0 Then NumUsers = NumUsers - 1
        
            Else
136             Call ResetUserSlot(userindex)
    
            End If
    
140         .ConnIDValida = False
    
        End With
    

        Exit Sub

ErrHandler:

144     UserList(userindex).ConnIDValida = False
146     Call ResetUserSlot(userindex)

148     Call TraceError(Err.Number, Err.Description, "TCP.CloseSocket", Erl)


End Sub

'[Alejo-21-5]: Cierra un socket sin limpiar el slot
Sub CloseSocketSL(ByVal userindex As Integer)
        
        On Error GoTo CloseSocketSL_Err

100     If UserList(userindex).ConnIDValida Then
102         Call modNetwork.Kick(userindex)

106         UserList(userindex).ConnIDValida = False
        End If
        
        Exit Sub

CloseSocketSL_Err:
108     Call TraceError(Err.Number, Err.Description, "TCP.CloseSocketSL", Erl)

        
End Sub

Function EstaPCarea(Index As Integer, Index2 As Integer) As Boolean
        
        On Error GoTo EstaPCarea_Err
        

        Dim X As Integer, Y As Integer

100     For Y = UserList(Index).Pos.Y - MinYBorder + 1 To UserList(Index).Pos.Y + MinYBorder - 1
102         For X = UserList(Index).Pos.X - MinXBorder + 1 To UserList(Index).Pos.X + MinXBorder - 1

104             If MapData(UserList(Index).Pos.Map, X, Y).userindex = Index2 Then
106                 EstaPCarea = True
                    Exit Function

                End If
        
108         Next X
110     Next Y

112     EstaPCarea = False

        
        Exit Function

EstaPCarea_Err:
114     Call TraceError(Err.Number, Err.Description, "TCP.EstaPCarea", Erl)

        
End Function

Function HayPCarea(ByVal Map As Integer, ByVal X As Integer, ByVal Y As Integer) As Boolean
        
        On Error GoTo HayPCarea_Err
        

        Dim tX As Integer, tY As Integer

100     For tY = Y - MinYBorder + 1 To Y + MinYBorder - 1
102         For tX = X - MinXBorder + 1 To X + MinXBorder - 1

104             If InMapBounds(Map, tX, tY) Then
106                 If MapData(Map, tX, tY).userindex > 0 Then
108                     HayPCarea = True
                        Exit Function

                    End If

                End If

            Next
        Next

110     HayPCarea = False

        
        Exit Function

HayPCarea_Err:
112     Call TraceError(Err.Number, Err.Description, "TCP.HayPCarea", Erl)

        
End Function

Function HayOBJarea(Pos As t_WorldPos, ObjIndex As Integer) As Boolean
        
        On Error GoTo HayOBJarea_Err
        

        Dim X As Integer, Y As Integer

100     For Y = Pos.Y - MinYBorder + 1 To Pos.Y + MinYBorder - 1
102         For X = Pos.X - MinXBorder + 1 To Pos.X + MinXBorder - 1

104             If MapData(Pos.Map, X, Y).ObjInfo.ObjIndex = ObjIndex Then
106                 HayOBJarea = True
                    Exit Function

                End If
        
108         Next X
110     Next Y

112     HayOBJarea = False

        
        Exit Function

HayOBJarea_Err:
114     Call TraceError(Err.Number, Err.Description, "TCP.HayOBJarea", Erl)

        
End Function

Function ValidateChr(ByVal userindex As Integer) As Boolean
        
        On Error GoTo ValidateChr_Err
        

100     ValidateChr = UserList(userindex).Char.Body <> 0 And Validate_Skills(userindex)

        
        Exit Function

ValidateChr_Err:
102     Call TraceError(Err.Number, Err.Description, "TCP.ValidateChr", Erl)

        
End Function

Function EntrarCuenta(ByVal userindex As Integer, ByVal CuentaEmail As String, ByVal md5 As String) As Boolean
        
        On Error GoTo EntrarCuenta_Err
        
        Dim adminIdx As Integer
        Dim laCuentaEsDeAdmin As Boolean
        
100     If ServerSoloGMs > 0 Then
102         laCuentaEsDeAdmin = False

104         For adminIdx = 0 To AdministratorAccounts.Count - 1
                ' Si el e-mail está declarado junto al nick de la cuenta donde esta el PJ GM en el Server.ini te dejo entrar.
106             If UCase$(AdministratorAccounts.Items(adminIdx)) = UCase$(CuentaEmail) Then
108                 laCuentaEsDeAdmin = True
                End If
110         Next adminIdx
            
112         If Not laCuentaEsDeAdmin Then
114             Call WriteShowMessageBox(userindex, "El servidor se encuentra habilitado solo para administradores por el momento.")
                Exit Function
            End If

        End If

        #If DEBUGGING = 0 Then
124         If LCase$(Md5Cliente) <> LCase$(md5) Then
126             Call WriteShowMessageBox(userindex, "Error al comprobar el cliente del juego, por favor reinstale y vuelva a intentar.")
                Exit Function
            End If
        #End If

128     If Not CheckMailString(CuentaEmail) Then
130         Call WriteShowMessageBox(userindex, "Email inválido.")
            Exit Function
        End If

        Exit Function

EntrarCuenta_Err:
134     Call TraceError(Err.Number, Err.Description, "TCP.EntrarCuenta", Erl)


        
End Function

Sub ConnectUser(ByVal userindex As Integer, _
                ByRef name As String, _
                Optional ByVal NewUser As Boolean = False)

        On Error GoTo ErrHandler

100     With UserList(userindex)

105         If Not ConnectUser_Check(userindex, name) Then Exit Sub
        
110         Call ConnectUser_Prepare(userindex, name)
        
            ' Cargamos el personaje
115         If Not NewUser Then Call LoadUser(userindex)

120         Call ConnectUser_Complete(userindex, name)
        End With

        Exit Sub
    
ErrHandler:
125     Call TraceError(Err.Number, Err.Description, "TCP.ConnectUser", Erl)
130     Call WriteShowMessageBox(userindex, "El personaje contiene un error. Comuníquese con un miembro del staff.")
135     Call CloseSocket(userindex)

End Sub

Sub SendMOTD(ByVal userindex As Integer)
        
        On Error GoTo SendMOTD_Err
        

        Dim j As Long

100     For j = 1 To MaxLines
102         Call WriteConsoleMsg(userindex, MOTD(j).texto, e_FontTypeNames.FONTTYPE_EXP)
104     Next j
    
        
        Exit Sub

SendMOTD_Err:
106     Call TraceError(Err.Number, Err.Description, "TCP.SendMOTD", Erl)

        
End Sub

Sub ResetFacciones(ByVal userindex As Integer)
        
        On Error GoTo ResetFacciones_Err
        

        '*************************************************
        'Author: Unknown
        'Last modified: 23/01/2007
        'Resetea todos los valores generales y las stats
        '03/15/2006 Maraxus - Uso de With para mayor performance y claridad.
        '23/01/2007 Pablo (ToxicWaste) - Agrego NivelIngreso, MatadosIngreso y NextRecompensa.
        '*************************************************
100     With UserList(userindex).Faccion
102         .ArmadaReal = 0
104         .ciudadanosMatados = 0
106         .CriminalesMatados = 0
108         .Status = 0
110         .FuerzasCaos = 0
112         .RecibioArmaduraCaos = 0
114         .RecibioArmaduraReal = 0
116         .RecibioExpInicialCaos = 0
118         .RecibioExpInicialReal = 0
120         .RecompensasCaos = 0
122         .RecompensasReal = 0
124         .Reenlistadas = 0
126         .NivelIngreso = 0
128         .MatadosIngreso = 0
130         .NextRecompensa = 0

        End With

        
        Exit Sub

ResetFacciones_Err:
132     Call TraceError(Err.Number, Err.Description, "TCP.ResetFacciones", Erl)

        
End Sub

Sub ResetContadores(ByVal userindex As Integer)
        
        On Error GoTo ResetContadores_Err
        

        '*************************************************
        'Author: Unknown
        'Last modified: 03/15/2006
        'Resetea todos los valores generales y las stats
        '03/15/2006 Maraxus - Uso de With para mayor performance y claridad.
        '05/20/2007 Integer - Agregue todas las variables que faltaban.
        '*************************************************
100     With UserList(userindex).Counters
102         .AGUACounter = 0
104         .AttackCounter = 0
106         .Ceguera = 0
108         .COMCounter = 0
110         .Estupidez = 0
112         .Frio = 0
114         .HPCounter = 0
116         .IdleCount = 0
118         .Invisibilidad = 0
120         .Paralisis = 0
122         .Inmovilizado = 0
124         .pasos = 0
126         .Pena = 0
128         .PiqueteC = 0
130         .STACounter = 0
132         .Veneno = 0
134         .Trabajando = 0
136         .Ocultando = 0
138         .Lava = 0
140         .Maldicion = 0
142         .Saliendo = False
144         .Salir = 0
146         .TiempoOculto = 0
148         .TimerMagiaGolpe = 0
150         .TimerGolpeMagia = 0
152         .TimerLanzarSpell = 0
154         .TimerPuedeAtacar = 0
156         .TimerPuedeUsarArco = 0
158         .TimerPuedeTrabajar = 0
160         .TimerUsar = 0
161         .TimerUsarClick = 0
            'Ladder
162         .Incineracion = 0
            'Ladder
170         .TiempoParaSubastar = 0
172         .TimerPerteneceNpc = 0
174         .TimerPuedeSerAtacado = 0
176         .TiempoDeInmunidad = 0
178         .RepetirMensaje = 0
180         .MensajeGlobal = 0
182         .CuentaRegresiva = -1
184         .SpeedHackCounter = 0
186         .LastStep = 0
188         .TimerBarra = 0
            .LastResetTick = 0
            .CounterGmMessages = 0
            .LastTransferGold = 0
            .TimeLastReset = 0
            .PacketCount = 0
            .TiempoOcultar = 0
        End With

        
        Exit Sub

ResetContadores_Err:
190     Call TraceError(Err.Number, Err.Description, "TCP.ResetContadores", Erl)

        
End Sub

Sub ResetCharInfo(ByVal userindex As Integer)
        '*************************************************
        'Author: Unknown
        'Last modified: 03/15/2006
        'Resetea todos los valores generales y las stats
        '03/15/2006 Maraxus - Uso de With para mayor performance y claridad.
        '*************************************************
        
        On Error GoTo ResetCharInfo_Err
        

100     With UserList(userindex).Char
102         .Body = 0
104         .CascoAnim = 0
106         .CharIndex = 0
108         .FX = 0
110         .Head = 0
112         .loops = 0
114         .Heading = 0
116         .loops = 0
118         .ShieldAnim = 0
120         .WeaponAnim = 0
122         .Arma_Aura = ""
124         .Body_Aura = ""
126         .Head_Aura = ""
128         .Otra_Aura = ""
130         .DM_Aura = ""
132         .RM_Aura = ""
134         .Escudo_Aura = ""
136         .ParticulaFx = 0
138         .speeding = 0

        End With

        
        Exit Sub

ResetCharInfo_Err:
140     Call TraceError(Err.Number, Err.Description, "TCP.ResetCharInfo", Erl)

        
End Sub

Sub ResetBasicUserInfo(ByVal userindex As Integer)
        
        On Error GoTo ResetBasicUserInfo_Err
        

        '*************************************************
        'Author: Unknown
        'Last modified: 03/15/2006
        'Resetea todos los valores generales y las stats
        '03/15/2006 Maraxus - Uso de With para mayor performance y claridad.
        'Agregue que se resetee el maná
        '*************************************************
        Dim LoopC As Integer

100     With UserList(userindex)
102         .name = vbNullString
104         .Cuenta = vbNullString
106         .ID = -1
108         .AccountID = -1
110         .Desc = vbNullString
112         .DescRM = vbNullString
114         .Pos.Map = 0
116         .Pos.X = 0
118         .Pos.Y = 0
120         .IP = vbNullString
122         .clase = 0
124         .Email = vbNullString
126         .genero = 0
128         .Hogar = 0
130         .raza = 0
132         .EmpoCont = 0

154         With .Stats
156             .InventLevel = 0
158             .Banco = 0
160             .ELV = 0
162             .Exp = 0
164             .def = 0
                '.CriminalesMatados = 0
166             .NPCsMuertos = 0
168             .UsuariosMatados = 0
                .PuntosPesca = 0
                .Creditos = 0
170             .SkillPts = 0
172             .GLD = 0
174             .UserAtributos(1) = 0
176             .UserAtributos(2) = 0
178             .UserAtributos(3) = 0
180             .UserAtributos(4) = 0
182             .UserAtributosBackUP(1) = 0
184             .UserAtributosBackUP(2) = 0
186             .UserAtributosBackUP(3) = 0
188             .UserAtributosBackUP(4) = 0
190             .MaxMAN = 0
192             .MinMAN = 0
                .tipoUsuario = e_TipoUsuario.tNormal
            End With
            
194         .NroMascotas = 0

        End With

        
        Exit Sub

ResetBasicUserInfo_Err:
200     Call TraceError(Err.Number, Err.Description, "TCP.ResetBasicUserInfo", Erl)

        
End Sub

Sub ResetGuildInfo(ByVal userindex As Integer)
        
        On Error GoTo ResetGuildInfo_Err
        

100     If UserList(userindex).EscucheClan > 0 Then
102         Call modGuilds.GMDejaDeEscucharClan(userindex, UserList(userindex).EscucheClan)
104         UserList(userindex).EscucheClan = 0

        End If

106     If UserList(userindex).GuildIndex > 0 Then
108         Call modGuilds.m_DesconectarMiembroDelClan(userindex, UserList(userindex).GuildIndex)

        End If

110     UserList(userindex).GuildIndex = 0
    
        
        Exit Sub

ResetGuildInfo_Err:
112     Call TraceError(Err.Number, Err.Description, "TCP.ResetGuildInfo", Erl)

        
End Sub

Sub ResetPacketRateData(ByVal userindex As Integer)

        On Error GoTo ResetPacketRateData_Err

        Dim i As Long
        
        With UserList(userindex)
        
            For i = 1 To MAX_PACKET_COUNTERS
                .MacroIterations(i) = 0
                .PacketTimers(i) = 0
                .PacketCounters(i) = 0
            Next i
            
        End With
        
        Exit Sub
        
ResetPacketRateData_Err:
282     Call TraceError(Err.Number, Err.Description, "TCP.ResetPacketRateData", Erl)

End Sub

Sub ResetUserFlags(ByVal userindex As Integer)
        '*************************************************
        'Author: Unknown
        'Last modified: 03/29/2006
        'Resetea todos los valores generales y las stats
        '03/15/2006 Maraxus - Uso de With para mayor performance y claridad.
        '03/29/2006 Maraxus - Reseteo el CentinelaOK también.
        '*************************************************
        
        On Error GoTo ResetUserFlags_Err
        

100     With UserList(userindex).flags
102         .LevelBackup = 0
104         .Comerciando = False
106         .Ban = 0
108         .Escondido = 0
110         .DuracionEfecto = 0
116         .NpcInv = 0
118         .StatsChanged = 0
120         .TargetNPC = 0
122         .TargetNpcTipo = e_NPCType.Comun
124         .TargetObj = 0
126         .TargetObjMap = 0
128         .TargetObjX = 0
130         .TargetObjY = 0
132         .TargetUser = 0
134         .TipoPocion = 0
136         .TomoPocion = False
138         .Descuento = vbNullString
144         .Descansar = False
146         .Navegando = 0
148         .Oculto = 0
150         .Envenenado = 0
154         .invisible = 0
156         .Paralizado = 0
158         .Inmovilizado = 0
160         .Maldicion = 0
162         .Bendicion = 0
164         .Meditando = 0
168         .Privilegios = 0
170         .PuedeMoverse = 0
172         .OldBody = 0
174         .OldHead = 0
176         .AdminInvisible = 0
178         .ValCoDe = 0
180         .Hechizo = 0
182         .Silenciado = 0
184         .CentinelaOK = False
186         .AdminPerseguible = False
            'Ladder
188         .VecesQueMoriste = 0
190         .MinutosRestantes = 0
192         .SegundosPasados = 0
194         .CarroMineria = 0
196         .Montado = 0
198         .Incinerado = 0
200         .Casado = 0
202         .Pareja = ""
204         .Candidato = 0
206         .UsandoMacro = False
208         .pregunta = 0

210         .Subastando = False
212         .Paraliza = 0
214         .Envenena = 0
216         .NoPalabrasMagicas = 0
218         .NoMagiaEfecto = 0
220         .incinera = 0
222         .Estupidiza = 0
224         .GolpeCertero = 0
226         .PendienteDelExperto = 0
228         .CarroMineria = 0
230         .PendienteDelSacrificio = 0
232         .AnilloOcultismo = 0
234         .RegeneracionMana = 0
236         .RegeneracionHP = 0
238         .RegeneracionSta = 0

242         .LastCrimMatado = vbNullString
244         .LastCiudMatado = vbNullString
        
246         .UserLogged = False
248         .FirstPacket = False
250         .Inmunidad = 0
            
252         .Mimetizado = e_EstadoMimetismo.Desactivado
254         .MascotasGuardadas = 0

256         .EnConsulta = False

258         .YaGuardo = False
                        
            .ModificoAttributos = False
            .ModificoHechizos = False
            .ModificoInventario = False
            .ModificoInventarioBanco = False
            .ModificoSkills = False
            .ModificoMascotas = False
            .ModificoQuests = False
            .ModificoQuestsHechas = False
            .RespondiendoPregunta = False
         
260         .ProcesosPara = vbNullString
262         .ScreenShotPara = vbNullString

            Dim i As Integer
266         For i = LBound(.ChatHistory) To UBound(.ChatHistory)
268             .ChatHistory(i) = vbNullString
            Next

270         .EnReto = False
272         .SolicitudReto.estado = e_SolicitudRetoEstado.Libre
274         .AceptoReto = 0
276         .LastPos.Map = 0
278         .ReturnPos.Map = 0
            
280         .Crafteando = 0

        End With

        
        Exit Sub

ResetUserFlags_Err:
282     Call TraceError(Err.Number, Err.Description, "TCP.ResetUserFlags", Erl)

        
End Sub

Sub ResetAccionesPendientes(ByVal userindex As Integer)
        
        On Error GoTo ResetAccionesPendientes_Err
        

        '*************************************************
        '*************************************************
100     With UserList(userindex).Accion
102         .AccionPendiente = False
104         .HechizoPendiente = 0
106         .RunaObj = 0
108         .Particula = 0
110         .TipoAccion = 0
112         .ObjSlot = 0

        End With

        
        Exit Sub

ResetAccionesPendientes_Err:
114     Call TraceError(Err.Number, Err.Description, "TCP.ResetAccionesPendientes", Erl)

        
End Sub

Sub ResetUserSpells(ByVal userindex As Integer)
        
        On Error GoTo ResetUserSpells_Err
        

        Dim LoopC As Long

100     For LoopC = 1 To MAXUSERHECHIZOS
102         UserList(userindex).Stats.UserHechizos(LoopC) = 0
            ' UserList(UserIndex).Stats.UserHechizosInterval(LoopC) = 0
104     Next LoopC

        
        Exit Sub

ResetUserSpells_Err:
106     Call TraceError(Err.Number, Err.Description, "TCP.ResetUserSpells", Erl)

        
End Sub

Sub ResetUserSkills(ByVal userindex As Integer)
        
        On Error GoTo ResetUserSkills_Err
        

        Dim LoopC As Long

100     For LoopC = 1 To NUMSKILLS
102         UserList(userindex).Stats.UserSkills(LoopC) = 0
104     Next LoopC

        
        Exit Sub

ResetUserSkills_Err:
106     Call TraceError(Err.Number, Err.Description, "TCP.ResetUserSkills", Erl)

        
End Sub

Sub ResetUserBanco(ByVal userindex As Integer)
        
        On Error GoTo ResetUserBanco_Err
        

        Dim LoopC As Long
    
100     For LoopC = 1 To MAX_BANCOINVENTORY_SLOTS
102         UserList(userindex).BancoInvent.Object(LoopC).amount = 0
104         UserList(userindex).BancoInvent.Object(LoopC).Equipped = 0
106         UserList(userindex).BancoInvent.Object(LoopC).ObjIndex = 0
108     Next LoopC
    
110     UserList(userindex).BancoInvent.NroItems = 0

        
        Exit Sub

ResetUserBanco_Err:
112     Call TraceError(Err.Number, Err.Description, "TCP.ResetUserBanco", Erl)

        
End Sub

Sub ResetUserKeys(ByVal userindex As Integer)
        
        On Error GoTo ResetUserKeys_Err
    
        
100     With UserList(userindex)
            Dim i As Integer
        
102         For i = 1 To MAXKEYS
104             .Keys(i) = 0
            Next
        End With
        
        Exit Sub

ResetUserKeys_Err:
106     Call TraceError(Err.Number, Err.Description, "TCP.ResetUserKeys", Erl)

        
End Sub

Public Sub LimpiarComercioSeguro(ByVal userindex As Integer)
        
        On Error GoTo LimpiarComercioSeguro_Err
        

100     With UserList(userindex).ComUsu

102         If .DestUsu > 0 Then
104             Call FinComerciarUsu(.DestUsu)
106             Call FinComerciarUsu(userindex)

            End If

        End With

        
        Exit Sub

LimpiarComercioSeguro_Err:
108     Call TraceError(Err.Number, Err.Description, "TCP.LimpiarComercioSeguro", Erl)

        
End Sub

Sub ResetUserSlot(ByVal userindex As Integer)
        
        On Error GoTo ResetUserSlot_Err
        

100     UserList(userindex).ConnIDValida = False

104     If UserList(userindex).Grupo.Lider = userindex Then
106         Call FinalizarGrupo(userindex)

        End If

108     If UserList(userindex).Grupo.EnGrupo Then
110         Call SalirDeGrupoForzado(userindex)

        End If

112     UserList(userindex).Grupo.CantidadMiembros = 0
114     UserList(userindex).Grupo.EnGrupo = False
116     UserList(userindex).Grupo.Lider = 0
118     UserList(userindex).Grupo.PropuestaDe = 0
120     UserList(userindex).Grupo.Miembros(6) = 0
122     UserList(userindex).Grupo.Miembros(1) = 0
124     UserList(userindex).Grupo.Miembros(2) = 0
126     UserList(userindex).Grupo.Miembros(3) = 0
128     UserList(userindex).Grupo.Miembros(4) = 0
130     UserList(userindex).Grupo.Miembros(5) = 0

132     Call ResetQuestStats(userindex)
134     Call ResetGuildInfo(userindex)
136     Call LimpiarComercioSeguro(userindex)
138     Call ResetFacciones(userindex)
140     Call ResetContadores(userindex)
141     Call ResetPacketRateData(userindex)
142     Call ResetCharInfo(userindex)
144     Call ResetBasicUserInfo(userindex)
146     Call ResetUserFlags(userindex)
148     Call ResetAccionesPendientes(userindex)
152     Call LimpiarInventario(userindex)
154     Call ResetUserSpells(userindex)
        'Call ResetUserPets(UserIndex)
156     Call ResetUserBanco(userindex)
158     Call ResetUserSkills(userindex)
160     Call ResetUserKeys(userindex)

162     With UserList(userindex).ComUsu
164         .Acepto = False
166         .cant = 0
168         .DestNick = vbNullString
170         .DestUsu = 0
172         .Objeto = 0

        End With

        
        Exit Sub

ResetUserSlot_Err:
174     Call TraceError(Err.Number, Err.Description, "TCP.ResetUserSlot", Erl)

        
End Sub

Sub ClearAndSaveUser(ByVal userindex As Integer)

    On Error GoTo ErrHandler
    
    Dim errordesc As String
    Dim Map As Integer
    Dim aN  As Integer
    Dim i   As Integer

100 With UserList(userindex)
102         errordesc = "ERROR AL SETEAR NPC"
        
104         aN = .flags.AtacadoPorNpc
    
106         If aN > 0 Then
108             NpcList(aN).Movement = NpcList(aN).flags.OldMovement
110             NpcList(aN).Hostile = NpcList(aN).flags.OldHostil
112             NpcList(aN).flags.AttackedBy = vbNullString
114             NpcList(aN).Target = 0
    
            End If
    
116         aN = .flags.NPCAtacado
    
118         If aN > 0 Then
120             If NpcList(aN).flags.AttackedFirstBy = .name Then
122                 NpcList(aN).flags.AttackedFirstBy = vbNullString
                End If
            End If
    
124         .flags.AtacadoPorNpc = 0
126         .flags.NPCAtacado = 0
        
128         errordesc = "ERROR AL DESMONTAR"
    
130         If .flags.Montado > 0 Then
132             Call DoMontar(userindex, ObjData(.Invent.MonturaObjIndex), .Invent.MonturaSlot)
            End If
            
134         errordesc = "ERROR AL CANCELAR SOLICITUD DE RETO"
            
136         If .flags.EnReto Then
138             Call AbandonarReto(userindex, True)

140         ElseIf .flags.SolicitudReto.estado <> e_SolicitudRetoEstado.Libre Then
142             Call CancelarSolicitudReto(userindex, .name & " se ha desconectado.")
            
144         ElseIf .flags.AceptoReto > 0 Then
146             Call CancelarSolicitudReto(.flags.AceptoReto, .name & " se ha desconectado.")
            End If
        
148         errordesc = "ERROR AL SACAR MIMETISMO"
150         If .flags.Mimetizado > 0 Then

152             .Char.Body = .CharMimetizado.Body
154             .Char.Head = .CharMimetizado.Head
156             .Char.CascoAnim = .CharMimetizado.CascoAnim
158             .Char.ShieldAnim = .CharMimetizado.ShieldAnim
160             .Char.WeaponAnim = .CharMimetizado.WeaponAnim
162             .Counters.Mimetismo = 0
164             .flags.Mimetizado = e_EstadoMimetismo.Desactivado

            End If
            
166         errordesc = "ERROR AL LIMPIAR INVENTARIO DE CRAFTEO"
168         If .flags.Crafteando <> 0 Then
170             Call ReturnCraftingItems(userindex)
            End If
        
172         errordesc = "ERROR AL ENVIAR PARTICULA"
        
174         .Char.FX = 0
176         .Char.loops = 0
178         .Char.ParticulaFx = 0
180         Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageParticleFX(.Char.CharIndex, 0, 0, True))
182         Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageCreateFX(.Char.CharIndex, 0, 0))

186         errordesc = "ERROR AL ENVIAR INVI"
        
            'Le devolvemos el body y head originales
188         If .flags.AdminInvisible = 1 Then Call DoAdminInvisible(userindex)
        
190         errordesc = "ERROR AL CANCELAR SUBASTA"
    
192         If .flags.Subastando = True Then
194             Call CancelarSubasta
    
            End If
        
196         errordesc = "ERROR AL BORRAR INDEX DE TORNEO"
    
198         If .flags.EnTorneo = True Then
200             Call BorrarIndexInTorneo(userindex)
202             .flags.EnTorneo = False
    
            End If
        
            'Save statistics
            'Call Statistics.UserDisconnected(UserIndex)
        
            ' Grabamos el personaje del usuario
        
204         errordesc = "ERROR AL GRABAR PJ"

206         Call SaveUser(userindex, True)

    End With
    
    Exit Sub
    
ErrHandler:
        'Call LogError("Error en CloseUser. Número " & Err.Number & ". Descripción: " & Err.Description & ". Detalle:" & errordesc)
208     Call TraceError(Err.Number, Err.Description & ". Detalle:" & errordesc, Erl)
210     Resume Next ' TODO: Provisional hasta solucionar bugs graves

End Sub

Sub CloseUser(ByVal userindex As Integer)

        On Error GoTo ErrHandler
    
        Dim errordesc As String
        Dim Map As Integer
        Dim aN  As Integer
        Dim i   As Integer
        
100     With UserList(userindex)
            
102         Map = .Pos.Map
        
104         If Not .flags.YaGuardo Then
106             Call ClearAndSaveUser(userindex)
            End If

108         errordesc = "ERROR AL DESCONTAR USER DE MAPA"
    
110         If MapInfo(Map).NumUsers > 0 Then
112             Call SendData(SendTarget.ToPCAreaButIndex, userindex, PrepareMessageRemoveCharDialog(.Char.CharIndex))
    
            End If
    
114         errordesc = "ERROR AL ERASEUSERCHAR"
        
            'Borrar el personaje
116         Call EraseUserChar(userindex, True)
        
118         errordesc = "ERROR AL BORRAR MASCOTAS"
        
            'Borrar mascotas
120         For i = 1 To MAXMASCOTAS
122             If .MascotasIndex(i) > 0 Then
124                 If NpcList(.MascotasIndex(i)).flags.NPCActive Then _
                        Call QuitarNPC(.MascotasIndex(i))
                End If
126         Next i
        
128         errordesc = "ERROR Update Map Users"
        
            'Update Map Users
130         MapInfo(Map).NumUsers = MapInfo(Map).NumUsers - 1
        
132         If MapInfo(Map).NumUsers < 0 Then MapInfo(Map).NumUsers = 0
    
            ' Si el usuario habia dejado un msg en la gm's queue lo borramos
            'If Ayuda.Existe(.Name) Then Call Ayuda.Quitar(.Name)
        
134         errordesc = "ERROR AL m_NameIndex.Remove() Name:" & .name & " cuenta:" & .Cuenta
            
136         Call m_NameIndex.Remove(UCase$(.name))
        
138         errordesc = "ERROR AL RESETSLOT Name:" & .name & " cuenta:" & .Cuenta

140         .flags.UserLogged = False

            .Counters.Saliendo = False
        
142         Call ResetUserSlot(userindex)

        End With
    
        Exit Sub
    
ErrHandler:
        'Call LogError("Error en CloseUser. Número " & Err.Number & ". Descripción: " & Err.Description & ". Detalle:" & errordesc)
144     Call TraceError(Err.Number, Err.Description & ". Detalle:" & errordesc, Erl)
146     Resume Next ' TODO: Provisional hasta solucionar bugs graves

End Sub

Public Sub EcharPjsNoPrivilegiados()
        
        On Error GoTo EcharPjsNoPrivilegiados_Err
        

        Dim LoopC As Long

100     For LoopC = 1 To LastUser

102         If UserList(LoopC).flags.UserLogged And UserList(LoopC).ConnIDValida Then
104             If UserList(LoopC).flags.Privilegios And e_PlayerType.user Then
106                 Call CloseSocket(LoopC)

                End If

            End If

108     Next LoopC

        
        Exit Sub

EcharPjsNoPrivilegiados_Err:
110     Call TraceError(Err.Number, Err.Description, "TCP.EcharPjsNoPrivilegiados", Erl)

        
End Sub

Function ValidarCabeza(ByVal UserRaza As e_Raza, ByVal UserSexo As e_Genero, ByVal Head As Integer) As Boolean

100     Select Case UserSexo
    
            Case e_Genero.Hombre
        
102             Select Case UserRaza
                
                    Case e_Raza.Humano
104                     ValidarCabeza = Head >= 1 And Head <= 41
                    
106                 Case e_Raza.Elfo
108                     ValidarCabeza = Head >= 101 And Head <= 132
                    
110                 Case e_Raza.Drow
112                     ValidarCabeza = Head >= 200 And Head <= 229
                    
114                 Case e_Raza.Enano
116                     ValidarCabeza = Head >= 300 And Head <= 329
                    
118                 Case e_Raza.Gnomo
120                     ValidarCabeza = Head >= 400 And Head <= 429
                    
122                 Case e_Raza.Orco
124                     ValidarCabeza = Head >= 500 And Head <= 529
                
                End Select
        
126         Case e_Genero.Mujer
        
128             Select Case UserRaza
                
                    Case e_Raza.Humano
130                     ValidarCabeza = Head >= 50 And Head <= 80
                    
132                 Case e_Raza.Elfo
134                     ValidarCabeza = Head >= 150 And Head <= 179
                    
136                 Case e_Raza.Drow
138                     ValidarCabeza = Head >= 250 And Head <= 279
                    
140                 Case e_Raza.Enano
142                     ValidarCabeza = Head >= 350 And Head <= 379
                    
144                 Case e_Raza.Gnomo
146                     ValidarCabeza = Head >= 450 And Head <= 479
                    
148                 Case e_Raza.Orco
150                     ValidarCabeza = Head >= 550 And Head <= 579
                
                End Select
    
        End Select

End Function

Function ValidarNombre(nombre As String) As Boolean
    
100     If Len(nombre) < 3 Or Len(nombre) > 18 Then Exit Function
    
        Dim Temp As String
102     Temp = UCase$(nombre)
    
        Dim i As Long, Char As Integer, LastChar As Integer
104     For i = 1 To Len(Temp)
106         Char = Asc(mid$(Temp, i, 1))
        
108         If (Char < 65 Or Char > 90) And Char <> 32 Then
                Exit Function
        
110         ElseIf Char = 32 And LastChar = 32 Then
                Exit Function
            End If
        
112         LastChar = Char
        Next

114     If Asc(mid$(Temp, 1, 1)) = 32 Or Asc(mid$(Temp, Len(Temp), 1)) = 32 Then
            Exit Function
        End If
    
116     ValidarNombre = True

End Function

Function ContarUsuariosMismaCuenta(ByVal AccountID As Long) As Integer

        Dim i As Integer
    
100     For i = 1 To LastUser
        
102         If UserList(i).flags.UserLogged And UserList(i).AccountID = AccountID Then
104             ContarUsuariosMismaCuenta = ContarUsuariosMismaCuenta + 1
            End If
        
        Next

End Function

Sub VaciarInventario(ByVal userindex As Integer)

    Dim i As Long

    With UserList(userindex)
        For i = 1 To MAX_INVENTORY_SLOTS
            .Invent.Object(i).amount = 0
            .Invent.Object(i).Equipped = 0
            .Invent.Object(i).ObjIndex = 0
        Next i
    End With
End Sub
