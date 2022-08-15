VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "richtx32.ocx"
Begin VB.Form Form1 
   AutoRedraw      =   -1  'True
   BackColor       =   &H80000001&
   BorderStyle     =   5  'Sizable ToolWindow
   Caption         =   "Encryptor"
   ClientHeight    =   2925
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   11415
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2925
   ScaleWidth      =   11415
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame Frame2 
      BackColor       =   &H80000007&
      BorderStyle     =   0  'None
      Caption         =   "Frame2"
      Height          =   1215
      Left            =   120
      TabIndex        =   10
      Top             =   240
      Visible         =   0   'False
      Width           =   2775
      Begin VB.TextBox txtUserActivate 
         Alignment       =   2  'Center
         Appearance      =   0  'Flat
         BackColor       =   &H80000006&
         BorderStyle     =   0  'None
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   300
         Left            =   0
         TabIndex        =   13
         Top             =   240
         Width           =   2775
      End
      Begin VB.TextBox txtActivationCode 
         Alignment       =   2  'Center
         Appearance      =   0  'Flat
         BackColor       =   &H80000006&
         BorderStyle     =   0  'None
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   300
         Left            =   0
         TabIndex        =   11
         Top             =   840
         Width           =   2775
      End
      Begin VB.Label Label4 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         Caption         =   "Username"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H8000000E&
         Height          =   495
         Left            =   600
         TabIndex        =   14
         Top             =   0
         Width           =   1575
      End
      Begin VB.Label Label3 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         Caption         =   "Activation code"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H8000000E&
         Height          =   495
         Left            =   600
         TabIndex        =   12
         Top             =   600
         Width           =   1575
      End
   End
   Begin VB.Frame Frame1 
      BackColor       =   &H80000007&
      BorderStyle     =   0  'None
      Height          =   1215
      Left            =   120
      TabIndex        =   5
      Top             =   240
      Width           =   2775
      Begin VB.TextBox txtUser 
         Alignment       =   2  'Center
         BackColor       =   &H80000006&
         BorderStyle     =   0  'None
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H0000C000&
         Height          =   285
         Left            =   0
         TabIndex        =   7
         Text            =   "tincho123123"
         Top             =   240
         Width           =   2775
      End
      Begin VB.TextBox txtPass 
         Alignment       =   2  'Center
         BackColor       =   &H80000006&
         BorderStyle     =   0  'None
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H0000C000&
         Height          =   285
         IMEMode         =   3  'DISABLE
         Left            =   0
         PasswordChar    =   "*"
         TabIndex        =   6
         Text            =   "Martin123"
         Top             =   840
         Width           =   2775
      End
      Begin VB.Label Label1 
         Alignment       =   2  'Center
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Password"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H8000000B&
         Height          =   195
         Left            =   1020
         TabIndex        =   9
         Top             =   600
         Width           =   840
      End
      Begin VB.Label Label2 
         Alignment       =   2  'Center
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Username"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H8000000B&
         Height          =   195
         Left            =   960
         TabIndex        =   8
         Top             =   0
         Width           =   870
      End
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Activate account"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   120
      TabIndex        =   4
      Top             =   2040
      Width           =   2775
   End
   Begin RichTextLib.RichTextBox rtbConsole 
      Height          =   2055
      Left            =   3000
      TabIndex        =   3
      Top             =   120
      Width           =   8295
      _ExtentX        =   14631
      _ExtentY        =   3625
      _Version        =   393217
      BackColor       =   -2147483647
      BorderStyle     =   0
      Enabled         =   -1  'True
      ScrollBars      =   2
      TextRTF         =   $"Form1.frx":0000
   End
   Begin VB.Timer timerConnection 
      Enabled         =   0   'False
      Interval        =   500
      Left            =   4440
      Top             =   120
   End
   Begin VB.CommandButton cmdCreateAccount 
      Caption         =   "Create Account"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   120
      TabIndex        =   2
      Top             =   1800
      Width           =   2775
   End
   Begin VB.CommandButton cmdLoginAccount 
      Caption         =   "Login"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   1560
      Width           =   2775
   End
   Begin MSWinsockLib.Winsock Winsock1 
      Left            =   0
      Top             =   240
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.Label lblStatus 
      Alignment       =   2  'Center
      BackColor       =   &H80000008&
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Not connected"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000C0&
      Height          =   375
      Left            =   480
      TabIndex        =   0
      Top             =   2400
      Width           =   2055
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public e_state As State

Private Sub cmdCreateAccount_Click()
    If e_state = State.SessionOpen Then
        e_state = State.RequestAccountCreate
        Call CreateAccountRequest
    End If
End Sub

Private Sub cmdLoginAccount_Click()
     If e_state = State.SessionOpen Then
        If cmdLoginAccount.Caption = "Login" Then
            e_state = State.RequestAccountLogin
            Call AccountLoginRequest
        Else
            e_state = State.RequestActivateAccount
            Call ActivateAccountRequest
        End If
    End If
End Sub

Private Sub Command1_Click()
    Form1.Frame1.Visible = Not Form1.Frame1.Visible
    Form1.Frame2.Visible = Not Form1.Frame2.Visible
    
    If Form1.Frame2.Visible Then
        Form1.txtUserActivate.Text = Form1.txtUser.Text
        Form1.cmdLoginAccount.Caption = "Activar"
    End If
    
End Sub

Private Sub Form_Load()

    e_state = State.Idle
    
    If Winsock1.State <> 7 Then
        Call connectToLoginServer
        If Winsock1.State <> 7 Then
            lblStatus.ForeColor = vbYellow
            lblStatus.Caption = "Connecting..."
        End If
    End If
    
   ' Call testDLL
    
End Sub

Private Function testDLL()
     Dim encrypted_string As String
    Dim decrypted_string As String
   
    encrypted_string = ModConnection.Encrypt("7061626C6F6D61727175657A41524731", "8g7+KBaUTNTWE7N2kaQXK2DZ3vAhBP2k7ooY8iFtJouc5r1pry8+rp4olINEF6Rs")
    decrypted_string = ModConnection.Decrypt("7061626C6F6D61727175657A41524731", encrypted_string)
    If encrypted_string <> "kcJENudJt/B1n3bTFCiurTFNtOXB/L73HYbosUz1Zwk1f6+mVsJNj+pMK88KVH9PlUQU4BB4fADsrHS9gjoQ4Q==" Then
       Debug.Assert False
    End If
   
    If decrypted_string <> "8g7+KBaUTNTWE7N2kaQXK2DZ3vAhBP2k7ooY8iFtJouc5r1pry8+rp4olINEF6Rs" Then
        Debug.Assert False
    End If
    Debug.Print "REF(ENCRYPTED) = kcJENudJt/B1n3bTFCiurTFNtOXB/L73HYbosUz1Zwk1f6+mVsJNj+pMK88KVH9PlUQU4BB4fADsrHS9gjoQ4Q=="
    Debug.Print "Encrypted: " & encrypted_string
    Debug.Print "REF(DECRYPTED)= 8g7+KBaUTNTWE7N2kaQXK2DZ3vAhBP2k7ooY8iFtJouc5r1pry8+rp4olINEF6Rs"
    Debug.Print "Decrypted: " & decrypted_string
    
End Function

Private Sub Winsock1_Connect()
    lblStatus.Caption = "Connected"
    lblStatus.ForeColor = vbGreen
    Call OpenSessionRequest
End Sub

Private Sub Winsock1_DataArrival(ByVal BytesTotal As Long)
    Select Case e_state
        Case State.RequestOpenSession
            Call HandleOpenSession(BytesTotal)
        Case State.RequestAccountLogin
            Call HandleAccountLogin(BytesTotal)
        Case State.RequestAccountCreate
            Call HandleAccountCreate(BytesTotal)
        Case State.RequestAccountCreate
            Call HandleAccountCreate(BytesTotal)
    End Select
End Sub


Public Function MakeInt(ByVal LoByte As Byte, _
   ByVal hiByte As Byte) As Integer

MakeInt = ((hiByte * &H100) + LoByte)

End Function

Public Function CopyBytes(ByRef src() As Byte, ByRef dst() As Byte, ByVal size As Long, Optional ByVal offset As Long = 0)
    Dim i As Long
    
    For i = 0 To (size - 1)
        dst(i + offset) = src(i)
    Next i
    
End Function

Public Function ByteArrayToHex(ByRef ByteArray() As Byte) As String
    Dim l As Long, strRet As String
    
    For l = LBound(ByteArray) To UBound(ByteArray)
        strRet = strRet & Hex$(ByteArray(l)) & " "
    Next l
    
    'Remove last space at end.
    ByteArrayToHex = Left$(strRet, Len(strRet) - 1)
End Function

