Attribute VB_Name = "modIAO"
Public FormatoIAO As Boolean

'***************************
'Sinuhe - Map format .CSM
'***************************

'The only current map

Private Type Position

    X As Integer
    y As Integer

End Type

'Item type
Private Type tItem

    objindex As Integer
    Amount As Integer

End Type

Private Type tWorldPos

    Map As Integer
    X As Integer
    y As Integer

End Type

Private Type Grh

    grhindex As Long
    FrameCounter As Single
    speed As Single
    Started As Byte
    alpha_blend As Boolean
    angle As Single

End Type

Private Type GrhData

    sX As Integer
    sY As Integer
    FileNum As Integer
    pixelWidth As Integer
    pixelHeight As Integer
    TileWidth As Single
    TileHeight As Single
    NumFrames As Integer
    Frames() As Integer
    speed As Integer
    mini_map_color As Long

End Type

Private Type tMapHeader

    NumeroBloqueados As Long
    NumeroLayers(1 To 4) As Long
    NumeroTriggers As Long
    NumeroLuces As Long
    NumeroParticulas As Long
    NumeroNPCs As Long
    NumeroOBJs As Long
    NumeroTE As Long

End Type

Private Type tDatosBloqueadosOld

    X As Integer
    y As Integer

End Type

Private Type tDatosBloqueados

    X As Integer
    y As Integer
    lados As Byte

End Type

Private Type tDatosGrh

    X As Integer
    y As Integer
    grhindex As Long

End Type

Private Type tDatosTrigger

    X As Integer
    y As Integer
    Trigger As Integer

End Type

Private Type tDatosLuces

    X As Integer
    y As Integer
    color As Long
    Rango As Byte

End Type

Private Type tDatosParticulas

    X As Integer
    y As Integer
    Particula As Long

End Type

Private Type tDatosNPC

    X As Integer
    y As Integer
    NPCIndex As Integer

End Type

Private Type tDatosObjs

    X As Integer
    y As Integer
    objindex As Integer
    ObjAmmount As Integer

End Type

Private Type tDatosTE

    X As Integer
    y As Integer
    DestM As Integer
    DestX As Integer
    DestY As Integer

End Type

Private Type tMapSize

    XMax As Integer
    XMin As Integer
    YMax As Integer
    YMin As Integer

End Type

Private Type tMapDat

    map_name As String
    backup_mode As Byte
    restrict_mode As String
    music_numberHi As Long
    music_numberLow As Long
    seguro As Byte
    zone As String
    terrain As String
    ambient As String
    base_light As Long
    letter_grh As Long
    extra1 As Long
    extra2 As Long
    extra3 As String
    lluvia As Byte
    nieve As Byte
    niebla As Byte

End Type

Private MapSize As tMapSize
Public MapDat   As tMapDat





Public Function Load_Map_Data_CSM(ByVal MapRoute As String, Optional ByVal Client_Mode As Boolean = False) As Boolean
    
    On Error GoTo Load_Map_Data_CSM_Err
    

    'On Error GoTo ErrorHandler
    ColorAmb = 0 'Luz Base por defecto
    engine.Map_Base_Light_Set ColorAmb

    engine.Light_Remove_All
    LightA.Delete_All_LigthRound
    
    engine.Particle_Group_Remove_All
    ' Call Borrar_Mapa

    Dim ERRORDESC    As String
    Dim fh           As Integer
    Dim MH           As tMapHeader
    Dim Blqs()       As tDatosBloqueados
    Dim L1()         As tDatosGrh
    Dim L2()         As tDatosGrh
    Dim L3()         As tDatosGrh
    Dim L4()         As tDatosGrh
    Dim Triggers()   As tDatosTrigger
    Dim Luces()      As tDatosLuces
    Dim Particulas() As tDatosParticulas
    Dim Objetos()    As tDatosObjs
    Dim NPCs()       As tDatosNPC
    Dim TEs()        As tDatosTE

    Dim Body         As Integer
    Dim Head         As Integer
    Dim Heading      As Byte
    
    Dim i            As Long
    Dim j            As Long

    fh = FreeFile
    Open MapRoute For Binary As fh

    Get #fh, , MH
    Get #fh, , MapSize
    Get #fh, , MapDat

    With MapSize
        ReDim MapData(1 To 100, 1 To 100)

        Rem      ReDim L1(1 To 100, 1 To 100)
    End With
    
    ERRORDESC = "Error al cargar el layer 1"
    Rem  Get #fh, , L1

    With MH

        'Cargamos Bloqueos

        If .NumeroBloqueados > 0 Then
            ERRORDESC = "Error al cargar bloqueos"
            ReDim Blqs(1 To .NumeroBloqueados)
            
            Get #fh, , Blqs

            For i = 1 To .NumeroBloqueados
                MapData(Blqs(i).X, Blqs(i).y).Blocked = Blqs(i).lados
            Next i

        End If
        
        'Cargamos Layer 1
        
        If .NumeroLayers(1) > 0 Then
            ERRORDESC = "Error al cargar el layer 1"
            ReDim L1(1 To .NumeroLayers(1))
            Get #fh, , L1

            For i = 1 To .NumeroLayers(1)
            
                MapData(L1(i).X, L1(i).y).Graphic(1).grhindex = L1(i).grhindex
            
                InitGrh MapData(L1(i).X, L1(i).y).Graphic(1), MapData(L1(i).X, L1(i).y).Graphic(1).grhindex
                ' Call Map_Grh_Set(L2(i).x, L2(i).y, L2(i).GrhIndex, 2)
            Next i

        End If
        
        'Cargamos Layer 2
        
        If .NumeroLayers(2) > 0 Then
            ERRORDESC = "Error al cargar el layer 2"
            ReDim L2(1 To .NumeroLayers(2))
            Get #fh, , L2

            For i = 1 To .NumeroLayers(2)
            
                MapData(L2(i).X, L2(i).y).Graphic(2).grhindex = L2(i).grhindex
            
                InitGrh MapData(L2(i).X, L2(i).y).Graphic(2), MapData(L2(i).X, L2(i).y).Graphic(2).grhindex
                ' Call Map_Grh_Set(L2(i).x, L2(i).y, L2(i).GrhIndex, 2)
            Next i

        End If
                
        If .NumeroLayers(3) > 0 Then
            ERRORDESC = "Error al cargar el layer 3"
            ReDim L3(1 To .NumeroLayers(3))
            Get #fh, , L3

            For i = 1 To .NumeroLayers(3)
            
                MapData(L3(i).X, L3(i).y).Graphic(3).grhindex = L3(i).grhindex
                InitGrh MapData(L3(i).X, L3(i).y).Graphic(3), MapData(L3(i).X, L3(i).y).Graphic(3).grhindex
            Next i

        End If
        
        If .NumeroLayers(4) > 0 Then
            ERRORDESC = "Error al cargar el layer 4"
            ReDim L4(1 To .NumeroLayers(4))
            Get #fh, , L4

            For i = 1 To .NumeroLayers(4)
                MapData(L4(i).X, L4(i).y).Graphic(4).grhindex = L4(i).grhindex
                InitGrh MapData(L4(i).X, L4(i).y).Graphic(4), MapData(L4(i).X, L4(i).y).Graphic(4).grhindex
         
            Next i

        End If
        
        If .NumeroTriggers > 0 Then
            ERRORDESC = "Error al cargar Triggers"
            ReDim Triggers(1 To .NumeroTriggers)
            Get #fh, , Triggers

            For i = 1 To .NumeroTriggers
                MapData(Triggers(i).X, Triggers(i).y).Trigger = Triggers(i).Trigger
            Next i

        End If
        
        If .NumeroParticulas > 0 Then
            ERRORDESC = "Error al cargar Particulas"
            ReDim Particulas(1 To .NumeroParticulas)
            Get #fh, , Particulas

            For i = 1 To .NumeroParticulas
            
                'MapData(Particulas(i).X, Particulas(i).y).particle_Index = Particulas(i).Particula
            
               ' General_Particle_Create MapData(Particulas(i).X, Particulas(i).y).particle_Index, Particulas(i).X, Particulas(i).y
            
                'MapData(Particulas(i).x, Particulas(i).y).particle_group_index = General_Particle_Create(Particulas(i).Particula, Particulas(i).x, Particulas(i).y)
            Next i

        End If
        
        If .NumeroLuces > 0 Then
            ERRORDESC = "Error al cargar Luces"
            ReDim Luces(1 To .NumeroLuces)
            Get #fh, , Luces

            For i = 1 To .NumeroLuces
                'MapData(Luces(i).X, Luces(i).y).luz.color = Luces(i).color
               ' MapData(Luces(i).X, Luces(i).y).luz.Rango = Luces(i).Rango


               
            Next i

        End If
        
        If Not Client_Mode Then
            If .NumeroOBJs > 0 Then
                ERRORDESC = "Error al cargar Objetos"
                ReDim Objetos(1 To .NumeroOBJs)
                Get #fh, , Objetos

                For i = 1 To .NumeroOBJs
                    ' Map_Item_Add Objetos(i).x, Objetos(i).y, Objetos(i).ObjIndex, Objetos(i).ObjAmmount
                
                    MapData(Objetos(i).X, Objetos(i).y).OBJInfo.objindex = Objetos(i).objindex
                    MapData(Objetos(i).X, Objetos(i).y).OBJInfo.Amount = Objetos(i).ObjAmmount

                    ' Debug.Print ObjData(MapData(Objetos(i).X, Objetos(i).Y).OBJInfo.objindex).name
                    If MapData(Objetos(i).X, Objetos(i).y).OBJInfo.objindex > 0 Then
                        InitGrh MapData(Objetos(i).X, Objetos(i).y).ObjGrh, ObjData(MapData(Objetos(i).X, Objetos(i).y).OBJInfo.objindex).grhindex

                    End If
                
                Next i

            End If
            
            If .NumeroNPCs > 0 Then
                ERRORDESC = "Error al cargar NPCS"
                ReDim NPCs(1 To .NumeroNPCs)
                Get #fh, , NPCs

                For i = 1 To .NumeroNPCs
                
                    '  Debug.Print .NumeroNPCs
                    'If NPCs(i).NPCIndex > 500 Then
                    MapData(NPCs(i).X, NPCs(i).y).NPCIndex = NPCs(i).NPCIndex
    
                    Body = NpcData(MapData(NPCs(i).X, NPCs(i).y).NPCIndex).Body
                    Head = NpcData(MapData(NPCs(i).X, NPCs(i).y).NPCIndex).Head
                    Heading = NpcData(MapData(NPCs(i).X, NPCs(i).y).NPCIndex).Heading
                   ' Call MakeChar(NextOpenChar(), Body, Head, Heading, NPCs(i).X, NPCs(i).y)
                
                    ' End If
                
                    'Map_NPC_Add NPCs(i).x, NPCs(i).y, NPCs(i).NpcIndex
                Next i

            End If
            
            If .NumeroTE > 0 Then
                ERRORDESC = "Error al cargar TilesExit"
                ReDim TEs(1 To .NumeroTE)
                Get #fh, , TEs

                For i = 1 To .NumeroTE
                
                    MapData(TEs(i).X, TEs(i).y).TileExit.Map = TEs(i).DestM
                    MapData(TEs(i).X, TEs(i).y).TileExit.X = TEs(i).DestX
                    MapData(TEs(i).X, TEs(i).y).TileExit.y = TEs(i).DestY
                Next i

            End If

        End If
        
    End With

    Close fh

    ERRORDESC = "Error al cargar variables"
    Call CargarVariables

   ' frmMain.TxtMidi.Text = MapDat.music_numberLow

    Load_Map_Data_CSM = True

    Call Pestañas(MapRoute)
   ' Call DibujarMiniMapa
    engine.Light_Render_All
    
    bRefreshRadar = True ' Radar
    'Set changed flag
    MapInfo.Changed = 0
    
    ' Vacia el Deshacer
    modEdicion.Deshacer_Clear
    
    'Change mouse icon
    frmMain.MousePointer = 0
    MapaCargado = True

    Exit Function

ErrorHandler:
    MsgBox "Error al cargar el mapa: " & ERRORDESC

    If fh <> 0 Then Close fh

    
    Exit Function

Load_Map_Data_CSM_Err:
   ' Call RegistrarError(Err.Number, Err.Description, "ModCargaIAO.Load_Map_Data_CSM", Erl)
    Resume Next
    
End Function
Public Function Save_Map_Data(ByVal MapRoute As String) As Boolean


End Function
Sub establecerVariables()
    MapDat.ambient = Ambiente
    MapDat.extra1 = AmbienteNoche
    MapDat.lluvia = MapDat.lluvia
    MapDat.nieve = Nieba
    MapDat.niebla = nieblaV
    MapDat.map_name = MapDat.map_name
    MapDat.backup_mode = MapDat.backup_mode
    MapDat.restrict_mode = MapDat.restrict_mode
    MapDat.music_numberLow = MidiMusic
    MapDat.music_numberHi = Mp3Music
    MapDat.zone = MapDat.zone
    MapDat.terrain = MapDat.terrain
    MapDat.base_light = ColorAmb
End Sub
Sub CargarVariables()
    Ambiente = MapDat.ambient
    AmbienteNoche = MapDat.extra1
   '  Llueve = MapDat.lluvia
    Nieba = MapDat.nieve
    nieblaV = MapDat.niebla
   ' MapInfo.name = MapDat.map_name
   ' MapInfo.BackUp = MapDat.backup_mode
   ' MapInfo.Restringir = MapDat.restrict_mode
    MidiMusic = MapDat.music_numberLow
    Mp3Music = MapDat.music_numberHi
   ' MapInfo.Zona = MapDat.zone
   ' MapInfo.Terreno = MapDat.terrain
    ColorAmb = MapDat.base_light

    Call CompletarForms
End Sub

Sub CompletarForms()
On Error Resume Next

    
    
    
 ' Dim Rojo As Byte, Verde As Byte, Azul As Byte &HFFFFFF
      
    'Call Obtener_RGB(ColorAmb, Rojo, Verde, Azul)
  
    'Colocamos el color de fondo pasandole a la función de vb RGB los valores

    
  


    
End Sub


