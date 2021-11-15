Attribute VB_Name = "FXs"

Public Type tIndiceFx
    Animacion As Long
    OffsetX As Integer
    OffsetY As Integer
    IsPng As Integer
End Type

Public Type FxData
    FX As GRH
    OffsetX As Long
    OffsetY As Long
    IsPng As Integer
End Type

Public Type tIndiceFxInt
    Animacion As Long
    OffsetX As Integer
    OffsetY As Integer
    IsPng As Integer
End Type

Public Type FxDataInt
    FX As GRHint
    OffsetX As Long
    OffsetY As Long
    IsPng As Integer
End Type

Public NumFxs As Integer
Public FxData() As FxData
Public MisFxs() As tIndiceFx
Public FxDataInt() As FxDataInt
Public MisFxsInt() As tIndiceFxInt

Sub CargarFxs()
On Error Resume Next
Dim n As Integer, i As Integer

n = FreeFile
If UsarIndex = False Then
    Open DirClien & "\INIT\Fxs.ind" For Binary Access Read As #n
Else
    Open DirIndex & "\Fxs.ind" For Binary Access Read As #n
End If

'cabecera
Get #n, , MiCabecera

'num de cabezas
Get #n, , NumFxs

'Resize array
ReDim FxData(0 To NumFxs + 1) As FxData
ReDim MisFxs(0 To NumFxs + 1) As tIndiceFx
If UsarGrhLong = False Then
    ReDim FxDataInt(0 To NumFxs + 1) As FxDataInt
    ReDim MisFxsInt(0 To NumFxs + 1) As tIndiceFxInt
End If


For i = 1 To NumFxs

    Get #n, , MisFxsInt(i)
    MisFxs(i).Animacion = MisFxsInt(i).Animacion

    Call InitGrh(FxData(i).FX, MisFxsInt(i).Animacion, 1)
    FxData(i).OffsetX = MisFxsInt(i).OffsetX
    FxData(i).OffsetY = MisFxsInt(i).OffsetY
    FxData(i).IsPng = MisFxsInt(i).IsPng
    

    
Next i

Close #n
End Sub
