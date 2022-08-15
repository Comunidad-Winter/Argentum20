Unicode true
;--------------------------------
;
; Instalador de Argentum Online
; creado por AlejoLp (alejolp@alejolp.com)
; y Maraxus (juansotuyo@gmail.com)
; Modificado por:
; Juan Andres Dalmasso (CHOTS) 
; y Lucas Recoaro (Recox)
; Para Argentum Online Libre
;
;--------------------------------


;--------------------------------
; Informacion basica del programa - Modificar estos strings para cada servidor
!define PRODUCT_NAME     "AO20"

!define GAME_CLIENT_FILE "Launcher\LauncherAO20.exe"
!define GAME_MANUAL_FILE "Manual.url"
!define WEBSITE          "https://ao20.com.ar"


; Folder in which the game files are stored (relative to script)
!define GAME_FILES       "Argentum20"

; Folder where the application executable is located (after installation)
!define CLIENT_FOLDER    "${GAME_FILES}\Cliente"

; Folder in which the dlls and ocx for the game are stored (relative to script)
!define DEPENDS_FOLDER   "dlls"

; Nombre del grupo de registros a crearse
!define AO_BASIC_REGKEY "AO20"

; Nombre del ejecutable que desinstalara la aplicacion
!define UNINSTALLER_NAME "uninstall.exe"

; Both icons MUST have the same size and depth!
!define APP_ICON         "install.ico"
!define APP_UNINST_ICON  "uninst.ico"


;Banner displayed on top during installation. MUST be a bmp.
!define INSTALL_BANNER   "logoao.bmp"


!define INCLUDE_CONFIGURE_APP "0"       ;Set it to 0 if no configuration program exists
!define CONFIGURE_APP "AOSetup.exe"     ;Name of the configuration program


!define INCLUDE_AUTOUPDATER_APP "0"              ;Set it to 0 if no auto-update program exists
!define AUTOUPDATER_APP "Autoupdate.exe"   ;Name of the auto-update program


!define INCLUDE_PASS_RECOVERY_APP "0"       ;Set it to 0 if no password recovery program exists
!define PASS_RECOVERY_APP "Recuperar.exe"   ;Name of the password recovery program

;--------------------------------
; De aca en mas no deberaas de tocar si no sabes lo que estas haciendo...


;--------------------------------
; Variables de uso frecuente

!define AO_INSTALLDIR_REGKEY "Software\${AO_BASIC_REGKEY}"
!define AO_UNISTALLER_REGKEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${AO_BASIC_REGKEY}"
!define AO_SM_FOLDER "${PRODUCT_NAME}"
!define AO_STARTMENU_FULL_DIR "$SMPROGRAMS\${AO_SM_FOLDER}"

!define GAME_LINK_FILE_NAME "${PRODUCT_NAME}.lnk"

!define INSTALL_DIR_REG_NAME "Install_Dir"

;--------------------------------
; Configuration

Name "${PRODUCT_NAME}"
OutFile "${PRODUCT_NAME}.exe"
InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"

; General

RequestExecutionLevel admin ;Require admin rights on NT6+ (When UAC is turned on)
CRCCheck force
SetOverwrite on
AutoCloseWindow false
ShowInstDetails show
ShowUninstDetails show
SetCompressor /SOLID lzma

;--------------------------------
; Header Files

!include LogicLib.nsh
!include MUI.nsh
!include Library.nsh

; Para las DLLs y OCXs
Var ALREADY_INSTALLED

; Para la creacion del grupo en el Menu de Inicio
Var START_MENU_FOLDER
Var MUI_TEMP

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM ${AO_INSTALLDIR_REGKEY} "${INSTALL_DIR_REG_NAME}"


;--------------------------------
;Interface Configuration

!define MUI_ICON "${APP_ICON}"
!define MUI_UNICON "${APP_UNINST_ICON}"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "${INSTALL_BANNER}"
!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_RUN "$INSTDIR\${GAME_CLIENT_FILE}"
!define MUI_FINISHPAGE_LINK "${WEBSITE}"
!define MUI_FINISHPAGE_LINK_LOCATION "${WEBSITE}"


;--------------------------------
; Pages for instalation

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_STARTMENU Application $START_MENU_FOLDER
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH


;--------------------------------
; Pages for uninstalation

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH


;--------------------------------
; Languages

!insertmacro MUI_LANGUAGE "Spanish"
!insertmacro MUI_LANGUAGE "English"


;--------------------------------
;Reserve Files

;If you are using solid compression, files that are required before
;the actual installation should be stored first in the data block,
;because this will make your installer start faster.

!insertmacro MUI_RESERVEFILE_LANGDLL


;--------------------------------
; Description of each component in each language

LangString ARGENTUM_DESC ${LANG_ENGLISH} "Basic client for ${PRODUCT_NAME}"
LangString ARGENTUM_DESC ${LANG_SPANISH} "Cliente basico de ${PRODUCT_NAME}"

LangString DESKTOP_LINK_DESC ${LANG_ENGLISH} "Adds a link to ${PRODUCT_NAME} in the Desktop"
LangString DESKTOP_LINK_DESC ${LANG_SPANISH} "Agrega un acceso directo a ${PRODUCT_NAME} en el Escritorio"

;--------------------------------
; Name of components that need to be translated

LangString DESKTOP_LINK_COMPONENT ${LANG_ENGLISH} "Create a link in the Desktop"
LangString DESKTOP_LINK_COMPONENT ${LANG_SPANISH} "Crear un acceso directo en el Escritorio"

;--------------------------------
; Tanslations of links

LangString UNINSTALL_LINK ${LANG_ENGLISH} "Uninstall ${PRODUCT_NAME}.lnk"
LangString UNINSTALL_LINK ${LANG_SPANISH} "Desinstalar ${PRODUCT_NAME}.lnk"

LangString CONFIGURATION_APP_LINK ${LANG_ENGLISH} "Configure ${PRODUCT_NAME}.lnk"
LangString CONFIGURATION_APP_LINK ${LANG_SPANISH} "Configurar ${PRODUCT_NAME}.lnk"

LangString AUTO_UPDATE_LINK ${LANG_ENGLISH} "Search for updates.lnk"
LangString AUTO_UPDATE_LINK ${LANG_SPANISH} "Buscar actualizaciones.lnk"

LangString PASS_RECOVERY_APP_LINK ${LANG_ENGLISH} "Recover password.lnk"
LangString PASS_RECOVERY_APP_LINK ${LANG_SPANISH} "Recuperar password.lnk"

;--------------------------------
; Licences for each language

LicenseLangString MUILicense ${LANG_ENGLISH} "license.txt"
LicenseLangString MUILicense ${LANG_SPANISH} "license-es.txt"


;--------------------------------
; Here starts the magic!

; The stuff to install
Section "${PRODUCT_NAME}" SEC_ARGENTUM

  SectionIn RO

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR

  ;--------------------------------------------------------------------
  ; *** Los archivos del juego ***

  File /r "${GAME_FILES}\*.*"
  
  ;--------------------------------------------------------------------
  ; Write the installation path into the registry
  WriteRegStr HKLM ${AO_INSTALLDIR_REGKEY} "${INSTALL_DIR_REG_NAME}" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "${AO_UNISTALLER_REGKEY}" "DisplayName" "${PRODUCT_NAME}"
  WriteRegStr HKLM "${AO_UNISTALLER_REGKEY}" "UninstallString" '"$INSTDIR\${UNINSTALLER_NAME}"'
  WriteRegDWORD HKLM "${AO_UNISTALLER_REGKEY}" "NoModify" 1
  WriteRegDWORD HKLM "${AO_UNISTALLER_REGKEY}" "NoRepair" 1
  
  WriteUninstaller "${UNINSTALLER_NAME}"

  Call CreateStartMenuGroup
SectionEnd

;--------------------------------
; C++ Runtime

Section "Visual Studio C++ Runtime"
  SectionIn RO
  SetOutPath "$INSTDIR"
  File "${DEPENDS_FOLDER}\VC_redist.x86.exe"
  ExecWait "$INSTDIR\VC_redist.x86.exe /install /quiet /norestart"
SectionEnd

;--------------------------------
; Optional section (can be disabled by the user)

Section "$(DESKTOP_LINK_COMPONENT)" SEC_DESKTOP_LINK
	
  SetOutPath "$INSTDIR\Launcher"
  CreateShortCut "$DESKTOP\${GAME_LINK_FILE_NAME}" "$INSTDIR\${GAME_CLIENT_FILE}" "" "$INSTDIR\${GAME_CLIENT_FILE}" 0

SectionEnd


;--------------------------------
; Uninstaller

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM "${AO_UNISTALLER_REGKEY}"
  DeleteRegKey HKLM "${AO_INSTALLDIR_REGKEY}"

  ; Remove game files
  Delete "$INSTDIR\*.*"

  ; Remove Start Menu shortcuts and folders, if any
  !insertmacro MUI_STARTMENU_GETFOLDER Application $MUI_TEMP

  Delete "$SMPROGRAMS\$MUI_TEMP\*.*"
  RMDir /r "$SMPROGRAMS\$MUI_TEMP"

  ; Remove Desktop shortcut, if any
  Delete "$DESKTOP\${GAME_LINK_FILE_NAME}"

  ; Remove directories used
  RMDir /r "$INSTDIR"

SectionEnd


;--------------------------------
; Install VB6 runtimes

Section "-Install VB6 runtimes"

  IfFileExists "$INSTDIR\${GAME_CLIENT_FILE}" 0 new_installation
    StrCpy $ALREADY_INSTALLED 1

  new_installation:

  ;--------------------------------
  ; Librerias COM usadas por la aplicación

  !insertmacro InstallLib REGDLL $ALREADY_INSTALLED REBOOT_PROTECTED \
     "${DEPENDS_FOLDER}\MSINET.OCX" "$SYSDIR\MSINET.OCX" "$TEMP"

  !insertmacro InstallLib REGDLL $ALREADY_INSTALLED REBOOT_PROTECTED \
     "${DEPENDS_FOLDER}\comctl32.ocx" "$SYSDIR\comctl32.ocx" "$TEMP"

  !insertmacro InstallLib REGDLL $ALREADY_INSTALLED REBOOT_PROTECTED \
     "${DEPENDS_FOLDER}\DX8VB.DLL" "$SYSDIR\DX8VB.DLL" "$TEMP"
	
  !insertmacro InstallLib REGDLL $ALREADY_INSTALLED REBOOT_PROTECTED \
     "${DEPENDS_FOLDER}\MSSTDFMT.DLL" "$SYSDIR\MSSTDFMT.DLL" "$TEMP"

  !insertmacro InstallLib REGDLL $ALREADY_INSTALLED REBOOT_PROTECTED \
     "${DEPENDS_FOLDER}\RICHTX32.OCX" "$SYSDIR\RICHTX32.OCX" "$TEMP"

  !insertmacro InstallLib REGDLL $ALREADY_INSTALLED REBOOT_PROTECTED \
     "${DEPENDS_FOLDER}\MSCOMCTL.OCX" "$SYSDIR\MSCOMCTL.OCX" "$TEMP"
     
SectionEnd

;--------------------------------
; Installer Functions

Function .onInit

    UserInfo::GetAccountType
    pop $0
    ${If} $0 != "admin" ;Require admin rights on NT4+
    	MessageBox mb_iconstop "Administrator rights required!"
     	SetErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
      	Quit
    ${EndIf}

  ; Make sure we request for the language
  !insertmacro MUI_LANGDLL_DISPLAY

FunctionEnd


;--------------------------------
; Uninstaller Functions

Function un.onInit

  ; Make sure we request for the language
  !insertmacro MUI_UNGETLANGUAGE

FunctionEnd


;----------------------------------------
; Create Start Menu group

Function CreateStartMenuGroup

    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application

    ;Create shortcuts
    CreateDirectory "${AO_STARTMENU_FULL_DIR}"

    CreateShortCut "${AO_STARTMENU_FULL_DIR}\$(UNINSTALL_LINK)" "$INSTDIR\${UNINSTALLER_NAME}" "" "$INSTDIR\${UNINSTALLER_NAME}" 0
	
	CreateShortCut "${AO_STARTMENU_FULL_DIR}\${GAME_LINK_FILE_NAME}" "$INSTDIR\${GAME_FILES}\${GAME_CLIENT_FILE}" "" "$INSTDIR\${GAME_FILES}\${GAME_CLIENT_FILE}" 0

    StrCmp ${INCLUDE_CONFIGURE_APP} "0" +2
      CreateShortCut "${AO_STARTMENU_FULL_DIR}\$(CONFIGURATION_APP_LINK)" "$INSTDIR\${CONFIGURE_APP}" "" "$INSTDIR\${CONFIGURE_APP}" 0

    StrCmp ${INCLUDE_AUTOUPDATER_APP} "0" +2
      CreateShortCut "${AO_STARTMENU_FULL_DIR}\$(AUTO_UPDATE_LINK)" "$INSTDIR\${AUTOUPDATER_APP}" "" "$INSTDIR\${AUTOUPDATER_APP}" 0

    StrCmp ${INCLUDE_PASS_RECOVERY_APP} "0" +2
      CreateShortCut "${AO_STARTMENU_FULL_DIR}\$(PASS_RECOVERY_APP_LINK)" "$INSTDIR\${PASS_RECOVERY_APP}" "" "$INSTDIR\${PASS_RECOVERY_APP}" 0

  !insertmacro MUI_STARTMENU_WRITE_END

FunctionEnd

;--------------------------------
; Section descriptions

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_ARGENTUM} "$(ARGENTUM_DESC)"
!insertmacro MUI_DESCRIPTION_TEXT ${SEC_DESKTOP_LINK} "$(DESKTOP_LINK_DESC)"
!insertmacro MUI_FUNCTION_DESCRIPTION_END
