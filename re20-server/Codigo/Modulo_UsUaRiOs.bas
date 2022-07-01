Attribute VB_Name = "UsUaRiOs"

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

'?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿
'                        Modulo Usuarios
'?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿
'Rutinas de los usuarios
'?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿?¿

Public Function ConnectUser_Check(ByVal userindex As Integer, _
                                  ByRef name As String) As Boolean
                           
    On Error GoTo Check_ConnectUser_Err

    With UserList(userindex)
        
        ConnectUser_Check = False
        
        If .flags.UserLogged Then
            Call LogSecurity("El usuario " & .name & " ha intentado loguear a " & name & " desde la IP " & .IP)
            'Kick player ( and leave character inside :D )!
            Call CloseSocketSL(userindex)
            Call Cerrar_Usuario(userindex)
            Exit Function
        End If
        
        'Controlo si superó el tiempo para conectarse nuevamente
        
        If dcnUsersLastLogout.Exists(UCase$(name)) Then
            Dim lastLogOut As Long
            lastLogOut = dcnUsersLastLogout(UCase$(name))
            If lastLogOut + 5000 >= GetTickCount() Then
                Call WriteShowMessageBox(userindex, "Aguarda un momento.")
                Exit Function
            End If
        End If
        
        '¿Ya esta conectado el personaje?
        Dim tIndex As Integer: tIndex = NameIndex(name)

        If tIndex > 0 And tIndex <> userindex Then

            If UserList(tIndex).Counters.Saliendo Then
                Call WriteShowMessageBox(userindex, "El personaje está saliendo.")

            Else
                
                Call WriteShowMessageBox(userindex, "El personaje ya está conectado. Espere mientras es desconectado.")

                ' Le avisamos al usuario que está jugando, en caso de que haya uno
                Call WriteShowMessageBox(tIndex, "Alguien está ingresando con tu personaje. Si no has sido tú, por favor cambia la contraseña de tu cuenta.")
            '    Call Cerrar_Usuario(tIndex)

            End If

            Call CloseSocket(userindex)
            Exit Function

        End If
        
        '¿Supera el máximo de usuarios por cuenta?
        If MaxUsersPorCuenta > 0 Then

            If ContarUsuariosMismaCuenta(.AccountID) >= MaxUsersPorCuenta Then

                If MaxUsersPorCuenta = 1 Then
                    Call WriteShowMessageBox(userindex, "Ya hay un usuario conectado con esta cuenta.")
                Else
                    Call WriteShowMessageBox(userindex, "La cuenta ya alcanzó el máximo de " & MaxUsersPorCuenta & " usuarios conectados.")

                End If

                Call CloseSocket(userindex)
                Exit Function

            End If

        End If
        
        'Controlamos no pasar el maximo de usuarios
        If NumUsers >= MaxUsers Then
            Call WriteShowMessageBox(userindex, "El servidor ha alcanzado el maximo de usuarios soportado, por favor vuelva a intertarlo mas tarde.")
            Call CloseSocket(userindex)
            Exit Function

        End If
        
        '¿Este IP ya esta conectado?
        If MaxConexionesIP > 0 Then

            If ContarMismaIP(userindex, .IP) >= MaxConexionesIP Then
                Call WriteShowMessageBox(userindex, "Has alcanzado el límite de conexiones por IP.")
                Call CloseSocket(userindex)
                Exit Function

            End If

        End If
        
        'Le damos los privilegios
            .flags.Privilegios = UserDarPrivilegioLevel(name)
        'Add RM flag if needed
        If EsRolesMaster(name) Then
            .flags.Privilegios = .flags.Privilegios Or e_PlayerType.RoleMaster
        End If
        
        If EsGM(userindex) Then
            Call SendData(SendTarget.ToAdmins, 0, PrepareMessageConsoleMsg("Servidor » " & name & " se conecto al juego.", e_FontTypeNames.FONTTYPE_INFOBOLD))
            Call LogGM(name, "Se conectó con IP: " & .IP)
        Else
            If ServerSoloGMs > 0 Then
                Dim i As Integer
                Dim EsCuentaGM As Boolean
                For i = 0 To AdministratorAccounts.Count - 1
                    ' Si el e-mail está declarado junto al nick de la cuenta donde esta el PJ GM en el Server.ini te dejo entrar.
                    If UCase$(AdministratorAccounts.Items(i)) = UCase$(UserList(userindex).Email) Then
                        EsCuentaGM = True
                    End If
                Next
                If Not EsCuentaGM Then
                    Call WriteShowMessageBox(userindex, "Servidor restringido a administradores. Por favor reintente en unos momentos.")
                    Call CloseSocket(userindex)
                    Exit Function
                End If
            End If
        End If
        
        If EnPausa Then

            Call WritePauseToggle(userindex)
            Call WriteConsoleMsg(userindex, "Servidor » Lo sentimos mucho pero el servidor se encuentra actualmente detenido. Intenta ingresar más tarde.", e_FontTypeNames.FONTTYPE_SERVER)
            Call CloseSocket(userindex)
            Exit Function

        End If

    
    End With
    
    ConnectUser_Check = True

    Exit Function

Check_ConnectUser_Err:
    Call TraceError(Err.Number, Err.Description, "UsUaRiOs.ConnectUser_Check", Erl)
        
End Function

Public Sub ConnectUser_Prepare(ByVal userindex As Integer, ByRef name As String)

        On Error GoTo Prepare_ConnectUser_Err

100     With UserList(userindex)
    
            'Reseteamos los FLAGS
105         .flags.Escondido = 0
110         .flags.TargetNPC = 0
115         .flags.TargetNpcTipo = e_NPCType.Comun
120         .flags.TargetObj = 0
125         .flags.TargetUser = 0
130         .Char.FX = 0
135         .Counters.CuentaRegresiva = -1

            ' Seteamos el nombre
170         .name = name
        
            ' Vinculamos el nombre con el UserIndex
175         m_NameIndex(UCase$(name)) = userindex

180         .showName = True
    
        End With
    
        Exit Sub

Prepare_ConnectUser_Err:
        Call TraceError(Err.Number, Err.Description, "UsUaRiOs.ConnectUser_Prepare", Erl)

End Sub

Public Function ConnectUser_Complete(ByVal userindex As Integer, _
                                     ByRef name As String)

        On Error GoTo Complete_ConnectUser_Err
        
        Dim n    As Integer
        Dim tStr As String
        
100     With UserList(userindex)
            
            ' -----------------------------------------------------------------------
            '   INFORMACION INICIAL DEL PERSONAJE
            ' -----------------------------------------------------------------------

105         If .flags.Paralizado = 1 Then
110             .Counters.Paralisis = IntervaloParalizado
            End If

115         If .flags.Muerto = 0 Then
120             .Char = .OrigChar
            
125             If .Char.Body = 0 Then
130                 Call DarCuerpoDesnudo(userindex)
                End If
            
135             If .Char.Head = 0 Then
140                 .Char.Head = 1
                End If
            Else
145             .Char.Body = iCuerpoMuerto
150             .Char.Head = iCabezaMuerto
155             .Char.WeaponAnim = NingunArma
160             .Char.ShieldAnim = NingunEscudo
165             .Char.CascoAnim = NingunCasco
170             .Char.Heading = e_Heading.SOUTH
            End If
            
            .Stats.UserAtributos(e_Atributos.Fuerza) = 18 + ModRaza(.raza).Fuerza
            .Stats.UserAtributos(e_Atributos.Agilidad) = 18 + ModRaza(.raza).Agilidad
            .Stats.UserAtributos(e_Atributos.Inteligencia) = 18 + ModRaza(.raza).Inteligencia
            .Stats.UserAtributos(e_Atributos.Constitucion) = 18 + ModRaza(.raza).Constitucion
            .Stats.UserAtributos(e_Atributos.Carisma) = 18 + ModRaza(.raza).Carisma
                    
            .Stats.UserAtributosBackUP(e_Atributos.Fuerza) = .Stats.UserAtributos(e_Atributos.Fuerza)
            .Stats.UserAtributosBackUP(e_Atributos.Agilidad) = .Stats.UserAtributos(e_Atributos.Agilidad)
            .Stats.UserAtributosBackUP(e_Atributos.Inteligencia) = .Stats.UserAtributos(e_Atributos.Inteligencia)
            .Stats.UserAtributosBackUP(e_Atributos.Constitucion) = .Stats.UserAtributos(e_Atributos.Constitucion)
            .Stats.UserAtributosBackUP(e_Atributos.Carisma) = .Stats.UserAtributos(e_Atributos.Carisma)
                    
            'Obtiene el indice-objeto del arma
175         If .Invent.WeaponEqpSlot > 0 Then
180             If .Invent.Object(.Invent.WeaponEqpSlot).ObjIndex > 0 Then
185                 .Invent.WeaponEqpObjIndex = .Invent.Object(.Invent.WeaponEqpSlot).ObjIndex

190                 If .flags.Muerto = 0 Then
195                     .Char.Arma_Aura = ObjData(.Invent.WeaponEqpObjIndex).CreaGRH
                    End If
                Else
200                 .Invent.WeaponEqpSlot = 0
                End If
            End If

            'Obtiene el indice-objeto del armadura
205         If .Invent.ArmourEqpSlot > 0 Then
210             If .Invent.Object(.Invent.ArmourEqpSlot).ObjIndex > 0 Then
215                 .Invent.ArmourEqpObjIndex = .Invent.Object(.Invent.ArmourEqpSlot).ObjIndex

220                 If .flags.Muerto = 0 Then
225                     .Char.Body_Aura = ObjData(.Invent.ArmourEqpObjIndex).CreaGRH
                    End If
                Else
230                 .Invent.ArmourEqpSlot = 0
                End If
235             .flags.Desnudo = 0
            Else
240             .flags.Desnudo = 1
            End If

            'Obtiene el indice-objeto del escudo
245         If .Invent.EscudoEqpSlot > 0 Then
250             If .Invent.Object(.Invent.EscudoEqpSlot).ObjIndex > 0 Then
255                 .Invent.EscudoEqpObjIndex = .Invent.Object(.Invent.EscudoEqpSlot).ObjIndex

260                 If .flags.Muerto = 0 Then
265                     .Char.Escudo_Aura = ObjData(.Invent.EscudoEqpObjIndex).CreaGRH
                    End If
                Else
270                 .Invent.EscudoEqpSlot = 0
                End If
            End If
        
            'Obtiene el indice-objeto del casco
275         If .Invent.CascoEqpSlot > 0 Then
280             If .Invent.Object(.Invent.CascoEqpSlot).ObjIndex > 0 Then
285                 .Invent.CascoEqpObjIndex = .Invent.Object(.Invent.CascoEqpSlot).ObjIndex

290                 If .flags.Muerto = 0 Then
295                     .Char.Head_Aura = ObjData(.Invent.CascoEqpObjIndex).CreaGRH
                    End If
                Else
300                 .Invent.CascoEqpSlot = 0
                End If
            End If

            'Obtiene el indice-objeto barco
305         If .Invent.BarcoSlot > 0 Then
310             If .Invent.Object(.Invent.BarcoSlot).ObjIndex > 0 Then
315                 .Invent.BarcoObjIndex = .Invent.Object(.Invent.BarcoSlot).ObjIndex
                Else
320                 .Invent.BarcoSlot = 0
                End If
            End If

            'Obtiene el indice-objeto municion
325         If .Invent.MunicionEqpSlot > 0 Then
330             If .Invent.Object(.Invent.MunicionEqpSlot).ObjIndex > 0 Then
335                 .Invent.MunicionEqpObjIndex = .Invent.Object(.Invent.MunicionEqpSlot).ObjIndex
                Else
340                 .Invent.MunicionEqpSlot = 0
                End If
            End If

            ' DM
345         If .Invent.DañoMagicoEqpSlot > 0 Then
350             If .Invent.Object(.Invent.DañoMagicoEqpSlot).ObjIndex > 0 Then
355                 .Invent.DañoMagicoEqpObjIndex = .Invent.Object(.Invent.DañoMagicoEqpSlot).ObjIndex

360                 If .flags.Muerto = 0 Then
365                     .Char.DM_Aura = ObjData(.Invent.DañoMagicoEqpObjIndex).CreaGRH
                    End If
                Else
370                 .Invent.DañoMagicoEqpSlot = 0
                End If
            End If
            
            ' RM
375         If .Invent.ResistenciaEqpSlot > 0 Then
380             If .Invent.Object(.Invent.ResistenciaEqpSlot).ObjIndex > 0 Then
385                 .Invent.ResistenciaEqpObjIndex = .Invent.Object(.Invent.ResistenciaEqpSlot).ObjIndex

390                 If .flags.Muerto = 0 Then
395                     .Char.RM_Aura = ObjData(.Invent.ResistenciaEqpObjIndex).CreaGRH
                    End If
                Else
400                 .Invent.ResistenciaEqpSlot = 0
                End If
            End If

405         If .Invent.MonturaSlot > 0 Then
410             If .Invent.Object(.Invent.MonturaSlot).ObjIndex > 0 Then
415                 .Invent.MonturaObjIndex = .Invent.Object(.Invent.MonturaSlot).ObjIndex
                Else
420                 .Invent.MonturaSlot = 0
                End If
            End If
        
425         If .Invent.HerramientaEqpSlot > 0 Then
430             If .Invent.Object(.Invent.HerramientaEqpSlot).ObjIndex Then
435                 .Invent.HerramientaEqpObjIndex = .Invent.Object(.Invent.HerramientaEqpSlot).ObjIndex
                Else
440                 .Invent.HerramientaEqpSlot = 0
                End If
            End If
        
445         If .Invent.NudilloSlot > 0 Then
450             If .Invent.Object(.Invent.NudilloSlot).ObjIndex > 0 Then
455                 .Invent.NudilloObjIndex = .Invent.Object(.Invent.NudilloSlot).ObjIndex

460                 If .flags.Muerto = 0 Then
465                     .Char.Arma_Aura = ObjData(.Invent.NudilloObjIndex).CreaGRH
                    End If
                Else
470                 .Invent.NudilloSlot = 0
                End If
            End If
        
475         If .Invent.MagicoSlot > 0 Then
480             If .Invent.Object(.Invent.MagicoSlot).ObjIndex Then
485                 .Invent.MagicoObjIndex = .Invent.Object(.Invent.MagicoSlot).ObjIndex

490                 If .flags.Muerto = 0 Then
495                     .Char.Otra_Aura = ObjData(.Invent.MagicoObjIndex).CreaGRH
                    End If
                Else
500                 .Invent.MagicoSlot = 0
                End If
            End If
            
505         If .Invent.EscudoEqpSlot = 0 Then .Char.ShieldAnim = NingunEscudo
510         If .Invent.CascoEqpSlot = 0 Then .Char.CascoAnim = NingunCasco
515         If .Invent.WeaponEqpSlot = 0 And .Invent.NudilloSlot = 0 And .Invent.HerramientaEqpSlot = 0 Then .Char.WeaponAnim = NingunArma
            ' -----------------------------------------------------------------------
            '   FIN - INFORMACION INICIAL DEL PERSONAJE
            ' -----------------------------------------------------------------------
            
520         If Not ValidateChr(userindex) Then
525             Call WriteShowMessageBox(userindex, "Error en el personaje. Comuniquese con el staff.")
530             Call CloseSocket(userindex)
                Exit Function

            End If
            
535         .flags.SeguroParty = True
540         .flags.SeguroClan = True
545         .flags.SeguroResu = True
        
550         .CurrentInventorySlots = getMaxInventorySlots(userindex)
        
555         Call WriteInventoryUnlockSlots(userindex)
        
560         Call LoadUserIntervals(userindex)
565         Call WriteIntervals(userindex)
        
570         Call UpdateUserInv(True, userindex, 0)
575         Call UpdateUserHechizos(True, userindex, 0)
        
580         Call EnviarLlaves(userindex)

590         If .flags.Paralizado Then Call WriteParalizeOK(userindex)
        
595         If .flags.Inmovilizado Then Call WriteInmovilizaOK(userindex)

            ''
            'TODO : Feo, esto tiene que ser parche cliente
600         If .flags.Estupidez = 0 Then
605             Call WriteDumbNoMore(userindex)
            End If
        
            'Ladder Inmunidad
610         .flags.Inmunidad = 1
615         .Counters.TiempoDeInmunidad = IntervaloPuedeSerAtacado
            'Ladder Inmunidad
            
            .Counters.TiempoDeInmunidadParalisisNoMagicas = 0
        
            'Mapa válido
620         If Not MapaValido(.Pos.Map) Then
625             Call WriteErrorMsg(userindex, "EL PJ se encuenta en un mapa invalido.")
630             Call CloseSocket(userindex)
                Exit Function

            End If
        
            'Tratamos de evitar en lo posible el "Telefrag". Solo 1 intento de loguear en pos adjacentes.
            'Codigo por Pablo (ToxicWaste) y revisado por Nacho (Integer), corregido para que realmetne ande y no tire el server por Juan Martin Sotuyo Dodero (Maraxus)
635         If MapData(.Pos.Map, .Pos.X, .Pos.Y).userindex <> 0 Or MapData(.Pos.Map, .Pos.X, .Pos.Y).NpcIndex <> 0 Then

                Dim FoundPlace As Boolean
                Dim esAgua     As Boolean
                Dim tX         As Long
                Dim tY         As Long
        
640             FoundPlace = False
645             esAgua = (MapData(.Pos.Map, .Pos.X, .Pos.Y).Blocked And FLAG_AGUA) <> 0

650             For tY = .Pos.Y - 1 To .Pos.Y + 1
655                 For tX = .Pos.X - 1 To .Pos.X + 1

660                     If esAgua Then

                            'reviso que sea pos legal en agua, que no haya User ni NPC para poder loguear.
665                         If LegalPos(.Pos.Map, tX, tY, True, True, False, False, False) Then
670                             FoundPlace = True
                                Exit For

                            End If

                        Else

                            'reviso que sea pos legal en tierra, que no haya User ni NPC para poder loguear.
675                         If LegalPos(.Pos.Map, tX, tY, False, True, False, False, False) Then
680                             FoundPlace = True
                                Exit For

                            End If

                        End If

685                 Next tX
            
690                 If FoundPlace Then Exit For
695             Next tY
        
700             If FoundPlace Then 'Si encontramos un lugar, listo, nos quedamos ahi

705                 .Pos.X = tX
710                 .Pos.Y = tY

                Else

                    'Si no encontramos un lugar, sacamos al usuario que tenemos abajo, y si es un NPC, lo pisamos.
715                 If MapData(.Pos.Map, .Pos.X, .Pos.Y).userindex <> 0 Then

                        'Si no encontramos lugar, y abajo teniamos a un usuario, lo pisamos y cerramos su comercio seguro
720                     If UserList(MapData(.Pos.Map, .Pos.X, .Pos.Y).userindex).ComUsu.DestUsu > 0 Then

                            'Le avisamos al que estaba comerciando que se tuvo que ir.
725                         If UserList(UserList(MapData(.Pos.Map, .Pos.X, .Pos.Y).userindex).ComUsu.DestUsu).flags.UserLogged Then
730                             Call FinComerciarUsu(UserList(MapData(.Pos.Map, .Pos.X, .Pos.Y).userindex).ComUsu.DestUsu)
735                             Call WriteConsoleMsg(UserList(MapData(.Pos.Map, .Pos.X, .Pos.Y).userindex).ComUsu.DestUsu, "Comercio cancelado. El otro usuario se ha desconectado.", e_FontTypeNames.FONTTYPE_WARNING)

                            End If

                            'Lo sacamos.
740                         If UserList(MapData(.Pos.Map, .Pos.X, .Pos.Y).userindex).flags.UserLogged Then
745                             Call FinComerciarUsu(MapData(.Pos.Map, .Pos.X, .Pos.Y).userindex)
750                             Call WriteErrorMsg(MapData(.Pos.Map, .Pos.X, .Pos.Y).userindex, "Alguien se ha conectado donde te encontrabas, por favor reconectate...")

                            End If

                        End If
                
755                     Call CloseSocket(MapData(.Pos.Map, .Pos.X, .Pos.Y).userindex)

                    End If

                End If

            End If
        
            'If in the water, and has a boat, equip it!
760         If .Invent.BarcoObjIndex > 0 And (MapData(.Pos.Map, .Pos.X, .Pos.Y).Blocked And FLAG_AGUA) <> 0 Then
765             .flags.Navegando = 1
770             Call EquiparBarco(userindex)

            End If
            
775         If .Invent.MagicoObjIndex <> 0 Then
780             If ObjData(.Invent.MagicoObjIndex).EfectoMagico = 11 Then .flags.Paraliza = 1
            End If

785         Call WriteUserIndexInServer(userindex) 'Enviamos el User index
        
795         Call WriteHora(userindex)
800         Call WriteChangeMap(userindex, .Pos.Map) 'Carga el mapa
            
805         Select Case .flags.Privilegios
            
                Case e_PlayerType.Admin
810                 .flags.ChatColor = RGB(217, 164, 32)
                
815             Case e_PlayerType.Dios
820                 .flags.ChatColor = RGB(217, 164, 32)
                    
825             Case e_PlayerType.SemiDios
830                 .flags.ChatColor = RGB(2, 161, 38)
                    
835             Case e_PlayerType.Consejero
840                 .flags.ChatColor = RGB(2, 161, 38)
                
845             Case Else
850                 .flags.ChatColor = vbWhite
                
            End Select
            
            ' Jopi: Te saco de los mapas de retos (si logueas ahi) 324 372 389 390
855         If Not EsGM(userindex) And (.Pos.Map = 324 Or .Pos.Map = 372 Or .Pos.Map = 389 Or .Pos.Map = 390) Then
                
                ' Si tiene una posicion a la que volver, lo mando ahi
860             If MapaValido(.flags.ReturnPos.Map) And .flags.ReturnPos.X > 0 And .flags.ReturnPos.X <= XMaxMapSize And .flags.ReturnPos.Y > 0 And .flags.ReturnPos.Y <= YMaxMapSize Then
                    
865                 Call WarpToLegalPos(userindex, .flags.ReturnPos.Map, .flags.ReturnPos.X, .flags.ReturnPos.Y, True)
                
                Else ' Lo mando a su hogar
                    
870                 Call WarpToLegalPos(userindex, Ciudades(.Hogar).Map, Ciudades(.Hogar).X, Ciudades(.Hogar).Y, True)
                    
                End If
                
            End If
            
            ''[EL OSO]: TRAIGO ESTO ACA ARRIBA PARA DARLE EL IP!
            #If ConUpTime Then
875             .LogOnTime = Now
            #End If
        
            'Crea  el personaje del usuario
880         Call MakeUserChar(True, .Pos.Map, userindex, .Pos.Map, .Pos.X, .Pos.Y, 1)

885         Call WriteUserCharIndexInServer(userindex)
890         Call ActualizarVelocidadDeUsuario(userindex)
        
895         If .flags.Privilegios And (e_PlayerType.SemiDios Or e_PlayerType.Dios Or e_PlayerType.Admin) Then
                Call DoAdminInvisible(userindex)
            End If
900         Call WriteUpdateUserStats(userindex)
905         Call WriteUpdateHungerAndThirst(userindex)
910         Call WriteUpdateDM(userindex)
915         Call WriteUpdateRM(userindex)
        
920         Call SendMOTD(userindex)
   
            'Actualiza el Num de usuarios
930         NumUsers = NumUsers + 1
935         .flags.UserLogged = True
940         .Counters.LastSave = GetTickCount
        
945         MapInfo(.Pos.Map).NumUsers = MapInfo(.Pos.Map).NumUsers + 1
        
950         If .Stats.SkillPts > 0 Then
955             Call WriteSendSkills(userindex)
960             Call WriteLevelUp(userindex, .Stats.SkillPts)

            End If
        
965         If NumUsers > DayStats.MaxUsuarios Then DayStats.MaxUsuarios = NumUsers
        
970         If NumUsers > RecordUsuarios Then
975             Call SendData(SendTarget.ToAll, 0, PrepareMessageConsoleMsg("Record de usuarios conectados simultáneamente: " & NumUsers & " usuarios.", e_FontTypeNames.FONTTYPE_INFO))
980             RecordUsuarios = NumUsers
            End If

990         Call SendData(SendTarget.ToIndex, userindex, PrepareMessageOnlineUser(NumUsers))

995         Call WriteFYA(userindex)
1000         Call WriteBindKeys(userindex)
        
1005         If .NroMascotas > 0 And MapInfo(.Pos.Map).Seguro = 0 And .flags.MascotasGuardadas = 0 Then
                 Dim i As Integer

1010             For i = 1 To MAXMASCOTAS

1015                If .MascotasType(i) > 0 Then
1020                    .MascotasIndex(i) = SpawnNpc(.MascotasType(i), .Pos, False, False, False, userindex)
                    
1025                    If .MascotasIndex(i) > 0 Then
1030                        NpcList(.MascotasIndex(i)).MaestroUser = userindex
1035                        Call FollowAmo(.MascotasIndex(i))
                        
                         Else
1040                        .MascotasIndex(i) = 0

                         End If
                     End If

1045            Next i

             End If
        
1050        If .flags.Navegando = 1 Then
1055            Call WriteNavigateToggle(userindex)
1060            Call EquiparBarco(userindex)

             End If
                     
1065        If .flags.Montado = 1 Then
1070            Call WriteEquiteToggle(userindex)

             End If

1075        Call ActualizarVelocidadDeUsuario(userindex)
        
1080        If .GuildIndex > 0 Then

                 'welcome to the show baby...
1085            If Not modGuilds.m_ConectarMiembroAClan(userindex, .GuildIndex) Then
1090                Call WriteConsoleMsg(userindex, "Tu estado no te permite entrar al clan.", e_FontTypeNames.FONTTYPE_GUILD)
                 End If

             End If

1100        If LenB(.LastGuildRejection) <> 0 Then
1105            Call WriteShowMessageBox(userindex, "Tu solicitud de ingreso al clan ha sido rechazada. El clan te explica que: " & .LastGuildRejection)

                .LastGuildRejection = vbNullString
                
                Call SaveUserGuildRejectionReason(.name, vbNullString)
             End If

1110        If Lloviendo Then Call WriteRainToggle(userindex)
        
1115        If ServidorNublado Then Call WriteNubesToggle(userindex)

1120        Call WriteLoggedMessage(userindex)
        
1125        If .Stats.ELV = 1 Then
1130            Call WriteConsoleMsg(userindex, "¡Bienvenido a las tierras de AO20! ¡" & .name & " que tengas buen viaje y mucha suerte!", e_FontTypeNames.FONTTYPE_GUILD)

1135        ElseIf .Stats.ELV < 14 Then
1140            Call WriteConsoleMsg(userindex, "¡Bienvenido de nuevo " & .name & "! Actualmente estas en el nivel " & .Stats.ELV & " en " & get_map_name(.Pos.Map) & ", ¡buen viaje y mucha suerte!", e_FontTypeNames.FONTTYPE_GUILD)

             End If

1145        If Status(userindex) = Criminal Or Status(userindex) = e_Facciones.Caos Then
1150            Call WriteSafeModeOff(userindex)
1155            .flags.Seguro = False

             Else
1160            .flags.Seguro = True
1165            Call WriteSafeModeOn(userindex)

             End If
        
1170        If LenB(.MENSAJEINFORMACION) > 0 Then
                 Dim Lines() As String
1175            Lines = Split(.MENSAJEINFORMACION, vbNewLine)

1180            For i = 0 To UBound(Lines)

1185                If LenB(Lines(i)) > 0 Then
1190                    Call WriteConsoleMsg(userindex, Lines(i), e_FontTypeNames.FONTTYPE_New_DONADOR)
                     End If

                 Next

1195            .MENSAJEINFORMACION = vbNullString
             End If

1215        If EventoActivo Then
1220            Call WriteConsoleMsg(userindex, PublicidadEvento & ". Tiempo restante: " & TiempoRestanteEvento & " minuto(s).", e_FontTypeNames.FONTTYPE_New_Eventos)
             End If
        
1225        Call WriteContadores(userindex)
1227        Call WritePrivilegios(userindex)
            
         End With

         Exit Function

Complete_ConnectUser_Err:
1235    Call TraceError(Err.Number, Err.Description, "UsUaRiOs.ConnectUser_Complete", Erl)

End Function

Sub ActStats(ByVal VictimIndex As Integer, ByVal AttackerIndex As Integer)
        
        On Error GoTo ActStats_Err
        

        Dim DaExp       As Integer

        Dim EraCriminal As Byte
    
100     DaExp = CInt(UserList(VictimIndex).Stats.ELV * 2)
    
102     If UserList(AttackerIndex).Stats.ELV < STAT_MAXELV Then
104         UserList(AttackerIndex).Stats.Exp = UserList(AttackerIndex).Stats.Exp + DaExp

106         If UserList(AttackerIndex).Stats.Exp > MAXEXP Then UserList(AttackerIndex).Stats.Exp = MAXEXP

108         Call WriteUpdateExp(AttackerIndex)
110         Call CheckUserLevel(AttackerIndex)

        End If
    
        'Lo mata
        'Call WriteConsoleMsg(attackerIndex, "Has matado a " & UserList(VictimIndex).name & "!", e_FontTypeNames.FONTTYPE_FIGHT)
    
112     Call WriteLocaleMsg(AttackerIndex, "184", e_FontTypeNames.FONTTYPE_FIGHT, UserList(VictimIndex).name)
114     Call WriteLocaleMsg(AttackerIndex, "140", e_FontTypeNames.FONTTYPE_EXP, DaExp)
          
        'Call WriteConsoleMsg(VictimIndex, UserList(attackerIndex).name & " te ha matado!", e_FontTypeNames.FONTTYPE_FIGHT)
116     Call WriteLocaleMsg(VictimIndex, "185", e_FontTypeNames.FONTTYPE_FIGHT, UserList(AttackerIndex).name)
    
118     If TriggerZonaPelea(VictimIndex, AttackerIndex) <> TRIGGER6_PERMITE Then
120         EraCriminal = Status(AttackerIndex)
        
122         If EraCriminal = 2 And Status(AttackerIndex) < 2 Then
124             Call RefreshCharStatus(AttackerIndex)
126         ElseIf EraCriminal < 2 And Status(AttackerIndex) = 2 Then
128             Call RefreshCharStatus(AttackerIndex)

            End If

        End If
    
130     Call UserDie(VictimIndex)
        
132     If UserList(AttackerIndex).Stats.UsuariosMatados < MAXUSERMATADOS Then
134         UserList(AttackerIndex).Stats.UsuariosMatados = UserList(AttackerIndex).Stats.UsuariosMatados + 1
        End If
        
        Exit Sub

ActStats_Err:
136     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.ActStats", Erl)

        
End Sub

Sub RevivirUsuario(ByVal userindex As Integer, Optional ByVal MedianteHechizo As Boolean)
        
        On Error GoTo RevivirUsuario_Err
        
100     With UserList(userindex)

102         .flags.Muerto = 0
104         .Stats.MinHp = .Stats.MaxHp

            ' El comportamiento cambia si usamos el hechizo Resucitar
106         If MedianteHechizo Then
108             .Stats.MinHp = 1
110             .Stats.MinHam = 0
112             .Stats.MinAGU = 0
            
114             Call WriteUpdateHungerAndThirst(userindex)
            End If
        
116         Call WriteUpdateHP(userindex)
            
118         If .flags.Navegando = 1 Then
120             Call EquiparBarco(userindex)
            Else

122             .Char.Head = .OrigChar.Head
    
124             If .Invent.CascoEqpObjIndex > 0 Then
126                 .Char.CascoAnim = ObjData(.Invent.CascoEqpObjIndex).CascoAnim
                End If
    
128             If .Invent.EscudoEqpObjIndex > 0 Then
130                 .Char.ShieldAnim = ObjData(.Invent.EscudoEqpObjIndex).ShieldAnim
    
                End If
    
132             If .Invent.WeaponEqpObjIndex > 0 Then
134                 .Char.WeaponAnim = ObjData(.Invent.WeaponEqpObjIndex).WeaponAnim
        
136                 If ObjData(.Invent.WeaponEqpObjIndex).CreaGRH <> "" Then
138                     .Char.Arma_Aura = ObjData(.Invent.WeaponEqpObjIndex).CreaGRH
140                     Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageAuraToChar(.Char.CharIndex, .Char.Arma_Aura, False, 1))
    
                    End If
            
                End If
    
142             If .Invent.ArmourEqpObjIndex > 0 Then
144                 .Char.Body = ObjData(.Invent.ArmourEqpObjIndex).Ropaje
        
146                 If ObjData(.Invent.ArmourEqpObjIndex).CreaGRH <> "" Then
148                     .Char.Body_Aura = ObjData(.Invent.ArmourEqpObjIndex).CreaGRH
150                     Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageAuraToChar(.Char.CharIndex, .Char.Body_Aura, False, 2))
    
                    End If
    
                Else
152                 Call DarCuerpoDesnudo(userindex)
            
                End If
    
154             If .Invent.EscudoEqpObjIndex > 0 Then
156                 .Char.ShieldAnim = ObjData(.Invent.EscudoEqpObjIndex).ShieldAnim
    
158                 If ObjData(.Invent.EscudoEqpObjIndex).CreaGRH <> "" Then
160                     .Char.Escudo_Aura = ObjData(.Invent.EscudoEqpObjIndex).CreaGRH
162                     Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageAuraToChar(.Char.CharIndex, .Char.Escudo_Aura, False, 3))
    
                    End If
            
                End If
    
164             If .Invent.CascoEqpObjIndex > 0 Then
166                 .Char.CascoAnim = ObjData(.Invent.CascoEqpObjIndex).CascoAnim
    
168                 If ObjData(.Invent.CascoEqpObjIndex).CreaGRH <> "" Then
170                     .Char.Head_Aura = ObjData(.Invent.CascoEqpObjIndex).CreaGRH
172                     Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageAuraToChar(.Char.CharIndex, .Char.Head_Aura, False, 4))
    
                    End If
            
                End If
    
174             If .Invent.MagicoObjIndex > 0 Then
176                 If ObjData(.Invent.MagicoObjIndex).CreaGRH <> "" Then
178                     .Char.Otra_Aura = ObjData(.Invent.MagicoObjIndex).CreaGRH
180                     Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageAuraToChar(.Char.CharIndex, .Char.Otra_Aura, False, 5))
    
                    End If
    
                End If
    
182             If .Invent.NudilloObjIndex > 0 Then
184                 If ObjData(.Invent.NudilloObjIndex).CreaGRH <> "" Then
186                     .Char.Arma_Aura = ObjData(.Invent.NudilloObjIndex).CreaGRH
188                     Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageAuraToChar(.Char.CharIndex, .Char.Arma_Aura, False, 1))
    
                    End If
                End If
                
190             If .Invent.DañoMagicoEqpObjIndex > 0 Then
192                 If ObjData(.Invent.DañoMagicoEqpObjIndex).CreaGRH <> "" Then
194                     .Char.DM_Aura = ObjData(.Invent.DañoMagicoEqpObjIndex).CreaGRH
196                     Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageAuraToChar(.Char.CharIndex, .Char.DM_Aura, False, 6))
                    End If
                End If
                
198             If .Invent.ResistenciaEqpObjIndex > 0 Then
200                 If ObjData(.Invent.ResistenciaEqpObjIndex).CreaGRH <> "" Then
202                     .Char.RM_Aura = ObjData(.Invent.ResistenciaEqpObjIndex).CreaGRH
204                     Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageAuraToChar(.Char.CharIndex, .Char.RM_Aura, False, 7))
                    End If
                End If
    
            End If
    
206         Call ActualizarVelocidadDeUsuario(userindex)
208         Call ChangeUserChar(userindex, .Char.Body, .Char.Head, .Char.Heading, .Char.WeaponAnim, .Char.ShieldAnim, .Char.CascoAnim)
            
         Call MakeUserChar(True, UserList(userindex).Pos.Map, userindex, UserList(userindex).Pos.Map, UserList(userindex).Pos.X, UserList(userindex).Pos.Y, 0)
        End With
        
        Exit Sub

RevivirUsuario_Err:
210     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.RevivirUsuario", Erl)

        
End Sub

Sub ChangeUserChar(ByVal userindex As Integer, ByVal Body As Integer, ByVal Head As Integer, ByVal Heading As Byte, ByVal Arma As Integer, ByVal Escudo As Integer, ByVal Casco As Integer)
        
        On Error GoTo ChangeUserChar_Err
        

100     With UserList(userindex).Char
102         .Body = Body
104         .Head = Head
106         .Heading = Heading
108         .WeaponAnim = Arma
110         .ShieldAnim = Escudo
112         .CascoAnim = Casco

        End With
    
114     Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageCharacterChange(Body, Head, Heading, UserList(userindex).Char.CharIndex, Arma, Escudo, UserList(userindex).Char.FX, UserList(userindex).Char.loops, Casco, False, UserList(userindex).flags.Navegando))

        
        Exit Sub

ChangeUserChar_Err:
116     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.ChangeUserChar", Erl)

        
End Sub

Sub EraseUserChar(ByVal userindex As Integer, ByVal Desvanecer As Boolean, Optional ByVal FueWarp As Boolean = False)

        On Error GoTo ErrorHandler

102     If UserList(userindex).Char.CharIndex = 0 Then Exit Sub
   
104     CharList(UserList(userindex).Char.CharIndex) = 0
    
106     If UserList(userindex).Char.CharIndex = LastChar Then

108         Do Until CharList(LastChar) > 0
110             LastChar = LastChar - 1

112             If LastChar <= 1 Then Exit Do
            Loop

        End If

        'Le mandamos el mensaje para que borre el personaje a los clientes que estén cerca
116     Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageCharacterRemove(4, UserList(userindex).Char.CharIndex, Desvanecer, FueWarp))

120     Call QuitarUser(userindex, UserList(userindex).Pos.Map)


124     MapData(UserList(userindex).Pos.Map, UserList(userindex).Pos.X, UserList(userindex).Pos.Y).userindex = 0

128     UserList(userindex).Char.CharIndex = 0
    
130     NumChars = NumChars - 1

        Exit Sub
    
ErrorHandler:
134     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.EraseUserChar", Erl)

End Sub

Sub RefreshCharStatus(ByVal userindex As Integer)
        
        On Error GoTo RefreshCharStatus_Err
        

        '*************************************************
        'Author: Tararira
        'Last modified: 6/04/2007
        'Refreshes the status and tag of UserIndex.
        '*************************************************
        Dim klan As String, name As String

100     If UserList(userindex).showName Then

102         If UserList(userindex).flags.Mimetizado = e_EstadoMimetismo.Desactivado Then

104             If UserList(userindex).GuildIndex > 0 Then
106                 klan = modGuilds.GuildName(UserList(userindex).GuildIndex)
108                 klan = " <" & klan & ">"
                End If
            
110             name = UserList(userindex).name & klan

            Else
112             name = UserList(userindex).NameMimetizado
            End If
            
114         If UserList(userindex).clase = e_Class.Pirat Then
116             If UserList(userindex).flags.Oculto = 1 Then
118                 name = vbNullString
                End If
            End If
            
        End If
    
120     Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageUpdateTagAndStatus(userindex, UserList(userindex).Faccion.Status, name))

        
        Exit Sub

RefreshCharStatus_Err:
122     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.RefreshCharStatus", Erl)

        
End Sub

Sub MakeUserChar(ByVal toMap As Boolean, _
                 ByVal sndIndex As Integer, _
                 ByVal userindex As Integer, _
                 ByVal Map As Integer, _
                 ByVal X As Integer, _
                 ByVal Y As Integer, _
                 Optional ByVal appear As Byte = 0)

        On Error GoTo HayError

        Dim CharIndex As Integer

        Dim TempName  As String
    
100     If InMapBounds(Map, X, Y) Then
        
102         With UserList(userindex)
        
                'If needed make a new character in list
104             If .Char.CharIndex = 0 Then
106                 CharIndex = NextOpenCharIndex
108                 .Char.CharIndex = CharIndex
110                 CharList(CharIndex) = userindex
                End If

                'Place character on map if needed
112             If toMap Then MapData(Map, X, Y).userindex = userindex

                'Send make character command to clients
                Dim klan       As String
                Dim clan_nivel As Byte

114             If Not toMap Then
                
116                 If .showName Then
118                     If .flags.Mimetizado = e_EstadoMimetismo.Desactivado Then
120                         If .GuildIndex > 0 Then
                    
122                             klan = modGuilds.GuildName(.GuildIndex)
124                             clan_nivel = modGuilds.NivelDeClan(.GuildIndex)
126                             TempName = .name & " <" & klan & ">"
                    
                            Else
                        
128                             klan = vbNullString
130                             clan_nivel = 0
                            
132                             If .flags.EnConsulta Then
                                
134                                 TempName = .name & " [CONSULTA]"
                                
                                Else
                            
136                                 TempName = .name
                            
                                End If
                            
                            End If
                        Else
138                         TempName = .NameMimetizado
                        End If
                    End If

140                 Call WriteCharacterCreate(sndIndex, .Char.Body, .Char.Head, .Char.Heading, .Char.CharIndex, X, Y, .Char.WeaponAnim, .Char.ShieldAnim, .Char.FX, 999, .Char.CascoAnim, TempName, .Faccion.Status, .flags.Privilegios, .Char.ParticulaFx, .Char.Head_Aura, .Char.Arma_Aura, .Char.Body_Aura, .Char.DM_Aura, .Char.RM_Aura, .Char.Otra_Aura, .Char.Escudo_Aura, .Char.speeding, 0, appear, .Grupo.Lider, .GuildIndex, clan_nivel, .Stats.MinHp, .Stats.MaxHp, .Stats.MinMAN, .Stats.MaxMAN, 0, False, .flags.Navegando, .Stats.tipoUsuario)
                Else
            
                    'Hide the name and clan - set privs as normal user
142                 Call AgregarUser(userindex, .Pos.Map, appear)
                
                End If
            
            End With
        
        End If

        Exit Sub

HayError:
        
        Dim Desc As String
144         Desc = Err.Description & vbNewLine & _
                    " Usuario: " & UserList(userindex).name & vbNewLine & _
                    "Pos: " & Map & "-" & X & "-" & Y
            
146     Call TraceError(Err.Number, Err.Description, "Usuarios.MakeUserChar", Erl())
        
148     Call CloseSocket(userindex)

End Sub

Sub CheckUserLevel(ByVal userindex As Integer)
        '*************************************************
        'Author: Unknown
        'Last modified: 01/10/2007
        'Chequea que el usuario no halla alcanzado el siguiente nivel,
        'de lo contrario le da la vida, mana, etc, correspodiente.
        '07/08/2006 Integer - Modificacion de los valores
        '01/10/2007 Tavo - Corregido el BUG de STAT_MAXELV
        '24/01/2007 Pablo (ToxicWaste) - Agrego modificaciones en ELU al subir de nivel.
        '24/01/2007 Pablo (ToxicWaste) - Agrego modificaciones de la subida de mana de los magos por lvl.
        '13/03/2007 Pablo (ToxicWaste) - Agrego diferencias entre el 18 y el 19 en Constitución.
        '09/01/2008 Pablo (ToxicWaste) - Ahora el incremento de vida por Consitución se controla desde Balance.dat
        '17/12/2020 WyroX: Distribución normal de las vidas
        '*************************************************

        On Error GoTo ErrHandler

        Dim Pts              As Integer

        Dim AumentoHIT       As Integer

        Dim AumentoMANA      As Integer

        Dim AumentoSta       As Integer

        Dim AumentoHP        As Integer

        Dim WasNewbie        As Boolean

        Dim Promedio         As Double
        
        Dim PromedioObjetivo As Double
        
        Dim PromedioUser     As Double

        Dim aux              As Integer
    
        Dim PasoDeNivel      As Boolean
        Dim experienceToLevelUp As Long

        ' Randomizo las vidas
100     Randomize Time
    
102     With UserList(userindex)

104         WasNewbie = EsNewbie(userindex)
106         experienceToLevelUp = ExpLevelUp(.Stats.ELV)
        
108         Do While .Stats.Exp >= experienceToLevelUp And .Stats.ELV < STAT_MAXELV
            
                'Store it!
                'Call Statistics.UserLevelUp(UserIndex)

110             Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageCreateFX(.Char.CharIndex, 106, 0))
112             Call SendData(SendTarget.ToPCArea, userindex, PrepareMessagePlayWave(SND_NIVEL, .Pos.X, .Pos.Y))
114             Call WriteLocaleMsg(userindex, "186", e_FontTypeNames.FONTTYPE_INFO)
            
116             .Stats.Exp = .Stats.Exp - experienceToLevelUp
                
118             Pts = Pts + 5
            
                ' Calculo subida de vida by WyroX
                ' Obtengo el promedio según clase y constitución
120             PromedioObjetivo = ModClase(.clase).Vida - (21 - .Stats.UserAtributos(e_Atributos.Constitucion)) * 0.5
                ' Obtengo el promedio actual del user
122             PromedioUser = CalcularPromedioVida(userindex)
                ' Lo modifico para compensar si está muy bajo o muy alto
124             Promedio = PromedioObjetivo + (PromedioObjetivo - PromedioUser) * DesbalancePromedioVidas
                ' Obtengo un entero al azar con más tendencia al promedio
126             AumentoHP = RandomIntBiased(PromedioObjetivo - RangoVidas, PromedioObjetivo + RangoVidas, Promedio, InfluenciaPromedioVidas)

                ' WyroX: Aumento del resto de stats
128             AumentoSta = ModClase(.clase).AumentoSta
130             AumentoMANA = ModClase(.clase).MultMana * .Stats.UserAtributos(e_Atributos.Inteligencia)
132             AumentoHIT = IIf(.Stats.ELV < 36, ModClase(.clase).HitPre36, ModClase(.clase).HitPost36)

134             .Stats.ELV = .Stats.ELV + 1
136             experienceToLevelUp = ExpLevelUp(.Stats.ELV)
                
                'Actualizamos HitPoints
138             .Stats.MaxHp = .Stats.MaxHp + AumentoHP

140             If .Stats.MaxHp > STAT_MAXHP Then .Stats.MaxHp = STAT_MAXHP
                'Actualizamos Stamina
142             .Stats.MaxSta = .Stats.MaxSta + AumentoSta

144             If .Stats.MaxSta > STAT_MAXSTA Then .Stats.MaxSta = STAT_MAXSTA
                'Actualizamos Mana
146             .Stats.MaxMAN = .Stats.MaxMAN + AumentoMANA

148             If .Stats.MaxMAN > STAT_MAXMAN Then .Stats.MaxMAN = STAT_MAXMAN

                'Actualizamos Golpe Máximo
150             .Stats.MaxHit = .Stats.MaxHit + AumentoHIT
            
                'Actualizamos Golpe Mínimo
152             .Stats.MinHIT = .Stats.MinHIT + AumentoHIT
        
                'Notificamos al user
154             If AumentoHP > 0 Then
                    'Call WriteConsoleMsg(UserIndex, "Has ganado " & AumentoHP & " puntos de vida.", e_FontTypeNames.FONTTYPE_INFO)
156                 Call WriteLocaleMsg(userindex, "197", e_FontTypeNames.FONTTYPE_INFO, AumentoHP)

                End If

158             If AumentoSta > 0 Then
                    'Call WriteConsoleMsg(UserIndex, "Has ganado " & AumentoSTA & " puntos de vitalidad.", e_FontTypeNames.FONTTYPE_INFO)
160                 Call WriteLocaleMsg(userindex, "198", e_FontTypeNames.FONTTYPE_INFO, AumentoSta)

                End If

162             If AumentoMANA > 0 Then
164                 Call WriteLocaleMsg(userindex, "199", e_FontTypeNames.FONTTYPE_INFO, AumentoMANA)

                    'Call WriteConsoleMsg(UserIndex, "Has ganado " & AumentoMANA & " puntos de magia.", e_FontTypeNames.FONTTYPE_INFO)
                End If

166             If AumentoHIT > 0 Then
168                 Call WriteLocaleMsg(userindex, "200", e_FontTypeNames.FONTTYPE_INFO, AumentoHIT)

                    'Call WriteConsoleMsg(UserIndex, "Tu golpe aumento en " & AumentoHIT & " puntos.", e_FontTypeNames.FONTTYPE_INFO)
                End If

170             PasoDeNivel = True
             
172             .Stats.MinHp = .Stats.MaxHp
            
                ' Call UpdateUserInv(True, UserIndex, 0)
            
174             If OroPorNivel > 0 Then
176                 If EsNewbie(userindex) Then
                        Dim OroRecompenza As Long
    
178                     OroRecompenza = OroPorNivel * .Stats.ELV * OroMult
180                     .Stats.GLD = .Stats.GLD + OroRecompenza
                        'Call WriteConsoleMsg(UserIndex, "Has ganado " & OroRecompenza & " monedas de oro.", e_FontTypeNames.FONTTYPE_INFO)
182                     Call WriteLocaleMsg(userindex, "29", e_FontTypeNames.FONTTYPE_INFO, PonerPuntos(OroRecompenza))
                    End If
                End If
            
184             If Not EsNewbie(userindex) And WasNewbie Then
        
186                 Call QuitarNewbieObj(userindex)
            
                End If
        
            Loop
        
188         If PasoDeNivel Then
190             If .Stats.ELV >= STAT_MAXELV Then .Stats.Exp = 0
        
192             Call UpdateUserInv(True, userindex, 0)
                'Call CheckearRecompesas(UserIndex, 3)
194             Call WriteUpdateUserStats(userindex)
            
196             If Pts > 0 Then
                
198                 .Stats.SkillPts = .Stats.SkillPts + Pts
200                 Call WriteLevelUp(userindex, .Stats.SkillPts)
202                 Call WriteLocaleMsg(userindex, "187", e_FontTypeNames.FONTTYPE_INFO, Pts)

                    'Call WriteConsoleMsg(UserIndex, "Has ganado un total de " & Pts & " skillpoints.", e_FontTypeNames.FONTTYPE_INFO)
                End If
                
204             If .Stats.ELV >= MapInfo(.Pos.Map).MaxLevel And Not EsGM(userindex) Then
206                 If MapInfo(.Pos.Map).Salida.Map <> 0 Then
208                     Call WriteConsoleMsg(userindex, "Tu nivel no te permite seguir en el mapa.", e_FontTypeNames.FONTTYPE_INFO)
210                     Call WarpUserChar(userindex, MapInfo(.Pos.Map).Salida.Map, MapInfo(.Pos.Map).Salida.X, MapInfo(.Pos.Map).Salida.Y, True)
                    End If
                End If

            End If
    
        End With
    
        Exit Sub

ErrHandler:
212     Call LogError("Error en la subrutina CheckUserLevel - Error : " & Err.Number & " - Description : " & Err.Description)

End Sub

Function MoveUserChar(ByVal userindex As Integer, ByVal nHeading As e_Heading) As Boolean
        ' 20/01/2021 - WyroX: Lo convierto a función y saco los WritePosUpdate, ahora están en el paquete

        On Error GoTo MoveUserChar_Err

        Dim nPos         As t_WorldPos
        Dim nPosOriginal As t_WorldPos
        Dim nPosMuerto   As t_WorldPos
        Dim IndexMover As Integer
        Dim Opposite_Heading As e_Heading

100     With UserList(userindex)

102         nPos = .Pos
104         Call HeadtoPos(nHeading, nPos)

106         If Not LegalWalk(.Pos.Map, nPos.X, nPos.Y, nHeading, .flags.Navegando = 1, .flags.Navegando = 0, .flags.Montado, , userindex) Then
                Exit Function
            End If
            
            If .flags.Navegando And .Invent.BarcoObjIndex = 197 And Not (MapData(.Pos.Map, nPos.X, nPos.Y).trigger = e_Trigger.DETALLEAGUA Or MapData(.Pos.Map, nPos.X, nPos.Y).trigger = e_Trigger.NADOCOMBINADO Or MapData(.Pos.Map, nPos.X, nPos.Y).trigger = e_Trigger.VALIDONADO) Then
                Exit Function
            End If

108         If .Accion.AccionPendiente = True Then
110             .Counters.TimerBarra = 0
112             Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageParticleFX(.Char.CharIndex, .Accion.Particula, .Counters.TimerBarra, True))
114             Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageBarFx(.Char.CharIndex, .Counters.TimerBarra, e_AccionBarra.CancelarAccion))
116             .Accion.AccionPendiente = False
118             .Accion.Particula = 0
120             .Accion.TipoAccion = e_AccionBarra.CancelarAccion
122             .Accion.HechizoPendiente = 0
124             .Accion.RunaObj = 0
126             .Accion.ObjSlot = 0
128             .Accion.AccionPendiente = False
            End If

            'If .flags.Muerto = 0 Then
            '    If MapData(nPos.Map, nPos.X, nPos.Y).TileExit.Map <> 0 And .Counters.EnCombate > 0 Then
            '        Call WriteConsoleMsg(UserIndex, "Estás en combate, debes aguardar " & .Counters.EnCombate & " segundo(s) para escapar...", e_FontTypeNames.FONTTYPE_INFOBOLD)
            '        Exit Function
            '    End If
            'End If

            'Si no estoy solo en el mapa...
130         If MapInfo(.Pos.Map).NumUsers > 1 Then

                ' Intercambia posición si hay un casper o gm invisible
132             IndexMover = MapData(nPos.Map, nPos.X, nPos.Y).userindex
            
134             If IndexMover <> 0 Then
                    ' Sólo puedo patear caspers/gms invisibles si no es él un gm invisible
136                 If UserList(userindex).flags.AdminInvisible <> 0 Then Exit Function

138                 Call WritePosUpdate(IndexMover)

140                 Opposite_Heading = InvertHeading(nHeading)
142                 Call HeadtoPos(Opposite_Heading, UserList(IndexMover).Pos)
                
                    ' Si es un admin invisible, no se avisa a los demas clientes
144                 If UserList(IndexMover).flags.AdminInvisible = 0 Then
146                     Call SendData(SendTarget.ToPCAreaButIndex, IndexMover, PrepareMessageCharacterMove(UserList(IndexMover).Char.CharIndex, UserList(IndexMover).Pos.X, UserList(IndexMover).Pos.Y))
                    Else
148                     Call SendData(SendTarget.ToAdminAreaButIndex, IndexMover, PrepareMessageCharacterMove(UserList(IndexMover).Char.CharIndex, UserList(IndexMover).Pos.X, UserList(IndexMover).Pos.Y))
                    End If
                    
150                 Call WriteForceCharMove(IndexMover, Opposite_Heading)
                
                    'Update map and char
152                 UserList(IndexMover).Char.Heading = Opposite_Heading
154                 MapData(UserList(IndexMover).Pos.Map, UserList(IndexMover).Pos.X, UserList(IndexMover).Pos.Y).userindex = IndexMover
                
                    'Actualizamos las areas de ser necesario
156                 Call ModAreas.CheckUpdateNeededUser(IndexMover, Opposite_Heading, 0)
                End If

158             If .flags.AdminInvisible = 0 Then
160                 Call SendData(SendTarget.ToPCAreaButIndex, userindex, PrepareMessageCharacterMove(.Char.CharIndex, nPos.X, nPos.Y))
                Else
162                 Call SendData(SendTarget.ToAdminAreaButIndex, userindex, PrepareMessageCharacterMove(.Char.CharIndex, nPos.X, nPos.Y))
                End If
            End If
        
            'Update map and user pos
164         If MapData(.Pos.Map, .Pos.X, .Pos.Y).userindex = userindex Then
166             MapData(.Pos.Map, .Pos.X, .Pos.Y).userindex = 0
            End If

168         .Pos = nPos
170         .Char.Heading = nHeading
172         MapData(.Pos.Map, .Pos.X, .Pos.Y).userindex = userindex
        
            'Actualizamos las áreas de ser necesario
174         Call ModAreas.CheckUpdateNeededUser(userindex, nHeading, 0)

176         If .Counters.Trabajando Then
178             Call WriteMacroTrabajoToggle(userindex, False)
            End If

180         If .Counters.Ocultando Then .Counters.Ocultando = .Counters.Ocultando - 1
    
        End With
    
182     MoveUserChar = True
    
        Exit Function
    
MoveUserChar_Err:
184     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.MoveUserChar", Erl)

        
End Function

Public Function InvertHeading(ByVal nHeading As e_Heading) As e_Heading
        
        On Error GoTo InvertHeading_Err
    
        

        '*************************************************
        'Author: ZaMa
        'Last modified: 30/03/2009
        'Returns the heading opposite to the one passed by val.
        '*************************************************
100     Select Case nHeading

            Case e_Heading.EAST
102             InvertHeading = e_Heading.WEST

104         Case e_Heading.WEST
106             InvertHeading = e_Heading.EAST

108         Case e_Heading.SOUTH
110             InvertHeading = e_Heading.NORTH

112         Case e_Heading.NORTH
114             InvertHeading = e_Heading.SOUTH

        End Select

        
        Exit Function

InvertHeading_Err:
116     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.InvertHeading", Erl)

        
End Function

Sub ChangeUserInv(ByVal userindex As Integer, ByVal Slot As Byte, ByRef Object As t_UserOBJ)
        
        On Error GoTo ChangeUserInv_Err
        
100     UserList(userindex).Invent.Object(Slot) = Object
102     Call WriteChangeInventorySlot(userindex, Slot)

        
        Exit Sub

ChangeUserInv_Err:
104     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.ChangeUserInv", Erl)

        
End Sub

Function NextOpenCharIndex() As Integer
        
        On Error GoTo NextOpenCharIndex_Err
        

        Dim LoopC As Long
    
100     For LoopC = 1 To MAXCHARS

102         If CharList(LoopC) = 0 Then
104             NextOpenCharIndex = LoopC
106             NumChars = NumChars + 1
            
108             If LoopC > LastChar Then LastChar = LoopC
            
                Exit Function

            End If

110     Next LoopC

        
        Exit Function

NextOpenCharIndex_Err:
112     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.NextOpenCharIndex", Erl)

        
End Function

Function NextOpenUser() As Integer
        
        On Error GoTo NextOpenUser_Err
        

        Dim LoopC As Long
   
100     For LoopC = 1 To MaxUsers + 1

102         If LoopC > MaxUsers Then Exit For
104         If (Not UserList(LoopC).ConnIDValida And UserList(LoopC).flags.UserLogged = False) Then Exit For
106     Next LoopC
   
108     NextOpenUser = LoopC

        
        Exit Function

NextOpenUser_Err:
110     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.NextOpenUser", Erl)

        
End Function

Sub SendUserStatsTxt(ByVal sendIndex As Integer, ByVal userindex As Integer)
        
        On Error GoTo SendUserStatsTxt_Err
        

        Dim GuildI As Integer

100     Call WriteConsoleMsg(sendIndex, "Estadisticas de: " & UserList(userindex).name, e_FontTypeNames.FONTTYPE_INFO)
102     Call WriteConsoleMsg(sendIndex, "Nivel: " & UserList(userindex).Stats.ELV & "  EXP: " & UserList(userindex).Stats.Exp & "/" & ExpLevelUp(UserList(userindex).Stats.ELV), e_FontTypeNames.FONTTYPE_INFO)
104     Call WriteConsoleMsg(sendIndex, "Salud: " & UserList(userindex).Stats.MinHp & "/" & UserList(userindex).Stats.MaxHp & "  Mana: " & UserList(userindex).Stats.MinMAN & "/" & UserList(userindex).Stats.MaxMAN & "  Vitalidad: " & UserList(userindex).Stats.MinSta & "/" & UserList(userindex).Stats.MaxSta, e_FontTypeNames.FONTTYPE_INFO)
    
106     If UserList(userindex).Invent.WeaponEqpObjIndex > 0 Then
108         Call WriteConsoleMsg(sendIndex, "Menor Golpe/Mayor Golpe: " & UserList(userindex).Stats.MinHIT & "/" & UserList(userindex).Stats.MaxHit & " (" & ObjData(UserList(userindex).Invent.WeaponEqpObjIndex).MinHIT & "/" & ObjData(UserList(userindex).Invent.WeaponEqpObjIndex).MaxHit & ")", e_FontTypeNames.FONTTYPE_INFO)
        Else
110         Call WriteConsoleMsg(sendIndex, "Menor Golpe/Mayor Golpe: " & UserList(userindex).Stats.MinHIT & "/" & UserList(userindex).Stats.MaxHit, e_FontTypeNames.FONTTYPE_INFO)

        End If
    
112     If UserList(userindex).Invent.ArmourEqpObjIndex > 0 Then
114         If UserList(userindex).Invent.EscudoEqpObjIndex > 0 Then
116             Call WriteConsoleMsg(sendIndex, "(CUERPO) Min Def/Max Def: " & ObjData(UserList(userindex).Invent.ArmourEqpObjIndex).MinDef + ObjData(UserList(userindex).Invent.EscudoEqpObjIndex).MinDef & "/" & ObjData(UserList(userindex).Invent.ArmourEqpObjIndex).MaxDef + ObjData(UserList(userindex).Invent.EscudoEqpObjIndex).MaxDef, e_FontTypeNames.FONTTYPE_INFO)
            Else
118             Call WriteConsoleMsg(sendIndex, "(CUERPO) Min Def/Max Def: " & ObjData(UserList(userindex).Invent.ArmourEqpObjIndex).MinDef & "/" & ObjData(UserList(userindex).Invent.ArmourEqpObjIndex).MaxDef, e_FontTypeNames.FONTTYPE_INFO)

            End If

        Else
120         Call WriteConsoleMsg(sendIndex, "(CUERPO) Min Def/Max Def: 0", e_FontTypeNames.FONTTYPE_INFO)

        End If
    
122     If UserList(userindex).Invent.CascoEqpObjIndex > 0 Then
124         Call WriteConsoleMsg(sendIndex, "(CABEZA) Min Def/Max Def: " & ObjData(UserList(userindex).Invent.CascoEqpObjIndex).MinDef & "/" & ObjData(UserList(userindex).Invent.CascoEqpObjIndex).MaxDef, e_FontTypeNames.FONTTYPE_INFO)
        Else
126         Call WriteConsoleMsg(sendIndex, "(CABEZA) Min Def/Max Def: 0", e_FontTypeNames.FONTTYPE_INFO)

        End If
    
128     GuildI = UserList(userindex).GuildIndex

130     If GuildI > 0 Then
132         Call WriteConsoleMsg(sendIndex, "Clan: " & modGuilds.GuildName(GuildI), e_FontTypeNames.FONTTYPE_INFO)

134         If UCase$(modGuilds.GuildLeader(GuildI)) = UCase$(UserList(sendIndex).name) Then
136             Call WriteConsoleMsg(sendIndex, "Status: Líder", e_FontTypeNames.FONTTYPE_INFO)

            End If

            'guildpts no tienen objeto
        End If
    
        #If ConUpTime Then

            Dim TempDate As Date

            Dim TempSecs As Long

            Dim TempStr  As String

138         TempDate = Now - UserList(userindex).LogOnTime
140         TempSecs = (UserList(userindex).UpTime + (Abs(Day(TempDate) - 30) * 24 * 3600) + (Hour(TempDate) * 3600) + (Minute(TempDate) * 60) + Second(TempDate))
142         TempStr = (TempSecs \ 86400) & " Dias, " & ((TempSecs Mod 86400) \ 3600) & " Horas, " & ((TempSecs Mod 86400) Mod 3600) \ 60 & " Minutos, " & (((TempSecs Mod 86400) Mod 3600) Mod 60) & " Segundos."
144         Call WriteConsoleMsg(sendIndex, "Logeado hace: " & Hour(TempDate) & ":" & Minute(TempDate) & ":" & Second(TempDate), e_FontTypeNames.FONTTYPE_INFO)
146         Call WriteConsoleMsg(sendIndex, "Total: " & TempStr, e_FontTypeNames.FONTTYPE_INFO)
        #End If

148     Call WriteConsoleMsg(sendIndex, "Oro: " & UserList(userindex).Stats.GLD & "  Posicion: " & UserList(userindex).Pos.X & "," & UserList(userindex).Pos.Y & " en mapa " & UserList(userindex).Pos.Map, e_FontTypeNames.FONTTYPE_INFO)
150     Call WriteConsoleMsg(sendIndex, "Dados: " & UserList(userindex).Stats.UserAtributos(e_Atributos.Fuerza) & ", " & UserList(userindex).Stats.UserAtributos(e_Atributos.Agilidad) & ", " & UserList(userindex).Stats.UserAtributos(e_Atributos.Inteligencia) & ", " & UserList(userindex).Stats.UserAtributos(e_Atributos.Constitucion) & ", " & UserList(userindex).Stats.UserAtributos(e_Atributos.Carisma), e_FontTypeNames.FONTTYPE_INFO)
152     Call WriteConsoleMsg(sendIndex, "Veces que Moriste: " & UserList(userindex).flags.VecesQueMoriste, e_FontTypeNames.FONTTYPE_INFO)

        Exit Sub

SendUserStatsTxt_Err:
154     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.SendUserStatsTxt", Erl)

        
End Sub

Sub SendUserMiniStatsTxt(ByVal sendIndex As Integer, ByVal userindex As Integer)
        
        On Error GoTo SendUserMiniStatsTxt_Err
        

        '*************************************************
        'Author: Unknown
        'Last modified: 23/01/2007
        'Shows the users Stats when the user is online.
        '23/01/2007 Pablo (ToxicWaste) - Agrego de funciones y mejora de distribución de parámetros.
        '*************************************************
100     With UserList(userindex)
102         Call WriteConsoleMsg(sendIndex, "Pj: " & .name, e_FontTypeNames.FONTTYPE_INFO)
104         Call WriteConsoleMsg(sendIndex, "Ciudadanos Matados: " & .Faccion.ciudadanosMatados & " Criminales Matados: " & .Faccion.CriminalesMatados & " UsuariosMatados: " & .Stats.UsuariosMatados, e_FontTypeNames.FONTTYPE_INFO)
106         Call WriteConsoleMsg(sendIndex, "NPCsMuertos: " & .Stats.NPCsMuertos, e_FontTypeNames.FONTTYPE_INFO)
108         Call WriteConsoleMsg(sendIndex, "Clase: " & ListaClases(.clase), e_FontTypeNames.FONTTYPE_INFO)
110         Call WriteConsoleMsg(sendIndex, "Pena: " & .Counters.Pena, e_FontTypeNames.FONTTYPE_INFO)

112         If .GuildIndex > 0 Then
114             Call WriteConsoleMsg(sendIndex, "Clan: " & GuildName(.GuildIndex), e_FontTypeNames.FONTTYPE_INFO)

            End If

116         Call WriteConsoleMsg(sendIndex, "Oro en billetera: " & .Stats.GLD, e_FontTypeNames.FONTTYPE_INFO)
118         Call WriteConsoleMsg(sendIndex, "Oro en banco: " & .Stats.Banco, e_FontTypeNames.FONTTYPE_INFO)

        End With

        
        Exit Sub

SendUserMiniStatsTxt_Err:
126     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.SendUserMiniStatsTxt", Erl)

        
End Sub

Sub SendUserInvTxt(ByVal sendIndex As Integer, ByVal userindex As Integer)
        
        On Error GoTo SendUserInvTxt_Err
    
        

        

        Dim j As Long
    
100     Call WriteConsoleMsg(sendIndex, UserList(userindex).name, e_FontTypeNames.FONTTYPE_INFO)
102     Call WriteConsoleMsg(sendIndex, "Tiene " & UserList(userindex).Invent.NroItems & " objetos.", e_FontTypeNames.FONTTYPE_INFO)
    
104     For j = 1 To UserList(userindex).CurrentInventorySlots

106         If UserList(userindex).Invent.Object(j).ObjIndex > 0 Then
108             Call WriteConsoleMsg(sendIndex, " Objeto " & j & " " & ObjData(UserList(userindex).Invent.Object(j).ObjIndex).name & " Cantidad:" & UserList(userindex).Invent.Object(j).amount, e_FontTypeNames.FONTTYPE_INFO)

            End If

110     Next j

        
        Exit Sub

SendUserInvTxt_Err:
112     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.SendUserInvTxt", Erl)

        
End Sub

Sub SendUserSkillsTxt(ByVal sendIndex As Integer, ByVal userindex As Integer)
        
        On Error GoTo SendUserSkillsTxt_Err
    
        

        

        Dim j As Integer

100     Call WriteConsoleMsg(sendIndex, UserList(userindex).name, e_FontTypeNames.FONTTYPE_INFO)

102     For j = 1 To NUMSKILLS
104         Call WriteConsoleMsg(sendIndex, SkillsNames(j) & " = " & UserList(userindex).Stats.UserSkills(j), e_FontTypeNames.FONTTYPE_INFO)
        Next
106     Call WriteConsoleMsg(sendIndex, " SkillLibres:" & UserList(userindex).Stats.SkillPts, e_FontTypeNames.FONTTYPE_INFO)

        
        Exit Sub

SendUserSkillsTxt_Err:
108     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.SendUserSkillsTxt", Erl)

        
End Sub

Function DameUserIndexConNombre(ByVal nombre As String) As Integer
        
        On Error GoTo DameUserIndexConNombre_Err
        

        Dim LoopC As Integer
  
100     LoopC = 1
  
102     nombre = UCase$(nombre)

104     Do Until UCase$(UserList(LoopC).name) = nombre

106         LoopC = LoopC + 1
    
108         If LoopC > MaxUsers Then
110             DameUserIndexConNombre = 0
                Exit Function

            End If
    
        Loop
  
112     DameUserIndexConNombre = LoopC

        
        Exit Function

DameUserIndexConNombre_Err:
114     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.DameUserIndexConNombre", Erl)

        
End Function

Sub NPCAtacado(ByVal NpcIndex As Integer, ByVal userindex As Integer)
        On Error GoTo NPCAtacado_Err
        
        ' WyroX: El usuario pierde la protección
100     UserList(userindex).Counters.TiempoDeInmunidad = 0
102     UserList(userindex).flags.Inmunidad = 0

        'Guardamos el usuario que ataco el npc.
104     If NpcList(NpcIndex).Movement <> Estatico And NpcList(NpcIndex).flags.AttackedFirstBy = vbNullString Then
106         NpcList(NpcIndex).Target = userindex
108         NpcList(NpcIndex).Hostile = 1
110         NpcList(NpcIndex).flags.AttackedBy = UserList(userindex).name
        End If

        'Npc que estabas atacando.
        Dim LastNpcHit As Integer

112     LastNpcHit = UserList(userindex).flags.NPCAtacado
        'Guarda el NPC que estas atacando ahora.
114     UserList(userindex).flags.NPCAtacado = NpcIndex

116     If NpcList(NpcIndex).flags.Faccion = Armada And Status(userindex) = e_Facciones.Ciudadano Then
118         Call VolverCriminal(userindex)
        End If
        
120     If NpcList(NpcIndex).MaestroUser > 0 And NpcList(NpcIndex).MaestroUser <> userindex Then
122         Call AllMascotasAtacanUser(userindex, NpcList(NpcIndex).MaestroUser)
        End If

124     'Call AllMascotasAtacanNPC(NpcIndex, UserIndex)
        
        Exit Sub

NPCAtacado_Err:
126     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.NPCAtacado", Erl)

        
End Sub

Sub SubirSkill(ByVal userindex As Integer, ByVal Skill As Integer)
        On Error GoTo SubirSkill_Err

        Dim Lvl As Integer, maxPermitido As Integer
100         Lvl = UserList(userindex).Stats.ELV

102     If UserList(userindex).Stats.UserSkills(Skill) = MAXSKILLPOINTS Then Exit Sub

        ' Se suben 5 skills cada dos niveles como máximo.
104     If (Lvl Mod 2 = 0) Then ' El level es numero par
106         maxPermitido = (Lvl \ 2) * 5
        Else ' El level es numero impar
            ' Esta cuenta signifca, que si el nivel anterior terminaba en 5 ahora
            ' suma dos puntos mas, sino 3. Lo de siempre.
108         maxPermitido = (Lvl \ 2) * 5 + 3 - (((((Lvl - 1) \ 2) * 5) Mod 10) \ 5)
        End If

110     If UserList(userindex).Stats.UserSkills(Skill) >= maxPermitido Then Exit Sub

112     If UserList(userindex).Stats.MinHam > 0 And UserList(userindex).Stats.MinAGU > 0 Then

            Dim Aumenta As Integer
            Dim prob    As Integer
            Dim Menor   As Byte
            
114         Menor = 10
            
            Select Case Lvl
                Case Is <= 12
                    prob = 15
                Case Is <= 24
                    prob = 30
                Case Else
                    prob = 50
            End Select
             
134         Aumenta = RandomNumber(1, prob * DificultadSubirSkill)
             
136         If UserList(userindex).flags.PendienteDelExperto = 1 Then
138             Menor = 15
            End If
            
140         If Aumenta < Menor Then
142             UserList(userindex).Stats.UserSkills(Skill) = UserList(userindex).Stats.UserSkills(Skill) + 1
    
144             Call WriteConsoleMsg(userindex, "¡Has mejorado tu skill " & SkillsNames(Skill) & " en un punto!. Ahora tienes " & UserList(userindex).Stats.UserSkills(Skill) & " pts.", e_FontTypeNames.FONTTYPE_INFO)
            
                Dim BonusExp As Long
146             BonusExp = 50& * ExpMult
        
                Call WriteConsoleMsg(userindex, "¡Has ganado " & BonusExp & " puntos de experiencia!", e_FontTypeNames.FONTTYPE_INFOIAO)
                
152             If UserList(userindex).Stats.ELV < STAT_MAXELV Then
154                 UserList(userindex).Stats.Exp = UserList(userindex).Stats.Exp + BonusExp
156                 If UserList(userindex).Stats.Exp > MAXEXP Then UserList(userindex).Stats.Exp = MAXEXP
                    
                    UserList(userindex).flags.ModificoSkills = True
                    
158                 If UserList(userindex).ChatCombate = 1 Then
160                     Call WriteLocaleMsg(userindex, "140", e_FontTypeNames.FONTTYPE_EXP, BonusExp)
                    End If
                
162                 Call WriteUpdateExp(userindex)
164                 Call CheckUserLevel(userindex)

                End If

            End If

        End If

        
        Exit Sub

SubirSkill_Err:
166     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.SubirSkill", Erl)

        
End Sub

Public Sub SubirSkillDeArmaActual(ByVal userindex As Integer)
        On Error GoTo SubirSkillDeArmaActual_Err

100     With UserList(userindex)

102         If .Invent.WeaponEqpObjIndex > 0 Then
                ' Arma con proyectiles, subimos armas a distancia
104             If ObjData(.Invent.WeaponEqpObjIndex).Proyectil Then
106                 Call SubirSkill(userindex, e_Skill.Proyectiles)

                ' Sino, subimos combate con armas
                Else
108                 Call SubirSkill(userindex, e_Skill.Armas)
                End If

            ' Si no está usando un arma, subimos combate sin armas
            Else
110             Call SubirSkill(userindex, e_Skill.Wrestling)
            End If

        End With

        Exit Sub

SubirSkillDeArmaActual_Err:
112         Call TraceError(Err.Number, Err.Description, "UsUaRiOs.SubirSkillDeArmaActual", Erl)


End Sub

''
' Muere un usuario
'
' @param UserIndex  Indice del usuario que muere
'

Sub UserDie(ByVal userindex As Integer)

        '************************************************
        'Author: Uknown
        'Last Modified: 04/15/2008 (NicoNZ)
        'Ahora se resetea el counter del invi
        '************************************************
        On Error GoTo ErrorHandler

        Dim i  As Long

        Dim aN As Integer
    
100     With UserList(userindex)
102         .Counters.Mimetismo = 0
104         .flags.Mimetizado = e_EstadoMimetismo.Desactivado
106         Call RefreshCharStatus(userindex)
    
            'Sonido
108         Call SendData(SendTarget.ToPCArea, userindex, PrepareMessagePlayWave(IIf(.genero = e_Genero.Hombre, e_SoundIndex.MUERTE_HOMBRE, e_SoundIndex.MUERTE_MUJER), .Pos.X, .Pos.Y))
        
            'Quitar el dialogo del user muerto
110         Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageRemoveCharDialog(.Char.CharIndex))
        
112         .Stats.MinHp = 0
114         .Stats.MinSta = 0
116         .flags.AtacadoPorUser = 0

118         .flags.incinera = 0
120         .flags.Paraliza = 0
122         .flags.Envenena = 0
124         .flags.Estupidiza = 0
126         .flags.Muerto = 1
            
130         Call WriteUpdateHP(userindex)
132         Call WriteUpdateSta(userindex)
        
134         aN = .flags.AtacadoPorNpc
    
136         If aN > 0 Then
138             NpcList(aN).Movement = NpcList(aN).flags.OldMovement
140             NpcList(aN).Hostile = NpcList(aN).flags.OldHostil
142             NpcList(aN).flags.AttackedBy = vbNullString
144             NpcList(aN).Target = 0
            End If
        
146         aN = .flags.NPCAtacado
    
148         If aN > 0 Then
150             If NpcList(aN).flags.AttackedFirstBy = .name Then
152                 NpcList(aN).flags.AttackedFirstBy = vbNullString
                End If
            End If
    
154         .flags.AtacadoPorNpc = 0
156         .flags.NPCAtacado = 0
    
158         If MapData(.Pos.Map, .Pos.X, .Pos.Y).trigger <> e_Trigger.ZONAPELEA Then

160             If (.flags.Privilegios And e_PlayerType.user) <> 0 Then

162                 If .flags.PendienteDelSacrificio = 0 Then
                
164                     Call TirarTodosLosItems(userindex)
    
                    Else
                
                        Dim MiObj As t_Obj

166                     MiObj.amount = 1
168                     MiObj.ObjIndex = PENDIENTE
170                     Call QuitarObjetos(PENDIENTE, 1, userindex)
172                     Call MakeObj(MiObj, .Pos.Map, .Pos.X, .Pos.Y)
174                     Call WriteConsoleMsg(userindex, "Has perdido tu pendiente del sacrificio.", e_FontTypeNames.FONTTYPE_INFO)

                    End If
    
                End If
    
            End If
            
            Call Desequipar(userindex, .Invent.ArmourEqpSlot)
            Call Desequipar(userindex, .Invent.WeaponEqpSlot)
            Call Desequipar(userindex, .Invent.EscudoEqpSlot)
            Call Desequipar(userindex, .Invent.CascoEqpSlot)
            Call Desequipar(userindex, .Invent.DañoMagicoEqpSlot)
            Call Desequipar(userindex, .Invent.HerramientaEqpSlot)
            Call Desequipar(userindex, .Invent.MonturaSlot)
            Call Desequipar(userindex, .Invent.MunicionEqpSlot)
            Call Desequipar(userindex, .Invent.NudilloSlot)
            Call Desequipar(userindex, .Invent.MagicoSlot)
            Call Desequipar(userindex, .Invent.ResistenciaEqpSlot)
        
176         .flags.CarroMineria = 0
   
            'desequipar montura
178         If .flags.Montado > 0 Then
180             Call DoMontar(userindex, ObjData(.Invent.MonturaObjIndex), .Invent.MonturaSlot)
            End If
        
            ' << Reseteamos los posibles FX sobre el personaje >>
182         If .Char.loops = INFINITE_LOOPS Then
184             .Char.FX = 0
186             .Char.loops = 0
    
            End If
        
188         .flags.VecesQueMoriste = .flags.VecesQueMoriste + 1
        
            ' << Restauramos los atributos >>
190         If .flags.TomoPocion Then
    
192             For i = 1 To 4
194                 .Stats.UserAtributos(i) = .Stats.UserAtributosBackUP(i)
196             Next i
    
198             Call WriteFYA(userindex)
    
            End If
            
            ' << Frenamos el contador de la droga >>
            .flags.DuracionEfecto = 0
        
            '<< Cambiamos la apariencia del char >>
200         If .flags.Navegando = 0 Then
202             .Char.Body = iCuerpoMuerto
204             .Char.Head = 0
206             .Char.ShieldAnim = NingunEscudo
208             .Char.WeaponAnim = NingunArma
210             .Char.CascoAnim = NingunCasco
            Else
212             Call EquiparBarco(userindex)
            End If
            
214         Call ActualizarVelocidadDeUsuario(userindex)
216         Call LimpiarEstadosAlterados(userindex)
        
218         For i = 1 To MAXMASCOTAS
220             If .MascotasIndex(i) > 0 Then
222                 Call MuereNpc(.MascotasIndex(i), 0)
                        
                End If
224         Next i
            
            
            If .clase = e_Class.Druid Then
            
                Dim Params() As Variant
                Dim ParamC As Long
                ReDim Params(MAXMASCOTAS * 3 - 1)
                ParamC = 0
                
                For i = 1 To MAXMASCOTAS
                    Params(ParamC) = .ID
                    ParamC = ParamC + 1
                    Params(ParamC) = i
                    ParamC = ParamC + 1
                    Params(ParamC) = 0
                    ParamC = ParamC + 1
                Next i
                
                Call Execute(QUERY_UPSERT_PETS, Params)
            End If
226         .NroMascotas = 0
        
            '<< Actualizamos clientes >>
228         Call ChangeUserChar(userindex, .Char.Body, .Char.Head, .Char.Heading, NingunArma, NingunEscudo, NingunCasco)

230         If MapInfo(.Pos.Map).Seguro = 0 Then
232             Call WriteConsoleMsg(userindex, "Escribe /HOGAR si deseas regresar rápido a tu hogar.", e_FontTypeNames.FONTTYPE_New_Naranja)
            End If
            
234         If .flags.EnReto Then
236             Call MuereEnReto(userindex)
            End If
            
            'Borramos todos los personajes del area
            
            
            Dim LoopC     As Long
            Dim tempIndex As Integer
            Dim Map       As Integer
            Dim AreaX     As Integer
            Dim AreaY     As Integer
            
             AreaX = UserList(userindex).AreasInfo.AreaPerteneceX
             AreaY = UserList(userindex).AreasInfo.AreaPerteneceY
                        
             For LoopC = 1 To ConnGroups(UserList(userindex).Pos.Map).CountEntrys
                 tempIndex = ConnGroups(UserList(userindex).Pos.Map).UserEntrys(LoopC)
        
                If UserList(tempIndex).AreasInfo.AreaReciveX And AreaX Then  'Esta en el area?
                    If UserList(tempIndex).AreasInfo.AreaReciveY And AreaY Then
        
                        If UserList(tempIndex).ConnIDValida And tempIndex <> userindex And UserList(tempIndex).GuildIndex <> UserList(userindex).GuildIndex Then
                            Call SendData(SendTarget.ToIndex, userindex, PrepareMessageCharacterRemove(3, UserList(tempIndex).Char.CharIndex, True))
                        End If
                    End If
                End If
        
             Next LoopC
            
            

        End With

        Exit Sub

ErrorHandler:
238        Call TraceError(Err.Number, Err.Description, "UsUaRiOs.UserDie", Erl)

End Sub

Sub ContarMuerte(ByVal Muerto As Integer, ByVal Atacante As Integer)
            On Error GoTo ContarMuerte_Err


100         If EsNewbie(Muerto) Then Exit Sub
102         If TriggerZonaPelea(Muerto, Atacante) = TRIGGER6_PERMITE Then Exit Sub
            'Si se llevan más de 10 niveles no le cuento la muerte.
            If CInt(UserList(Atacante).Stats.ELV) - CInt(UserList(Muerto).Stats.ELV) > 10 Then Exit Sub
106         If Status(Muerto) = 0 Or Status(Muerto) = 2 Then
108             If UserList(Atacante).flags.LastCrimMatado <> UserList(Muerto).name Then
110                 UserList(Atacante).flags.LastCrimMatado = UserList(Muerto).name

112                 If UserList(Atacante).Faccion.CriminalesMatados < MAXUSERMATADOS Then
114                     UserList(Atacante).Faccion.CriminalesMatados = UserList(Atacante).Faccion.CriminalesMatados + 1
                    End If
                End If

116         ElseIf Status(Muerto) = 1 Or Status(Muerto) = 3 Then

118             If UserList(Atacante).flags.LastCiudMatado <> UserList(Muerto).name Then
120                 UserList(Atacante).flags.LastCiudMatado = UserList(Muerto).name

122                 If UserList(Atacante).Faccion.ciudadanosMatados < MAXUSERMATADOS Then
124                     UserList(Atacante).Faccion.ciudadanosMatados = UserList(Atacante).Faccion.ciudadanosMatados + 1
                    End If

                End If

            End If

            Exit Sub

ContarMuerte_Err:
126         Call TraceError(Err.Number, Err.Description, "UsUaRiOs.ContarMuerte", Erl)


End Sub

Sub Tilelibre(ByRef Pos As t_WorldPos, ByRef nPos As t_WorldPos, ByRef obj As t_Obj, ByRef Agua As Boolean, ByRef Tierra As Boolean, Optional ByVal InitialPos As Boolean = True)

        
        On Error GoTo Tilelibre_Err
        

        '**************************************************************
        'Author: Unknown
        'Last Modify Date: 23/01/2007
        '23/01/2007 -> Pablo (ToxicWaste): El agua es ahora un TileLibre agregando las condiciones necesarias.
        '**************************************************************
        Dim Notfound As Boolean

        Dim LoopC    As Integer

        Dim tX       As Integer

        Dim tY       As Integer

        Dim hayobj   As Boolean
        
100     hayobj = False
102     nPos.Map = Pos.Map

104     Do While Not LegalPos(Pos.Map, nPos.X, nPos.Y, Agua, Tierra) Or hayobj
        
106         If LoopC > 15 Then
108             Notfound = True
                Exit Do

            End If
        
110         For tY = Pos.Y - LoopC To Pos.Y + LoopC
112             For tX = Pos.X - LoopC To Pos.X + LoopC
            
114                 If LegalPos(nPos.Map, tX, tY, Agua, Tierra) Then
                        'We continue if: a - the item is different from 0 and the dropped item or b - the Amount dropped + Amount in map exceeds MAX_INVENTORY_OBJS
116                     hayobj = (MapData(nPos.Map, tX, tY).ObjInfo.ObjIndex > 0 And MapData(nPos.Map, tX, tY).ObjInfo.ObjIndex <> obj.ObjIndex)

118                     If Not hayobj Then hayobj = (MapData(nPos.Map, tX, tY).ObjInfo.amount + obj.amount > MAX_INVENTORY_OBJS)

120                     If Not hayobj And MapData(nPos.Map, tX, tY).TileExit.Map = 0 And (InitialPos Or (tX <> Pos.X And tY <> Pos.Y)) Then
122                         nPos.X = tX
124                         nPos.Y = tY
126                         tX = Pos.X + LoopC
128                         tY = Pos.Y + LoopC

                        End If

                    End If
            
130             Next tX
132         Next tY
        
134         LoopC = LoopC + 1
        
        Loop
    
136     If Notfound = True Then
138         nPos.X = 0
140         nPos.Y = 0

        End If

        
        Exit Sub

Tilelibre_Err:
142     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.Tilelibre", Erl)

        
End Sub

Sub WarpToLegalPos(ByVal userindex As Integer, ByVal Map As Integer, ByVal X As Byte, ByVal Y As Byte, Optional ByVal FX As Boolean = False, Optional ByVal AguaValida As Boolean = False)

        On Error GoTo WarpToLegalPos_Err

        Dim LoopC    As Integer

        Dim tX       As Integer

        Dim tY       As Integer

102     Do While True

104         If LoopC > 20 Then Exit Sub

108         For tY = Y - LoopC To Y + LoopC
110             For tX = X - LoopC To X + LoopC
            
112                 If LegalPos(Map, tX, tY, AguaValida, True, UserList(userindex).flags.Montado = 1, False, False) Then
                        If MapData(Map, tX, tY).trigger < 50 Then
114                         Call WarpUserChar(userindex, Map, tX, tY, FX)
                            Exit Sub
                        End If
                    End If
        
122             Next tX
124         Next tY
    
126         LoopC = LoopC + 1
    
        Loop

        Call WarpUserChar(userindex, Map, X, Y, FX)

        Exit Sub

WarpToLegalPos_Err:
132     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.WarpToLegalPos", Erl)

        
End Sub

Sub WarpUserChar(ByVal userindex As Integer, _
                 ByVal Map As Integer, _
                 ByVal X As Integer, _
                 ByVal Y As Integer, _
                 Optional ByVal FX As Boolean = False)
        
        On Error GoTo WarpUserChar_Err

        Dim OldMap As Integer
        Dim OldX   As Integer
        Dim OldY   As Integer
    
100     With UserList(userindex)
            If Map <= 0 Then Exit Sub
102         If .ComUsu.DestUsu > 0 Then

104             If UserList(.ComUsu.DestUsu).flags.UserLogged Then

106                 If UserList(.ComUsu.DestUsu).ComUsu.DestUsu = userindex Then
108                     Call WriteConsoleMsg(.ComUsu.DestUsu, "Comercio cancelado por el otro usuario", e_FontTypeNames.FONTTYPE_TALK)
110                     Call FinComerciarUsu(.ComUsu.DestUsu)

                    End If

                End If

            End If
    
            'Quitar el dialogo
112         Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageRemoveCharDialog(.Char.CharIndex))
    
114         Call WriteRemoveAllDialogs(userindex)
    
116         OldMap = .Pos.Map
118         OldX = .Pos.X
120         OldY = .Pos.Y
    
122         Call EraseUserChar(userindex, True, FX)
    
124         If OldMap <> Map Then
126             Call WriteChangeMap(userindex, Map)

128             If MapInfo(OldMap).Seguro = 1 And MapInfo(Map).Seguro = 0 And .Stats.ELV < 42 Then
130                 Call WriteConsoleMsg(userindex, "Estás saliendo de una zona segura, recuerda que aquí corres riesgo de ser atacado.", e_FontTypeNames.FONTTYPE_WARNING)

                End If
        

        
                'Update new Map Users
156             MapInfo(Map).NumUsers = MapInfo(Map).NumUsers + 1
        
                'Update old Map Users
158             MapInfo(OldMap).NumUsers = MapInfo(OldMap).NumUsers - 1

160             If MapInfo(OldMap).NumUsers < 0 Then
162                 MapInfo(OldMap).NumUsers = 0

                End If

164             If .flags.Traveling = 1 Then
166                 .flags.Traveling = 0
168                 .Counters.goHome = 0
170                 Call WriteConsoleMsg(userindex, "El viaje ha terminado.", e_FontTypeNames.FONTTYPE_INFOBOLD)

                End If
   
            End If
    
172         .Pos.X = X
174         .Pos.Y = Y
176         .Pos.Map = Map

178         If .Grupo.EnGrupo = True Then
180             Call CompartirUbicacion(userindex)
            End If
    
182         If FX Then
184             Call MakeUserChar(True, Map, userindex, Map, X, Y, 1)
            Else
186             Call MakeUserChar(True, Map, userindex, Map, X, Y, 0)
            End If
    
188         Call WriteUserCharIndexInServer(userindex)
    
            'Seguis invisible al pasar de mapa
190         If (.flags.invisible = 1 Or .flags.Oculto = 1) And (Not .flags.AdminInvisible = 1) Then

                ' Si el mapa lo permite
192             If MapInfo(Map).SinInviOcul Then
            
194                 .flags.invisible = 0
196                 .flags.Oculto = 0
                    .Counters.TiempoOcultar = 1
198                 .Counters.TiempoOculto = 0
                
200                 Call WriteConsoleMsg(userindex, "Una fuerza divina que vigila esta zona te ha vuelto visible.", e_FontTypeNames.FONTTYPE_INFO)
                
                Else
202                 Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageSetInvisible(.Char.CharIndex, True))

                End If

            End If
    
            'Reparacion temporal del bug de particulas. 08/07/09 LADDER
204         If .flags.AdminInvisible = 0 Then
        
206             If FX Then 'FX
208                 Call SendData(SendTarget.ToPCArea, userindex, PrepareMessagePlayWave(SND_WARP, X, Y))
210                 Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageCreateFX(.Char.CharIndex, e_FXIDs.FXWARP, 0))
                End If

            Else
212             Call SendData(ToIndex, userindex, PrepareMessageSetInvisible(.Char.CharIndex, True))

            End If
        
214         If .NroMascotas > 0 Then Call WarpMascotas(userindex)
    
216         If MapInfo(Map).zone = "DUNGEON" Or MapData(Map, X, Y).trigger >= 9 Then

218             If .flags.Montado > 0 Then
220                 Call DoMontar(userindex, ObjData(.Invent.MonturaObjIndex), .Invent.MonturaSlot)
                End If

            End If
    
        End With

        Exit Sub

WarpUserChar_Err:
222     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.WarpUserChar", Erl)


        
End Sub


Sub Cerrar_Usuario(ByVal userindex As Integer)

        On Error GoTo Cerrar_Usuario_Err
    
100     With UserList(userindex)

102         If .flags.UserLogged And Not .Counters.Saliendo Then
104             .Counters.Saliendo = True
106             .Counters.Salir = IntervaloCerrarConexion
            
108             If .flags.Traveling = 1 Then
110                 Call WriteConsoleMsg(userindex, "Se ha cancelado el viaje a casa", e_FontTypeNames.FONTTYPE_INFO)
112                 .flags.Traveling = 0
114                 .Counters.goHome = 0
                End If
                
                If .flags.invisible + .flags.Oculto > 0 Then
                    .flags.invisible = 0
                    .flags.Oculto = 0
                    Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageSetInvisible(.Char.CharIndex, False))
                    Call WriteConsoleMsg(userindex, "Has vuelto a ser visible", e_FontTypeNames.FONTTYPE_INFO)
                End If
                
            
116             Call WriteLocaleMsg(userindex, "203", e_FontTypeNames.FONTTYPE_INFO, .Counters.Salir)
            
118             If EsGM(userindex) Or MapInfo(.Pos.Map).Seguro = 1 Then
120                 Call WriteDisconnect(userindex)
122                 Call CloseSocket(userindex)
                End If

            End If

        End With

        Exit Sub

Cerrar_Usuario_Err:
124     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.Cerrar_Usuario", Erl)


End Sub

''
' Cancels the exit of a user. If it's disconnected it's reset.
'
' @param    UserIndex   The index of the user whose exit is being reset.

Public Sub CancelExit(ByVal userindex As Integer)
        
        On Error GoTo CancelExit_Err
        

        '***************************************************
        'Author: Juan Martín Sotuyo Dodero (Maraxus)
        'Last Modification: 04/02/08
        '
        '***************************************************
100     If UserList(userindex).Counters.Saliendo And UserList(userindex).ConnIDValida Then

            ' Is the user still connected?
102         If UserList(userindex).ConnIDValida Then
104             UserList(userindex).Counters.Saliendo = False
106             UserList(userindex).Counters.Salir = 0
108             Call WriteConsoleMsg(userindex, "/salir cancelado.", e_FontTypeNames.FONTTYPE_WARNING)
            Else

                'Simply reset
110             If UserList(userindex).flags.Privilegios = e_PlayerType.user And MapInfo(UserList(userindex).Pos.Map).Seguro = 0 Then
112                 UserList(userindex).Counters.Salir = IntervaloCerrarConexion
                Else
114                 Call WriteConsoleMsg(userindex, "Gracias por jugar Argentum20.", e_FontTypeNames.FONTTYPE_INFO)
116                 Call WriteDisconnect(userindex)
                
118                 Call CloseSocket(userindex)

                End If
            
                'UserList(UserIndex).Counters.Salir = IIf((UserList(UserIndex).flags.Privilegios And e_PlayerType.User) And MapInfo(UserList(UserIndex).Pos.Map).Seguro = 0, IntervaloCerrarConexion, 0)
            End If

        End If

        
        Exit Sub

CancelExit_Err:
120     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.CancelExit", Erl)

        
End Sub

Sub VolverCriminal(ByVal userindex As Integer)
        
    On Error GoTo VolverCriminal_Err
        

    '**************************************************************
    'Author: Unknown
    'Last Modify Date: 21/06/2006
    'Nacho: Actualiza el tag al cliente
    '**************************************************************
        
100 With UserList(userindex)
        
102     If MapData(.Pos.Map, .Pos.X, .Pos.Y).trigger = 6 Then Exit Sub

104     If .flags.Privilegios And (e_PlayerType.user Or e_PlayerType.Consejero) Then
   
106         If .Faccion.ArmadaReal = 1 Then
                ' WyroX: NUNCA debería pasar, pero dejo un log por si las...
                Call TraceError(111, "Un personaje de la Armada Real atacó un ciudadano.", "UsUaRiOs.VolverCriminal")
                'Call ExpulsarFaccionReal(UserIndex)
            End If

        End If

108     If .Faccion.FuerzasCaos = 1 Then Exit Sub

110     .Faccion.Status = 0
        
112     If MapInfo(.Pos.Map).NoPKs And Not EsGM(userindex) And MapInfo(.Pos.Map).Salida.Map <> 0 Then
114         Call WriteConsoleMsg(userindex, "En este mapa no se admiten criminales.", e_FontTypeNames.FONTTYPE_INFO)
116         Call WarpUserChar(userindex, MapInfo(.Pos.Map).Salida.Map, MapInfo(.Pos.Map).Salida.X, MapInfo(.Pos.Map).Salida.Y, True)
        Else
118         Call RefreshCharStatus(userindex)
        End If

    End With
        
    Exit Sub

VolverCriminal_Err:
120     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.VolverCriminal", Erl)

        
End Sub

Sub VolverCiudadano(ByVal userindex As Integer)
    '**************************************************************
    'Author: Unknown
    'Last Modify Date: 21/06/2006
    'Nacho: Actualiza el tag al cliente.
    '**************************************************************
        
    On Error GoTo VolverCiudadano_Err
        
100 With UserList(userindex)

102     If MapData(.Pos.Map, .Pos.X, .Pos.Y).trigger = 6 Then Exit Sub

104     .Faccion.Status = 1

106     If MapInfo(.Pos.Map).NoCiudadanos And Not EsGM(userindex) And MapInfo(.Pos.Map).Salida.Map <> 0 Then
108         Call WriteConsoleMsg(userindex, "En este mapa no se admiten ciudadanos.", e_FontTypeNames.FONTTYPE_INFO)
110         Call WarpUserChar(userindex, MapInfo(.Pos.Map).Salida.Map, MapInfo(.Pos.Map).Salida.X, MapInfo(.Pos.Map).Salida.Y, True)
        Else
112         Call RefreshCharStatus(userindex)
        End If

        Call WriteSafeModeOn(userindex)
        .flags.Seguro = True

    End With
        
    Exit Sub

VolverCiudadano_Err:
114     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.VolverCiudadano", Erl)

        
End Sub

Public Function getMaxInventorySlots(ByVal userindex As Integer) As Byte
        '***************************************************
        'Author: Unknown
        'Last Modification: 30/09/2020
        '
        '***************************************************
        
        On Error GoTo getMaxInventorySlots_Err
        

100     If UserList(userindex).Stats.InventLevel > 0 Then
102         getMaxInventorySlots = MAX_USERINVENTORY_SLOTS + UserList(userindex).Stats.InventLevel * SLOTS_PER_ROW_INVENTORY
        Else
104         getMaxInventorySlots = MAX_USERINVENTORY_SLOTS

        End If

        
        Exit Function

getMaxInventorySlots_Err:
106     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.getMaxInventorySlots", Erl)

        
End Function

Private Sub WarpMascotas(ByVal userindex As Integer)
        
        On Error GoTo WarpMascotas_Err
    
        

        '************************************************
        'Author: Uknown
        'Last Modified: 26/10/2010
        '13/02/2009: ZaMa - Arreglado respawn de mascotas al cambiar de mapa.
        '13/02/2009: ZaMa - Las mascotas no regeneran su vida al cambiar de mapa (Solo entre mapas inseguros).
        '11/05/2009: ZaMa - Chequeo si la mascota pueden spawnear para asiganrle los stats.
        '26/10/2010: ZaMa - Ahora las mascotas respawnean de forma aleatoria.
        '************************************************
        Dim i                As Integer

        Dim petType          As Integer

        Dim ZonaSegura       As Boolean
        
        Dim PermiteMascotas  As Boolean

        Dim Index            As Integer

        Dim iMinHP           As Integer
        
        Dim PetTiempoDeVida  As Integer
    
        Dim MascotaQuitada   As Boolean
        Dim ElementalQuitado As Boolean
        Dim SpawnInvalido    As Boolean

100     ZonaSegura = MapInfo(UserList(userindex).Pos.Map).Seguro = 1
        PermiteMascotas = MapInfo(UserList(userindex).Pos.Map).NoMascotas = False

102     For i = 1 To MAXMASCOTAS
104         Index = UserList(userindex).MascotasIndex(i)
        
106         If Index > 0 Then
108             iMinHP = NpcList(Index).Stats.MinHp
110             PetTiempoDeVida = NpcList(Index).Contadores.TiempoExistencia
            
112             NpcList(Index).MaestroUser = 0
            
114             Call QuitarNPC(Index)

116             If PetTiempoDeVida > 0 Then
118                 Call QuitarMascota(userindex, Index)
120                 ElementalQuitado = True

122             ElseIf ZonaSegura Or Not PermiteMascotas Then
124                 UserList(userindex).MascotasIndex(i) = 0
126                 MascotaQuitada = True
                End If
            
            Else
128             iMinHP = 0
130             PetTiempoDeVida = 0
            End If
        
132         petType = UserList(userindex).MascotasType(i)
        
134         If petType > 0 And Not ZonaSegura And PermiteMascotas And UserList(userindex).flags.MascotasGuardadas = 0 And PetTiempoDeVida = 0 Then
        
                Dim SpawnPos As t_WorldPos
        
136             SpawnPos.Map = UserList(userindex).Pos.Map
138             SpawnPos.X = UserList(userindex).Pos.X + RandomNumber(-3, 3)
140             SpawnPos.Y = UserList(userindex).Pos.Y + RandomNumber(-3, 3)
        
142             Index = SpawnNpc(petType, SpawnPos, False, False, False, userindex)
            
                'Controlamos que se sumoneo OK - should never happen. Continue to allow removal of other pets if not alone
                ' Exception: Pets don't spawn in water if they can't swim
144             If Index > 0 Then
146                 UserList(userindex).MascotasIndex(i) = Index

                    ' Nos aseguramos de que conserve el hp, si estaba danado
148                 If iMinHP Then NpcList(Index).Stats.MinHp = iMinHP

150                 Call FollowAmo(Index)
            
                Else
152                 SpawnInvalido = True
                End If

            End If

154     Next i

156     If MascotaQuitada Then
            If ZonaSegura Then
158             Call WriteConsoleMsg(userindex, "No se permiten mascotas en zona segura. Estas te esperarán afuera.", e_FontTypeNames.FONTTYPE_INFO)
            
            ElseIf Not PermiteMascotas Then
                Call WriteConsoleMsg(userindex, "Una fuerza superior impide que tus mascotas entren en este mapa. Estas te esperarán afuera.", e_FontTypeNames.FONTTYPE_INFO)
            End If

160     ElseIf SpawnInvalido Then
162         Call WriteConsoleMsg(userindex, "Tus mascotas no pueden transitar este mapa.", e_FontTypeNames.FONTTYPE_INFO)

164     ElseIf ElementalQuitado Then
166         Call WriteConsoleMsg(userindex, "Pierdes el control de tus mascotas invocadas.", e_FontTypeNames.FONTTYPE_INFO)
        End If

        
        Exit Sub

WarpMascotas_Err:
168     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.WarpMascotas", Erl)

        
End Sub

Function TieneArmaduraCazador(ByVal userindex As Integer) As Boolean
        
        On Error GoTo TieneArmaduraCazador_Err
    
        

100     If UserList(userindex).Invent.ArmourEqpObjIndex > 0 Then
        
102         If ObjData(UserList(userindex).Invent.ArmourEqpObjIndex).Subtipo = 3 Then ' Aguante hardcodear números :D
104             TieneArmaduraCazador = True
            End If
        
        End If

        
        Exit Function

TieneArmaduraCazador_Err:
106     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.TieneArmaduraCazador", Erl)

        
End Function

Public Sub SetModoConsulta(ByVal userindex As Integer)
        '***************************************************
        'Author: Torres Patricio (Pato)
        'Last Modification: 05/06/10
        '
        '***************************************************

        Dim sndNick As String

100     With UserList(userindex)
102         sndNick = .name
    
104         If .flags.EnConsulta Then
106             sndNick = sndNick & " [CONSULTA]"
            
            Else

108             If .GuildIndex > 0 Then
110                 sndNick = sndNick & " <" & modGuilds.GuildName(.GuildIndex) & ">"
                End If

            End If

112         Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageUpdateTagAndStatus(userindex, .Faccion.Status, sndNick))

        End With

End Sub

' Autor: WyroX - 20/01/2021
' Intenta moverlo hacia un "costado" según el heading indicado.
' Si no hay un lugar válido a los lados, lo mueve a la posición válida más cercana.
Sub MoveUserToSide(ByVal userindex As Integer, ByVal Heading As e_Heading)

        On Error GoTo Handler

100     With UserList(userindex)

            ' Elegimos un lado al azar
            Dim R As Integer
102         R = RandomNumber(0, 1) * 2 - 1 ' -1 o 1

            ' Roto el heading original hacia ese lado
104         Heading = Rotate_Heading(Heading, R)

            ' Intento moverlo para ese lado
106         If MoveUserChar(userindex, Heading) Then
                ' Le aviso al usuario que fue movido
108             Call WriteForceCharMove(userindex, Heading)
                Exit Sub
            End If
        
            ' Si falló, intento moverlo para el lado opuesto
110         Heading = InvertHeading(Heading)
112         If MoveUserChar(userindex, Heading) Then
                ' Le aviso al usuario que fue movido
114             Call WriteForceCharMove(userindex, Heading)
                Exit Sub
            End If
        
            ' Si ambos fallan, entonces lo dejo en la posición válida más cercana
            Dim NuevaPos As t_WorldPos
116         Call ClosestLegalPos(.Pos, NuevaPos, .flags.Navegando, .flags.Navegando = 0)
118         Call WarpUserChar(userindex, NuevaPos.Map, NuevaPos.X, NuevaPos.Y)

        End With

        Exit Sub
    
Handler:
120     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.MoveUserToSide", Erl)

End Sub

' Autor: WyroX - 02/03/2021
' Quita parálisis, veneno, invisibilidad, estupidez, mimetismo, deja de descansar, de meditar y de ocultarse; y quita otros estados obsoletos (por si acaso)
Public Sub LimpiarEstadosAlterados(ByVal userindex As Integer)

        On Error GoTo Handler
    
100     With UserList(userindex)

            '<<<< Envenenamiento >>>>
102         .flags.Envenenado = 0
        
            '<<<< Paralisis >>>>
104         If .flags.Paralizado = 1 Then
106             .flags.Paralizado = 0
108             Call WriteParalizeOK(userindex)
            End If
                
            '<<<< Inmovilizado >>>>
110         If .flags.Inmovilizado = 1 Then
112             .flags.Inmovilizado = 0
114             Call WriteInmovilizaOK(userindex)
            End If
                
            '<<< Estupidez >>>
116         If .flags.Estupidez = 1 Then
118             .flags.Estupidez = 0
120             Call WriteDumbNoMore(userindex)
            End If
                
            '<<<< Descansando >>>>
122         If .flags.Descansar Then
124             .flags.Descansar = False
126             Call WriteRestOK(userindex)
            End If
                
            '<<<< Meditando >>>>
128         If .flags.Meditando Then
130             .flags.Meditando = False
132             .Char.FX = 0
134             Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageMeditateToggle(.Char.CharIndex, 0))
            End If
        
            '<<<< Invisible >>>>
136         If (.flags.invisible = 1 Or .flags.Oculto = 1) And .flags.AdminInvisible = 0 Then
138             .flags.Oculto = 0
                .Counters.TiempoOcultar = 1
140             .flags.invisible = 0
142             .Counters.TiempoOculto = 0
144             .Counters.Invisibilidad = 0
146             Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageSetInvisible(.Char.CharIndex, False))
            End If
        
            '<<<< Mimetismo >>>>
148         If .flags.Mimetizado > 0 Then
        
150             If .flags.Navegando Then
            
152                 If .flags.Muerto = 0 Then
154                     .Char.Body = ObjData(UserList(userindex).Invent.BarcoObjIndex).Ropaje
                    Else
156                     .Char.Body = iFragataFantasmal
                    End If

158                 .Char.ShieldAnim = NingunEscudo
160                 .Char.WeaponAnim = NingunArma
162                 .Char.CascoAnim = NingunCasco
                
                Else
            
164                 .Char.Body = .CharMimetizado.Body
166                 .Char.Head = .CharMimetizado.Head
168                 .Char.CascoAnim = .CharMimetizado.CascoAnim
170                 .Char.ShieldAnim = .CharMimetizado.ShieldAnim
172                 .Char.WeaponAnim = .CharMimetizado.WeaponAnim
                
                End If
            
174             .Counters.Mimetismo = 0
176             .flags.Mimetizado = e_EstadoMimetismo.Desactivado
            End If
        
            '<<<< Estados obsoletos >>>>
180         .flags.Incinerado = 0
        
        End With
    
        Exit Sub
    
Handler:
182     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.LimpiarEstadosAlterados", Erl)


End Sub

Public Sub DevolverPosAnterior(ByVal userindex As Integer)

100     With UserList(userindex).flags
102         Call WarpToLegalPos(userindex, .LastPos.Map, .LastPos.X, .LastPos.Y, True)
        End With

End Sub

Public Function ActualizarVelocidadDeUsuario(ByVal userindex As Integer) As Single
        On Error GoTo ActualizarVelocidadDeUsuario_Err
    
        Dim velocidad As Single, modificadorItem As Single, modificadorHechizo As Single
    
100     velocidad = VelocidadNormal
102     modificadorItem = 1
104     modificadorHechizo = 1
    
106     With UserList(userindex)
108         If .flags.Muerto = 1 Then
110             velocidad = VelocidadMuerto
112             GoTo UpdateSpeed ' Los muertos no tienen modificadores de velocidad
            End If
        
            ' El traje para nadar es considerado barco, de subtipo = 0
114         If (.flags.Navegando + .flags.Nadando > 0) And (.Invent.BarcoObjIndex > 0) Then
116             modificadorItem = ObjData(.Invent.BarcoObjIndex).velocidad
            End If
        
118         If (.flags.Montado = 1) And (.Invent.MonturaObjIndex > 0) Then
120             modificadorItem = ObjData(.Invent.MonturaObjIndex).velocidad
            End If
        
            ' Algun hechizo le afecto la velocidad
122         If .flags.VelocidadHechizada > 0 Then
124             modificadorHechizo = .flags.VelocidadHechizada
            End If
        
126         velocidad = VelocidadNormal * modificadorItem * modificadorHechizo
        
UpdateSpeed:
128         .Char.speeding = velocidad
        
130         Call SendData(SendTarget.ToPCArea, userindex, PrepareMessageSpeedingACT(.Char.CharIndex, .Char.speeding))
132         Call WriteVelocidadToggle(userindex)
     
        End With

        Exit Function
    
ActualizarVelocidadDeUsuario_Err:
134     Call TraceError(Err.Number, Err.Description, "UsUaRiOs.CalcularVelocidad_Err", Erl)

End Function

