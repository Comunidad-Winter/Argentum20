VERSION 5.00
Begin VB.Form Cuerpo 
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "[CUERPOS]"
   ClientHeight    =   6690
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5895
   Icon            =   "Bodys.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   ScaleHeight     =   6690
   ScaleWidth      =   5895
   StartUpPosition =   2  'CenterScreen
   Begin VB.TextBox HeadY 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   3240
      Locked          =   -1  'True
      TabIndex        =   16
      Top             =   600
      Width           =   615
   End
   Begin VB.TextBox HeadX 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   285
      Left            =   3240
      Locked          =   -1  'True
      TabIndex        =   14
      Top             =   240
      Width           =   615
   End
   Begin VB.Timer Anim 
      Interval        =   140
      Left            =   4320
      Top             =   240
   End
   Begin VB.TextBox GRHt 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   930
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   9
      Top             =   5400
      Width           =   5655
   End
   Begin VB.PictureBox HD 
      BackColor       =   &H00000000&
      ForeColor       =   &H0000FF00&
      Height          =   1935
      Index           =   3
      Left            =   3960
      ScaleHeight     =   1875
      ScaleWidth      =   1755
      TabIndex        =   7
      Top             =   1200
      Width           =   1815
      Begin VB.PictureBox HDCx 
         BackColor       =   &H00000000&
         BorderStyle     =   0  'None
         Height          =   2535
         Index           =   3
         Left            =   120
         ScaleHeight     =   2535
         ScaleWidth      =   2895
         TabIndex        =   8
         Top             =   120
         Width           =   2895
         Begin VB.Image HDX 
            Height          =   135
            Index           =   3
            Left            =   120
            Top             =   0
            Width           =   135
         End
      End
      Begin VB.Label HX 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   6
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H0000FF00&
         Height          =   255
         Index           =   3
         Left            =   120
         TabIndex        =   13
         Top             =   0
         Width           =   615
      End
   End
   Begin VB.PictureBox HD 
      BackColor       =   &H00000000&
      ForeColor       =   &H0000FF00&
      Height          =   1935
      Index           =   2
      Left            =   2040
      ScaleHeight     =   1875
      ScaleWidth      =   1755
      TabIndex        =   5
      Top             =   3360
      Width           =   1815
      Begin VB.PictureBox HDCx 
         BackColor       =   &H00000000&
         BorderStyle     =   0  'None
         Height          =   2535
         Index           =   2
         Left            =   120
         ScaleHeight     =   2535
         ScaleWidth      =   2895
         TabIndex        =   6
         Top             =   120
         Width           =   2895
         Begin VB.Image HDX 
            Height          =   135
            Index           =   2
            Left            =   120
            Top             =   120
            Width           =   135
         End
      End
      Begin VB.Label HX 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   6
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H0000FF00&
         Height          =   255
         Index           =   2
         Left            =   0
         TabIndex        =   12
         Top             =   0
         Width           =   615
      End
   End
   Begin VB.PictureBox HD 
      BackColor       =   &H00000000&
      ForeColor       =   &H0000FF00&
      Height          =   1935
      Index           =   1
      Left            =   3960
      ScaleHeight     =   1875
      ScaleWidth      =   1755
      TabIndex        =   3
      Top             =   3360
      Width           =   1815
      Begin VB.PictureBox HDCx 
         BackColor       =   &H00000000&
         BorderStyle     =   0  'None
         Height          =   2535
         Index           =   1
         Left            =   120
         ScaleHeight     =   2535
         ScaleWidth      =   2895
         TabIndex        =   4
         Top             =   240
         Width           =   2895
         Begin VB.Image HDX 
            Height          =   135
            Index           =   1
            Left            =   120
            Top             =   120
            Width           =   135
         End
      End
      Begin VB.Label HX 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   6
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H0000FF00&
         Height          =   255
         Index           =   1
         Left            =   0
         TabIndex        =   11
         Top             =   120
         Width           =   615
      End
   End
   Begin VB.PictureBox HD 
      BackColor       =   &H00000000&
      ForeColor       =   &H0000FF00&
      Height          =   1935
      Index           =   0
      Left            =   2040
      ScaleHeight     =   1875
      ScaleWidth      =   1755
      TabIndex        =   1
      Top             =   1200
      Width           =   1815
      Begin VB.PictureBox HDCx 
         BackColor       =   &H00000000&
         BorderStyle     =   0  'None
         Height          =   2535
         Index           =   0
         Left            =   120
         ScaleHeight     =   2535
         ScaleWidth      =   2895
         TabIndex        =   2
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
      Begin VB.Label HX 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   6
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H0000FF00&
         Height          =   255
         Index           =   0
         Left            =   0
         TabIndex        =   10
         Top             =   120
         Width           =   615
      End
   End
   Begin VB.ListBox Listado 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   4935
      Left            =   120
      TabIndex        =   0
      Top             =   285
      Width           =   1815
   End
   Begin VB.Label Label6 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Derecha"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Left            =   4080
      TabIndex        =   21
      Top             =   3120
      Width           =   1695
   End
   Begin VB.Label Label5 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Abajo"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Left            =   2040
      TabIndex        =   20
      Top             =   3120
      Width           =   1815
   End
   Begin VB.Label Label4 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Izquierda"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Left            =   4080
      TabIndex        =   19
      Top             =   960
      Width           =   1575
   End
   Begin VB.Label Label3 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Arriba"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Left            =   2160
      TabIndex        =   18
      Top             =   960
      Width           =   1695
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Head Offset Y"
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   2040
      TabIndex        =   17
      Top             =   600
      Width           =   1095
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Head Offset X"
      ForeColor       =   &H0000FF00&
      Height          =   255
      Left            =   2040
      TabIndex        =   15
      Top             =   240
      Width           =   1095
   End
End
Attribute VB_Name = "Cuerpo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim Selecc As Integer
Dim Paso(1 To 4) As Integer
Dim Frames(1 To 4) As Integer

Private Sub Anim_Timer()
On Error Resume Next
Dim i As Integer, Gr As Long
Dim ImagenX As String
'Exit Sub
If Selecc <= 0 Or Selecc > NumCuerpos Then Exit Sub
For i = 1 To 4
    Frames(i) = Frames(i) + 1
    Gr = BodyData(Listado.Text).Walk(i).grhindex
    If GrhData(Gr).NumFrames < Frames(i) Then Frames(i) = 1
    Call CargarImagen(i - 1, Gr, Frames(i))
    Paso(i) = Paso(i) + 1
    If Paso(i) > 4 Then Paso(i) = 1
Next
End Sub

Private Sub Form_Load()
Dim i As Long
Selecc = 0
Me.Icon = Form1.Icon
Me.Caption = Form1.Caption & " [CUERPOS]"
Listado.Clear
For i = 1 To NumCuerpos
    If BodyData(i).Walk(1).grhindex > 0 Then
        Listado.AddItem i
    End If
Next
End Sub

Private Sub Listado_Click()
Dim i As Integer, Gr As Long
Dim ImagenX As String
GRHt.Text = "[BODY" & Listado.Text & "]" & vbCrLf & vbCrLf
'Img.Visible = False
Selecc = Listado.Text
For i = 0 To 3
    Frames(i + 1) = 1
    Paso(i + 1) = 1
    Gr = BodyData(Listado.Text).Walk(i + 1).grhindex
    HeadX = BodyData(Listado.Text).HeadOffset.X
    HeadY = BodyData(Listado.Text).HeadOffset.Y
    HX(i).Caption = Gr
    GRHt.Text = GRHt.Text & "WALK" & (i + 1) & "=" & Gr & vbCrLf
    Call CargarImagen(i, Gr, 1)
Next
GRHt.Text = GRHt.Text & "HeadOffsetX=" & HeadX & vbCrLf & "HeadOffsetY=" & HeadY
End Sub

Sub CargarImagen(ByVal Index As Integer, ByVal grhindex As Long, ByVal Frame As Integer)
On Error Resume Next
    HDX(Index).Visible = False
    HDX(Index).Left = 0
    HDX(Index).Top = 0
    HDCx(Index).Visible = False
    HDCx(Index).CurrentX = 0
    HDCx(Index).CurrentY = 0
    If GrhData(grhindex).NumFrames <= 0 Or GrhData(grhindex).Frames(Frame) <= 0 Then Exit Sub
    If Frame > GrhData(grhindex).NumFrames Then Frame = GrhData(grhindex).NumFrames
    grhindex = GrhData(grhindex).Frames(Frame)
    ImagenX = DirClien & "\GRAFICOS\" & GrhData(grhindex).FileNum & ".png"
    Call ConvertFileImage(ImagenX, App.Path & "\temp\" & FileName & ".jpg", 100)
    HDX(Index).Picture = LoadPicture(App.Path & "\temp\" & FileName & ".jpg")
    HDX(Index).Tag = ImagenX
    HDCx(Index).Width = GrhData(grhindex).pixelWidth * 15
    HDCx(Index).Height = GrhData(grhindex).pixelHeight * 15
    HDX(Index).Left = HDX(Index).Left - GrhData(grhindex).sx * 15
    HDX(Index).Top = HDX(Index).Top - GrhData(grhindex).sy * 15
    HDCx(Index).Visible = True
    HDX(Index).Visible = True
    Kill App.Path & "\temp\" & FileName & ".jpg"
End Sub
