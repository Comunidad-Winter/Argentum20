VERSION 5.00
Begin VB.Form frmOpciones 
   BorderStyle     =   0  'None
   Caption         =   "Form1"
   ClientHeight    =   5010
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4335
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   ScaleHeight     =   5010
   ScaleWidth      =   4335
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.Image cmdsalir 
      Height          =   375
      Left            =   3840
      Top             =   0
      Width           =   495
   End
   Begin VB.Image cmdaceptar 
      Height          =   495
      Left            =   1200
      Top             =   4320
      Width           =   1935
   End
   Begin VB.Image musicaCMD 
      Appearance      =   0  'Flat
      Height          =   255
      Left            =   570
      Top             =   1650
      Width           =   255
   End
   Begin VB.Image vsyncCmd 
      Height          =   255
      Left            =   570
      Top             =   3310
      Width           =   255
   End
   Begin VB.Label lbldlls 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Height          =   315
      Left            =   600
      TabIndex        =   0
      Top             =   3720
      Width           =   3045
   End
   Begin VB.Image PantallaCompletacmd 
      Height          =   255
      Left            =   570
      Top             =   2060
      Width           =   255
   End
   Begin VB.Image fxcmd 
      Appearance      =   0  'Flat
      Height          =   255
      Left            =   570
      Top             =   1230
      Width           =   255
   End
   Begin VB.Image punteroscmd 
      Height          =   255
      Left            =   570
      Top             =   2480
      Width           =   255
   End
   Begin VB.Image precargacmd 
      Height          =   255
      Left            =   570
      Top             =   2900
      Width           =   255
   End
End
Attribute VB_Name = "frmOpciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdaceptar_Click()
Unload Me
End Sub

Private Sub cmdsalir_Click()
Unload Me
End Sub

Private Sub Form_Load()
    Me.Picture = General_Load_Picture_From_Resource("launcher_configuracion.bmp")

    PantallaCompleta = Val(GetVar(ConfigFile, "VIDEO", "PantallaCompleta"))
    Precarga = Val(GetVar(ConfigFile, "VIDEO", "UtilizarPreCarga"))
    CursoresGraficos = Val(GetVar(ConfigFile, "VIDEO", "CursoresGraficos"))
    Vsync = Val(GetVar(ConfigFile, "VIDEO", "VSync"))
    
    
    'Sonido = Val(GetVar(ConfigFile, "AUDIO", "Sonido"))
    Fx = Val(GetVar(ConfigFile, "AUDIO", "Fx"))
    Musica = Val(GetVar(ConfigFile, "AUDIO", "Musica"))

    
    If Vsync = 1 Then
        frmOpciones.vsyncCmd.Picture = General_Load_Picture_From_Resource("check-amarillo.bmp")
    Else
        frmOpciones.vsyncCmd.Picture = Nothing
    End If
    
    
    If PantallaCompleta = 1 Then
        frmOpciones.PantallaCompletacmd.Picture = General_Load_Picture_From_Resource("check-amarillo.bmp")
    Else
        frmOpciones.PantallaCompletacmd.Picture = Nothing

    End If
    
    
    If Musica = 1 Then
        frmOpciones.musicaCMD.Picture = General_Load_Picture_From_Resource("check-amarillo.bmp")
    Else
        frmOpciones.musicaCMD.Picture = Nothing

    End If

    
    If Fx = 1 Then
        frmOpciones.fxcmd.Picture = General_Load_Picture_From_Resource("check-amarillo.bmp")
    Else
        frmOpciones.fxcmd.Picture = Nothing

    End If
    
    If Precarga = 1 Then
        frmOpciones.precargacmd.Picture = General_Load_Picture_From_Resource("check-amarillo.bmp")
    Else
        frmOpciones.precargacmd.Picture = Nothing

    End If
    
    If CursoresGraficos = 1 Then
        frmOpciones.punteroscmd.Picture = General_Load_Picture_From_Resource("check-amarillo.bmp")
    Else
        frmOpciones.punteroscmd.Picture = Nothing

    End If
End Sub

Private Sub lbldlls_Click()

Select Case MsgBox("¿Esta seguro que desea registrar las librerias necesarias?", vbYesNo + vbQuestion)

        Case vbYes
            Call ActualizarDlls
            MsgBox "Finalizado", vbInformation, "Registrar librerias"
            
        Case vbNo   'Boton NO.
            Exit Sub
    End Select
End Sub

Private Sub musicaCMD_Click()
    If Musica = 0 Then
        Musica = 1
        musicaCMD.Picture = General_Load_Picture_From_Resource("check-amarillo.bmp")
        Call WriteVar(ConfigFile, "AUDIO", "Sonido", CByte(1))
        Call WriteVar(ConfigFile, "AUDIO", "Musica", CByte(Musica))
    Else
        Musica = 0
        musicaCMD.Picture = Nothing
        Call WriteVar(ConfigFile, "AUDIO", "Musica", CByte(Musica))
    End If
End Sub

Private Sub PantallaCompletacmd_Click()

    If PantallaCompleta = 0 Then
        PantallaCompleta = 1
        PantallaCompletacmd.Picture = General_Load_Picture_From_Resource("check-amarillo.bmp")
        Call WriteVar(ConfigFile, "VIDEO", "PantallaCompleta", CByte(PantallaCompleta))
    Else
        PantallaCompleta = 0
        PantallaCompletacmd.Picture = Nothing
        Call WriteVar(ConfigFile, "VIDEO", "PantallaCompleta", CByte(PantallaCompleta))

    End If

End Sub

Private Sub fxcmd_Click()

    If Fx = 0 Then
        Fx = 1
        fxcmd.Picture = General_Load_Picture_From_Resource("check-amarillo.bmp")
        Call WriteVar(ConfigFile, "AUDIO", "Sonido", CByte(1))
        Call WriteVar(ConfigFile, "AUDIO", "Fx", CByte(Fx))
    Else
        Fx = 0
        fxcmd.Picture = Nothing
        Call WriteVar(ConfigFile, "AUDIO", "Fx", CByte(Fx))

    End If

End Sub

Private Sub punteroscmd_Click()

    If CursoresGraficos = 0 Then
        CursoresGraficos = 1
        punteroscmd.Picture = General_Load_Picture_From_Resource("check-amarillo.bmp")
        Call WriteVar(ConfigFile, "VIDEO", "CursoresGraficos", CByte(CursoresGraficos))
    Else
        CursoresGraficos = 0
        punteroscmd.Picture = Nothing
        Call WriteVar(ConfigFile, "VIDEO", "CursoresGraficos", CByte(CursoresGraficos))

    End If

End Sub

Private Sub precargacmd_Click()

    If Precarga = 0 Then
        Precarga = 1
        precargacmd.Picture = General_Load_Picture_From_Resource("check-amarillo.bmp")
        Call WriteVar(ConfigFile, "VIDEO", "UtilizarPreCarga", CByte(Precarga))
    Else
        Precarga = 0
        precargacmd.Picture = Nothing
        Call WriteVar(ConfigFile, "VIDEO", "UtilizarPreCarga", CByte(Precarga))

    End If

End Sub

Private Sub vsyncCmd_Click()
    If Vsync = 0 Then
        Vsync = 1
        vsyncCmd.Picture = General_Load_Picture_From_Resource("check-amarillo.bmp")
        Call WriteVar(ConfigFile, "VIDEO", "VSync", CByte(Vsync))
    Else
        Vsync = 0
        vsyncCmd.Picture = Nothing
        Call WriteVar(ConfigFile, "VIDEO", "VSync", CByte(Vsync))

    End If
End Sub
