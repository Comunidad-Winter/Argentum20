VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.2#0"; "MSCOMCTL.OCX"
Begin VB.Form frmBinary 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "ORE Compressor"
   ClientHeight    =   3240
   ClientLeft      =   2325
   ClientTop       =   1500
   ClientWidth     =   4560
   Icon            =   "frmBinary.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3240
   ScaleWidth      =   4560
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton SavePass 
      Caption         =   "Guardar"
      Height          =   255
      Left            =   3720
      TabIndex        =   16
      Top             =   1560
      Width           =   735
   End
   Begin VB.CommandButton ReadPass 
      Caption         =   "Leer"
      Height          =   255
      Left            =   3240
      TabIndex        =   15
      Top             =   1560
      Width           =   495
   End
   Begin VB.CommandButton RandomPass 
      Caption         =   "Random"
      Height          =   255
      Left            =   2505
      TabIndex        =   14
      Top             =   1560
      Width           =   750
   End
   Begin VB.TextBox Password 
      Alignment       =   2  'Center
      Height          =   285
      Left            =   120
      TabIndex        =   12
      Text            =   "Contraseña"
      Top             =   1560
      Width           =   2295
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Extraer uno"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   3000
      TabIndex        =   11
      Top             =   1920
      Width           =   1455
   End
   Begin VB.Frame Frame1 
      Caption         =   "Tipo de archivo"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1335
      Left            =   120
      TabIndex        =   2
      Top             =   120
      Width           =   4335
      Begin VB.OptionButton Option1 
         Caption         =   "MiniMapas"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   5
         Left            =   1560
         TabIndex        =   13
         Top             =   960
         Width           =   1215
      End
      Begin VB.OptionButton Option1 
         Caption         =   "Mapas"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   7
         Left            =   2760
         TabIndex        =   10
         Top             =   600
         Width           =   1215
      End
      Begin VB.OptionButton Option1 
         Caption         =   "Interface"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   6
         Left            =   2760
         TabIndex        =   9
         Top             =   240
         Width           =   1215
      End
      Begin VB.OptionButton Option1 
         Caption         =   "Patch"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   8
         Left            =   2760
         TabIndex        =   8
         Top             =   960
         Width           =   1215
      End
      Begin VB.OptionButton Option1 
         Caption         =   "Inits"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   4
         Left            =   1560
         TabIndex        =   7
         Top             =   600
         Width           =   1215
      End
      Begin VB.OptionButton Option1 
         Caption         =   "Wav"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   3
         Left            =   1560
         TabIndex        =   6
         Top             =   240
         Width           =   1215
      End
      Begin VB.OptionButton Option1 
         Caption         =   "MP3"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   2
         Left            =   240
         TabIndex        =   5
         Top             =   960
         Width           =   1215
      End
      Begin VB.OptionButton Option1 
         Caption         =   "MIDI"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   1
         Left            =   240
         TabIndex        =   4
         Top             =   600
         Width           =   1215
      End
      Begin VB.OptionButton Option1 
         Caption         =   "Graficos"
         BeginProperty Font 
            Name            =   "Tahoma"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   0
         Left            =   240
         TabIndex        =   3
         Top             =   240
         Value           =   -1  'True
         Width           =   1215
      End
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Extraer"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   1560
      TabIndex        =   1
      Top             =   1920
      Width           =   1335
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Comprimir"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   120
      TabIndex        =   0
      Top             =   1920
      Width           =   1335
   End
   Begin MSComctlLib.ProgressBar ProgressBar1 
      Height          =   375
      Left            =   120
      TabIndex        =   17
      Top             =   2760
      Width           =   4320
      _ExtentX        =   7620
      _ExtentY        =   661
      _Version        =   393216
      Appearance      =   1
      Scrolling       =   1
   End
   Begin VB.Label lblComprimiendo 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Comprimiendo..."
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   1560
      TabIndex        =   18
      Top             =   2400
      Width           =   1530
   End
End
Attribute VB_Name = "frmBinary"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim File_Type_Index As Byte

Public Passwd As String

' Paths
Private INPUT_PATH As String
Public OUTPUT_PATH As String

Sub Form_Load()
    ' Paths
    INPUT_PATH = App.Path & "\..\Recursos"
    OUTPUT_PATH = INPUT_PATH & "\OUTPUT\"
    
    ' Leer argumentos
    Call LeerLineaComandos
    
    Call BarraProgreso(False)
End Sub

Private Sub Command1_Click()
    Call BarraProgreso(True)
    
    lblComprimiendo.Caption = "Comprimiendo..."
    
    Call Compress_Files(File_Type_Index, INPUT_PATH, OUTPUT_PATH, Passwd)
    
    Call BarraProgreso(False)
End Sub

Private Sub Command2_Click()
    Call BarraProgreso(True)
    
    lblComprimiendo.Caption = "Descomprimiendo..."
    
    If File_Type_Index <> Patch Then
        Call Extract_All_Files(File_Type_Index, INPUT_PATH, Passwd, True)
    Else
        Call Extract_Patch(OUTPUT_PATH, OUTPUT_PATH & "Patch.rao", Passwd)
    End If
    
    Call BarraProgreso(False)
End Sub

Private Sub Command3_Click()
    Dim tmp As String: tmp = InputBox("Ingrese el nombre del archivo a extraer")
    Call Extract_File(File_Type_Index, App.Path & "\output", tmp, App.Path & "\output\", Passwd, False)
End Sub

Private Sub Option1_Click(Index As Integer)
    File_Type_Index = Index
End Sub

Function ReadField(ByVal Pos As Integer, ByRef Text As String, ByVal SepASCII As Byte) As String
'*****************************************************************
'Gets a field from a delimited string
'Author: Juan Mart?n Sotuyo Dodero (Maraxus)
'Last Modify Date: 11/15/2004
'*****************************************************************
    Dim i As Long
    Dim LastPos As Long
    Dim CurrentPos As Long
    Dim delimiter As String * 1
    
    delimiter = Chr$(SepASCII)
    
    For i = 1 To Pos
        LastPos = CurrentPos
        CurrentPos = InStr(LastPos + 1, Text, delimiter, vbBinaryCompare)
    Next i
    
    If CurrentPos = 0 Then
        ReadField = mid$(Text, LastPos + 1, Len(Text) - LastPos)
    Else
        ReadField = mid$(Text, LastPos + 1, CurrentPos - LastPos - 1)
    End If
    
End Function

Public Sub LeerLineaComandos()
    Dim rdata As String
    rdata = Command
    
    Dim FileTypeName As String
    Dim FileTypeIndex As Integer
      
    FileTypeName = ReadField(1, rdata, Asc("*")) ' File Type Name

    Passwd = ReadField(2, rdata, Asc("*")) ' Contraseña

    If Len(FileTypeName) > 0 Then
    
        FileTypeName = UCase(FileTypeName)
        
        If FileTypeName = "PASSWORD" Or FileTypeName = "CONTRASEÑA" Then

            Call SavePassword(Passwd)

        Else
        
            Select Case FileTypeName
                Case Is = "GRAFICOS"
                    Option1_Click (FileTypeEnum.Graficos)
                    Option1(FileTypeEnum.Graficos).value = True
                Case Is = "MIDI"
                    Option1_Click (FileTypeEnum.Midi)
                    Option1(FileTypeEnum.Midi).value = True
                Case Is = "WAV"
                    Option1_Click (FileTypeEnum.Wav)
                    Option1(FileTypeEnum.Wav).value = True
                Case Is = "INITS"
                    Option1_Click (FileTypeEnum.Inits)
                    Option1(FileTypeEnum.Inits).value = True
                Case Is = "PATCH"
                    Option1_Click (FileTypeEnum.PatchOk)
                    Option1(FileTypeEnum.PatchOk).value = True
                Case Is = "INTERFACE"
                    Option1_Click (FileTypeEnum.Interface)
                    Option1(FileTypeEnum.Interface).value = True
                Case Is = "MAPAS"
                    Option1_Click (FileTypeEnum.Mapas)
                    Option1(FileTypeEnum.Mapas).value = True
                Case Is = "MINIMAPAS"
                    Option1_Click (FileTypeEnum.MiniMapas)
                    Option1(FileTypeEnum.MiniMapas).value = True
            End Select
        
            Call Command1_Click
            
        End If
        
        End
    
    End If

End Sub

Private Sub Password_Change()
    Passwd = Password.Text
End Sub

Private Sub RandomPass_Click()
    Password.Text = RandomString(64)
End Sub

Private Sub ReadPass_Click()
    Password.Text = GetPassword
End Sub

Private Sub SavePass_Click()
    Call SavePassword(Password.Text)
End Sub

Private Sub BarraProgreso(ByVal Mostrar As Boolean)
    
    If Mostrar Then
        Me.Height = 3615
    Else
        Me.Height = 2805
    End If
    
End Sub
