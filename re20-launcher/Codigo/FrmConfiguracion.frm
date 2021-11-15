VERSION 5.00
Begin VB.Form FrmConfiguracion 
   BorderStyle     =   0  'None
   Caption         =   "Form1"
   ClientHeight    =   2760
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4995
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2760
   ScaleWidth      =   4995
   StartUpPosition =   2  'CenterScreen
   Begin VB.PictureBox Picture4 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   435
      Left            =   380
      ScaleHeight     =   435
      ScaleWidth      =   420
      TabIndex        =   3
      Top             =   1600
      Width           =   420
   End
   Begin VB.PictureBox Picture2 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   435
      Left            =   380
      ScaleHeight     =   435
      ScaleWidth      =   420
      TabIndex        =   1
      Top             =   1000
      Width           =   420
      Begin VB.PictureBox Picture3 
         Appearance      =   0  'Flat
         AutoSize        =   -1  'True
         BackColor       =   &H80000005&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   435
         Left            =   360
         Picture         =   "FrmConfiguracion.frx":0000
         ScaleHeight     =   435
         ScaleWidth      =   420
         TabIndex        =   2
         Top             =   0
         Width           =   420
      End
   End
   Begin VB.PictureBox Picture1 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   435
      Left            =   380
      ScaleHeight     =   435
      ScaleWidth      =   420
      TabIndex        =   0
      Top             =   400
      Width           =   420
   End
   Begin VB.Label volver 
      BackStyle       =   0  'Transparent
      Height          =   375
      Left            =   3600
      TabIndex        =   4
      Top             =   2040
      Width           =   975
   End
End
Attribute VB_Name = "FrmConfiguracion"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Dim Musica      As Byte

Dim Fx          As Byte

Dim Ambientales As Byte

Public bmoving  As Boolean

Public DX       As Integer

Public dy       As Integer
Option Explicit

Private WithEvents zip As ZipExtractionClass
Attribute zip.VB_VarHelpID = -1

' Constantes para SendMessage
Const WM_SYSCOMMAND    As Long = &H112&

Const MOUSE_MOVE       As Long = &HF012&

Private Declare Function ReleaseCapture Lib "USER32" () As Long

Private Declare Function SendMessage _
                Lib "USER32" _
                Alias "SendMessageA" (ByVal hwnd As Long, _
                                      ByVal wMsg As Long, _
                                      ByVal wParam As Long, _
                                      lParam As Long) As Long

' función Api para aplicar la transparencia a la ventana
Private Declare Function SetLayeredWindowAttributes _
                Lib "USER32" (ByVal hwnd As Long, _
                              ByVal crKey As Long, _
                              ByVal bAlpha As Byte, _
                              ByVal dwFlags As Long) As Long

' Funciones api para los estilos de la ventana
Private Declare Function GetWindowLong _
                Lib "USER32" _
                Alias "GetWindowLongA" (ByVal hwnd As Long, _
                                        ByVal nIndex As Long) As Long

Private Declare Function SetWindowLong _
                Lib "USER32" _
                Alias "SetWindowLongA" (ByVal hwnd As Long, _
                                        ByVal nIndex As Long, _
                                        ByVal dwNewLong As Long) As Long

'constantes
Private Const GWL_EXSTYLE = (-20)

Private Const LWA_ALPHA = &H2

Private Const WS_EX_LAYERED = &H80000

' Función que recibe el handle de la ventana y el valor para aplciar la _
  Transparencia

Public Function Transparencia(ByVal hwnd As Long, valor As Integer) As Long

    On Local Error GoTo ErrSub

    Dim Estilo As Long

    If valor < 0 Or valor > 255 Then
        Transparencia = 1
    Else

        Estilo = GetWindowLong(hwnd, GWL_EXSTYLE)
        Estilo = Estilo Or WS_EX_LAYERED
    
        SetWindowLong hwnd, GWL_EXSTYLE, Estilo
    
        'Aplica el nuevo estilo con la transparencia
        SetLayeredWindowAttributes hwnd, 0, valor, LWA_ALPHA
        Transparencia = 0

    End If

    If Err Then
        Transparencia = 2

    End If

    Exit Function
    'Error
ErrSub:
    MsgBox Err.Description, vbCritical, "Error"

End Function

Private Sub Form_Load()
    Call Transparencia(Me.hwnd, 225)
    Musica = Val(GetVar(App.Path & "\recursos\Init\RevolucionAoInit.rao", "OPCIONES", "Musica"))
    Fx = Val(GetVar(App.Path & "\recursos\Init\RevolucionAoInit.rao", "OPCIONES", "FX"))
    Ambientales = Val(GetVar(App.Path & "\recursos\Init\RevolucionAoInit.rao", "OPCIONES", "ambientaleshabiltados"))

    If Musica = 1 Then
        Picture4.Picture = LoadPicture(App.Path & "\Recursos\Graficos\Interfaz\Botones\" & "chekeoOK.gif")
    Else
        Picture4.Picture = LoadPicture(App.Path & "\Recursos\Graficos\Interfaz\Botones\" & "chekeocancel.gif")

    End If

    If Fx = 1 Then
        Picture1.Picture = LoadPicture(App.Path & "\Recursos\Graficos\Interfaz\Botones\" & "chekeoOK.gif")
    Else
        Picture1.Picture = LoadPicture(App.Path & "\Recursos\Graficos\Interfaz\Botones\" & "chekeocancel.gif")

    End If

    If Ambientales = 1 Then
        Picture2.Picture = LoadPicture(App.Path & "\Recursos\Graficos\Interfaz\Botones\" & "chekeoOK.gif")
    Else
        Picture2.Picture = LoadPicture(App.Path & "\Recursos\Graficos\Interfaz\Botones\" & "chekeocancel.gif")

    End If

End Sub

Private Sub Picture1_Click()

    If Fx = 1 Then
        Fx = 0
        Picture1.Picture = LoadPicture(App.Path & "\Recursos\Graficos\Interfaz\Botones\" & "chekeocancel.gif")
        Call WriteVar(App.Path & "\recursos\Init\RevolucionAoInit.rao", "OPCIONES", "FX", 0)
    Else
        Fx = 1
        Picture1.Picture = LoadPicture(App.Path & "\Recursos\Graficos\Interfaz\Botones\" & "chekeoOK.gif")
        Call WriteVar(App.Path & "\recursos\Init\RevolucionAoInit.rao", "OPCIONES", "FX", 1)

    End If

End Sub

Private Sub Picture2_Click()

    If Ambientales = 1 Then
        Ambientales = 0
        Picture2.Picture = LoadPicture(App.Path & "\Recursos\Graficos\Interfaz\Botones\" & "chekeocancel.gif")
        Call WriteVar(App.Path & "\recursos\Init\RevolucionAoInit.rao", "OPCIONES", "ambientaleshabiltados", 0)
    Else
        Ambientales = 1

        If Fx = 0 Then
            Call MsgBox("Los sonidos ambientales solo sonaran si tiene activado los Efectos de sonido.", vbOKOnly)

        End If

        Picture2.Picture = LoadPicture(App.Path & "\Recursos\Graficos\Interfaz\Botones\" & "chekeoOK.gif")
        Call WriteVar(App.Path & "\recursos\Init\RevolucionAoInit.rao", "OPCIONES", "ambientaleshabiltados", 1)

    End If

End Sub

Private Sub Picture4_Click()

    If Musica = 1 Then
        Musica = 0
        Picture4.Picture = LoadPicture(App.Path & "\Recursos\Graficos\Interfaz\Botones\" & "chekeocancel.gif")
        Call WriteVar(App.Path & "\recursos\Init\RevolucionAoInit.rao", "OPCIONES", "Musica", 0)
    Else
        Musica = 1
        Picture4.Picture = LoadPicture(App.Path & "\Recursos\Graficos\Interfaz\Botones\" & "chekeoOK.gif")
        Call WriteVar(App.Path & "\recursos\Init\RevolucionAoInit.rao", "OPCIONES", "Musica", 1)

    End If

End Sub

Private Sub volver_Click()
    Unload Me

End Sub

Private Sub Form_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)

    If bmoving = False And Button = vbLeftButton Then

        DX = X

        dy = Y

        bmoving = True

    End If

End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)

    If bmoving And ((X <> DX) Or (Y <> dy)) Then

        Move Left + (X - DX), Top + (Y - dy)

    End If

End Sub

Private Sub Form_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)

    If Button = vbLeftButton Then

        bmoving = False

    End If

End Sub

