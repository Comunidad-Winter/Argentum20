Attribute VB_Name = "ModConnection"
Option Explicit

Public Enum State
    Idle = 0
    RequestOpenSession
    SessionOpen
    RequestAccountLogin
    RequestAccountCreate
    RequestActivateAccount
End Enum

Public public_key() As Byte

Public Sub OpenSessionRequest()
    Dim arr(0 To 3) As Byte
    arr(0) = &H0
    arr(1) = &HAA
    arr(2) = &H0
    arr(3) = &H4
    Call Form1.Winsock1.SendData(arr)
    Form1.e_state = State.RequestOpenSession
End Sub

Public Sub AccountLoginRequest()
    Dim username As String
    Dim password As String
    Dim len_encrypted_password As Integer
    Dim len_encrypted_username As Integer
    
    Dim login_request() As Byte
    Dim packet_size As Integer
    Dim offset_login_request As Long
    Call AddtoRichTextBox("------------------------------------", 0, 255, 0, True)
    Call AddtoRichTextBox("AccountLoginRequest", 255, 255, 255, True)
    Call AddtoRichTextBox("------------------------------------", 0, 255, 0, True)
    username = Form1.txtUser.Text
    password = Form1.txtPass.Text
    
  '  encrypted_username = CHinterface.ENCRYPT(username, public_key)
  '  encrypted_password = CHinterface.ENCRYPT(password, public_key)
    Dim encrypted_username() As Byte
    Dim encrypted_username_b64 As String
    
    Dim encrypted_password() As Byte
    Dim encrypted_password_b64 As String
    
    
    encrypted_username_b64 = AO20CryptoSysWrapper.Encrypt(cnvHexStrFromBytes(public_key), username)
    encrypted_password_b64 = AO20CryptoSysWrapper.Encrypt(cnvHexStrFromBytes(public_key), password)
    
    Call AddtoRichTextBox("Username: " & encrypted_username_b64, 255, 255, 255)
    Call AddtoRichTextBox("Password: " & encrypted_password_b64, 255, 255, 255)
    
    Call Str2ByteArr(encrypted_username_b64, encrypted_username)
    Call Str2ByteArr(encrypted_password_b64, encrypted_password)
    
    
    Dim len_username As Integer
    Dim len_password As Integer
    
    len_username = Len(encrypted_username_b64)
    len_password = Len(encrypted_password_b64)
    
    ReDim login_request(1 To (2 + 2 + 2 + len_username + 2 + len_password))
    
    packet_size = UBound(login_request)
    
    login_request(1) = &HDE
    login_request(2) = &HAD
    'Siguientes 2 bytes indican tamaño total del paquete
    login_request(3) = hiByte(packet_size)
    login_request(4) = LoByte(packet_size)
    
    'Los siguientes 2 bytes son el SIZE_ENCRYPTED_USER
    login_request(5) = hiByte(len_username)
    login_request(6) = LoByte(len_username)
    Call Form1.CopyBytes(encrypted_username, login_request, len_username, 7)
    
    offset_login_request = 7 + UBound(encrypted_username)
        
    login_request(offset_login_request + 1) = hiByte(len_password)
    login_request(offset_login_request + 2) = LoByte(len_password)
    
    Call Form1.CopyBytes(encrypted_password, login_request, len_password, offset_login_request + 3)
    
    Call Form1.Winsock1.SendData(login_request)
    Form1.e_state = State.RequestAccountLogin
End Sub

Public Sub ActivateAccountRequest()
    Dim username As String
    Dim activation_code As String
    
    Dim len_encrypted_username As Integer
    Dim len_encrypted_activation_code As Integer
    
    Dim encrypted_username() As Byte
    Dim encrypted_activation_code() As Byte
    
    Dim login_request() As Byte
    Dim packet_size As Integer
    
    Dim offset_login_request As Long
    Call AddtoRichTextBox("------------------------------------", 0, 255, 0, True)
    Call AddtoRichTextBox("ActivateAccountRequest", 255, 255, 255, True)
    Call AddtoRichTextBox("------------------------------------", 0, 255, 0, True)
    
    username = Form1.txtUserActivate.Text
    activation_code = Form1.txtActivationCode.Text
    
  '  encrypted_username = CHinterface.ENCRYPT(username, public_key)
   ' encrypted_activation_code = CHinterface.ENCRYPT(activation_code, public_key)
    
    Call AddtoRichTextBox("Username: " & Form1.ByteArr2String(encrypted_username), 255, 255, 255)
    Call AddtoRichTextBox("Activation code: " & Form1.ByteArr2String(encrypted_activation_code), 255, 255, 255)
    
    
    ReDim login_request(1 To (2 + 2 + 2 + Form1.ByteArr2String(encrypted_username) + 2 + Form1.ByteArr2String(encrypted_activation_code)))
    
    packet_size = UBound(login_request)
    
    login_request(1) = &HBA
    login_request(2) = &HAD
    
    'Siguientes 2 bytes indican tamaño total del paquete
    login_request(3) = Form1.hiByte(packet_size)
    login_request(4) = Form1.LoByte(packet_size)
    
    'Los siguientes 2 bytes son el SIZE_ENCRYPTED_USER
    
    len_encrypted_username = Len(Form1.ByteArr2String(encrypted_username))
    
    login_request(5) = Form1.hiByte(len_encrypted_username)
    login_request(6) = Form1.LoByte(len_encrypted_username)
    Call Form1.CopyBytes(encrypted_username, login_request, Len(Form1.ByteArr2String(encrypted_username)), 7)
    
    offset_login_request = 7 + UBound(encrypted_username)
    
    len_encrypted_activation_code = Len(Form1.ByteArr2String(encrypted_activation_code))
    
    login_request(offset_login_request + 1) = Form1.hiByte(len_encrypted_activation_code)
    login_request(offset_login_request + 2) = Form1.LoByte(len_encrypted_activation_code)
    
    Call Form1.CopyBytes(encrypted_activation_code, login_request, Len(Form1.ByteArr2String(encrypted_activation_code)), offset_login_request + 3)
    
    Call Form1.Winsock1.SendData(login_request)
    Form1.e_state = State.RequestAccountLogin
End Sub

Public Sub CreateAccountRequest()
    Dim arr() As Byte
    Dim packet_size As Integer
    Dim path As String, file As String
    path = App.path & "\character.txt"
    file = FileToString(path)
    Dim encrypted_account() As Byte
    
   'File is the plain_text JSON with the data of the account
   '///////////////
   
   'encrypted_account = CHinterface.ENCRYPT(file, public_key)
    
    
    ReDim Preserve arr(1 To (2 + 2 + Len(Form1.ByteArr2String(encrypted_account))))
    
    arr(1) = &HBE
    arr(2) = &HEF
    
    packet_size = UBound(arr)
    
    arr(3) = Form1.hiByte(packet_size)
    arr(4) = Form1.LoByte(packet_size)
    
    Call Form1.CopyBytes(encrypted_account, arr, Len(Form1.ByteArr2String(encrypted_account)), 5)
    Call Form1.Winsock1.SendData(arr)
    Form1.e_state = State.RequestAccountCreate
End Sub

Public Sub connectToLoginServer()
    Form1.Winsock1.RemoteHost = "194.113.72.86"
    Form1.Winsock1.RemotePort = "4000"
    Form1.Winsock1.Connect
End Sub

Public Sub HandleOpenSession(ByVal BytesTotal As Long)
    Call AddtoRichTextBox("------------------------------------", 0, 255, 0, True)
    Call AddtoRichTextBox("HandleOpenSession", 255, 255, 255, True)
    Call AddtoRichTextBox("------------------------------------", 0, 255, 0, True)
    Dim strData As String
    Form1.Winsock1.PeekData strData, vbString, BytesTotal
    Call AddtoRichTextBox("Bytes total: " & strData, 255, 255, 255, False)
    
    Form1.Winsock1.GetData strData, vbString, 2
    Call AddtoRichTextBox("Id: " & strData, 255, 255, 255, False)
    
    Form1.Winsock1.GetData strData, vbString, 2
    
    Dim encrypted_token() As Byte
    Dim secret_key_byte() As Byte
    
    Form1.Winsock1.GetData encrypted_token, 64
            
    Call Str2ByteArr("pablomarquezARG1", secret_key_byte)
    Dim decrypted_session_token As String
     
    decrypted_session_token = AO20CryptoSysWrapper.Decrypt("7061626C6F6D61727175657A41524731", cnvStringFromHexStr(cnvToHex(encrypted_token)))
    Call AddtoRichTextBox("Decripted_session_token: " & decrypted_session_token, 255, 255, 255, False)
        
    public_key = Mid(decrypted_session_token, 1, 16)
    
    Call AddtoRichTextBox("Public key:" & CStr(public_key), 255, 255, 255, False)
    
    Str2ByteArr decrypted_session_token, public_key, 16
    Form1.e_state = State.SessionOpen
    
End Sub

Public Sub HandleAccountLogin(ByVal BytesTotal As Long)

    Call AddtoRichTextBox("------------------------------------", 0, 255, 0, True)
    Call AddtoRichTextBox("HandleRequestAccountLogin", 255, 255, 255, True)
    Call AddtoRichTextBox("------------------------------------", 0, 255, 0, True)
    Dim data() As Byte
    
    Form1.Winsock1.PeekData data, vbByte, BytesTotal
    
    Form1.Winsock1.GetData data, vbByte, 2
    
    If data(0) = &HAF And data(1) = &HA1 Then
        Call AddtoRichTextBox("LOGIN-OK", 0, 255, 0, True)
        'Call AddtoRichTextBox(Form1.ByteArrayToHex(data), 255, 255, 255)
    Else
       Call AddtoRichTextBox("ERROR", 255, 0, 0, True)
        Form1.Winsock1.GetData data, vbByte, 4
        Select Case data(3)
            Case 1
                Call AddtoRichTextBox("Invalid Username", 255, 0, 0)
            Case 4
                Call AddtoRichTextBox("Username is already logged.", 255, 255, 0)
            Case 6
                Call AddtoRichTextBox("Username has been banned.", 255, 0, 0)
            Case 7
                Call AddtoRichTextBox("Ther server has reached the max. number of users.", 255, 0, 0)
            Case 9
                Call AddtoRichTextBox("The account has not been activated.", 255, 255, 0)
            Case Else
                Call AddtoRichTextBox("Unknown error: " & Form1.ByteArrayToHex(data), 255, 255, 0)
        End Select
    End If
        
    Form1.e_state = State.SessionOpen
End Sub

Public Sub HandleAccountCreate(ByVal BytesTotal As Long)

    Call AddtoRichTextBox("------------------------------------", 0, 255, 0, True)
    Call AddtoRichTextBox("HandleAccountCreate", 255, 255, 255, True)
    Call AddtoRichTextBox("------------------------------------", 0, 255, 0, True)
    Dim data() As Byte
    
    Form1.Winsock1.PeekData data, vbByte, BytesTotal
    Call AddtoRichTextBox(Form1.ByteArrayToHex(data), 255, 255, 255)
    Form1.Winsock1.GetData data, vbByte, 2
    
    If data(0) = &HBF And data(1) = &HB1 Then
        Call AddtoRichTextBox("ACCOUNT-CREATED-OK", 0, 255, 0, True)
    Else
       Call AddtoRichTextBox("ERROR", 255, 0, 0, True)
    End If
        
   ' Debug.Print Form1.ByteArrayToHex(data)
    Form1.Winsock1.GetData data, vbByte, 2
    Form1.e_state = State.SessionOpen
End Sub


Sub AddtoRichTextBox(ByVal Text As String, Optional ByVal red As Integer = -1, Optional ByVal green As Integer, Optional ByVal blue As Integer, Optional ByVal bold As Boolean = False, Optional ByVal italic As Boolean = False, Optional ByVal bCrLf As Boolean = False)
    '******************************************
    'HarThaoS: Martín Trionfetti 20-11-2021
    '******************************************
    With Form1.rtbConsole
    
        If Len(.Text) > 20000 Then
            .Text = vbNullString
            .SelStart = InStr(1, .Text, vbCrLf) + 1
            .SelLength = Len(.Text) - .SelStart + 2
            .TextRTF = .SelRTF
        End If
        
        .SelStart = Len(.Text)
        .SelLength = 0
        .SelBold = bold
        .SelItalic = italic
        
        If Not red = -1 Then .SelColor = RGB(red, green, blue)
        bCrLf = True
        
        If bCrLf And Len(.Text) > 0 Then Text = vbCrLf & Text
        .SelText = Text
        
    End With
    
End Sub

Function FileToString(strFileName As String) As String
  Open strFileName For Input As #1
    FileToString = StrConv(InputB(LOF(1), 1), vbUnicode)
  Close #1
End Function

Public Sub HandleAccountActivate(ByVal BytesTotal As Long)

    Call AddtoRichTextBox("------------------------------------", 0, 255, 0, True)
    Call AddtoRichTextBox("HandleAccountActivate", 255, 255, 255, True)
    Call AddtoRichTextBox("------------------------------------", 0, 255, 0, True)
    Dim data() As Byte
    
    Form1.Winsock1.PeekData data, vbByte, BytesTotal
    
    Form1.Winsock1.GetData data, vbByte, 2
    
    If data(0) = &H77 And data(1) = &H77 Then
        Call AddtoRichTextBox("ACCOUNT-ACTIVATED-OK", 0, 255, 0, True)
        'Call AddtoRichTextBox(Form1.ByteArrayToHex(data), 255, 255, 255)
    Else
       Call AddtoRichTextBox("ERROR", 255, 0, 0, True)
        Form1.Winsock1.GetData data, vbByte, 4
        Select Case data(3)
            Case 1
                Call AddtoRichTextBox("Invalid Username", 255, 0, 0)
            Case 10
                Call AddtoRichTextBox("Incorrect activation code.", 255, 0, 0)
            Case 11
                Call AddtoRichTextBox("Username already activated account.", 255, 255, 0)
            Case Else
                Call AddtoRichTextBox("Unknown error: " & Form1.ByteArrayToHex(data), 255, 255, 0)
        End Select
    End If
        
    Form1.e_state = State.SessionOpen
End Sub
