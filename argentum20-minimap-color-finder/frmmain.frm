VERSION 5.00
Begin VB.Form frmMain 
   AutoRedraw      =   -1  'True
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "AO Minimap Color Finder"
   ClientHeight    =   5040
   ClientLeft      =   45
   ClientTop       =   450
   ClientWidth     =   3075
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmmain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   336
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   205
   StartUpPosition =   2  'CenterScreen
   Begin VB.PictureBox Picture2 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      DragMode        =   1  'Automatic
      FillStyle       =   0  'Solid
      ForeColor       =   &H80000008&
      Height          =   480
      Left            =   2370
      ScaleHeight     =   480
      ScaleWidth      =   585
      TabIndex        =   4
      Top             =   4440
      Width           =   585
   End
   Begin VB.PictureBox Picture1 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      DragMode        =   1  'Automatic
      FillStyle       =   0  'Solid
      ForeColor       =   &H80000008&
      Height          =   2880
      Left            =   90
      ScaleHeight     =   2880
      ScaleWidth      =   2880
      TabIndex        =   3
      Top             =   1470
      Width           =   2880
   End
   Begin VB.CommandButton Command1 
      BackColor       =   &H00C0FFC0&
      Caption         =   "Comenzar!"
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   2
      Top             =   720
      Width           =   2895
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Cargar gráficos"
      Height          =   525
      Left            =   90
      Style           =   1  'Graphical
      TabIndex        =   1
      Top             =   120
      Width           =   2895
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Color Promedio"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   11.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   270
      Left            =   240
      TabIndex        =   5
      Top             =   4530
      Width           =   1665
   End
   Begin VB.Label lblstatus 
      Alignment       =   2  'Center
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      BackStyle       =   0  'Transparent
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Graficos.ind cargado!"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   195
      Left            =   90
      TabIndex        =   0
      Top             =   1200
      Visible         =   0   'False
      Width           =   2880
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H0080FFFF&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   150
      Left            =   120
      Top             =   1230
      Width           =   15
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
    
Dim i As Long
    
    If frmMain.lblstatus.Visible = False Then Exit Sub
    
    Command1.Enabled = False
    
    If File_Exists(App.Path & "\..\recursos\INIT\Minimap.bin", vbNormal) Then Kill App.Path & "\..\recursos\INIT\minimap.bin"
    
    Shape1.Width = 0
    
    Open App.Path & "\..\recursos\INIT\MiniMap.bin" For Binary Access Write As #1
    
        Seek #1, 1
        
        For i = 1 To grhCount
            If GrhData(i).Active = True Then
                Picture1.Cls
                Picture2.Cls
                lblstatus.Caption = "Cargando grafico " & i & "/" & grhCount
                Shape1.Width = ((i / 100) / (grhCount / 100)) * 189
                Put #1, , Grh_GetColor(i)
            End If
            DoEvents
        Next i
        
    Close #1
    
    Kill App.Path & "\temp\*.*"
    
    lblstatus = "Finalizado!"
    
    MsgBox "Finalizado!"
    
    Unload Me
    
End Sub

Private Sub Command2_Click()
    Call LoadGrh
    Command2.Enabled = False
End Sub

Private Sub Form_Unload(Cancel As Integer)
End
End Sub
