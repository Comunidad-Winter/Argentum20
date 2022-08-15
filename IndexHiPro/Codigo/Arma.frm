VERSION 5.00
Begin VB.Form Arma 
   BackColor       =   &H00000000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "[ARMAS]"
   ClientHeight    =   5745
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5895
   Icon            =   "Arma.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   ScaleHeight     =   5745
   ScaleWidth      =   5895
   StartUpPosition =   2  'CenterScreen
   Begin VB.Timer Anim 
      Interval        =   140
      Left            =   4080
      Top             =   3120
   End
   Begin VB.ListBox Listado 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   3960
      Left            =   120
      TabIndex        =   13
      Top             =   225
      Width           =   1815
   End
   Begin VB.PictureBox HD 
      BackColor       =   &H00000000&
      ForeColor       =   &H0000FF00&
      Height          =   1935
      Index           =   0
      Left            =   2040
      ScaleHeight     =   1875
      ScaleWidth      =   1755
      TabIndex        =   10
      Top             =   240
      Width           =   1815
      Begin VB.PictureBox HDCx 
         BackColor       =   &H00000000&
         BorderStyle     =   0  'None
         Height          =   2535
         Index           =   0
         Left            =   120
         ScaleHeight     =   2535
         ScaleWidth      =   2895
         TabIndex        =   11
         Top             =   120
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
      TabIndex        =   7
      Top             =   2280
      Width           =   1815
      Begin VB.PictureBox HDCx 
         BackColor       =   &H00000000&
         BorderStyle     =   0  'None
         Height          =   2535
         Index           =   1
         Left            =   120
         ScaleHeight     =   2535
         ScaleWidth      =   2895
         TabIndex        =   8
         Top             =   120
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
         TabIndex        =   9
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
      TabIndex        =   4
      Top             =   2280
      Width           =   1815
      Begin VB.PictureBox HDCx 
         BackColor       =   &H00000000&
         BorderStyle     =   0  'None
         Height          =   2535
         Index           =   2
         Left            =   120
         ScaleHeight     =   2535
         ScaleWidth      =   2895
         TabIndex        =   5
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
         TabIndex        =   6
         Top             =   0
         Width           =   615
      End
   End
   Begin VB.PictureBox HD 
      BackColor       =   &H00000000&
      ForeColor       =   &H0000FF00&
      Height          =   1935
      Index           =   3
      Left            =   3960
      ScaleHeight     =   1875
      ScaleWidth      =   1755
      TabIndex        =   1
      Top             =   240
      Width           =   1815
      Begin VB.PictureBox HDCx 
         BackColor       =   &H00000000&
         BorderStyle     =   0  'None
         Height          =   2535
         Index           =   3
         Left            =   120
         ScaleHeight     =   2535
         ScaleWidth      =   2895
         TabIndex        =   2
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
         TabIndex        =   3
         Top             =   0
         Width           =   615
      End
   End
   Begin VB.TextBox GRHt 
      BackColor       =   &H00004000&
      ForeColor       =   &H0000FF00&
      Height          =   1290
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   0
      Top             =   4320
      Width           =   5655
   End
End
Attribute VB_Name = "Arma"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim Selecc As Long
Dim Paso(1 To 4) As Integer
Dim Frames(1 To 4) As Integer


Private Sub Anim_Timer()
On Error Resume Next
Dim i As Integer, Gr As Long
Dim ImagenX As String
'Exit Sub
If Selecc <= 0 Or Selecc > NumWeaponAnims Then Exit Sub
For i = 1 To 4
    Frames(i) = Frames(i) + 1
    Gr = WeaponAnimData(Listado.Text).WeaponWalk(i).grhindex
    If GrhData(Gr).NumFrames < Frames(i) Then Frames(i) = 1
    Call CargarImagen(i - 1, Gr, Frames(i))
    Paso(i) = Paso(i) + 1
    If Paso(i) > 3 Then Paso(i) = 1
Next
End Sub

Private Sub Form_Load()
Dim i As Integer
'Paso = 0
Selecc = 0
Me.Icon = Form1.Icon
Me.Caption = Form1.Caption & " [ARMAS]"
Listado.Clear
For i = 1 To NumWeaponAnims
    If WeaponAnimData(i).WeaponWalk(1).grhindex > 0 Then
        Listado.AddItem i
    End If
Next
End Sub

Private Sub Listado_Click()
Dim i As Integer, Gr As Long
Dim ImagenX As String
GRHt.Text = "[Arma" & Listado.Text & "]" & vbCrLf & vbCrLf
Selecc = Listado.Text
For i = 0 To 3
    Frames(i + 1) = 1
    Paso(i + 1) = 1
    Gr = WeaponAnimData(Listado.Text).WeaponWalk(i + 1).grhindex
    HX(i).Caption = Gr
    GRHt.Text = GRHt.Text & "Dir" & i + 1 & "=" & Gr & vbCrLf
    Call CargarImagen(i, Gr, 1)
Next
GRHt.Text = Left(GRHt.Text, Len(GRHt.Text) - 2)
End Sub

Sub CargarImagen(ByVal Index As Integer, ByVal grhindex As Long, ByVal Frame As Integer)
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
    
    Call ConvertFileImage(ImagenX, App.Path & "\temp\" & FileName & ".jpg", 100)
    
    If LenB(Dir(ImagenX, vbArchive)) = 0 Then Exit Sub
    HDX(Index).Picture = LoadPicture(App.Path & "\temp\" & FileName & ".jpg")
    HDCx(Index).Width = GrhData(grhindex).pixelWidth * 15
    HDCx(Index).Height = GrhData(grhindex).pixelHeight * 15
    HDX(Index).Left = HDX(Index).Left - GrhData(grhindex).sx * 15
    HDX(Index).Top = HDX(Index).Top - GrhData(grhindex).sy * 15
    HDCx(Index).Visible = True
    HDX(Index).Visible = True
    Kill App.Path & "\temp\" & FileName & ".jpg"
End Sub
