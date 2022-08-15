VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.ocx"
Begin VB.Form frmMain 
   BorderStyle     =   0  'None
   Caption         =   "DbManager"
   ClientHeight    =   1935
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   3450
   LinkTopic       =   "Form1"
   ScaleHeight     =   1935
   ScaleWidth      =   3450
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin MSWinsockLib.Winsock MainSocket 
      Left            =   120
      Top             =   120
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.Label Label1 
      Caption         =   "<Inserte información útil aquí>"
      Height          =   375
      Left            =   600
      TabIndex        =   0
      Top             =   840
      Width           =   2295
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private DataBuffer As cStringBuilder

Private Sub Form_Load()

    Database_Connect

    Dim Puerto As Integer
    Puerto = Val(GetVar(App.Path & "\..\re20-server\Server.ini", "DBMANAGER", "PUERTO"))

    Call MainSocket.Connect("localhost", Puerto)
    
    Set DataBuffer = New cStringBuilder
End Sub

Private Sub MainSocket_Close()
    Database_Close
    End
End Sub

Private Sub MainSocket_Connect()
    Debug.Print "Conectado"
End Sub

Private Sub MainSocket_DataArrival(ByVal bytesTotal As Long)

    Dim Data As String
    Call MainSocket.GetData(Data, vbString, bytesTotal)

    Call DataBuffer.Append(Data)
    
    Dim Separator As Long, Packet As String
    
    Do
        Separator = DataBuffer.Find(Chr(0))
        
        If Separator > 0 Then
            Packet = DataBuffer.SubStr(0, Separator - 1)

            Debug.Print Packet
            Call ProcessPacket(Packet)

            Call DataBuffer.Remove(0, Separator)
        End If

    Loop While Separator > 0
    
End Sub

Private Sub ProcessPacket(Packet As String)
    On Error Resume Next

    Dim FirstSeparator As Long
    FirstSeparator = InStr(1, Packet, Chr(1))

    If FirstSeparator > 0 Then
        Dim Query As String
        Query = Left$(Packet, FirstSeparator - 1)
    
        Dim Fields() As String
        Fields = Split(Right$(Packet, Len(Packet) - FirstSeparator), Chr(1))
    
        Dim Params() As Variant
        ReDim Params(UBound(Fields))
        
        Dim i As Integer
        For i = 0 To UBound(Fields)
            Params(i) = Fields(i)
        Next
    
        Call MakeQuery(Query, True, Params)
    Else
        Call MakeQuery(Packet, True)
    End If

End Sub
