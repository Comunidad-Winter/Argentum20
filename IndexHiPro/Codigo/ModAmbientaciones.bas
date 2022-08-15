Attribute VB_Name = "ModAmbientaciones"
Option Explicit
Public AmbientacionesTotal As Integer

Public Type Ambientacion
    nombre As String
    tipo As Byte
    grhindex As Long
End Type

Public Ambientaciones(1 To 1200) As Ambientacion

Sub LeerAmbientaciones()
AmbientacionesTotal = Val(GetVar(DirClien & "\init\ambientacion.ini", "INIT", "AmbientacionTotales"))
Dim i As Integer

For i = 1 To AmbientacionesTotal
    Ambientaciones(i).nombre = GetVar(DirClien & "\init\ambientacion.ini", Val(i), "Nombre")
    Ambientaciones(i).tipo = GetVar(DirClien & "\init\ambientacion.ini", Val(i), "Tipo")
    Ambientaciones(i).grhindex = GetVar(DirClien & "\init\ambientacion.ini", Val(i), "GrhIndex")

Next i
End Sub


Sub GrabarAmbientacion()
Dim i As Long
Form1.GRHt.Text = "Exportando..."
Call WriteVar(DirClien & "\init\ambientacion.ini", "INIT", "AmbientacionTotales", Val(AmbientacionesTotal))
For i = 1 To AmbientacionesTotal
Call WriteVar(DirClien & "\init\ambientacion.ini", Val(i), "Nombre", Ambientaciones(i).nombre)
Call WriteVar(DirClien & "\init\ambientacion.ini", Val(i), "grhindex", Val(Ambientaciones(i).grhindex))
Call WriteVar(DirClien & "\init\ambientacion.ini", Val(i), "Tipo", Val(Ambientaciones(i).tipo))
Next i
Form1.GRHt.Text = "Ambientaciones.ini exportado exitosamanete."
End Sub



