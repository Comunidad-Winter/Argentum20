VERSION 5.00
Begin VB.Form frmBinary 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "ORE Compressor"
   ClientHeight    =   2010
   ClientLeft      =   2325
   ClientTop       =   1500
   ClientWidth     =   4485
   Icon            =   "frmBinary.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2010
   ScaleWidth      =   4485
   StartUpPosition =   2  'CenterScreen
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
      Top             =   1560
      Width           =   1335
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
         Index           =   5
         Left            =   1560
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
      Top             =   1560
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
      Top             =   1560
      Width           =   1335
   End
End
Attribute VB_Name = "frmBinary"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim File_Type_Index As Byte

Sub Form_Load()
    Call LeerLineaComandos
End Sub

Private Sub Command1_Click()
    frmProgress.Show
    frmProgress.Label1.Caption = "Comprimiendo..."
    Compress_Files File_Type_Index, App.Path & "\..\Recursos", App.Path & "\..\Recursos\OUTPUT\"
    Unload frmProgress
End Sub

Private Sub Command2_Click()
    Dim LoopC As Long
    
    frmProgress.Show
    frmProgress.Label1.Caption = "Descomprimiendo..."
    If File_Type_Index <> Patch Then
        Extract_All_Files File_Type_Index, App.Path & "\..\Recursos", True
    Else
         Extract_Patch App.Path & "\..\Recursos\OUTPUT", App.Path & "\..\Recursos\OUTPUT\Patch.rao"
    End If
    
    Unload frmProgress
End Sub

Private Sub Command3_Click()
Dim tmp As String
tmp = InputBox("Ingrese el nombre del archivo a extraer")
Extract_File File_Type_Index, App.Path & "\output", tmp, App.Path & "\output\", False
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
    
    rdata = Right$(rdata, Len(rdata))
      
    FileTypeName = ReadField(1, rdata, Asc("*")) ' File Type Name
    
    If Len(FileTypeName) > 0 Then
    
        FileTypeName = UCase(FileTypeName)
        
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
        End Select
    
        Call Command1_Click
        
        End
    
    End If

    
    
    
    

    
End Sub

