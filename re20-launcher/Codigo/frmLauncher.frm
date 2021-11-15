VERSION 5.00
Object = "{48E59290-9880-11CF-9754-00AA00C00908}#1.0#0"; "MSINET.ocx"
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.4#0"; "COMCTL32.ocx"
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Begin VB.Form frmLauncher 
   Appearance      =   0  'Flat
   BackColor       =   &H00000000&
   BorderStyle     =   0  'None
   Caption         =   "AO20 Launcher"
   ClientHeight    =   6660
   ClientLeft      =   5865
   ClientTop       =   2835
   ClientWidth     =   7380
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   DrawStyle       =   5  'Transparent
   BeginProperty Font 
      Name            =   "MS Sans Serif"
      Size            =   9.75
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   -1  'True
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmLauncher.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   NegotiateMenus  =   0   'False
   PaletteMode     =   2  'Custom
   ScaleHeight     =   6660
   ScaleMode       =   0  'User
   ScaleWidth      =   7380
   StartUpPosition =   2  'CenterScreen
   Begin VB.Timer Timer3 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   6960
      Top             =   1680
   End
   Begin InetCtlsObjects.Inet Inet2 
      Left            =   8280
      Top             =   840
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
   End
   Begin InetCtlsObjects.Inet Inet1 
      Left            =   8280
      Top             =   240
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
   End
   Begin RichTextLib.RichTextBox rectxt 
      Height          =   2655
      Left            =   480
      TabIndex        =   8
      TabStop         =   0   'False
      ToolTipText     =   "Mensajes del servidor"
      Top             =   2280
      Width           =   4240
      _ExtentX        =   7488
      _ExtentY        =   4683
      _Version        =   393217
      BackColor       =   16777215
      BorderStyle     =   0
      ReadOnly        =   -1  'True
      ScrollBars      =   2
      DisableNoScroll =   -1  'True
      Appearance      =   0
      TextRTF         =   $"frmLauncher.frx":57E2
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Verdana"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin ComctlLib.ProgressBar ProgressBar1 
      Height          =   165
      Left            =   480
      TabIndex        =   7
      Top             =   120
      Visible         =   0   'False
      Width           =   2700
      _ExtentX        =   4763
      _ExtentY        =   291
      _Version        =   327682
      Appearance      =   0
   End
   Begin VB.Label lblRestablecerVersiones 
      Alignment       =   2  'Center
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Restablecer versión"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00E0E0E0&
      Height          =   165
      Left            =   5175
      TabIndex        =   10
      Top             =   3640
      Width           =   1515
   End
   Begin VB.Image Image1 
      Height          =   465
      Index           =   2
      Left            =   4920
      Tag             =   "0"
      Top             =   3120
      Width           =   2055
   End
   Begin VB.Image Image1 
      Height          =   300
      Index           =   7
      Left            =   6240
      OLEDropMode     =   1  'Manual
      Top             =   5880
      Width           =   345
   End
   Begin VB.Image Image1 
      Height          =   300
      Index           =   6
      Left            =   6600
      OLEDropMode     =   1  'Manual
      Top             =   5880
      Width           =   345
   End
   Begin VB.Image Image1 
      Height          =   300
      Index           =   5
      Left            =   5480
      OLEDropMode     =   1  'Manual
      Top             =   5880
      Width           =   345
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "V1.5"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   255
      Left            =   6600
      TabIndex        =   9
      Top             =   6240
      Width           =   375
   End
   Begin VB.Label estado 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   615
      Left            =   2040
      TabIndex        =   6
      Top             =   6000
      Width           =   3375
   End
   Begin VB.Image Image1 
      Height          =   240
      Index           =   1
      Left            =   6990
      Top             =   45
      Width           =   360
   End
   Begin VB.Image Image1 
      Height          =   300
      Index           =   3
      Left            =   360
      OLEDropMode     =   1  'Manual
      Top             =   5900
      Width           =   1665
   End
   Begin VB.Image Image1 
      Height          =   585
      Index           =   0
      Left            =   2490
      Tag             =   "0"
      Top             =   5340
      Width           =   2415
   End
   Begin VB.Label Label2 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Version actual de su cliente:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   375
      Left            =   120
      TabIndex        =   5
      Top             =   360
      Visible         =   0   'False
      Width           =   2775
   End
   Begin VB.Label versionactual 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Left            =   120
      TabIndex        =   4
      Top             =   960
      Visible         =   0   'False
      Width           =   735
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "Version necesaria:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   375
      Left            =   120
      TabIndex        =   3
      Top             =   600
      Visible         =   0   'False
      Width           =   2775
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Left            =   2760
      TabIndex        =   2
      Top             =   1200
      Visible         =   0   'False
      Width           =   735
   End
   Begin VB.Label cuantas 
      BackColor       =   &H00FFFFFF&
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Left            =   2760
      TabIndex        =   1
      Top             =   1440
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.Label Label6 
      Alignment       =   1  'Right Justify
      BackColor       =   &H80000007&
      BackStyle       =   0  'Transparent
      Caption         =   "Actualizaciones necesarias:"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   840
      Visible         =   0   'False
      Width           =   2775
   End
End
Attribute VB_Name = "frmLauncher"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Public bmoving As Boolean

Public DX      As Integer

Public dy      As Integer
Option Explicit

Private WithEvents zip As ZipExtractionClass
Attribute zip.VB_VarHelpID = -1

' Constantes para SendMessage
Const WM_SYSCOMMAND    As Long = &H112&

Const MOUSE_MOVE       As Long = &HF012&

Private Declare Function ReleaseCapture Lib "USER32" () As Long

Private Declare Function SendMessage _
                Lib "USER32" _
                Alias "SendMessageA" (ByVal hwnd As Long, _
                                      ByVal wMsg As Long, _
                                      ByVal wParam As Long, _
                                      lParam As Long) As Long

' función Api para aplicar la transparencia a la ventana
Private Declare Function SetLayeredWindowAttributes _
                Lib "USER32" (ByVal hwnd As Long, _
                              ByVal crKey As Long, _
                              ByVal bAlpha As Byte, _
                              ByVal dwFlags As Long) As Long

' Funciones api para los estilos de la ventana
Private Declare Function GetWindowLong _
                Lib "USER32" _
                Alias "GetWindowLongA" (ByVal hwnd As Long, _
                                        ByVal nIndex As Long) As Long

Private Declare Function SetWindowLong _
                Lib "USER32" _
                Alias "SetWindowLongA" (ByVal hwnd As Long, _
                                        ByVal nIndex As Long, _
                                        ByVal dwNewLong As Long) As Long

Private Declare Function ShellExecute _
                Lib "shell32.dll" _
                Alias "ShellExecuteA" (ByVal hwnd As Long, _
                                       ByVal lpOperation As String, _
                                       ByVal lpFile As String, _
                                       ByVal lpParameters As String, _
                                       ByVal lpDirectory As String, _
                                       ByVal nShowCmd As Long) As Long

'constantes
Private Const GWL_EXSTYLE = (-20)

Private Const LWA_ALPHA = &H2

Private Const WS_EX_LAYERED = &H80000

Private Const WS_EX_TRANSPARENT As Long = &H20&

' Función que recibe el handle de la ventana y el valor para aplciar la _
  Transparencia

Public Function Transparencia(ByVal hwnd As Long, valor As Integer) As Long

    On Local Error GoTo ErrSub

    Dim Estilo As Long

    If valor < 0 Or valor > 255 Then
    
        Transparencia = 1
        
    Else

        Estilo = GetWindowLong(hwnd, GWL_EXSTYLE)
        Estilo = Estilo Or WS_EX_LAYERED
    
        Call SetWindowLong(hwnd, GWL_EXSTYLE, Estilo)
    
        'Aplica el nuevo estilo con la transparencia
        Call SetLayeredWindowAttributes(hwnd, 0, valor, LWA_ALPHA)
        Transparencia = 0

    End If

    If Err Then Transparencia = 2

    Exit Function
    
    'Error
ErrSub:
    MsgBox Err.Description, vbCritical, "Error"

End Function

Private Sub moverForm()

    Call ReleaseCapture
    
    Call SendMessage(Me.hwnd, WM_SYSCOMMAND, MOUSE_MOVE, 0)

End Sub

Private Sub Picture2_Click()
    Unload Me

End Sub

Private Sub actu_Click()
    Unload Me

End Sub

Sub AddtoRichTextBox(ByRef RichTextBox As RichTextBox, _
                     ByVal Text As String, _
                     Optional ByVal red As Integer = -1, _
                     Optional ByVal green As Integer, _
                     Optional ByVal blue As Integer, _
                     Optional ByVal bold As Boolean = False, _
                     Optional ByVal italic As Boolean = False, _
                     Optional ByVal bCrLf As Boolean = False)
    '******************************************
    'Adds text to a Richtext box at the bottom.
    'Automatically scrolls to new text.
    'Text box MUST be multiline and have a 3D
    'apperance!
    'Pablo (ToxicWaste) 01/26/2007 : Now the list refeshes properly.
    'Juan Martín Sotuyo Dodero (Maraxus) 03/29/2007 : Replaced ToxicWaste's code for extra performance.
    '******************************************r

    With RichTextBox

        If Len(.Text) > 1000 Then
            'Get rid of first line
            .SelStart = InStr(1, .Text, vbCrLf) + 1
            .SelLength = Len(.Text) - .SelStart + 2
            .TextRTF = .SelRTF

        End If
        
        .SelStart = Len(RichTextBox.Text)
        .SelLength = 0
        .SelBold = bold
        .SelItalic = italic
        
        If Not red = -1 Then .SelColor = RGB(red, green, blue)
        
        .SelText = IIf(bCrLf, Text, Text)

    End With

End Sub

Private Sub Form_Load()
    Call Transparencia(Me.hwnd, 250)
    
    ConfigFile = App.Path & "\recursos\output\Configuracion.ini"
    AutoupdateConfig = App.Path & "\recursos\output\Autoupdate.ini"
    
    ' FTP donde se encuentran las actualizaciones
    Host = GetVar(AutoupdateConfig, "AUTOUPDATE", "host")
     
    Windows_Temp_Dir = General_Get_Temp_Dir
    
    frmLauncher.Picture = General_Load_Picture_From_Resource("ventanalauncher.bmp")
    
    RegistrarDLL = Val(GetVar(AutoupdateConfig, "AUTOUPDATE", "RegistrarDLL"))

    If RegistrarDLL = 1 Then Call ActualizarDlls

    rojo = 255
    subiendo = False

    Call SetWindowLong(rectxt.hwnd, GWL_EXSTYLE, WS_EX_TRANSPARENT)
    Call CargarChangelog

End Sub

Private Sub Form_KeyUp(KeyCode As Integer, Shift As Integer)

    If KeyCode = vbKeyV Then
    
        versionactual.Visible = True
        cuantas.Visible = True
        Label1.Visible = True
        Label2.Visible = True
        Label3.Visible = True
        Label6.Visible = True
        estado.Visible = True
        KeyCode = 0

    End If

    Exit Sub

End Sub

Private Sub Image1_Click(Index As Integer)

    Select Case Index

        Case 0
            Call WriteVar(AutoupdateConfig, "AUTOUPDATE", "RegistrarDLL", "0")
            estado.Caption = "Descargando lista de parches..."
            Call Comprobaciones

        Case 1
            End

        Case 2
            frmOpciones.Show , Me
    
        Case 3
            ShellExecute Me.hwnd, "open", "https://ao20.com.ar/", "", "", 0

        Case 4
            MsgBox "Aún no disponible"

        Case 5
            ShellExecute Me.hwnd, "open", "https://discord.gg/e3juVbF", "", "", 0

        Case 6
            ShellExecute Me.hwnd, "open", "https://www.instagram.com/argentumforever/", "", "", 0 'https://ao20.com.ar/

        Case 7
            ShellExecute Me.hwnd, "open", "https://www.facebook.com/argentumforever", "", "", 0 'https://www.facebook.com/argentumforever

    End Select

End Sub

Private Sub Image1_MouseDown(Index As Integer, _
                             Button As Integer, _
                             Shift As Integer, _
                             X As Single, _
                             Y As Single)

    Select Case Index

        Case 0
            Image1(0).Picture = General_Load_Picture_From_Resource("boton-comenzar-ES-off.bmp")
            Image1(0).Tag = "1"

    End Select

End Sub

Private Sub Image1_MouseMove(Index As Integer, _
                             Button As Integer, _
                             Shift As Integer, _
                             X As Single, _
                             Y As Single)

    Select Case Index

        Case 0

            If Image1(0).Tag = 0 Then
                Image1(0).Picture = General_Load_Picture_From_Resource("boton-comenzar-ES-over.bmp")
                Image1(0).Tag = "1"

            End If

    End Select

End Sub

Private Sub Inet2_StateChanged(ByVal State As Integer)

    Dim vtData As Variant 'acá almacenamos los datos

    Select Case State

        Case StateConstants.icResponseCompleted

            Dim bDone       As Boolean: bDone = False
            Dim tempArray() As Byte ' Un array para grabar los datos en un archivo

            'Para saber el tamaño del fichero en bytes
            Dim FileSize    As Long
            Dim contenttype As String

            FileSize = Inet2.GetHeader("Content-length")

            'Establecemos el Max del = a al tamaño del archivo
            ProgressBar1.max = FileSize
            contenttype = Inet2.GetHeader("Content-type")
            
            'Creamos y abrimos un nuevo archivo en modo binario
            Open NuevoArchivo For Binary Access Write As #1

            ' Leemos de a 1 Kbytes. El segundo parámetro indica _
              el tipo de fichero. Tipo texto o tipo Binario, en este caso _
              binario
            vtData = Inet2.GetChunk(1024, icByteArray)

            DoEvents
            'Si el tamaño del fichero es 0 ponemos bDone en True para que no _
             entre en el bucle

            If Len(vtData) = 0 Then bDone = True

            Do While Not bDone
            
                'Almacenamos en un array el contenido del archivo
                tempArray = vtData
                
                'Escribimos el archivo en disco
                Put #1, , tempArray

                prog = prog + Len(vtData) * 2

                estado.Caption = "Descargando parches  - " & Round(CDbl(prog) * CDbl(100) / CDbl(FileSize), 2) & "%"

                ' Leemos de pedazos de a 1 kb (1024 bytes)
                vtData = Inet2.GetChunk(1024, icByteArray)
                
                DoEvents

                If Len(vtData) = 0 Then bDone = True

            Loop

            Close #1
            
            Call extraer
        
        Case StateConstants.icError
            Close #1
        
    End Select


End Sub

Private Sub Label4_Click()
    Call MsgBox("Vuelva a iniciar el launcher, se registraran las dlls necesarias para jugar.")
    Call WriteVar(AutoupdateConfig, "AUTOUPDATE", "RegistrarDLL", "1")
    End

End Sub

Private Sub lblRestablecerVersiones_Click()

    Select Case MsgBox("Esta opción descargara nuevamente todos los parches del cliente. ¿Esta seguro que desea continuar?", vbYesNo + vbQuestion)

        Case vbYes
            Call WriteVar(AutoupdateConfig, "AUTOUPDATE", "N", 0)
            
        Case vbNo   'Boton NO.
            Exit Sub

    End Select

End Sub

Private Sub lblRestablecerVersiones_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)

    lblRestablecerVersiones.ForeColor = vbYellow

End Sub

Private Sub Timer3_Timer()

    Timer3.Enabled = False

    Call ShellExecute(Me.hwnd, "Open", App.Path & "\Cliente\Argentum.exe", "/LAUNCHER", "", 1)
    
    End

End Sub

Public Sub Comprobaciones()

    'Carga del formulario. Verifica si hay actualizaciones.
    VersionCliente = Val(GetVar(AutoupdateConfig, "AUTOUPDATE", "N"))
    versionactual.Caption = VersionCliente

    ' Inet Control settings
    Inet1.AccessType = icUseDefault
    Inet1.URL = Host & "/parche.txt" 'TXT QUE CONTIENE LA VERSION QUE TENDRIA QUE TENER EL JUEGO"

    Label3.Caption = Inet1.OpenURL

    On Error Resume Next

    If Len(Label3.Caption) = 0 Then
        Call MsgBox("¡No se a podido conectar con el servidor, Verifique que este conectado a Internet, si el problema persiste verifique el estado en nuestra pagina ao20.com.ar!", vbOKOnly, "AutoUpdate")
        Unload Me
        End

    End If

    If VersionCliente >= Label3.Caption And Not Actualizo Then
        estado.Caption = "¡Cliente al día!"
        Timer3.Enabled = True

    End If

    If VersionCliente >= Label3.Caption And Actualizo Then
        estado.Caption = "¡Actualización realizada!"
        Timer3.Enabled = True

    End If

    If VersionCliente < Label3.Caption Then 'Se fija si el numero de version del cliente es menor al del que marca en la web.
    
        ' Matamos el ejecutable del cliente
        If IsClientRunning Then
            If MsgBox("Para poder actualizar es necesario cerrar el juego." & vbNewLine & "¿Desea cerrarlo y continuar?", vbYesNo, "Se han encontrado actualizaciones") = vbNo Then
                Exit Sub
            End If
            
            Call CloseAllClients
        End If

        cuantas.Caption = Label3.Caption - VersionCliente

        Label6 = "Actualizaciones restantes:"
        Call AutoDownload

    End If

End Sub

Public Sub AutoDownload()

    'Descarga de la actualizacion
    
    On Error Resume Next

    Dim numero As Integer: numero = VersionCliente + 1

    NuevoArchivo = App.Path & "\recursos\output\" & numero & ".zip"

    'Inet1.AccessType = icUseDefault
    Dim strURL As String

    estado.Caption = "Descargando parches, aguarde..."

    Dim WEB As String
        WEB = Host & "/" & numero & ".zip" ' URL donde descarga los archivos
        
    ProgressBar1.value = 0
    
    ' Inet Control settings
    Inet2.AccessType = icUseDefault
    Inet2.URL = WEB
    Debug.Print WEB
    
    Call Inet2.Execute(, "GET")
    
End Sub

Public Sub extraer()

    estado.Caption = "Instalando, por favor aguarde..."

    Set zip = New ZipExtractionClass

    If zip.OpenZip(NuevoArchivo) Then
    
        Call zip.Extract(App.Path, True, True)

        Call zip.CloseZip

    End If

    Set zip = Nothing
   
    If FileExist(App.Path & "\Patch.rao", vbArchive) Then
        Call Extract_Patch(App.Path & "\recursos\output\", "Patch.rao")
        Call Kill(App.Path & "\patch.rao")

    End If
   
    Call Kill(NuevoArchivo)
    
    VersionCliente = VersionCliente + 1
    
    Call WriteVar(AutoupdateConfig, "AUTOUPDATE", "N", Str(VersionCliente))
    
    Actualizo = True
    
    Call Comprobaciones

End Sub

Private Sub Form_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)

    If bmoving = False And Button = vbLeftButton Then

        DX = X

        dy = Y

        bmoving = True

    End If

End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Image1(0).Picture = Nothing
    Image1(0).Tag = "0"
    Image1(1).Picture = Nothing
    Image1(3).Picture = Nothing

    If bmoving And ((X <> DX) Or (Y <> dy)) Then
    
        Call Move(Left + (X - DX), Top + (Y - dy))

    End If
    
    
    lblRestablecerVersiones.ForeColor = &HE0E0E0

End Sub

Private Sub Form_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)

    If Button = vbLeftButton Then

        bmoving = False

    End If

End Sub

Sub CargarChangelog()

    Inet1.AccessType = icUseDefault
    Inet1.URL = Host & "/changelog.txt"

    Dim strResponse As String: strResponse = Inet1.OpenURL
    
    ' Limpiamos antes de actualizar el changelog.
    rectxt.Text = vbNullString
    
    Call AddtoRichTextBox(Me.rectxt, strResponse, 239, 228, 176, 0, 0)

End Sub
