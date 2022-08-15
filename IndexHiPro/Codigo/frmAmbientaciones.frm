VERSION 5.00
Begin VB.Form frmAmbientaciones 
   Appearance      =   0  'Flat
   BackColor       =   &H00000000&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Ambientaciones"
   ClientHeight    =   4095
   ClientLeft      =   11475
   ClientTop       =   5175
   ClientWidth     =   8475
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4095
   ScaleWidth      =   8475
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton Command1 
      Caption         =   "Cerrar"
      Height          =   495
      Left            =   3480
      TabIndex        =   13
      Top             =   3360
      Width           =   1575
   End
   Begin VB.PictureBox HDCx 
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      Height          =   2535
      Index           =   0
      Left            =   5640
      ScaleHeight     =   2535
      ScaleWidth      =   2895
      TabIndex        =   12
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
   Begin VB.TextBox Text1 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   4320
      Locked          =   -1  'True
      TabIndex        =   10
      Top             =   360
      Width           =   1095
   End
   Begin VB.TextBox total 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   3120
      Locked          =   -1  'True
      TabIndex        =   9
      Top             =   360
      Width           =   1095
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Guardar edicion"
      Height          =   495
      Left            =   3480
      TabIndex        =   7
      Top             =   2760
      Width           =   1575
   End
   Begin VB.ComboBox tipo 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   315
      ItemData        =   "frmAmbientaciones.frx":0000
      Left            =   3120
      List            =   "frmAmbientaciones.frx":0010
      TabIndex        =   5
      Top             =   1560
      Width           =   2295
   End
   Begin VB.TextBox grhindex 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   3120
      Locked          =   -1  'True
      TabIndex        =   3
      Top             =   2280
      Width           =   2295
   End
   Begin VB.TextBox nombre 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   3120
      TabIndex        =   1
      Top             =   960
      Width           =   2295
   End
   Begin VB.ListBox List1 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   3765
      Left            =   240
      TabIndex        =   0
      Top             =   120
      Width           =   2775
   End
   Begin VB.Label Label5 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Indice:"
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   4320
      TabIndex        =   11
      Top             =   120
      Width           =   1095
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "Cantidad total:"
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   3120
      TabIndex        =   8
      Top             =   120
      Width           =   1215
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Tipo:"
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   3120
      TabIndex        =   6
      Top             =   1320
      Width           =   1095
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Grhindex:"
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   3120
      TabIndex        =   4
      Top             =   1920
      Width           =   1095
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Nombre:"
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   3120
      TabIndex        =   2
      Top             =   720
      Width           =   1095
   End
   Begin VB.Menu menuamb 
      Caption         =   "menuamb"
      Visible         =   0   'False
      Begin VB.Menu Agregar 
         Caption         =   "Agregar"
      End
   End
End
Attribute VB_Name = "frmAmbientaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Agregar_Click()
On Error Resume Next
AmbientacionesTotal = AmbientacionesTotal + 1
NewAmb.grhindex = Form1.Listado.List(Form1.Listado.ListIndex)
NewAmb.total.Text = AmbientacionesTotal
NewAmb.Show
Call NewAmb.CargarImagen(0, NewAmb.grhindex, 1)

End Sub

Private Sub Command1_Click()
Unload Me
End Sub

Private Sub Command2_Click()
Ambientaciones(List1.ListIndex + 1).nombre = nombre.Text
Ambientaciones(List1.ListIndex + 1).grhindex = grhindex.Text
Ambientaciones(List1.ListIndex + 1).tipo = tipo.ListIndex + 1
End Sub
Sub CargarImagen(ByVal Index As Integer, ByVal grhindex As Long, ByVal Frame As Integer)
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
Private Sub Form_Load()
List1.Clear
Dim i As Integer
total.Text = AmbientacionesTotal

For i = 1 To AmbientacionesTotal
    List1.AddItem Ambientaciones(i).nombre
Next i
End Sub

Private Sub List1_Click()
nombre.Text = Ambientaciones(List1.ListIndex + 1).nombre
tipo.ListIndex = Ambientaciones(List1.ListIndex + 1).tipo - 1
grhindex.Text = Ambientaciones(List1.ListIndex + 1).grhindex
Text1.Text = List1.ListIndex + 1
Call CargarImagen(0, Ambientaciones(List1.ListIndex + 1).grhindex, 1)
End Sub

