VERSION 5.00
Begin VB.Form NewAmb 
   Appearance      =   0  'Flat
   BackColor       =   &H00000000&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Agregar"
   ClientHeight    =   3375
   ClientLeft      =   6945
   ClientTop       =   4080
   ClientWidth     =   7200
   ControlBox      =   0   'False
   FillColor       =   &H0000FF00&
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3375
   ScaleWidth      =   7200
   ShowInTaskbar   =   0   'False
   Begin VB.PictureBox HDCx 
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      Height          =   2535
      Index           =   0
      Left            =   2760
      ScaleHeight     =   2535
      ScaleWidth      =   2895
      TabIndex        =   10
      Top             =   240
      Width           =   2895
      Begin VB.Image HDX 
         Height          =   135
         Index           =   0
         Left            =   120
         Top             =   120
         Width           =   135
      End
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Cancelar"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   1440
      TabIndex        =   9
      Top             =   2640
      Width           =   1095
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Agregar"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   240
      TabIndex        =   8
      Top             =   2640
      Width           =   1095
   End
   Begin VB.TextBox grhindex 
      BackColor       =   &H00004000&
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   240
      Locked          =   -1  'True
      TabIndex        =   6
      Text            =   "18"
      Top             =   2160
      Width           =   2295
   End
   Begin VB.ComboBox tipo 
      BackColor       =   &H00004000&
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   315
      ItemData        =   "NewAmb.frx":0000
      Left            =   240
      List            =   "NewAmb.frx":0010
      TabIndex        =   4
      Top             =   1560
      Width           =   2295
   End
   Begin VB.TextBox total 
      BackColor       =   &H00004000&
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   240
      Locked          =   -1  'True
      TabIndex        =   3
      Top             =   360
      Width           =   2295
   End
   Begin VB.TextBox nombre 
      BackColor       =   &H00004000&
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   240
      TabIndex        =   0
      Top             =   960
      Width           =   2295
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Grhindex:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   240
      TabIndex        =   7
      Top             =   1920
      Width           =   1095
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Tipo:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   240
      TabIndex        =   5
      Top             =   1320
      Width           =   1095
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "Cantidad:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   240
      TabIndex        =   2
      Top             =   120
      Width           =   855
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Nombre:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   240
      TabIndex        =   1
      Top             =   720
      Width           =   1095
   End
End
Attribute VB_Name = "NewAmb"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
Ambientaciones(AmbientacionesTotal).grhindex = grhindex.Text
Ambientaciones(AmbientacionesTotal).nombre = nombre.Text
Ambientaciones(AmbientacionesTotal).tipo = tipo.ListIndex + 1
Unload Me
End Sub

Private Sub Command2_Click()
AmbientacionesTotal = AmbientacionesTotal - 1
Unload Me
End Sub

Sub CargarImagen(ByVal Index As Integer, ByVal grhindex As Integer, ByVal Frame As Integer)
Dim ImagenX As String
    HDX(Index).Visible = False
    HDCx(Index).CurrentX = 0
    HDCx(Index).CurrentY = 0
    HDCx(Index).Visible = False
    HDX(Index).Left = 0
    HDX(Index).Top = 0
    If GrhData(grhindex).NumFrames <= 0 Or GrhData(grhindex).Frames(Frame) <= 0 Then Exit Sub
    If Frame > GrhData(grhindex).NumFrames Then Frame = GrhData(grhindex).NumFrames
    grhindex = GrhData(grhindex).Frames(Frame)
    ImagenX = DirClien & "\GRAFICOS\" & GrhData(grhindex).FileNum & ".png"
    Call ConvertFileImage(ImagenX, App.Path & "\temp\" & GrhData(grhindex).FileNum & ".jpg", 100)
    
    If LenB(Dir(ImagenX, vbArchive)) = 0 Then Exit Sub
    HDX(Index).Picture = LoadPicture(App.Path & "\temp\" & GrhData(grhindex).FileNum & ".jpg")
    HDCx(Index).Width = GrhData(grhindex).pixelWidth * 15
    HDCx(Index).Height = GrhData(grhindex).pixelHeight * 15
    HDX(Index).Left = HDX(Index).Left - GrhData(grhindex).sx * 15
    HDX(Index).Top = HDX(Index).Top - GrhData(grhindex).sy * 15
    HDCx(Index).Visible = True
    HDX(Index).Visible = True
    Kill App.Path & "\temp\" & GrhData(grhindex).FileNum & ".jpg"
End Sub




