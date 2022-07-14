Attribute VB_Name = "modCompression"
'*****************************************************************
'modCompression.bas - v1.0.0
'
'All methods to handle resource files
'
'*****************************************************************
'Respective portions copyrighted by contributors listed below.
'
'This library is free software; you can redistribute it and/or
'modify it under the terms of the GNU Lesser General Public
'License as published by the Free Software Foundation version 2.1 of
'the License
'
'This library is distributed in the hope that it will be useful,
'but WITHOUT ANY WARRANTY; without even the implied warranty of
'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
'Lesser General Public License for more details.
'
'You should have received a copy of the GNU Lesser General Public
'License along with this library; if not, write to the Free Software
'Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
'*****************************************************************

'*****************************************************************
'Contributors History
'   When releasing modifications to this source file please add your
'   date of release, name, email, and any info to the top of this list.
'   Follow this template:
'    XX/XX/200X - Your Name Here (Your Email Here)
'       - Your Description Here
'       Sub Release Contributors:
'           XX/XX/2003 - Sub Contributor Name Here (SC Email Here)
'               - SC Description Here
'*****************************************************************
'
' Alexis Caraballo (alexiscaraballo96@gmail.com) - 24/03/2021
'   - Password system
'
' Juan Mart�n Sotuyo Dodero (juansotuyo@hotmail.com) - 10/13/2004
'   - First Release
'*****************************************************************
Option Explicit
Private Declare Function GetDiskFreeSpace Lib "kernel32" Alias "GetDiskFreeSpaceExA" (ByVal lpRootPathName As String, FreeBytesToCaller As Currency, BytesTotal As Currency, FreeBytesTotal As Currency) As Long


'This structure will describe our binary file's
'size and number of contained files
Public Type FILEHEADER
    lngFileSize As Long                 'How big is this file? (Used to check integrity)
    intNumFiles As Integer              'How many files are inside?
    lngPassword As String * 32          'Integrity check
End Type

'This structure will describe each file contained
'in our binary file
Public Type INFOHEADER
    lngFileStart As Long            'Where does the chunk start?
    lngFileSize As Long             'How big is this chunk of stored data?
    strFileName As String * 32      'What's the name of the file this data came from?
    lngFileSizeUncompressed As Long 'How big is the file compressed
End Type

Public Enum resource_file_type
    Graphics
    Midi
    MP3
    Wav
    Scripts
    MiniMaps
    Interface
    Maps
    Patch
    InterfaceIngles
End Enum

Private Const GRAPHIC_PATH As String = "\Graficos\"
Private Const MIDI_PATH As String = "\Midi\"
Private Const MP3_PATH As String = "\Mp3\"
Private Const WAV_PATH As String = "\Wav\"
Private Const INTERFACE_PATH As String = "\Interface\"
Private Const SCRIPT_PATH As String = "\Init\"
Private Const PATCH_PATH As String = "\Patches\"
Private Const OUTPUT_PATH As String = "\Output\"
Private Const MAP_PATH As String = "\Mapas\"
Private Const MINIMAP_PATH As String = "\MiniMapas\"

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (ByRef destination As Any, ByRef source As Any, ByVal Length As Long)

Private Sub Compress_Data(ByRef Data() As Byte)
    Dim BufTemp() As Byte
    Dim iv() As Byte
    Dim key() As Byte
      key = cnvBytesFromHexStr("AB45456789ABCDEFA0E1D2C3B4A59666")
    iv = cnvBytesFromHexStr("FEDCAA9A76543A10FEDCBA9876543322")
    BufTemp = cipherEncryptBytes2(zlibDeflate(Data), key, iv, "Aes128/CFB/nopad")
    Data = BufTemp
End Sub

Private Sub Decompress_Data(ByRef Data() As Byte, ByVal OrigSize As Long)
    Dim BufTemp() As Byte
    Dim iv() As Byte
    Dim key() As Byte
      key = cnvBytesFromHexStr("AB45456789ABCDEFA0E1D2C3B4A59666")
    iv = cnvBytesFromHexStr("FEDCAA9A76543A10FEDCBA9876543322")
    BufTemp = cipherDecryptBytes2(Data, key, iv, "Aes128/CFB/nopad")
    Data = zlibInflate(BufTemp)
End Sub

Public Function Extract_All_Files(ByVal file_type As resource_file_type, ByVal resource_path As String, ByVal Passwd As String, Optional ByVal UseOutputFolder As Boolean = False) As Boolean
'*****************************************************************
'Author: Juan Mart�n Dotuyo Dodero
'Last Modify Date: 10/13/2004
'Extracts all files from a resource file
'*****************************************************************
    Dim LoopC As Long
    Dim SourceFilePath As String
    Dim OutputFilePath As String
    Dim SourceFile As Integer
    Dim SourceData() As Byte
    Dim FileHead As FILEHEADER
    Dim InfoHead() As INFOHEADER
    Dim Handle As Integer
    
'Set up the error handler
On Local Error GoTo ErrHandler
    
    Select Case file_type
        Case Graphics
            If UseOutputFolder Then
                SourceFilePath = resource_path & OUTPUT_PATH & "Graficos"
            Else
                SourceFilePath = resource_path & "\Graficos"
            End If
            OutputFilePath = resource_path & GRAPHIC_PATH
            
        Case Midi
            If UseOutputFolder Then
                SourceFilePath = resource_path & OUTPUT_PATH & "Midi"
            Else
                SourceFilePath = resource_path & "\MIDI"
            End If
            OutputFilePath = resource_path & MIDI_PATH
        
        Case MP3
            If UseOutputFolder Then
                SourceFilePath = resource_path & OUTPUT_PATH & "MP3"
            Else
                SourceFilePath = resource_path & "\MP3"
            End If
            OutputFilePath = resource_path & MP3_PATH
        
        Case Wav
            If UseOutputFolder Then
                SourceFilePath = resource_path & OUTPUT_PATH & "Sounds"
            Else
                SourceFilePath = resource_path & "\Sounds"
            End If
            OutputFilePath = resource_path & WAV_PATH
        
        Case Scripts
            If UseOutputFolder Then
                SourceFilePath = resource_path & OUTPUT_PATH & "init"
            Else
                SourceFilePath = resource_path & "\Init"
            End If
            OutputFilePath = resource_path & SCRIPT_PATH
        
        Case Interface
            If UseOutputFolder Then
                SourceFilePath = resource_path & OUTPUT_PATH & "Interface"
            Else
                SourceFilePath = resource_path & "\Interface\ES"
            End If
            OutputFilePath = resource_path & INTERFACE_PATH
        Case InterfaceIngles
            If UseOutputFolder Then
                SourceFilePath = resource_path & OUTPUT_PATH & "Interface"
            Else
                SourceFilePath = resource_path & "\Interface\EN"
            End If
            OutputFilePath = resource_path & INTERFACE_PATH
        
        Case Maps
            If UseOutputFolder Then
                SourceFilePath = resource_path & OUTPUT_PATH & "Mapas"
            Else
                SourceFilePath = resource_path & "\mapas"
            End If
            OutputFilePath = resource_path & MAP_PATH
            
        Case MiniMaps
            If UseOutputFolder Then
                SourceFilePath = resource_path & OUTPUT_PATH & "MiniMapas"
            Else
                SourceFilePath = resource_path & "\MiniMapas"
            End If
            OutputFilePath = resource_path & MINIMAP_PATH
            
        Case Else
            Exit Function
    End Select
    
    'Open the binary file
    SourceFile = FreeFile
    Open SourceFilePath For Binary Access Read Lock Write As SourceFile
    
    'Extract the FILEHEADER
    Get SourceFile, 1, FileHead

    'Check the file for validity
    If LOF(SourceFile) <> FileHead.lngFileSize Then
        MsgBox "Resource file " & SourceFilePath & " seems to be corrupted.", , "Error"
        Close SourceFile
        Erase InfoHead
        Exit Function
    End If

    ' Check password
    If LenB(Passwd) = 0 Then Passwd = "Contrase�a"
    
    Dim PasswordHash As String * 32
    PasswordHash = MD5String(Passwd)
    
    If PasswordHash <> FileHead.lngPassword Then
        MsgBox "Invalid password to decrypt the file.", , "Error"
        Close SourceFile
        Erase InfoHead
        Exit Function
    End If

    'Size the InfoHead array
    ReDim InfoHead(FileHead.intNumFiles - 1)
    
    'Extract the INFOHEADER
    Get SourceFile, , InfoHead
    
    frmBinary.ProgressBar1.max = UBound(InfoHead)
    'Extract all of the files from the binary file
    For LoopC = 0 To UBound(InfoHead)
        frmBinary.ProgressBar1.value = LoopC
        
        'Check if there is enough memory
        If InfoHead(LoopC).lngFileSizeUncompressed > General_Drive_Get_Free_Bytes(Left(App.Path, 3)) Then
            MsgBox "There is not enough free memory to continue extracting files."
            Exit Function
        End If
        
        'Resize the byte data array
        ReDim SourceData(InfoHead(LoopC).lngFileSize - 1)
        
        'Get the data
        Get SourceFile, InfoHead(LoopC).lngFileStart, SourceData
        
        'Decrypt data
        DoCrypt_Data SourceData, Passwd
        
        'Decompress all data
        Decompress_Data SourceData, InfoHead(LoopC).lngFileSizeUncompressed
        
        'Get a free handler
        Handle = FreeFile
        
        'Create a new file and put in the data
        Open OutputFilePath & InfoHead(LoopC).strFileName For Binary As Handle
        
        Put Handle, , SourceData
        
        Close Handle
        
        Erase SourceData
        
        DoEvents
    Next LoopC
    
    'Close the binary file
    Close SourceFile
    
    Erase InfoHead
    
    Extract_All_Files = True
Exit Function

ErrHandler:
    Close SourceFile
    Erase SourceData
    Erase InfoHead
    'Display an error message if it didn't work
    MsgBox "Unable to decode binary file. Reason: " & Err.Number & " : " & Err.Description, vbOKOnly, "Error"
End Function

Public Function Extract_Patch(ByVal resource_path As String, ByVal file_name As String, ByVal Passwd As String) As Boolean
'*****************************************************************
'Author: Juan Mart�n Dotuyo Dodero
'Last Modify Date: 10/13/2004
'Comrpesses all files to a resource file
'*****************************************************************
    Dim LoopC As Long
    Dim LoopC2 As Long
    Dim LoopC3 As Long
    Dim OutputFile As Integer
    Dim UpdatedFile As Integer
    Dim SourceFilePath As String
    Dim SourceFile As Integer
    Dim SourceData() As Byte
    Dim ResFileHead As FILEHEADER
    Dim ResInfoHead() As INFOHEADER
    Dim UpdatedInfoHead As INFOHEADER
    Dim FileHead As FILEHEADER
    Dim InfoHead() As INFOHEADER
    Dim RequiredSpace As Currency
    Dim FileExtension As String
    Dim DataOffset As Long
    Dim OutputFilePath As String
    
    'Done flags
    Dim bmp_done As Boolean
    Dim wav_done As Boolean
    Dim mid_done As Boolean
    Dim mp3_done As Boolean
    Dim exe_done As Boolean
    Dim gui_done As Boolean
    Dim ind_done As Boolean
    Dim dat_done As Boolean
    
    '************************************************************************************************
    'This is similar to Extract, but has some small differences to make sure what is being updated
    '************************************************************************************************
'Set up the error handler
On Local Error GoTo ErrHandler

    'Open the binary file
    SourceFile = FreeFile
    SourceFilePath = file_name
    Open SourceFilePath For Binary Access Read Lock Write As SourceFile

    'Extract the FILEHEADER
    Get SourceFile, 1, FileHead

    'Check the file for validity
    If LOF(SourceFile) <> FileHead.lngFileSize Then
        Exit Function
    End If

    ' Check password
    If LenB(Passwd) = 0 Then Passwd = "Contrase�a"

    Dim PasswordHash As String * 32
    PasswordHash = MD5String(Passwd)

    If PasswordHash <> FileHead.lngPassword Then
        Exit Function
    End If

    'Size the InfoHead array
    ReDim InfoHead(FileHead.intNumFiles - 1)

    'Extract the INFOHEADER
    Get SourceFile, , InfoHead

    'Check if there is enough hard drive space to extract all files
    For LoopC = 0 To UBound(InfoHead)
        RequiredSpace = RequiredSpace + InfoHead(LoopC).lngFileSizeUncompressed
    Next LoopC
    
    If RequiredSpace >= General_Drive_Get_Free_Bytes(Left(App.Path, 3)) Then
        Erase InfoHead
        MsgBox "�No hay espacio suficiente para extraer el archivo!", , "Error"
        Exit Function
    End If
    
    'Extract all of the files from the binary file
    For LoopC = 0 To UBound(InfoHead())
        'Check the extension of the file
        Select Case LCase(Right(Trim(InfoHead(LoopC).strFileName), 3))
            Case Is = "png"
                If bmp_done Then GoTo EndMainLoop
                FileExtension = "png"
                OutputFilePath = resource_path & "\Graficos"
                bmp_done = True
            Case Is = "mid"
                If mid_done Then GoTo EndMainLoop
                FileExtension = "mid"
                OutputFilePath = resource_path & "\MIDI"
                mid_done = True
            Case Is = "mp3"
                If mp3_done Then GoTo EndMainLoop
                FileExtension = "mp3"
                OutputFilePath = resource_path & "\MP3"
                mp3_done = True
            Case Is = "wav"
                If wav_done Then GoTo EndMainLoop
                FileExtension = "wav"
                OutputFilePath = resource_path & "\Sounds"
                wav_done = True
            Case Is = "bmp"
                If gui_done Then GoTo EndMainLoop
                FileExtension = "bmp"
                OutputFilePath = resource_path & "\Interface"
                gui_done = True
            Case Is = "ind"
                If ind_done Then GoTo EndMainLoop
                FileExtension = "ind"
                OutputFilePath = resource_path & "\Init"
                ind_done = True
            Case Is = "dat"
                If dat_done Then GoTo EndMainLoop
                FileExtension = "dat"
                OutputFilePath = resource_path & "\Init"
                dat_done = True
        End Select
        
        OutputFile = FreeFile
        Open OutputFilePath For Binary Access Read Lock Write As OutputFile
        
        'Get file header
        Get OutputFile, 1, ResFileHead
                
        'Resize the Info Header array
        ReDim ResInfoHead(ResFileHead.intNumFiles - 1)
        
        'Load the info header
        Get OutputFile, , ResInfoHead
                
        'Check how many of the files are new, and how many are replacements
        For LoopC2 = LoopC To UBound(InfoHead())
            If LCase$(Right$(Trim$(InfoHead(LoopC2).strFileName), 3)) = FileExtension Then
                'Look for same name in the resource file
                For LoopC3 = 0 To UBound(ResInfoHead())
                    If ResInfoHead(LoopC3).strFileName = InfoHead(LoopC2).strFileName Then
                        Exit For
                    End If
                Next LoopC3
                
                'Update the File Head
                If LoopC3 > UBound(ResInfoHead()) Then
                    'Update number of files and size
                    ResFileHead.intNumFiles = ResFileHead.intNumFiles + 1
                    ResFileHead.lngFileSize = ResFileHead.lngFileSize + Len(InfoHead(0)) + InfoHead(LoopC2).lngFileSize
                Else
                    'We substract the size of the old file and add the one of the new one
                    ResFileHead.lngFileSize = ResFileHead.lngFileSize - ResInfoHead(LoopC3).lngFileSize + InfoHead(LoopC2).lngFileSize
                End If
            End If
        Next LoopC2
        
        'Get the offset of the compressed data
        DataOffset = CLng(ResFileHead.intNumFiles) * Len(ResInfoHead(0)) + Len(FileHead) + 1
                
        'Now we start saving the updated file
        UpdatedFile = FreeFile
        Open OutputFilePath & "2" For Binary Access Write Lock Read As UpdatedFile
        
        'Store the filehead
        Put UpdatedFile, 1, ResFileHead
        
        'Start storing the Info Heads
        LoopC2 = LoopC
        For LoopC3 = 0 To UBound(ResInfoHead())
            Do While LoopC2 <= UBound(InfoHead())
                If LCase$(ResInfoHead(LoopC3).strFileName) < LCase$(InfoHead(LoopC2).strFileName) Then Exit Do
                If LCase$(Right$(Trim$(InfoHead(LoopC2).strFileName), 3)) = FileExtension Then
                    'Copy the info head data
                    UpdatedInfoHead = InfoHead(LoopC2)
                    
                    'Set the file start pos and update the offset
                    UpdatedInfoHead.lngFileStart = DataOffset
                    DataOffset = DataOffset + UpdatedInfoHead.lngFileSize
                                        
                    Put UpdatedFile, , UpdatedInfoHead
                    
                    DoEvents
                    
                End If
                LoopC2 = LoopC2 + 1
            Loop
            
            'If the file was replaced in the patch, we skip it
            If LoopC2 Then
                If LCase$(ResInfoHead(LoopC3).strFileName) <= LCase$(InfoHead(LoopC2 - 1).strFileName) Then GoTo EndLoop
            End If
            
            'Copy the info head data
            UpdatedInfoHead = ResInfoHead(LoopC3)
            
            'Set the file start pos and update the offset
            UpdatedInfoHead.lngFileStart = DataOffset
            DataOffset = DataOffset + UpdatedInfoHead.lngFileSize
                        
            Put UpdatedFile, , UpdatedInfoHead
EndLoop:
        Next LoopC3
        
        'If there was any file in the patch that would go in the bottom of the list we put it now
        For LoopC2 = LoopC2 To UBound(InfoHead())
            If LCase$(Right$(Trim$(InfoHead(LoopC2).strFileName), 3)) = FileExtension Then
                'Copy the info head data
                UpdatedInfoHead = InfoHead(LoopC2)
                
                'Set the file start pos and update the offset
                UpdatedInfoHead.lngFileStart = DataOffset
                DataOffset = DataOffset + UpdatedInfoHead.lngFileSize
                                
                Put UpdatedFile, , UpdatedInfoHead
            End If
        Next LoopC2
        
        'Now we start adding the compressed data
        LoopC2 = LoopC
        For LoopC3 = 0 To UBound(ResInfoHead())
            Do While LoopC2 <= UBound(InfoHead())
                If LCase$(ResInfoHead(LoopC3).strFileName) < LCase$(InfoHead(LoopC2).strFileName) Then Exit Do
                If LCase$(Right$(Trim$(InfoHead(LoopC2).strFileName), 3)) = FileExtension Then
                    'Get the compressed data
                    ReDim SourceData(InfoHead(LoopC2).lngFileSize - 1)
                    
                    Get SourceFile, InfoHead(LoopC2).lngFileStart, SourceData
                    
                    Put UpdatedFile, , SourceData
                End If
                LoopC2 = LoopC2 + 1
            Loop
            
            'If the file was replaced in the patch, we skip it
            If LoopC2 Then
                If LCase$(ResInfoHead(LoopC3).strFileName) <= LCase$(InfoHead(LoopC2 - 1).strFileName) Then GoTo EndLoop2
            End If
            
            'Get the compressed data
            ReDim SourceData(ResInfoHead(LoopC3).lngFileSize - 1)
            
            Get OutputFile, ResInfoHead(LoopC3).lngFileStart, SourceData
            
            Put UpdatedFile, , SourceData
EndLoop2:
        Next LoopC3
        
        'If there was any file in the patch that would go in the bottom of the lsit we put it now
        For LoopC2 = LoopC2 To UBound(InfoHead())
            If LCase$(Right$(Trim$(InfoHead(LoopC2).strFileName), 3)) = FileExtension Then
                'Get the compressed data
                ReDim SourceData(InfoHead(LoopC2).lngFileSize - 1)
                
                Get SourceFile, InfoHead(LoopC2).lngFileStart, SourceData
                
                Put UpdatedFile, , SourceData
            End If
        Next LoopC2
        
        'We are done updating the file
        Close UpdatedFile
        
        'Close and delete the old resource file
        Close OutputFile
        Kill OutputFilePath
        
        'Rename the new one
        Name OutputFilePath & "2" As OutputFilePath
        
        'Deallocate the memory used by the data array
        Erase SourceData
EndMainLoop:
    Next LoopC
    
    'Close the binary file
    Close SourceFile
    
    Erase InfoHead
    Erase ResInfoHead
    
    Extract_Patch = True
Exit Function

ErrHandler:
    Erase SourceData
    Erase InfoHead

End Function


Public Function Compress_Files(ByVal file_type As resource_file_type, ByVal resource_path As String, ByVal dest_path As String, ByVal Passwd As String) As Boolean
'*****************************************************************
'Author: Juan Mart�n Dotuyo Dodero
'Last Modify Date: 10/13/2004
'Comrpesses all files to a resource file
'*****************************************************************
    Dim SourceFilePath As String
    Dim SourceFileExtension As String
    Dim OutputFilePath As String
    Dim SourceFile As Long
    Dim OutputFile As Long
    Dim SourceFileName As String
    Dim SourceData() As Byte
    Dim FileHead As FILEHEADER
    Dim InfoHead() As INFOHEADER
    Dim FileNames() As String
    Dim lngFileStart As Long
    Dim LoopC As Long
    
'Set up the error handler
On Local Error GoTo ErrHandler
    
    Select Case file_type
        Case Graphics
            SourceFilePath = resource_path & GRAPHIC_PATH
            SourceFileExtension = ".png"
            OutputFilePath = dest_path & "Graficos"
        
        Case Midi
            SourceFilePath = resource_path & MIDI_PATH
            SourceFileExtension = ".mid"
            OutputFilePath = dest_path & "MIDI"
        
        Case MP3
            SourceFilePath = resource_path & MP3_PATH
            SourceFileExtension = ".mp3"
            OutputFilePath = dest_path & "MP3"
        
        Case Wav
            SourceFilePath = resource_path & WAV_PATH
            SourceFileExtension = ".wav"
            OutputFilePath = dest_path & "Sounds"
            
        Case Scripts
            SourceFilePath = resource_path & SCRIPT_PATH
            SourceFileExtension = ".*"
            OutputFilePath = dest_path & "Init"
        
        Case Patch
            SourceFilePath = resource_path & PATCH_PATH
            SourceFileExtension = ".*"
            OutputFilePath = dest_path & "Patch"
    
        Case Interface
            SourceFilePath = resource_path & INTERFACE_PATH
            SourceFileExtension = ".bmp"
            OutputFilePath = dest_path & "Interface"
            
        Case Maps
            SourceFilePath = resource_path & MAP_PATH
            SourceFileExtension = ".csm"
            OutputFilePath = dest_path & "Mapas"
            
        Case MiniMaps
            SourceFilePath = resource_path & MINIMAP_PATH
            SourceFileExtension = ".bmp"
            OutputFilePath = dest_path & "MiniMapas"
    
    End Select
    
    'Get first file in the directoy
    SourceFileName = Dir$(SourceFilePath & "*" & SourceFileExtension, vbNormal)
    
    SourceFile = FreeFile
    
    'Get all other files in the directory
    While SourceFileName <> ""
        FileHead.intNumFiles = FileHead.intNumFiles + 1
        
        ReDim Preserve FileNames(FileHead.intNumFiles - 1)
        FileNames(FileHead.intNumFiles - 1) = LCase(SourceFileName)
        
        'Search new file
        SourceFileName = Dir$()
    Wend
    
    'If we found none, be can't compress a thing, so we exit
    If FileHead.intNumFiles = 0 Then
        MsgBox "There are no files of extension " & SourceFileExtension & " in " & SourceFilePath & ".", , "Error"
        Exit Function
    End If
    
    'Sort file names alphabetically (this will make patching much easier).
    General_Quick_Sort FileNames(), 0, UBound(FileNames)
    
    'Resize InfoHead array
    ReDim InfoHead(FileHead.intNumFiles - 1)
        
    'Destroy file if it previuosly existed
    If Dir(OutputFilePath, vbNormal) <> "" Then
        Kill OutputFilePath
    End If
    
    ' Setup password
    If LenB(Passwd) = 0 Then Passwd = "Contrase�a"
    
    'Open a new file
    OutputFile = FreeFile
    Open OutputFilePath For Binary Access Read Write As OutputFile

    If Not (file_type = Patch) Then
        frmBinary.ProgressBar1.max = FileHead.intNumFiles - 1
    End If
    
    Dim IHead As Long

    For LoopC = 0 To FileHead.intNumFiles - 1
    
        If Not (file_type = Patch) Then
            frmBinary.ProgressBar1.value = LoopC
        End If
    
        'Find a free file number to use and open the file
        SourceFile = FreeFile
        Open SourceFilePath & FileNames(LoopC) For Binary Access Read Lock Write As SourceFile
        
        If LOF(SourceFile) > 0 Then
            'Store file name
            InfoHead(IHead).strFileName = FileNames(LoopC)
        
            'Find out how large the file is and resize the data array appropriately
            ReDim SourceData(LOF(SourceFile) - 1)
            
            'Store the value so we can decompress it later on
            InfoHead(IHead).lngFileSizeUncompressed = LOF(SourceFile)
            
            'Get the data from the file
            Get SourceFile, , SourceData
            
            'Compress it
            Compress_Data SourceData
            
            'Encription
            DoCrypt_Data SourceData, Passwd
            
            'Save it to a temp file
            Put OutputFile, , SourceData
            
            'Set up the file header
            FileHead.lngFileSize = FileHead.lngFileSize + UBound(SourceData) + 1
            
            'Set up the info headers
            InfoHead(IHead).lngFileSize = UBound(SourceData) + 1
            
            Erase SourceData
            
            IHead = IHead + 1
            
        Else
        
            FileHead.intNumFiles = FileHead.intNumFiles - 1
            
        End If
            
        'Close temp file
        Close SourceFile
            
        DoEvents
            
    Next LoopC
    
    ReDim Preserve InfoHead(FileHead.intNumFiles - 1)
    
    'Finish setting the FileHeader data
    FileHead.lngFileSize = FileHead.lngFileSize + CLng(FileHead.intNumFiles) * Len(InfoHead(0)) + Len(FileHead)
    
    'Password hash
    FileHead.lngPassword = MD5String(Passwd)

    'Set InfoHead data
    lngFileStart = Len(FileHead) + CLng(FileHead.intNumFiles) * Len(InfoHead(0)) + 1
    For LoopC = 0 To FileHead.intNumFiles - 1
        InfoHead(LoopC).lngFileStart = lngFileStart
        lngFileStart = lngFileStart + InfoHead(LoopC).lngFileSize
    Next LoopC
        
    '************ Write Data
    
    'Get all data stored so far
    ReDim SourceData(LOF(OutputFile) - 1)
    Seek OutputFile, 1
    Get OutputFile, , SourceData
    
    Seek OutputFile, 1
    
    'Store the data in the file
    Put OutputFile, , FileHead
    Put OutputFile, , InfoHead
    Put OutputFile, , SourceData
    
    'Close the file
    Close OutputFile
    
    Erase InfoHead
    Erase SourceData
Exit Function

ErrHandler:
    Erase SourceData
    Erase InfoHead
    'Display an error message if it didn't work
    MsgBox "Unable to create binary file. Reason: " & Err.Number & " : " & Err.Description, vbOKOnly, "Error"
End Function

Public Function Extract_File(ByVal file_type As resource_file_type, ByVal resource_path As String, ByVal file_name As String, ByVal OutputFilePath As String, ByVal Passwd As String, Optional ByVal UseOutputFolder As Boolean = False) As Boolean
'*****************************************************************
'Author: Juan Mart�n Dotuyo Dodero
'Last Modify Date: 10/13/2004
'Extracts all files from a resource file
'*****************************************************************
    Dim LoopC As Long
    Dim SourceFilePath As String
    Dim SourceData() As Byte
    Dim InfoHead As INFOHEADER
    Dim Handle As Integer
    
'Set up the error handler
On Local Error GoTo ErrHandler
    
    Select Case file_type
        Case Graphics
            If UseOutputFolder Then
                SourceFilePath = resource_path & OUTPUT_PATH & "Graficos"
            Else
                SourceFilePath = resource_path & "\Graficos"
            End If
            
        Case Midi
            If UseOutputFolder Then
                SourceFilePath = resource_path & OUTPUT_PATH & "MIDI"
            Else
                SourceFilePath = resource_path & "\MIDI"
            End If
        
        Case MP3
            If UseOutputFolder Then
                SourceFilePath = resource_path & OUTPUT_PATH & "MP3"
            Else
                SourceFilePath = resource_path & "\MP3"
            End If
        
        Case Wav
            If UseOutputFolder Then
                SourceFilePath = resource_path & OUTPUT_PATH & "Sounds"
            Else
                SourceFilePath = resource_path & "\Sounds"
            End If
        
        Case Scripts
            If UseOutputFolder Then
                SourceFilePath = resource_path & OUTPUT_PATH & "init"
            Else
                SourceFilePath = resource_path & "\init"
            End If
        
        Case Interface
            If UseOutputFolder Then
                SourceFilePath = resource_path & OUTPUT_PATH & "Interface"
            Else
                SourceFilePath = resource_path & "\Interface"
            End If
            
        Case Maps
            If UseOutputFolder Then
                SourceFilePath = resource_path & OUTPUT_PATH & "Mapas"
            Else
                SourceFilePath = resource_path & "\mapas"
            End If
            
        Case MiniMaps
            If UseOutputFolder Then
                SourceFilePath = resource_path & OUTPUT_PATH & "MiniMapas"
            Else
                SourceFilePath = resource_path & "\MiniMapas"
            End If
        
        Case Else
            Exit Function
    End Select
    
    'Find the Info Head of the desired file
    InfoHead = File_Find(SourceFilePath, file_name, Passwd)
    
    If InfoHead.strFileName = "" Or InfoHead.lngFileSize = 0 Then Exit Function

    'Open the binary file
    Handle = FreeFile
    Open SourceFilePath For Binary Access Read Lock Write As Handle

    'Make sure there is enough space in the HD
    If InfoHead.lngFileSizeUncompressed > General_Drive_Get_Free_Bytes(Left$(App.Path, 3)) Then
        Close Handle
        MsgBox "There is not enough drive space to extract the compressed file.", , "Error"
        Exit Function
    End If
    
    'Extract file from the binary file
    
    'Resize the byte data array
    ReDim SourceData(InfoHead.lngFileSize - 1)
    
    'Get the data
    Get Handle, InfoHead.lngFileStart, SourceData
    
    'Decrypt data
    DoCrypt_Data SourceData, Passwd
    
    'Decompress all data
    Decompress_Data SourceData, InfoHead.lngFileSizeUncompressed
    
    'Close the binary file
    Close Handle
    
    'Get a free handler
    Handle = FreeFile
    
    Open OutputFilePath & InfoHead.strFileName For Binary As Handle
    
    Put Handle, 1, SourceData
    
    Close Handle
    
    Erase SourceData
        
    Extract_File = True
Exit Function

ErrHandler:
    Close Handle
    Erase SourceData
    'Display an error message if it didn't work
    'MsgBox "Unable to decode binary file. Reason: " & Err.number & " : " & Err.Description, vbOKOnly, "Error"
End Function

Public Sub Delete_File(ByVal file_path As String)
'*****************************************************************
'Author: Juan Mart�n Dotuyo Dodero
'Last Modify Date: 3/03/2005
'Deletes a resource files
'*****************************************************************
    Dim Handle As Integer
    Dim Data() As Byte
    
    On Error GoTo Error_Handler
    
    'We open the file to delete
    Handle = FreeFile
    Open file_path For Binary Access Write Lock Read As Handle
    
    'We replace all the bytes in it with 0s
    ReDim Data(LOF(Handle) - 1)
    Put Handle, 1, Data
    
    'We close the file
    Close Handle
    
    'Now we delete it, knowing that if they retrieve it (some antivirus may create backup copies of deleted files), it will be useless
    Kill file_path
    
    Exit Sub
    
Error_Handler:
    Kill file_path
        
End Sub

Private Function File_Find(ByVal resource_file_path As String, ByVal file_name As String, ByVal Passwd As String) As INFOHEADER
'**************************************************************
'Author: Juan Mart�n Sotuyo Dodero
'Last Modify Date: 5/04/2005
'Looks for a compressed file in a resource file. Uses binary search ;)
'**************************************************************
On Error GoTo ErrHandler
    Dim max As Integer  'Max index
    Dim min As Integer  'Min index
    Dim mid As Integer  'Middle index
    Dim file_handler As Integer
    Dim file_head As FILEHEADER
    Dim info_head As INFOHEADER
    
    'Fill file name with spaces for compatibility
    If Len(file_name) < Len(info_head.strFileName) Then _
        file_name = file_name & Space$(Len(info_head.strFileName) - Len(file_name))
    
    'Open resource file
    file_handler = FreeFile
    Open resource_file_path For Binary Access Read Lock Write As file_handler
    
    'Get file head
    Get file_handler, 1, file_head
    
    ' Check password
    If LenB(Passwd) = 0 Then Passwd = "Contrase�a"
    
    Dim PasswordHash As String * 32
    PasswordHash = MD5String(Passwd)
    
    If PasswordHash <> file_head.lngPassword Then Exit Function
    
    min = 1
    max = file_head.intNumFiles
    
    Do While min <= max
        mid = (min + max) / 2
        
        'Get the info header of the appropiate compressed file
        Get file_handler, CLng(Len(file_head) + CLng(Len(info_head)) * CLng((mid - 1)) + 1), info_head
                
        If file_name < info_head.strFileName Then
            If max = mid Then
                max = max - 1
            Else
                max = mid
            End If
        ElseIf file_name > info_head.strFileName Then
            If min = mid Then
                min = min + 1
            Else
                min = mid
            End If
        Else
            'Copy info head
            File_Find = info_head
            
            'Close file and exit
            Close file_handler
            Exit Function
        End If
    Loop
    
ErrHandler:
    'Close file
    Close file_handler
    File_Find.strFileName = ""
    File_Find.lngFileSize = 0
End Function

Public Function General_Drive_Get_Free_Bytes(ByVal DriveName As String) As Currency
'**************************************************************
'Author: Juan Mart�n Sotuyo Dodero
'Last Modify Date: 6/07/2004
'
'**************************************************************
    Dim retval As Long
    Dim FB As Currency
    Dim BT As Currency
    Dim FBT As Currency
    
    retval = GetDiskFreeSpace(Left(DriveName, 2), FB, BT, FBT)
    
    General_Drive_Get_Free_Bytes = FB * 10000 'convert result to actual size in bytes
End Function


Public Sub General_Quick_Sort(ByRef SortArray As Variant, ByVal first As Long, ByVal last As Long)
'**************************************************************
'Author: juan Mart�n Sotuyo Dodero
'Last Modify Date: 3/03/2005
'Good old QuickSort algorithm :)
'**************************************************************
    Dim Low As Long, High As Long
    Dim temp As Variant
    Dim List_Separator As Variant
    
    Low = first
    High = last
    List_Separator = SortArray((first + last) / 2)
    Do While (Low <= High)
        Do While SortArray(Low) < List_Separator
            Low = Low + 1
        Loop
        Do While SortArray(High) > List_Separator
            High = High - 1
        Loop
        If Low <= High Then
            temp = SortArray(Low)
            SortArray(Low) = SortArray(High)
            SortArray(High) = temp
            Low = Low + 1
            High = High - 1
        End If
    Loop
    If first < High Then General_Quick_Sort SortArray, first, High
    If Low < last Then General_Quick_Sort SortArray, Low, last
End Sub

' WyroX: Encriptado casero. Funciona para encriptar y desencriptar (maravillas del Xor)
Private Sub DoCrypt_Data(Data() As Byte, ByVal Password As String)
    
    Dim i As Long, c As Integer
    
    ' Recorro todos los bytes haciendo Xor con la contrase�a, variando tambi�n el caracter elegido de la contrase�a
    
    c = UBound(Data) Mod Len(Password) + 1
    
    For i = LBound(Data) To UBound(Data)
        Data(i) = Data(i) Xor (Asc(mid$(Password, c, 1)) And &HFF)
        
        c = c - 1
        If c < 1 Then c = Len(Password)
    Next
    
End Sub
