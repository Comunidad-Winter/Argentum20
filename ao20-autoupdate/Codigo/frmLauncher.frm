VERSION 5.00
Object = "{48E59290-9880-11CF-9754-00AA00C00908}#1.0#0"; "MSINET.ocx"
Object = "{3B7C8863-D78F-101B-B9B5-04021C009402}#1.2#0"; "RICHTX32.OCX"
Object = "{55473EAC-7715-4257-B5EF-6E14EBD6A5DD}#1.0#0"; "VBALPROGBAR6.OCX"
Begin VB.Form frmLauncher 
   BackColor       =   &H80000010&
   BorderStyle     =   0  'None
   Caption         =   "Launcher - AO Libre"
   ClientHeight    =   9000
   ClientLeft      =   6585
   ClientTop       =   3720
   ClientWidth     =   11985
   Icon            =   "frmLauncher.frx":0000
   LinkTopic       =   "Form1"
   Picture         =   "frmLauncher.frx":C84A
   ScaleHeight     =   9000
   ScaleWidth      =   11985
   StartUpPosition =   2  'CenterScreen
   Begin AOLibreAutoUpdate.uAOCheckbox CMDSombras 
      Height          =   225
      Left            =   4440
      TabIndex        =   7
      Top             =   840
      Width           =   210
      _ExtentX        =   370
      _ExtentY        =   397
      CHCK            =   0   'False
      ENAB            =   -1  'True
      PICC            =   "frmLauncher.frx":45F9A
   End
   Begin AOLibreAutoUpdate.uAOCheckbox CMDParticulas 
      Height          =   225
      Left            =   1440
      TabIndex        =   13
      Top             =   360
      Width           =   210
      _ExtentX        =   370
      _ExtentY        =   397
      CHCK            =   0   'False
      ENAB            =   -1  'True
      PICC            =   "frmLauncher.frx":46EB2
   End
   Begin AOLibreAutoUpdate.uAOCheckbox CMDVSync 
      Height          =   225
      Left            =   7560
      TabIndex        =   15
      Top             =   360
      Width           =   210
      _ExtentX        =   370
      _ExtentY        =   397
      CHCK            =   0   'False
      ENAB            =   -1  'True
      PICC            =   "frmLauncher.frx":47DCA
   End
   Begin RichTextLib.RichTextBox RichTextBoxLog 
      Height          =   975
      Left            =   720
      TabIndex        =   6
      Top             =   7080
      Width           =   10455
      _ExtentX        =   18441
      _ExtentY        =   1720
      _Version        =   393217
      BackColor       =   4210752
      Enabled         =   -1  'True
      TextRTF         =   $"frmLauncher.frx":48CE2
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Segoe UI Symbol"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin AOLibreAutoUpdate.uAOButton BtnSalir 
      Height          =   495
      Left            =   11160
      TabIndex        =   2
      Top             =   360
      Width           =   495
      _ExtentX        =   873
      _ExtentY        =   873
      TX              =   "X"
      ENAB            =   -1  'True
      FCOL            =   16777215
      OCOL            =   16777215
      PICE            =   "frmLauncher.frx":48D66
      PICF            =   "frmLauncher.frx":49EEA
      PICH            =   "frmLauncher.frx":4B88E
      PICV            =   "frmLauncher.frx":4D922
      BeginProperty FONT {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin InetCtlsObjects.Inet InetGithubReleases 
      Left            =   360
      Top             =   1200
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
   End
   Begin InetCtlsObjects.Inet InetGithubAutoupdate 
      Left            =   8880
      Top             =   1200
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
   End
   Begin vbalProgBarLib6.vbalProgressBar ProgressBar1 
      Height          =   540
      Left            =   1200
      TabIndex        =   1
      Top             =   8160
      Width           =   9345
      _ExtentX        =   16484
      _ExtentY        =   953
      Picture         =   "frmLauncher.frx":4F986
      BackColor       =   0
      ForeColor       =   16777152
      Appearance      =   0
      BorderStyle     =   0
      BarColor        =   16777215
      BarForeColor    =   12648384
      BarPicture      =   "frmLauncher.frx":4F9A2
      BarPictureMode  =   0
      BackPictureMode =   0
      ShowText        =   -1  'True
      Text            =   "[0% Completado]"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin AOLibreAutoUpdate.uAOButton BtnJugar 
      Height          =   735
      Left            =   9480
      TabIndex        =   3
      Top             =   6120
      Width           =   1575
      _ExtentX        =   2778
      _ExtentY        =   1296
      TX              =   "Jugar"
      ENAB            =   -1  'True
      FCOL            =   16777215
      OCOL            =   16777215
      PICE            =   "frmLauncher.frx":55356
      PICF            =   "frmLauncher.frx":564DA
      PICH            =   "frmLauncher.frx":57E7E
      PICV            =   "frmLauncher.frx":59F12
      BeginProperty FONT {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Lucida Console"
         Size            =   20.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin AOLibreAutoUpdate.uAOButton LblSpanish 
      Height          =   735
      Left            =   720
      TabIndex        =   4
      Top             =   6120
      Width           =   1575
      _ExtentX        =   2778
      _ExtentY        =   1296
      TX              =   "Castellano"
      ENAB            =   -1  'True
      FCOL            =   16777215
      OCOL            =   16777215
      PICE            =   "frmLauncher.frx":5BF76
      PICF            =   "frmLauncher.frx":5D0FA
      PICH            =   "frmLauncher.frx":5EA9E
      PICV            =   "frmLauncher.frx":60B32
      BeginProperty FONT {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin AOLibreAutoUpdate.uAOButton LblEnglish 
      Height          =   735
      Left            =   2400
      TabIndex        =   5
      Top             =   6120
      Width           =   1575
      _ExtentX        =   2778
      _ExtentY        =   1296
      TX              =   "English"
      ENAB            =   -1  'True
      FCOL            =   16777215
      OCOL            =   16777215
      PICE            =   "frmLauncher.frx":62B96
      PICF            =   "frmLauncher.frx":63D1A
      PICH            =   "frmLauncher.frx":656BE
      PICV            =   "frmLauncher.frx":67752
      BeginProperty FONT {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin AOLibreAutoUpdate.uAOCheckbox CMDSoundsFxs 
      Height          =   225
      Left            =   4440
      TabIndex        =   8
      Top             =   360
      Width           =   210
      _ExtentX        =   370
      _ExtentY        =   397
      CHCK            =   0   'False
      ENAB            =   -1  'True
      PICC            =   "frmLauncher.frx":697B6
   End
   Begin AOLibreAutoUpdate.uAOCheckbox CMDEffectSound 
      Height          =   225
      Left            =   1440
      TabIndex        =   9
      Top             =   840
      Width           =   210
      _ExtentX        =   370
      _ExtentY        =   397
      CHCK            =   0   'False
      ENAB            =   -1  'True
      PICC            =   "frmLauncher.frx":6A6CE
   End
   Begin VB.Label lblParticulas 
      BackStyle       =   0  'Transparent
      Caption         =   "lblParticulas"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FFFF&
      Height          =   375
      Left            =   2040
      TabIndex        =   16
      Top             =   360
      Width           =   3495
   End
   Begin VB.Label LblVSync 
      BackStyle       =   0  'Transparent
      Caption         =   "LblVSync"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FFFF&
      Height          =   375
      Left            =   7920
      TabIndex        =   12
      Top             =   360
      Width           =   2895
   End
   Begin VB.Label lblShadow 
      BackStyle       =   0  'Transparent
      Caption         =   "lblShadow"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FFFF&
      Height          =   375
      Left            =   4920
      TabIndex        =   11
      Top             =   840
      Width           =   3495
   End
   Begin VB.Label lblSoundsFxs 
      BackStyle       =   0  'Transparent
      Caption         =   "lblSoundsFxs"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FFFF&
      Height          =   375
      Left            =   4920
      TabIndex        =   14
      Top             =   360
      Width           =   3495
   End
   Begin VB.Label LblSounds 
      BackStyle       =   0  'Transparent
      Caption         =   "LblSounds"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0000FFFF&
      Height          =   375
      Left            =   2160
      TabIndex        =   10
      Top             =   840
      Width           =   3495
   End
   Begin VB.Label LblVersion 
      BackColor       =   &H80000013&
      BackStyle       =   0  'Transparent
      Caption         =   "Version"
      BeginProperty Font 
         Name            =   "Palatino Linotype"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000C0&
      Height          =   375
      Left            =   360
      TabIndex        =   0
      Top             =   600
      Width           =   975
   End
End
Attribute VB_Name = "frmLauncher"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Declare Sub Sleep Lib "kernel32.dll" (ByVal dwMilliseconds As Long)
Dim Directory As String, bDone As Boolean, dError As Boolean, F As Integer

Dim SizeInMb As Double
Dim JsonObject As Object

Private Language As String
Private JsonLanguage As Object

Private NoInternetConnection As Boolean

Private ClientPath As String

Private Sub DisableAllButtons()
    BtnJugar.Enabled = False
    BtnSalir.Enabled = False
    LblEnglish.Enabled = False
    LblSpanish.Enabled = False
End Sub

Private Sub EnableAllButtons()
    BtnJugar.Enabled = True
    BtnSalir.Enabled = True
    LblEnglish.Enabled = True
    LblSpanish.Enabled = True
End Sub

Private Sub BtnJugar_Click()
    Call DisableAllButtons
    Call Analizar("Client")
    Call EnableAllButtons
End Sub

Private Sub BtnWorldeditor_Click()
    Call DisableAllButtons
    Call Analizar("WorldEditor")
    Call EnableAllButtons
End Sub

Private Sub BtnSalir_Click()
    End
End Sub

Private Sub BtnServer_Click()
    Call DisableAllButtons
    Call Analizar("Server")
    Call EnableAllButtons
End Sub

Private Sub BtnParticleEditor_Click()
    Call DisableAllButtons
    Call Analizar("ParticleEditor")
    Call EnableAllButtons
End Sub

Private Sub BtnFronBot_Click()
    Call DisableAllButtons
    Call Analizar("FronBot")
    Call EnableAllButtons
End Sub

Private Sub LblEnglish_Click()
    Call WriteVar(App.Path & "\" & ClientPath & "\INIT\Config.ini", "PARAMETERS", "LANGUAGE", "english")
    Call WriteVar(App.Path & "\ConfigAutoupdate.ini", "ConfigAutoupdate", "language", "english")
    Call LaunchPopUpBeforeClose
End Sub

Private Sub LblSpanish_Click()
    Call WriteVar(App.Path & "\" & ClientPath & "\INIT\Config.ini", "PARAMETERS", "LANGUAGE", "spanish")
    Call WriteVar(App.Path & "\ConfigAutoupdate.ini", "ConfigAutoupdate", "language", "spanish")
    Call LaunchPopUpBeforeClose
End Sub

Private Sub LaunchPopUpBeforeClose()
    If MsgBox(JsonLanguage.Item("close_before_change_language"), vbYesNo) = vbYes Then
        End
    End If
End Sub

Private Function RandomNumber(ByVal LowerBound As Long, ByVal UpperBound As Long) As Long
    'Initialize randomizer
    Randomize Timer
    
    'Generate random number
    RandomNumber = (UpperBound - LowerBound) * Rnd + LowerBound
End Function

Private Sub Form_Load()
    ClientPath = GetVar(App.Path & "\ConfigAutoupdate.ini", "Client", "folderToExtract")
    'Solo hay 2 imagenes de cargando, cambiar 10 por el numero maximo si se quiere cambiar
    Me.Picture = LoadPicture(App.Path & "\Graficos\frmMain.jpg")

    NoInternetConnection = False
    LblVersion.Caption = GetVar(App.Path & "\ConfigAutoupdate.ini", "ConfigAutoupdate", "version")
    Call SetLanguageApplication
    Call CheckIfIEVersionIsCompatible
    Call CheckIfRunningLastVersionAutoupdate
    
    BtnJugar.Caption = JsonLanguage.Item("play_btn")

    LblEnglish.Caption = JsonLanguage.Item("english_label")
    LblSpanish.Caption = JsonLanguage.Item("spanish_label")
    LblVSync.Caption = JsonLanguage.Item("vsync_label")
    lblShadow.Caption = JsonLanguage.Item("shadow_label")
    LblSounds.Caption = JsonLanguage.Item("sounds_label")
    lblSoundsFxs.Caption = JsonLanguage.Item("sounds_fx_label")
    lblParticulas.Caption = JsonLanguage.Item("particles_label")
    
    ProgressBar1.Value = 0
    ProgressBar1.Text = JsonLanguage.Item("completed")
    
    LoadCheckboxesInitialStatus
End Sub

Private Sub SetLanguageApplication(Optional LanguageSelection As String)
    Dim JsonLanguageString As String
    
    If LenB(LanguageSelection) = 0 Then
        Language = GetVar(App.Path & "\ConfigAutoupdate.ini", "ConfigAutoupdate", "language")
    Else
        Language = LanguageSelection
    End If
    
    JsonLanguageString = FileToString(App.Path & "\Languages\" & Language & ".json")
    
    Set JsonLanguage = JSON.parse(JsonLanguageString)
    
End Sub

Public Function GetIEVersion()
    Dim FileSystemObject As New FileSystemObject
    Dim Version As String
    
    Version = FileSystemObject.GetFileVersion("c:\windows\system32\ieframe.dll")
    GetIEVersion = Version
End Function

Public Function CheckIfIEVersionIsCompatible()
    Dim IEVersion As String
    Dim IEVersionArray() As String

    IEVersion = GetIEVersion
    IEVersionArray() = Split(IEVersion, ".")

    If CInt(IEVersionArray(0)) < 10 Then
        Dim windowsXpTutorial As String
        windowsXpTutorial = GetVar(App.Path & "\ConfigAutoupdate.ini", "Links", "windowsXpTutorial")
        MsgBox (Replace(JsonLanguage.Item("error_ie"), "VAR_IEVersion", IEVersionArray(0)))
        MsgBox (JsonLanguage.Item("error_windows_xp") & windowsXpTutorial)
        End
    End If
End Function

Private Function FileToString(strFilename As String) As String
    
    Dim ifile As Integer: ifile = FreeFile
    
    Open strFilename For Input As #ifile
        FileToString = StrConv(InputB(LOF(ifile), ifile), vbUnicode)
    Close #ifile
    
End Function

Private Sub CheckIfRunningLastVersionAutoupdate()
On Error Resume Next
    Dim responseGithub As String, versionNumberMaster As String, versionNumberLocal As String
    Dim githubAccount As String
    
    githubAccount = GetVar(App.Path & "\ConfigAutoupdate.ini", "ConfigAutoupdate", "githubAccount")

    responseGithub = InetGithubAutoupdate.OpenURL("https://api.github.com/repos/" & githubAccount & "/ao-autoupdate/releases/latest")
    
    Set JsonObject = JSON.parse(responseGithub)

    If LenB(responseGithub) = 0 Then
        MsgBox JsonLanguage.Item("github_error")
        NoInternetConnection = True
        Exit Sub
    End If

    
    versionNumberMaster = JsonObject.Item("tag_name")
    versionNumberLocal = GetVar(App.Path & "\ConfigAutoupdate.ini", "ConfigAutoupdate", "version")
    
    If Not versionNumberMaster = versionNumberLocal Then
        MsgBox (JsonLanguage.Item("launcher_outdated"))
        MsgBox (JsonLanguage.Item("your_version") & " " & versionNumberLocal & " " & JsonLanguage.Item("last_version") & " " & versionNumberMaster)
        End
    End If
End Sub

Private Function CheckIfApplicationIsUpdated(ApplicationToUpdate As String) As Boolean
On Error Resume Next
    Dim versionNumberLocal As String, versionNumberMaster As String
    Dim repository As String, githubAccount As String
    Dim responseGithub As String, urlEndpointUpdate As String, fileToExecuteAfterUpdated As String
    Dim applicationName As String
    
    githubAccount = GetVar(App.Path & "\ConfigAutoupdate.ini", ApplicationToUpdate, "githubAccount")
    applicationName = GetVar(App.Path & "\ConfigAutoupdate.ini", ApplicationToUpdate, "application")
    repository = GetVar(App.Path & "\ConfigAutoupdate.ini", ApplicationToUpdate, "repository")
    urlEndpointUpdate = "https://api.github.com/repos/" & githubAccount & "/" & repository & "/releases/latest"
    
    'Mandamos a la consola los mensajes.
    Call addConsole(JsonLanguage.Item("looking_for_upgrades"), 255, 255, 255, True, False)
    Call addConsole(JsonLanguage.Item("configured_to") & applicationName, 100, 200, 40, True, False)   '>> Informacion
    
    'Reproducimos el sonido.
    Call Reproducir_WAV(App.Path & "\Wav\Revision_" & JsonLanguage.Item("lang_abbreviation") & ".wav", SND_FILENAME)
    
    'Enviamos la peticion GET
    responseGithub = InetGithubReleases.OpenURL(urlEndpointUpdate)
    
    'Si no recibimos nada mandamos error.
    If LenB(responseGithub) = 0 Then
        MsgBox JsonLanguage.Item("github_error")
        NoInternetConnection = True
        Exit Function
    End If
    
    'Obtenemos el numero de la ultima version.
    Set JsonObject = JSON.parse(responseGithub)
    versionNumberMaster = JsonObject.Item("tag_name")
    versionNumberLocal = GetVar(App.Path & "\ConfigAutoupdate.ini", ApplicationToUpdate, "version")
    
    'Chequeamos si son iguales y devolvemos el resultado.
    If versionNumberMaster = versionNumberLocal Then
        CheckIfApplicationIsUpdated = True
    ElseIf Not versionNumberMaster = versionNumberLocal Then
        CheckIfApplicationIsUpdated = False
    End If
    
End Function

Private Sub Analizar(ApplicationToUpdate As String)
On Error Resume Next
    Dim SubDirectoryApp As String
    Dim IsApplicationUpdated As Boolean
    Dim CancelUpdate As Boolean
    
    'Borramos todo el texto de la consola para que no haya mucho texto.
    frmLauncher.RichTextBoxLog.Text = ""
    
    IsApplicationUpdated = CheckIfApplicationIsUpdated(ApplicationToUpdate)
    SubDirectoryApp = GetVar(App.Path & "\ConfigAutoupdate.ini", ApplicationToUpdate, "folderToExtract")

    'Por que el server no deja modificar por el UAC cosas lo movemos de lugar.
    'Hacemos un Left para poder solo obtener la letra del HD
    Dim ApplicationPath As String
    ApplicationPath = Left$(App.Path, 2) & "\AO-Libre\"

    'Por que por culpa del UAC no permite editar archivos del server.
    If Dir(ApplicationPath, vbDirectory) = "" Then
        MkDir ApplicationPath
    End If

    'Creamos sub-carpeta de aplicacion
    ApplicationPath = ApplicationPath & SubDirectoryApp
    If Dir(ApplicationPath, vbDirectory) = "" Then
        MkDir ApplicationPath
    End If

    If NoInternetConnection = True Then
        Call addConsole("No hay conexion a internet/No Internet Connection", 255, 0, 0, True, False)
        Dim versionNumberLocal As String
        versionNumberLocal = GetVar(App.Path & "\ConfigAutoupdate.ini", ApplicationToUpdate, "version")
        
        If versionNumberLocal <> "v0" Then
            If MsgBox(Replace(JsonLanguage.Item("open_app"), "VAR_Program", ApplicationToUpdate), vbYesNo) = vbYes Then
                fileToExecuteAfterUpdated = GetVar(App.Path & "\ConfigAutoupdate.ini", ApplicationToUpdate, "fileToExecuteAfterUpdated")
                
                If LenB(SubDirectoryApp) > 0 Then
                    Call ShellExecute(Me.hWnd, "open", App.Path & "\" & SubDirectoryApp & "\" & fileToExecuteAfterUpdated, "", "", 1)
                Else
                    Call ShellExecute(Me.hWnd, "open", App.Path & "\" & fileToExecuteAfterUpdated, "", "", 1)
                End If
            End If
        End If
        
        Exit Sub
        
    End If
    
    If IsApplicationUpdated Then
    
        Call addConsole(JsonLanguage.Item("up_to_date"), 149, 100, 210, True, False)
    Else
        If MsgBox(JsonLanguage.Item("download_continue"), vbYesNo) = vbYes Then
            ProgressBar1.Visible = True
            
            Call addConsole(JsonLanguage.Item("starting"), 200, 200, 200, True, False)   '>> Informacion
            
            ProgressBar1.Max = JsonObject.Item("assets").Item(1).Item("size")
            SizeInMb = BytesToMegabytes(JsonObject.Item("assets").Item(1).Item("size"))
            
            InetGithubAutoupdate.AccessType = icUseDefault
            InetGithubAutoupdate.URL = JsonObject.Item("assets").Item(1).Item("browser_download_url")
            Directory = App.Path & "\Updates\" & JsonObject.Item("assets").Item(1).Item("name")
            bDone = False
            dError = False
                
            InetGithubAutoupdate.Execute , "GET"
            
            Do While bDone = False
                DoEvents
            Loop
                
            If dError Then Exit Sub
            
            Call addConsole(JsonLanguage.Item("one_more_moment"), 50, 90, 220, True, False)

            Call UnZip(Directory, ApplicationPath)
            Kill Directory
            
            Call WriteVar(App.Path & "\ConfigAutoupdate.ini", ApplicationToUpdate, "version", CStr(JsonObject.Item("tag_name")))
            
            Call addConsole(ApplicationToUpdate & JsonLanguage.Item("update_succesful"), 66, 255, 30, True, False)
            Call addConsole(JsonLanguage.Item("comments_update") & JsonObject.Item("body") & ".", 200, 200, 200, True, False)
            Call Reproducir_WAV(App.Path & "\Wav\Actualizado_" & JsonLanguage.Item("lang_abbreviation") & ".wav", SND_FILENAME)
            ProgressBar1.Value = 0
            
        ElseIf vbNo Then
            Call addConsole(JsonLanguage.Item("download_canceled"), 255, 0, 0, True, False)
            CancelUpdate = True
        End If
    End If
    
    If CancelUpdate = False Then
        If MsgBox(Replace(JsonLanguage.Item("open_app"), "VAR_Program", ApplicationToUpdate), vbYesNo) = vbYes Then
            fileToExecuteAfterUpdated = GetVar(App.Path & "\ConfigAutoupdate.ini", ApplicationToUpdate, "fileToExecuteAfterUpdated")
            
            If LenB(SubDirectoryApp) > 0 Then
                Call ShellExecute(Me.hWnd, "open", ApplicationPath & "\" & fileToExecuteAfterUpdated, "", "", 1)
            Else
                Call ShellExecute(Me.hWnd, "open", App.Path & "\" & fileToExecuteAfterUpdated, "", "", 1)
            End If
            
            'End
        End If
    End If

End Sub


Private Sub InetGithubAutoupdate_StateChanged(ByVal State As Integer)
    Dim Percentage As Long
    Select Case State
        Case icError
            Call addConsole(JsonLanguage.Item("error_connection"), 255, 0, 0, True, False)
            bDone = True
            dError = True
        Case icResponseCompleted
            Dim vtData As Variant
            Dim tempArray() As Byte
            Call addConsole(JsonLanguage.Item("download_started"), 100, 255, 130, True, False)
            
            Open Directory For Binary Access Write As #1
                vtData = InetGithubAutoupdate.GetChunk(1024, icByteArray)
                DoEvents
                
                Do While Not Len(vtData) = 0
                    tempArray = vtData
                    Put #1, , tempArray
                    
                    vtData = InetGithubAutoupdate.GetChunk(1024, icByteArray)

                    ProgressBar1.Value = ProgressBar1.Value + Len(vtData) * 2
                    
                    Percentage = (ProgressBar1.Value / ProgressBar1.Max) * 100
                    ProgressBar1.Text = "[" & Percentage & "% de " & SizeInMb & " MBs.]"
                    
                    DoEvents
                Loop
            Close #1
            
            Call addConsole(JsonLanguage.Item("download_finished"), 0, 255, 0, True, False)

            ProgressBar1.Value = 0
            
            bDone = True
        Case icRequesting
            'Call addConsole("Buscando ultima version disponible", 0, 76, 0, True, False)
        Case icConnecting
            'Call addConsole("Obteniendo numero de la ultima actualizacion ¯\_(O.O)_/¯", 0, 255, 0, True, False)
        Case 1 'icHostResolvingHost
            'Call addConsole("Resolviendo host... por favor espere", 0, 130, 0, True, False)
        Case icRequestSent
            'Call addConsole("Seguimos resolviendo host..", 110, 230, 20, True, False)
        Case icReceivingResponse
            'Call addConsole("Escuchamos una señal, vamos a comprobar que tengas la ultima version.", 100, 190, 200, True, False)
        Case icConnected
            'Call addConsole("Nos conectamos, ya vamos a empezar a bajar... paciencia =P ", 200, 90, 220, True, False)
        Case icResponseReceived
            'Call addConsole("Recibimos respuesta", 250, 140, 10, True, False)
        Case icHostResolved
            'Call addConsole("Lo hicimos resolvimos el host.", 110, 30, 20, True, False)
        Case Else
            Dim WebpageAolibre As String
            WebpageAolibre = GetVar(App.Path & "\ConfigAutoupdate.ini", "Links", "webpage")
            Call addConsole(JsonLanguage.Item("error_connection") & WebpageAolibre, 255, 0, 0, True, False)
    End Select
End Sub

Private Sub cmdSalir_Click()
    Unload Me
End Sub

Private Sub CMDSoundsFxs_Click()
    
    Dim Value As Boolean
        Value = CBool(GetVar(App.Path & "\" & ClientPath & "\INIT\Config.ini", "AUDIO", "SoundEffects"))
    
    If Value = 0 Then
        Call WriteVar(App.Path & "\" & ClientPath & "\INIT\Config.ini", "AUDIO", "SoundEffects", "TRUE")
    Else
        Call WriteVar(App.Path & "\" & ClientPath & "\INIT\Config.ini", "AUDIO", "SoundEffects", "FALSE")
    End If
    
End Sub

Private Sub CMDEffectSound_Click()
    
    Dim Value As Boolean
        Value = CBool(GetVar(App.Path & "\" & ClientPath & "\INIT\Config.ini", "AUDIO", "MUSIC"))
    
    If Value = 0 Then
        Call WriteVar(App.Path & "\" & ClientPath & "\INIT\Config.ini", "AUDIO", "Music", "TRUE")
    Else
        Call WriteVar(App.Path & "\" & ClientPath & "\INIT\Config.ini", "AUDIO", "Music", "FALSE")
    End If
    
End Sub

Private Sub CMDSombras_Click()
    
    Dim Value As Boolean
        Value = CBool(GetVar(App.Path & "\" & ClientPath & "\INIT\Config.ini", "VIDEO", "Sombras"))
    
    If Value = 0 Then
        Call WriteVar(App.Path & "\" & ClientPath & "\INIT\Config.ini", "VIDEO", "Sombras", "TRUE")
    Else
        Call WriteVar(App.Path & "\" & ClientPath & "\INIT\Config.ini", "VIDEO", "Sombras", "FALSE")
    End If
    
End Sub

Private Sub CMDParticulas_Click()
    
    Dim Value As Boolean
        Value = CBool(GetVar(App.Path & "\" & ClientPath & "\INIT\Config.ini", "VIDEO", "ParticleEngine"))
    
    If Value = 0 Then
        Call WriteVar(App.Path & "\" & ClientPath & "\INIT\Config.ini", "VIDEO", "ParticleEngine", "True")
    Else
        Call WriteVar(App.Path & "\" & ClientPath & "\INIT\Config.ini", "VIDEO", "ParticleEngine", "False")
    End If
    
End Sub

Private Sub CMDVSync_Click()
    
    Dim Value As Boolean
        Value = CBool(GetVar(App.Path & "\" & ClientPath & "\INIT\Config.ini", "VIDEO", "LimitarFPS"))
    
    If Value = 0 Then
        Call WriteVar(App.Path & "\" & ClientPath & "\INIT\Config.ini", "VIDEO", "LimitarFPS", "True")
    Else
        Call WriteVar(App.Path & "\" & ClientPath & "\INIT\Config.ini", "VIDEO", "LimitarFPS", "False")
    End If
    
End Sub

Private Sub LoadCheckboxesInitialStatus()
    
    Dim Value As Boolean

    Value = CBool(GetVar(App.Path & "\" & ClientPath & "\INIT\Config.ini", "VIDEO", "Sombras"))
    If Value = True Then
        CMDSombras.Checked = True
    End If

    Value = CBool(GetVar(App.Path & "\" & ClientPath & "\INIT\Config.ini", "VIDEO", "LimitarFPS"))
    If Value = True Then
        CMDVSync.Checked = True
    End If
    
    Value = CBool(GetVar(App.Path & "\" & ClientPath & "\INIT\Config.ini", "VIDEO", "ParticleEngine"))
    If Value = True Then
        CMDParticulas.Checked = True
    End If

    Value = CBool(GetVar(App.Path & "\" & ClientPath & "\INIT\Config.ini", "AUDIO", "SoundEffects"))
    If Value = True Then
        CMDSoundsFxs.Checked = True
    End If

    Value = CBool(GetVar(App.Path & "\" & ClientPath & "\INIT\Config.ini", "AUDIO", "Music"))
    If Value = True Then
        CMDEffectSound.Checked = True
    End If

End Sub

