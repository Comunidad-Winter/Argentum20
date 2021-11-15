Attribute VB_Name = "Mod_General"
'Actualizador By Ladder
'Echo en tan solo 2 dias. :P
'Recuerden esta frase que ami me sirvio de mucho "Si lo queres a tu manera, hacelo vos"
'Lo libero el 01/5/07
'Suerte para todos!
'Comentarios a pablito_3_15@hotmail.com
'Jessi te amo (l)

'Compresion
Public rojo             As Byte

Public subiendo         As Boolean

Public Fx           As Byte


Public Musica           As Byte

Public Vsync            As Byte

Public PantallaCompleta As Byte

Public Precarga         As Byte

Public CursoresGraficos As Byte

Public RegistrarDLL     As Byte

Private Declare Function GetTempPath _
                Lib "kernel32" _
                Alias "GetTempPathA" (ByVal nBufferLength As Long, _
                                      ByVal lpBuffer As String) As Long

Private Const MAX_LENGTH = 512

Public Declare Function writeprivateprofilestring _
               Lib "kernel32" _
               Alias "WritePrivateProfileStringA" (ByVal lpApplicationname As String, _
                                                   ByVal lpKeyname As Any, _
                                                   ByVal lpString As String, _
                                                   ByVal lpFileName As String) As Long

Public Declare Function getprivateprofilestring _
               Lib "kernel32" _
               Alias "GetPrivateProfileStringA" (ByVal lpApplicationname As String, _
                                                 ByVal lpKeyname As Any, _
                                                 ByVal lpdefault As String, _
                                                 ByVal lpreturnedstring As String, _
                                                 ByVal nSize As Long, _
                                                 ByVal lpFileName As String) As Long
Declare Function GetSystemDirectory _
        Lib "kernel32" _
        Alias "GetSystemDirectoryA" (ByVal lpBuffer As String, _
                                     ByVal nSize As Long) As Long

Private Const HWND_BROADCAST = &HFFFF&

Private Const WM_FONTCHANGE = &H1D

Private Declare Function AddFontResource _
                Lib "gdi32" _
                Alias "AddFontResourceA" (ByVal lpFileName As String) As Long

Private Declare Function SendMessage _
                Lib "USER32" _
                Alias "SendMessageA" (ByVal hwnd As Long, _
                                      ByVal wMsg As Long, _
                                      ByVal wParam As Long, _
                                      lParam As Any) As Long

Public Sub ActualizarDlls()

    On Error Resume Next

    'objeto para el manejo de ficheros
    'y directorios en visual basic
    Dim dlls As New Scripting.FileSystemObject
    
    'ruta donde se encuentran las dlls originales
    Set directorio = dlls.GetFolder(App.Path & "\recursos\dlls")
   
    'por cada fichero en el directorio dlls copiar fichero y registrar dll
    For Each fichero In directorio.Files

        'copiar la dll al directorio de sistema de windows
        Call dlls.CopyFile(App.Path & "\recursos\dlls\" & fichero.Name, RutaDelSistema & "\" & fichero.Name)
    
        'Mostramos que libreria se esta registrando
 
        'registar la dll copia
        Call Shell(RutaDelSistema & "\regsvr32 /s " & RutaDelSistema & "\" & fichero.Name, vbHide)
    
    Next

    Call AddFontResource(App.Path & "\recursos\dlls\" & "fuente.otf")

End Sub

'funcion que devuelve
'la ruta del directorio del sistema de windows
Public Function RutaDelSistema()

    Dim Car As String * 128
    Dim Longitud, Es As Integer
    Dim Camino As String
    
    Longitud = 128
    
    Es = GetSystemDirectory(Car, Longitud)
    Camino = RTrim$(LCase$(Left$(Car, Es)))
    RutaDelSistema = Camino

End Function

Function FileExist(ByVal file As String, ByVal FileType As VbFileAttribute) As Boolean
    FileExist = (Len(Dir$(file, FileType)) <> 0)

End Function

Function GetVar(file As String, Main As String, Var As String) As String

    Dim sSpaces  As String: sSpaces = Space(5000)

    Call getprivateprofilestring(Main, Var, "", sSpaces, Len(sSpaces), file)

    GetVar = RTrim(sSpaces)
    GetVar = Left(GetVar, Len(GetVar) - 1)

End Function

Sub WriteVar(file As String, Main As String, Var As String, value As String)

    Call writeprivateprofilestring(Main, Var, value, file)

End Sub

Public Function General_Get_Temp_Dir() As String

    '**************************************************************
    'Author: Augusto José Rando
    'Last Modify Date: 6/11/2005
    'Gets windows temporary directory
    '**************************************************************
    Dim s As String
    Dim c As Long

    s = Space$(MAX_LENGTH)
    c = GetTempPath(MAX_LENGTH, s)

    If c > 0 Then
    
        If c > Len(s) Then
        
            s = Space$(c + 1)
            c = GetTempPath(MAX_LENGTH, s)

        End If

    End If

    General_Get_Temp_Dir = IIf(c > 0, Left$(s, c), vbNullString)

End Function

Public Function CloseAllClients() As Boolean

    Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
    
    Set colItems = objWMIService.ExecQuery("Select * From Win32_Process")
    
    For Each objItem In colItems
        If objItem.Name = "Argentum.exe" Then objItem.Terminate
    Next

End Function

Public Function IsClientRunning() As Boolean

    Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
    Set colItems = objWMIService.ExecQuery("Select * From Win32_Process")
    
    For Each objItem In colItems

        If objItem.Name = "Argentum.exe" Then
            IsClientRunning = True
            Exit Function

        End If

    Next

End Function
