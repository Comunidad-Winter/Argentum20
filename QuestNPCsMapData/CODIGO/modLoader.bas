Attribute VB_Name = "modLoader"
Option Explicit

Private Type t_Position

    X As Integer
    y As Integer

End Type

'Item type
Private Type t_Item

    ObjIndex As Integer
    amount As Integer

End Type

Private Type t_WorldPos

    map As Integer
    X As Byte
    y As Byte

End Type

Private Type t_Grh

    GrhIndex As Long
    FrameCounter As Single
    Speed As Single
    Started As Byte
    alpha_blend As Boolean
    angle As Single

End Type

Private Type t_GrhData

    sX As Integer
    sY As Integer
    FileNum As Integer
    pixelWidth As Integer
    pixelHeight As Integer
    TileWidth As Single
    TileHeight As Single
    NumFrames As Integer
    Frames() As Integer
    Speed As Integer
    mini_map_color As Long

End Type

Private Type t_MapHeader

    NumeroBloqueados As Long
    NumeroLayers(1 To 4) As Long
    NumeroTriggers As Long
    NumeroLuces As Long
    NumeroParticulas As Long
    NumeroNPCs As Long
    NumeroOBJs As Long
    NumeroTE As Long

End Type

Private Type t_DatosBloqueados

    X As Integer
    y As Integer
    Lados As Byte

End Type

Private Type t_DatosGrh

    X As Integer
    y As Integer
    GrhIndex As Long

End Type

Private Type t_DatosTrigger

    X As Integer
    y As Integer
    trigger As Integer

End Type

Private Type t_DatosLuces

    X As Integer
    y As Integer
    Color As Long
    Rango As Byte

End Type

Private Type t_DatosParticulas

    X As Integer
    y As Integer
    Particula As Long

End Type

Private Type t_DatosNPC

    X As Integer
    y As Integer
    NpcIndex As Integer

End Type

Private Type t_DatosObjs

    X As Integer
    y As Integer
    ObjIndex As Integer
    ObjAmmount As Integer

End Type

Private Type t_DatosTE

    X As Integer
    y As Integer
    DestM As Integer
    DestX As Integer
    DestY As Integer

End Type

Private Type t_MapSize

    XMax As Integer
    XMin As Integer
    YMax As Integer
    YMin As Integer

End Type

Private Type t_MapDat

    map_name As String
    backup_mode As Byte
    restrict_mode As String
    music_numberHi As Long
    music_numberLow As Long
    Seguro As Byte
    zone As String
    terrain As String
    ambient As String
    base_light As Long
    letter_grh As Long
    level As Long
    extra2 As Long
    Salida As String
    lluvia As Byte
    Nieve As Byte
    niebla As Byte

End Type

Private MapSize As t_MapSize
Private MapDat  As t_MapDat
Public DatPath As String
Public MapPath As String
Global LeerNPCs As New clsIniManager

'''''''''''''''''''''''''''''''''''''''''''''''
'Public ListNPCMapData() As Variant
Public ListNPCMapData() As t_QuestNPCMapData

Public Type t_QuestNPCMapData
    Position As t_Position
    NPCNumber As Integer
    State As Integer
End Type

Public MapHasNPC() As Boolean
Public NumMaps As Long
Public Const MAX_QUESTNPCS_VISIBLE As Long = 100
'''''''''''''''''''''''''''''''''''''''''''''''

Sub Main()

    DatPath = App.Path & "\..\Recursos\Dat\"
    MapPath = App.Path & "\..\Recursos\Mapas\"
    
    Set LeerNPCs = New clsIniManager
    Call LeerNPCs.Initialize(DatPath & "NPCs.dat")
    
    NumMaps = 600 ' test
    
    'ReDim ListNPCMapData(1 To NumMaps) As Variant
    ReDim ListNPCMapData(1 To NumMaps, 1 To MAX_QUESTNPCS_VISIBLE) As t_QuestNPCMapData
    ReDim MapHasNPC(1 To NumMaps) As Boolean
    
    Dim map As Long
    For map = 1 To NumMaps
        Call CargarMapaFormatoCSM(map, MapPath & "Mapa" & map & ".csm")
        DoEvents
    Next map
    
    Call SaveNPCsMapData
End Sub

Public Sub SaveNPCsMapData()
    Dim fh As Integer
    fh = FreeFile

    Open App.Path & "\..\Recursos\OUTPUT\QuestNPCsMapData.bin" For Binary As fh
        Dim i As Integer
        For i = 1 To NumMaps
            If MapHasNPC(i) Then
                Put fh, , CInt(i)
                Dim j As Long
                
                For j = 1 To MAX_QUESTNPCS_VISIBLE
                    Put fh, , CInt(ListNPCMapData(i, j).NPCNumber)
                    Put fh, , CInt(ListNPCMapData(i, j).Position.X)
                    Put fh, , CInt(ListNPCMapData(i, j).Position.y)
                    Put fh, , CInt(ListNPCMapData(i, j).State)
                Next j
            End If
        Next i
    Close fh
End Sub

Public Sub CargarMapaFormatoCSM(ByVal map As Long, ByVal MAPFl As String)

        On Error GoTo ErrorHandler:
        Dim fh           As Integer
        Dim MH           As t_MapHeader
        Dim Blqs()       As t_DatosBloqueados
        Dim L1()         As t_DatosGrh
        Dim L2()         As t_DatosGrh
        Dim L3()         As t_DatosGrh
        Dim L4()         As t_DatosGrh
        Dim Triggers()   As t_DatosTrigger
        Dim Luces()      As t_DatosLuces
        Dim Particulas() As t_DatosParticulas
        Dim Objetos()    As t_DatosObjs
        Dim NPCs()       As t_DatosNPC
        Dim TEs()        As t_DatosTE

        Dim Body         As Integer
        Dim Head         As Integer
        Dim Heading      As Byte

        Dim i            As Long
        Dim j            As Long
    
        Dim X As Integer, y As Integer
        
100     If Not FileExist(MAPFl, vbNormal) Then
102         'MsgBox "Estas tratando de cargar un MAPA que NO EXISTE" & vbNewLine & "Mapa: " & MAPFl
            Debug.Print "Omitiendo mapa " & map & " inexistente."
            Exit Sub
        End If
        
104     If FileLen(MAPFl) = 0 Then
106         MsgBox "Se trato de cargar un mapa corrupto o mal generado" & vbNewLine & "Mapa: " & MAPFl
            Exit Sub
        End If
    
108     fh = FreeFile
110     Open MAPFl For Binary As fh
    
112     Get #fh, , MH
114     Get #fh, , MapSize
116     Get #fh, , MapDat
        
        MapHasNPC(map) = False
        
        Rem Get #fh, , L1
118     With MH
            'Cargamos Bloqueos
120         If .NumeroBloqueados > 0 Then
122             ReDim Blqs(1 To .NumeroBloqueados)
124             Get #fh, , Blqs
            End If
        
            'Cargamos Layer 1
132         If .NumeroLayers(1) > 0 Then
134             ReDim L1(1 To .NumeroLayers(1))
136             Get #fh, , L1
            End If
        
            'Cargamos Layer 2
152         If .NumeroLayers(2) > 0 Then
154             ReDim L2(1 To .NumeroLayers(2))
156             Get #fh, , L2
            End If
                
170         If .NumeroLayers(3) > 0 Then
172             ReDim L3(1 To .NumeroLayers(3))
174             Get #fh, , L3
            End If
        
190         If .NumeroLayers(4) > 0 Then
192             ReDim L4(1 To .NumeroLayers(4))
194             Get #fh, , L4
            End If

202         If .NumeroTriggers > 0 Then
204             ReDim Triggers(1 To .NumeroTriggers)
206             Get #fh, , Triggers
            End If

222         If .NumeroParticulas > 0 Then
224             ReDim Particulas(1 To .NumeroParticulas)
226             Get #fh, , Particulas
            End If

236         If .NumeroLuces > 0 Then
238             ReDim Luces(1 To .NumeroLuces)
240             Get #fh, , Luces
            End If
            
254         If .NumeroOBJs > 0 Then
256             ReDim Objetos(1 To .NumeroOBJs)
258             Get #fh, , Objetos
            End If

276         If .NumeroNPCs > 0 Then
278             ReDim NPCs(1 To .NumeroNPCs)
280             Get #fh, , NPCs
                Dim NumNpc As Integer, NpcIndex As Integer
                Dim QuestNpcCount As Long
                QuestNpcCount = 1
282             For i = 1 To .NumeroNPCs
284                 NumNpc = NPCs(i).NpcIndex
286                 If NumNpc > 0 Then
288                     If Val(GetNPCData(NumNpc, "NumQuest")) > 0 Then
                           ' Dim NPCName As String
                            'NPCName = GetNPCData(NumNpc, "Name")
                            ListNPCMapData(map, QuestNpcCount).NPCNumber = NumNpc
                            ListNPCMapData(map, QuestNpcCount).Position.X = NPCs(i).X
                            ListNPCMapData(map, QuestNpcCount).Position.y = NPCs(i).y
                            ListNPCMapData(map, QuestNpcCount).State = 2
                            QuestNpcCount = QuestNpcCount + 1
                            MapHasNPC(map) = True
                            'Lo puso el feroncho: Debug.Print "En el Mapa: " & map & " en la posición: " & NPCs(i).X & " - " & NPCs(i).y & " se encuentra el NPC de Quest: " & NPCName
                        ElseIf Val(GetNPCData(NumNpc, "Minimap")) > 0 Then
                            ListNPCMapData(map, QuestNpcCount).NPCNumber = NumNpc
                            ListNPCMapData(map, QuestNpcCount).Position.X = NPCs(i).X
                            ListNPCMapData(map, QuestNpcCount).Position.y = NPCs(i).y
                            ListNPCMapData(map, QuestNpcCount).State = Val(GetNPCData(NumNpc, "Minimap"))
                            QuestNpcCount = QuestNpcCount + 1
                            MapHasNPC(map) = True
                        End If
                        
                    End If
312             Next i
            End If
            
314         'If .NumeroTE > 0 Then
316         '    ReDim TEs(1 To .NumeroTE)
318         '    Get #fh, , TEs
            'End If
        End With

330     Close fh

340     'MapInfo(map).map_name = MapDat.map_name
 
        Exit Sub

ErrorHandler:
394     Close fh
        MsgBox "Error cargando mapa " & map
End Sub

Public Sub CargaNpcsDat(Optional ByVal ActualizarNPCsExistentes As Boolean = False)
        
            On Error GoTo CargaNpcsDat_Err
        
            ' Leemos el NPCs.dat y lo almacenamos en la memoria.
100         Set LeerNPCs = New clsIniManager
102         Call LeerNPCs.Initialize(DatPath & "NPCs.dat")
        
            Exit Sub

CargaNpcsDat_Err:
118         MsgBox "Error cargando NPCs"
        
End Sub

Public Function GetNPCData(ByVal Number As Long, ByVal Parameter As String) As String

    Dim Leer As clsIniManager
    Set Leer = LeerNPCs
    
    'If requested index is invalid, abort
    If Not Leer.KeyExists("NPC" & Number) Then
        GetNPCData = "-1Z"
        Exit Function
    End If
    
    GetNPCData = Leer.GetValue("NPC" & Number, Parameter)
    
End Function
