VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form frmMain 
   BackColor       =   &H00E0E0E0&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Editor de Auras  - Revolucion-Ao - Ladder"
   ClientHeight    =   7080
   ClientLeft      =   4905
   ClientTop       =   2385
   ClientWidth     =   6810
   ClipControls    =   0   'False
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ForeColor       =   &H00000000&
   Icon            =   "frmMain.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   472
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   454
   StartUpPosition =   2  'CenterScreen
   Visible         =   0   'False
   Begin VB.TextBox fin 
      Height          =   285
      Left            =   1560
      TabIndex        =   19
      Top             =   4320
      Width           =   2535
   End
   Begin VB.Frame frameColorSettings 
      BorderStyle     =   0  'None
      Caption         =   "Color Tint Settings"
      Height          =   2175
      Left            =   0
      TabIndex        =   5
      Top             =   4800
      Width           =   4455
      Begin VB.CheckBox Check1 
         Caption         =   "Body"
         Height          =   195
         Left            =   3480
         TabIndex        =   22
         Top             =   1680
         Width           =   855
      End
      Begin VB.CommandButton Generar 
         Caption         =   "Generar"
         Height          =   855
         Left            =   2760
         TabIndex        =   20
         Top             =   240
         Width           =   1455
      End
      Begin VB.TextBox txtB 
         Alignment       =   1  'Right Justify
         Height          =   285
         Left            =   2880
         Locked          =   -1  'True
         MaxLength       =   4
         TabIndex        =   12
         Text            =   "0"
         Top             =   1200
         Width           =   375
      End
      Begin VB.TextBox txtG 
         Alignment       =   1  'Right Justify
         Height          =   285
         Left            =   2880
         Locked          =   -1  'True
         MaxLength       =   4
         TabIndex        =   11
         Text            =   "0"
         Top             =   1520
         Width           =   375
      End
      Begin VB.TextBox txtR 
         Alignment       =   1  'Right Justify
         Height          =   285
         Left            =   2880
         Locked          =   -1  'True
         MaxLength       =   4
         TabIndex        =   10
         Text            =   "0"
         Top             =   1800
         Width           =   375
      End
      Begin VB.PictureBox picColor 
         BackColor       =   &H00000000&
         Height          =   855
         Left            =   240
         ScaleHeight     =   795
         ScaleWidth      =   2355
         TabIndex        =   9
         Top             =   240
         Width           =   2415
      End
      Begin VB.HScrollBar BScroll 
         Height          =   255
         Left            =   360
         Max             =   255
         TabIndex        =   8
         Top             =   1200
         Width           =   2415
      End
      Begin VB.HScrollBar GScroll 
         Height          =   255
         Left            =   360
         Max             =   255
         TabIndex        =   7
         Top             =   1500
         Width           =   2415
      End
      Begin VB.HScrollBar RScroll 
         Height          =   255
         Left            =   360
         Max             =   255
         TabIndex        =   6
         Top             =   1800
         Width           =   2415
      End
      Begin VB.Label Label23 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "B:"
         Height          =   195
         Left            =   120
         TabIndex        =   15
         Top             =   1800
         Width           =   150
      End
      Begin VB.Label Label26 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "G:"
         Height          =   195
         Left            =   120
         TabIndex        =   14
         Top             =   1500
         Width           =   165
      End
      Begin VB.Label Label27 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "R:"
         Height          =   195
         Left            =   120
         TabIndex        =   13
         Top             =   1200
         Width           =   165
      End
   End
   Begin VB.Frame frameGrhs 
      Caption         =   "Parametros de graficos"
      Height          =   6675
      Left            =   4560
      TabIndex        =   1
      Top             =   240
      Width           =   2130
      Begin VB.PictureBox picPreview 
         Appearance      =   0  'Flat
         BackColor       =   &H00000000&
         BorderStyle     =   0  'None
         ForeColor       =   &H80000008&
         Height          =   1905
         Left            =   120
         ScaleHeight     =   131.097
         ScaleMode       =   0  'User
         ScaleWidth      =   120
         TabIndex        =   18
         Top             =   4560
         Width           =   1800
      End
      Begin VB.ListBox lstGrhs 
         Height          =   3765
         Left            =   45
         TabIndex        =   2
         Top             =   450
         Width           =   1860
      End
      Begin VB.Label Label20 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Lista de graficos"
         Height          =   195
         Left            =   60
         TabIndex        =   4
         Top             =   255
         Width           =   1170
      End
      Begin VB.Label Label28 
         Caption         =   "Vista Previa"
         Height          =   225
         Left            =   120
         TabIndex        =   3
         Top             =   4320
         Width           =   1275
      End
   End
   Begin VB.Timer SpoofCheck 
      Interval        =   1000
      Left            =   6120
      Top             =   240
   End
   Begin VB.PictureBox renderer 
      Appearance      =   0  'Flat
      BackColor       =   &H00000000&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   3975
      Left            =   120
      ScaleHeight     =   265
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   281
      TabIndex        =   0
      Top             =   120
      Width           =   4215
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   0
      Top             =   0
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Generado:"
      Height          =   375
      Left            =   720
      TabIndex        =   21
      Top             =   4320
      Width           =   1215
   End
   Begin VB.Label Label34 
      BackColor       =   &H00E0E0E0&
      Caption         =   "FPS:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   4560
      TabIndex        =   17
      Top             =   0
      Width           =   495
   End
   Begin VB.Label Label35 
      BackColor       =   &H00E0E0E0&
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   255
      Left            =   5160
      TabIndex        =   16
      Top             =   0
      Width           =   1215
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public tX As Byte
Public tY As Byte
Public MouseX As Long
Public MouseY As Long
Public MouseBoton As Long
Public MouseShift As Long
Private clicX As Long
Private clicY As Long

Public IsPlaying As Byte

Dim PuedeMacrear As Boolean


Private Sub BScroll_Change()
On Error Resume Next
DataChanged = True

AuraData(1).color.r = BScroll.value
txtB.Text = BScroll.value




picColor.BackColor = RGB(txtB.Text, txtG.Text, txtR.Text)


End Sub

Private Sub cmdNewParticle_Click()

End Sub

Private Sub Command1_Click()
lstGrhs.ListIndex = 19975

End Sub

Private Sub Command2_Click()


lstGrhs.ListIndex = 35390

End Sub

Private Sub Check1_Click()
body = Not body
End Sub

Private Sub Form_Unload(Cancel As Integer)
prgRun = False
End Sub

Private Sub Generar_Click()
Dim c     As Long
  
  Dim r   As Integer ' Red component value   (0 to 255)
  Dim g   As Integer ' Green component value (0 to 255)
  Dim b   As Integer ' Blue component value  (0 to 255)
  
  Dim Out As String  ' Function output string
    
' Setup the color selection palette dialog.

  
' Set initial flags to open the full palette and allow an
' initial default color selection.

      
  c = RGB(AuraData(1).color.r, AuraData(1).color.g, AuraData(1).color.b)
      

  
                      
  
  r = c And 255              ' Get lowest 8 bits  - Red
  g = Int(c / 256) And 255   ' Get middle 8 bits  - Green
  b = Int(c / 65536) And 255 ' Get highest 8 bits - Blue
  
' If H mode is selected, replace default with hex RGB values.
     Out = "&H" & format(Hex(r), "0#") _
     & format(Hex(g), "0#") _
      & format(Hex(b), "0#")
     'Form1.picture1.BackColor = RGB(r, g, b)
'Label3.ForeColor = RGB(r, g, b)

AuraData(1).colorlng = Out


fin.Text = "CreaGRH=" & AuraData(1).aura & ":" & AuraData(1).colorlng & ":0:248"


Clipboard.SetText fin.Text
End Sub

Private Sub GScroll_Change()
On Error Resume Next
DataChanged = True


AuraData(1).color.g = GScroll.value
txtG.Text = GScroll.value

picColor.BackColor = RGB(txtB.Text, txtG.Text, txtR.Text)




End Sub

Private Sub lstGrhs_Click()
picPreview.Refresh
On Error Resume Next
Call Grh_Render_To_Hdc(picPreview, (lstGrhs.List(lstGrhs.ListIndex)), 0, 0)
AuraData(1).aura = lstGrhs.List(lstGrhs.ListIndex)


Call Generar_Click
End Sub



Private Sub picColor_Click()


  Dim c     As Long
  
  Dim r   As Integer ' Red component value   (0 to 255)
  Dim g   As Integer ' Green component value (0 to 255)
  Dim b   As Integer ' Blue component value  (0 to 255)
  
  Dim Out As String  ' Function output string
    
' Setup the color selection palette dialog.
  With frmMain.CommonDialog1
  
' Set initial flags to open the full palette and allow an
' initial default color selection.
  .flags = cdlCCFullOpen + cdlCCRGBInit
      
  .color = RGB(255, 255, 255)
      
' Display the full color palette
  .ShowColor
  c = .color
                      
  End With
  r = c And 255              ' Get lowest 8 bits  - Red
  g = Int(c / 256) And 255   ' Get middle 8 bits  - Green
  b = Int(c / 65536) And 255 ' Get highest 8 bits - Blue
  
' If H mode is selected, replace default with hex RGB values.
     Out = "&H" & format(Hex(r), "0#") _
     & format(Hex(g), "0#") _
      & format(Hex(b), "0#")
    picColor.BackColor = RGB(r, g, b)
'Label3.ForeColor = RGB(r, g, b)

txtB.Text = r
txtG.Text = g
txtR.Text = b
  'Selected_Color = Out

AuraData(1).colorlng = Out

AuraData(1).color.b = r
AuraData(1).color.g = g
AuraData(1).color.r = b


BScroll.value = r
GScroll.value = g
RScroll.value = b

'fin.Text = "CreaGRH=" & AuraData(1).aura & ":" & AuraData(1).colorlng & ":0:248"
End Sub

Private Sub RScroll_Change()
On Error Resume Next
DataChanged = True


AuraData(1).color.b = RScroll.value
txtR.Text = RScroll.value

picColor.BackColor = RGB(txtB.Text, txtG.Text, txtR.Text)
End Sub
Private Sub SpoofCheck_Timer()
If engine.bRunning Then engine.Engine_ActFPS
End Sub



