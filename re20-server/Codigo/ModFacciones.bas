Attribute VB_Name = "ModFacciones"

Option Explicit

Public Sub EnlistarArmadaReal(ByVal userindex As Integer)
            On Error GoTo EnlistarArmadaReal_Err

            Dim charIndexStr As String

100         With UserList(userindex)
102             charIndexStr = str$(NpcList(.flags.TargetNPC).Char.CharIndex)
                
104             If .Faccion.ArmadaReal = 1 Then
106                 Call WriteChatOverHead(userindex, "Ya perteneces a mi ej�rcito j�ven soldado. Ve a combatir el caos en mis tierras para subir de rango en el Ej�rcito Real.", charIndexStr, vbWhite)
                    Exit Sub

                End If

108             If .Faccion.FuerzasCaos = 1 Then
110                 Call WriteChatOverHead(userindex, "�Has llegado al lugar equivocado maldita escoria! Vete de aqu� antes de ser encarcelado e interrogado.", charIndexStr, vbWhite)
                    Exit Sub

                End If

112             If Status(userindex) = 2 Then
114                 Call WriteChatOverHead(userindex, "No se permiten criminales en el Ej�rcito Real.", charIndexStr, vbWhite)
                    Exit Sub
                End If
                

116             If Status(userindex) = 0 Then
118                 Call WriteChatOverHead(userindex, "No se permiten criminales en el Ej�rcito Real. Si no has derramado sangre inocente ve a inclinarte y pedir perd�n ante un sacerdote.", charIndexStr, vbWhite)
                    Exit Sub

                End If

120             If .clase = e_Class.Thief Then
122                 Call WriteChatOverHead(userindex, "No hay lugar para escoria en el Ej�rcito Real.", charIndexStr, vbWhite)
                    Exit Sub

                End If

                'Si fue miembro de la Legi�n del Caos no se puede enlistar
124             If .Faccion.ciudadanosMatados > 0 Then
126                 Call WriteChatOverHead(userindex, "Has derramado sangre inocente. Solo aceptamos almas nobles en el Ej�rcito Real.", charIndexStr, vbWhite)
                    Exit Sub

                End If
                
128             If Not HayLugarEnInventario(userindex) Then
130                 Call WriteChatOverHead(userindex, "�No tienes lugar suficiente en el inventario.", charIndexStr, vbWhite)
                    Exit Sub
                End If
                

132             If .Faccion.Reenlistadas > 0 Then
134                 Call WriteChatOverHead(userindex, "Ya has desertado el Ej�rcito Real. No ser�s aceptado otra vez.", charIndexStr, vbWhite)
                    Exit Sub

                End If

                Dim primerRango As t_RangoFaccion
136                 primerRango = RangosFaccion(1)

138             If .Faccion.CriminalesMatados < primerRango.AsesinatosRequeridos Then
140                 Call WriteChatOverHead(userindex, "Para unirte a nuestras fuerzas debes matar al menos " & primerRango.AsesinatosRequeridos & " criminales, solo has matado " & .Faccion.CriminalesMatados, charIndexStr, vbWhite)
                    Exit Sub

                End If

142             If .Stats.ELV < primerRango.NivelRequerido Then
144                 Call WriteChatOverHead(userindex, "���Para unirte a nuestras fuerzas debes ser al menos de nivel " & primerRango.NivelRequerido & "!!!", charIndexStr, vbWhite)
                    Exit Sub

                End If
                
                'HarThaoS: Lo pongo al final para que lo expulse del clan solamente si cumple todos los requisitos.
146             If .GuildIndex > 0 Then
148                 If PersonajeEsLeader(.name) Then
                        'Si el clan es neutral no lo dejo, le digo que tiene que salir del clan para poder enlistarse
                        If GuildAlignmentIndex(.GuildIndex) = e_ALINEACION_GUILD.ALINEACION_NEUTRAL Then
                            Call WriteChatOverHead(userindex, "No puedes integrar nuestras fuerzas si perteneces a un clan neutral, deber�s abandonarlo si tu deseo es integrar el Ej�rcito Real.", charIndexStr, vbWhite)
                            Exit Sub
                        End If
                    Else
                        If GuildAlignmentIndex(.GuildIndex) <> e_ALINEACION_GUILD.ALINEACION_CIUDADANA Then
152                         Call m_EcharMiembroDeClan(userindex, .name)
                        End If
                    End If
                End If

                ' Cumple con los requisitos para enlistarse
154             .Faccion.ArmadaReal = 1
156             .Faccion.RecompensasReal = primerRango.rank ' Asigna primer rango
158             .Faccion.Reenlistadas = .Faccion.Reenlistadas + 1
160             .Faccion.Status = 3

162             If .Faccion.RecibioArmaduraReal = 0 Then
164                 Call WriteChatOverHead(userindex, "���Bienvenido al Ejercito Imperial!!!, aqui tienes tus vestimentas. Cumple bien tu labor exterminando Criminales y me encargar� de recompensarte.", charIndexStr, vbWhite)

166                 .Faccion.NivelIngreso = .Stats.ELV
168                 .Faccion.MatadosIngreso = .Faccion.ciudadanosMatados

                End If

170             Call WriteConsoleMsg(userindex, "�Ahora perteneces al Ejercito Real!", e_FontTypeNames.FONTTYPE_INFOIAO)
172             Call DarRecompensas(userindex)
174             Call RefreshCharStatus(userindex)

            End With

            'Call LogEjercitoReal(.Name & " ingres� el " & Date & " cuando era nivel " & .Stats.ELV)

            Exit Sub

EnlistarArmadaReal_Err:
176         Call TraceError(Err.Number, Err.Description, "ModFacciones.EnlistarArmadaReal", Erl)


End Sub

' Subir de Rango y asignar recompensas.
Public Sub RecompensaArmadaReal(ByVal userindex As Integer)
            On Error GoTo RecompensaArmadaReal_Err

            Dim Crimis As Long, npcCharIndex As String
            Dim proxRango As t_RangoFaccion

100         With UserList(userindex)
102             Crimis = .Faccion.CriminalesMatados
104             npcCharIndex = str(NpcList(.flags.TargetNPC).Char.CharIndex)

106             If .Faccion.RecompensasReal >= MaxRangoFaccion Then
108                 Call WriteChatOverHead(userindex, "Has alcanzado el m�ximo rango dentro de mis soldados. Demuestra tu bondad y liderazgo en el campo de batalla para alg�n d�a pertenecer al Consejo de Banderbill.", npcCharIndex, vbWhite)
                    Exit Sub
                End If
                
110             If Not HayLugarEnInventario(userindex) Then
112                 Call WriteChatOverHead(userindex, "�No tienes lugar suficiente en el inventario.", npcCharIndex, vbWhite)
                    Exit Sub
                End If

114             proxRango = ProximoRango(userindex)

116             If Crimis < proxRango.AsesinatosRequeridos Then
118                 Call WriteChatOverHead(userindex, "Mata " & proxRango.AsesinatosRequeridos - Crimis & " Criminales m�s para recibir la pr�xima Recompensa", npcCharIndex, vbWhite)
                    Exit Sub

                End If

120             If proxRango.NivelRequerido > .Stats.ELV Then
122               Call WriteChatOverHead(userindex, "Has matado suficientes criminales pero, te faltan " & (proxRango.NivelRequerido - .Stats.ELV) & " niveles para poder recibir la pr�xima recompensa.", npcCharIndex, vbWhite)

                Else ' El usuario cumple con los requerimientos de nivel, se le asigna la recomenza.
124               .Faccion.RecompensasReal = proxRango.rank

126               Call WriteChatOverHead(userindex, "���Aqui tienes tu recompensa " + proxRango.Titulo + "!!!", npcCharIndex, vbWhite)
128               Call DarRecompensas(userindex)
                  '.Stats.Exp = .Stats.Exp + ExpX100
                End If
            End With

            Exit Sub

RecompensaArmadaReal_Err:
130         Call TraceError(Err.Number, Err.Description, "ModFacciones.RecompensaArmadaReal", Erl)


End Sub

Public Sub ExpulsarFaccionReal(ByVal userindex As Integer)
            On Error GoTo ExpulsarFaccionReal_Err

100         UserList(userindex).Faccion.ArmadaReal = 0
102         UserList(userindex).Faccion.Status = 1
104         Call RefreshCharStatus(userindex)

106         Call PerderItemsFaccionarios(userindex)
108         Call WriteConsoleMsg(userindex, "Has sido expulsado del Ejercito Real.", e_FontTypeNames.FONTTYPE_INFOIAO)
            

            Exit Sub

ExpulsarFaccionReal_Err:
110         Call TraceError(Err.Number, Err.Description, "ModFacciones.ExpulsarFaccionReal", Erl)


End Sub

Public Sub ExpulsarFaccionCaos(ByVal userindex As Integer)

            On Error GoTo ExpulsarFaccionCaos_Err

100         UserList(userindex).Faccion.FuerzasCaos = 0
102         UserList(userindex).Faccion.Status = 0
104         Call RefreshCharStatus(userindex)

106         Call PerderItemsFaccionarios(userindex)
108         Call WriteConsoleMsg(userindex, "Has sido expulsado de la Legi�n Oscura.", e_FontTypeNames.FONTTYPE_INFOIAO)

            Exit Sub

ExpulsarFaccionCaos_Err:
110         Call TraceError(Err.Number, Err.Description, "ModFacciones.ExpulsarFaccionCaos", Erl)


End Sub

Public Function TituloReal(ByVal userindex As Integer) As String
            On Error GoTo TituloReal_Err

            Dim rank As Byte
100             rank = UserList(userindex).Faccion.RecompensasReal

102         If rank > 0 Then
                'Los indices impares son los Rangos de Armada
104             TituloReal = RangosFaccion(2 * rank - 1).Titulo
            End If

            Exit Function

TituloReal_Err:
106         Call TraceError(Err.Number, Err.Description, "ModFacciones.TituloReal", Erl)


End Function

Public Sub EnlistarCaos(ByVal userindex As Integer)
            On Error GoTo EnlistarCaos_Err

            Dim charIndexStr As String

100         With UserList(userindex)
102             charIndexStr = str(NpcList(.flags.TargetNPC).Char.CharIndex)

104             If .Faccion.FuerzasCaos = 1 Then
106                 Call WriteChatOverHead(userindex, "Ya perteneces a la Legi�n Oscura.", charIndexStr, vbWhite)
                    Exit Sub

                End If

108             If .Faccion.ArmadaReal = 1 Then
110                 Call WriteChatOverHead(userindex, "El caos y el poder de las sombras reinar� en este mundo y tu sufrir�s maldito s�bdito de Tancredo.", charIndexStr, vbWhite)
                    Exit Sub

                End If

                'Si fue miembro de la Armada Real no se puede enlistar
112             If .Faccion.RecompensasReal > 0 Then
114                 Call WriteChatOverHead(userindex, "No permitir� que ning�n insecto real ingrese a mis tropas.", charIndexStr, vbWhite)
                    Exit Sub

                End If

116             If Status(userindex) = 1 Then
118                 Call WriteChatOverHead(userindex, "��Ja ja ja!! Tu no eres bienvenido aqu� asqueroso Ciudadano", charIndexStr, vbWhite)
                    Exit Sub

                End If
                
120             If Not HayLugarEnInventario(userindex) Then
122                 Call WriteChatOverHead(userindex, "�No tienes lugar suficiente en el inventario.", charIndexStr, vbWhite)
                    Exit Sub
                End If

124             If .clase = e_Class.Thief Then
126                 Call WriteChatOverHead(userindex, "�La legi�n oscura no tiene lugar para escorias como t�! Los ladrones no son dignos de llevar nuestras armaduras.", charIndexStr, vbWhite)
                    Exit Sub

                End If

128             If UserList(userindex).Faccion.Reenlistadas > 0 Then
130                 Call WriteChatOverHead(userindex, "Has sido expulsado de las fuerzas oscuras y durante tu rebeld�a has atacado a mi ej�rcito. �Vete de aqu�!", charIndexStr, vbWhite)
                    Exit Sub

                End If


                Dim primerRango As t_RangoFaccion
132                 primerRango = RangosFaccion(2) ' 2 es el primer rango del caos

134             If .Faccion.ciudadanosMatados < primerRango.AsesinatosRequeridos Then
136                 Call WriteChatOverHead(userindex, "Para unirte a nuestras fuerzas debes matar al menos " & primerRango.AsesinatosRequeridos & " ciudadanos, solo has matado " & .Faccion.ciudadanosMatados, charIndexStr, vbWhite)
                    Exit Sub

                End If

138             If .Stats.ELV < primerRango.NivelRequerido Then
140                 Call WriteChatOverHead(userindex, "���Para unirte a nuestras fuerzas debes ser al menos de nivel " & primerRango.NivelRequerido & "!!!", charIndexStr, vbWhite)
                    Exit Sub
                End If
                
                
                'HarThaoS: Lo pongo al final para que lo expulse del clan solamente si cumple todos los requisitos.
146             If .GuildIndex > 0 Then
148                 If PersonajeEsLeader(.name) Then
                        'Si el clan es neutral no lo dejo, le digo que tiene que salir del clan para poder enlistarse
                        If GuildAlignmentIndex(.GuildIndex) = e_ALINEACION_GUILD.ALINEACION_NEUTRAL Then
                            Call WriteChatOverHead(userindex, "No puedes integrar nuestras fuerzas si perteneces a un clan neutral, deber�s abandonarlo si tu deseo es integrar la Legi�n Oscura.", charIndexStr, vbWhite)
                            Exit Sub
                        End If
                    Else
                        If GuildAlignmentIndex(.GuildIndex) <> e_ALINEACION_GUILD.ALINEACION_CRIMINAL Then
                         Call m_EcharMiembroDeClan(userindex, .name)
                        End If
                    End If
                End If

                ' Cumple con los requisitos para enlistarse
150             .Faccion.FuerzasCaos = 1
152             .Faccion.RecompensasCaos = primerRango.rank ' Asigna primer rango
154             .Faccion.Reenlistadas = .Faccion.Reenlistadas + 1
156             .Faccion.Status = 2

158             If .Faccion.RecibioArmaduraCaos = 0 Then
160                 Call WriteChatOverHead(userindex, "Aqu� tienes tu armadura legionario, ve a derramar sangre de los s�bditos de Tancredo. Esta guerra ser� larga y cruel.", charIndexStr, vbWhite)
162                 .Faccion.NivelIngreso = .Stats.ELV
                End If

164             Call WriteConsoleMsg(userindex, "�Ahora perteneces a la Legi�n Oscura.!", e_FontTypeNames.FONTTYPE_INFOIAO)
166             Call DarRecompensas(userindex)
168             Call RefreshCharStatus(userindex)

            End With

            'Call LogEjercitoCaos(UserList(UserIndex).Name & " ingres� el " & Date & " cuando era nivel " & UserList(UserIndex).Stats.ELV)

            Exit Sub

EnlistarCaos_Err:
170         Call TraceError(Err.Number, Err.Description, "ModFacciones.EnlistarCaos", Erl)


End Sub

Public Sub RecompensaCaos(ByVal userindex As Integer)
            On Error GoTo RecompensaCaos_Err


            Dim ciudadanosMatados As Long, npcCharIndex As String
            Dim proxRango As t_RangoFaccion

100         With UserList(userindex)
102             ciudadanosMatados = .Faccion.ciudadanosMatados
104             npcCharIndex = str(NpcList(.flags.TargetNPC).Char.CharIndex)

106             If .Faccion.RecompensasCaos >= MaxRangoFaccion Then
108                 Call WriteChatOverHead(userindex, "�Has alcanzado uno de los mejores lugares en mis filas. Mant�n firme tu liderazgo y crueldad para alg�n d�a formar parte del Concilio de las Sombras.", npcCharIndex, vbWhite)
                    Exit Sub
                End If
                
110             If Not HayLugarEnInventario(userindex) Then
112                 Call WriteChatOverHead(userindex, "�No tienes lugar suficiente en el inventario.", npcCharIndex, vbWhite)
                    Exit Sub
                End If

114             proxRango = ProximoRango(userindex)

116             If ciudadanosMatados < proxRango.AsesinatosRequeridos Then
118                 Call WriteChatOverHead(userindex, "Mata " & proxRango.AsesinatosRequeridos - ciudadanosMatados & " Ciudadanos m�s para recibir la pr�xima Recompensa", npcCharIndex, vbWhite)
                    Exit Sub
                End If

120             If proxRango.NivelRequerido > .Stats.ELV Then
122               Call WriteChatOverHead(userindex, "Has acabado con la vida de suficientes enemigos pero a�n te faltan " & (proxRango.NivelRequerido - .Stats.ELV) & " niveles para alcanzar el siguiente rango.", npcCharIndex, vbWhite)

                Else ' El usuario cumple con los requerimientos de nivel, se le asigna la recomenza.
124               .Faccion.RecompensasCaos = proxRango.rank

126               Call WriteChatOverHead(userindex, "���Bien hecho " + proxRango.Titulo + ", aqu� tienes tu recompensa, sigue pregonando el caos a lo largo de estas tierras.!!! ", npcCharIndex, vbWhite)
128               Call DarRecompensas(userindex)
                  '.Stats.Exp = .Stats.Exp + ExpX100
                End If
            End With

            Exit Sub

RecompensaCaos_Err:
130         Call TraceError(Err.Number, Err.Description, "ModFacciones.RecompensaCaos", Erl)


End Sub

Public Function TituloCaos(ByVal userindex As Integer) As String
            On Error GoTo TituloCaos_Err

            Dim rank As Byte
100             rank = UserList(userindex).Faccion.RecompensasCaos

102         If rank > 0 Then
                'Los indices pares son los Rangos del Caos
104             TituloCaos = RangosFaccion(2 * rank).Titulo
            End If

            Exit Function

TituloCaos_Err:
106         Call TraceError(Err.Number, Err.Description, "ModFacciones.TituloCaos", Erl)


End Function


' Devuelve el proximo rango para el usuario de la faccion que pertenece.
Private Function ProximoRango(ByVal userindex As Integer) As t_RangoFaccion
            On Error GoTo ProximoRango_Err

100         With UserList(userindex)
102             If .Faccion.ArmadaReal = 1 And .Faccion.RecompensasReal < MaxRangoFaccion Then
104                 ProximoRango = RangosFaccion(2 * .Faccion.RecompensasReal + 1)
106             ElseIf .Faccion.FuerzasCaos = 1 And .Faccion.RecompensasCaos < MaxRangoFaccion Then
108                 ProximoRango = RangosFaccion(2 * .Faccion.RecompensasCaos + 2)
                Else ' No pertenece a ninguna faccion.
                    ' No devuelve nada
                End If
            End With

            Exit Function

ProximoRango_Err:
110         Call TraceError(Err.Number, Err.Description, "ModFacciones.TituloCaos", Erl)


End Function


' Rutina para dar las recompensas de faccion al usuario.
' Si el usuario sube mas de un rango por vez, esta rutina le dara TODOS los objetos
' que deber�a tener hasta alcanzar su rango.
Private Sub DarRecompensas(ByVal userindex As Integer)
            On Error GoTo DarRecompensas_Err

            Dim recompensa As t_RecompensaFaccion
            Dim rank As Byte
            Dim ultimaRecompensa As Byte
            Dim objetoRecompensa As t_Obj
            Dim i As Integer

100         With UserList(userindex)
                ' Si es semidios o consejero, no le damos nada
102             If .flags.Privilegios And (e_PlayerType.Consejero Or e_PlayerType.SemiDios) Then
                    Exit Sub
                End If

104             If .Faccion.ArmadaReal = 1 Then
106                 rank = .Faccion.RecompensasReal
108                 ultimaRecompensa = .Faccion.RecibioArmaduraReal
110             ElseIf .Faccion.FuerzasCaos = 1 Then
112                 rank = .Faccion.RecompensasCaos
114                 ultimaRecompensa = .Faccion.RecibioArmaduraCaos
                Else ' No pertenece a ninguna faccion.
                    Exit Sub
                End If

116             If ultimaRecompensa >= rank Then
                    Exit Sub
                End If

                ' Esto puede parecer ineficiente, pero DarRecompensas sucede pocas veces en el juego.
                ' Por ahora, iterar por todas las recompensas es mas facil que mantener una estructura mas
                ' complicada (como diccionarios). El total de recompensas se puede aproximar como: `C * R * F * nR`
                ' C = 12 (clases distintas); R = 6 (max rango por faccion); F = 2 (facciones distintas);
                ' nR = 1 (numero de recompensas por rango)
118             For i = 1 To UBound(RecompensasFaccion)
120                 recompensa = RecompensasFaccion(i)

                    ' Como puede subir varios rangos todos juntos, nos aseguramos que
                    ' entregamos TODAS las recompensas hasta el rango actual desde la ultima recompensa.
122                 If recompensa.rank <= rank And recompensa.rank > ultimaRecompensa Then
                        ' Por alguna razon, PuedeUsarObjeto devuelve 0 cuando el usuario SI puede usarlo.
124                     If PuedeUsarObjeto(userindex, recompensa.ObjIndex, False) = 0 Then
126                         objetoRecompensa.amount = 1
128                         objetoRecompensa.ObjIndex = recompensa.ObjIndex

130                         If Not MeterItemEnInventario(userindex, objetoRecompensa) Then
132                             Call TirarItemAlPiso(.Pos, objetoRecompensa)

                            End If
                        End If
                    End If

134             Next i

                ' Guardamos que el usuario recibio las recompensas de su rank.
136             If .Faccion.ArmadaReal = 1 Then
138               .Faccion.RecibioArmaduraReal = rank
                Else
140               .Faccion.RecibioArmaduraCaos = rank
                End If

142             Call SendData(SendTarget.ToIndex, userindex, PrepareMessagePlayWave(48, NO_3D_SOUND, NO_3D_SOUND))
            End With

            Exit Sub

DarRecompensas_Err:
144         Call TraceError(Err.Number, Err.Description, "ModFacciones.DarRecompensas", Erl)


End Sub


Private Sub PerderItemsFaccionarios(ByVal userindex As Integer)
            On Error GoTo PerderItemsFaccionarios_Err

            Dim i         As Byte
            Dim ItemIndex As Integer

100         With UserList(userindex)
102             For i = 1 To .CurrentInventorySlots
104                 ItemIndex = .Invent.Object(i).ObjIndex

106                 If ItemIndex > 0 Then

108                     If ObjData(ItemIndex).Real = 1 Or ObjData(ItemIndex).Caos = 1 Then

110                         Call QuitarUserInvItem(userindex, i, MAX_INVENTORY_OBJS)
112                         Call UpdateUserInv(False, userindex, i)

                        End If
                    End If
114             Next i
            End With

            Exit Sub

PerderItemsFaccionarios_Err:
116         Call TraceError(Err.Number, Err.Description, "ModFacciones.PerderItemsFaccionarios", Erl)


End Sub
