Attribute VB_Name = "Unit_Protocol_Writes"
Option Explicit
Private Writer As Network.Writer

Public Function writer_is_nothing() As Boolean
    writer_is_nothing = Writer Is Nothing
End Function
Public Sub Initialize()
    Set Writer = New Network.Writer
End Sub

Public Sub Clear()
    Call Writer.Clear
End Sub


Public Sub WriteLoginNewChar(ByVal public_key As String, ByVal username As String, _
    ByVal app_major As Byte, ByVal app_minor As Byte, ByVal app_revision As Byte, ByVal md5 As String, _
    ByVal race As Byte, ByVal gender As Byte, ByVal Class As Byte, ByVal body As Byte, _
    ByVal head As Byte, ByVal home As Byte)
     
     Dim encrypted_username_b64 As String
     encrypted_username_b64 = AO20CryptoSysWrapper.ENCRYPT(cnvHexStrFromString(public_key), username)
     Call Writer.WriteInt(ClientPacketID.LoginNewChar)
     Call Writer.WriteString8(UnitTesting.encrypted_token)
     Call Writer.WriteString8(encrypted_username_b64)
     Call Writer.WriteInt8(App.Major)
     Call Writer.WriteInt8(App.Minor)
     Call Writer.WriteInt8(App.Revision)
     Call Writer.WriteString8(md5)
     Call Writer.WriteInt8(race)
     Call Writer.WriteInt8(gender)
     Call Writer.WriteInt8(Class)
     Call Writer.WriteInt(head)
     Call Writer.WriteInt8(home)
     Call UnitClient.Send(Writer)
End Sub

Public Sub WriteLong(ByVal value_to_send As Long)
    Call Writer.WriteInt(value_to_send)
    Call UnitClient.Send(Writer)
End Sub

Public Sub HandleShowMessageBox(ByRef Reader As Network.Reader)
    Dim mensaje As String
    mensaje = Reader.ReadString8()
    Debug.Print "HandleShowMessageBox " & mensaje
End Sub

Public Sub HandleCharacterChange(ByRef Reader As Network.Reader)
    Dim charindex As Integer
    Dim TempInt   As Integer
    Dim headIndex As Integer
    Call Reader.ReadInt
    TempInt = Reader.ReadInt()
    headIndex = Reader.ReadInt()
    Call Reader.ReadInt8
    TempInt = Reader.ReadInt()
    TempInt = Reader.ReadInt()
    TempInt = Reader.ReadInt()
    Reader.ReadInt
    Reader.ReadInt
    Reader.ReadInt8
End Sub



