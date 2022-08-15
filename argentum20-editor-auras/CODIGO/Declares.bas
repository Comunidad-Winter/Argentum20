Attribute VB_Name = "Mod_Declaraciones"
Option Explicit
Public DataChanged As Boolean
Public CurStreamFile As String
Public GraficosTotales As Long


Public body As Boolean

Public DirGraficos As String
Public DirInits As String

Public AuraFile As String


Public NumAuras As Byte
'RGB Type
Public Type RGB
    r As Long
    g As Long
    b As Long
End Type
Public AuraData(1) As tIndiceAura

Public Type tIndiceAura
    Name As String
    aura As Long
    OffsetX As Integer
    OffsetY As Integer
    color As RGB
    colorlng As String
End Type



''
'The main timer of the game.
Public MainTimer As New clsTimer

Public Previa As Integer





Public NoRes As Boolean 'no cambiar la resolucion









Public Connected As Boolean 'True when connected to server


'Control
Public prgRun As Boolean 'When true the program ends



'
'********** FUNCIONES API ***********
'

Public Declare Function GetTickCount Lib "kernel32" () As Long

'para escribir y leer variables
Public Declare Function writeprivateprofilestring Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationname As String, ByVal lpKeyname As Any, ByVal lpString As String, ByVal lpFileName As String) As Long
Public Declare Function getprivateprofilestring Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationname As String, ByVal lpKeyname As Any, ByVal lpdefault As String, ByVal lpreturnedstring As String, ByVal nsize As Long, ByVal lpFileName As String) As Long

'Teclado
Public Declare Function GetKeyState Lib "user32" (ByVal nVirtKey As Long) As Integer
Public Declare Function GetAsyncKeyState Lib "user32" (ByVal nVirtKey As Long) As Integer

Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

'Para ejecutar el Internet Explorer para el manual
Public Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hWnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long


