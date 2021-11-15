VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ZipExtractionClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'Actualizador By Ladder
'Echo en tan solo 2 dias. :P
'Recuerden esta frase que ami me sirvio de mucho "Si lo queres a tu manera, hacelo vos"
'Lo libero el 01/5/07
'Suerte para todos!
'Comentarios a pablito_3_15@hotmail.com
'Jessi te amo (l)

Option Explicit

Private fh As Long

Private Declare Function CopyMemory _
                Lib "kernel32" _
                Alias "RtlMoveMemory" (dest As Any, _
                                       src As Any, _
                                       ByVal length As Long) As Long

Private Declare Function lstrcpy _
                Lib "kernel32" _
                Alias "lstrcpyA" (ByVal lpBuffer As String, _
                                  ByVal lpString As Long) As Long

Private Declare Function lstrlen _
                Lib "kernel32" _
                Alias "lstrlenA" (ByVal lpString As Long) As Long

Private Declare Function ZLibVer Lib "zlib" Alias "zlibVersion" () As Long

Private Declare Function Compress _
                Lib "zlib.dll" _
                Alias "compress" (dest As Any, _
                                  destLen As Any, _
                                  src As Any, _
                                  ByVal srcLen As Long) As Long

Private Declare Function Compress2 _
                Lib "zlib.dll" _
                Alias "compress2" (dest As Any, _
                                   destLen As Any, _
                                   src As Any, _
                                   ByVal srcLen As Long, _
                                   ByVal Level As Long) As Long

Private Declare Function UnCompress _
                Lib "zlib.dll" _
                Alias "uncompress" (dest As Any, _
                                    destLen As Any, _
                                    src As Any, _
                                    ByVal srcLen As Long) As Long

Private Declare Function lCRC32 _
                Lib "zlib.dll" _
                Alias "crc32" (ByVal crc As Long, _
                               Buffer As Any, _
                               ByVal length As Long) As Long

Public Enum eZipError

    zeZLibNotInstalled = 1
    zeNotZipFile = 2
    zeNoOpenZipFile = 3
    zeUnsupportedCompressionMethod = 4
    zeChecksumError = 5
    zeFileNotFound = 10
    zeFileAlreadyExists = 11
    zeCantRemoveFile = 12
    zeCantCreateFolder = 13

End Enum

Private Type typCentralFileHeader

    CentralFileHeaderSigniature As Long
    VersionMadeBy As Integer
    VersionNeededToExtract As Integer
    GeneralPurposeBitFlag As Integer
    CompressionMethod As Integer
    LastModFileTime As Integer
    LastModFileDate As Integer
    CRC32 As Long
    CompressedSize As Long
    UnCompressedSize As Long
    FileNameLength As Integer
    ExtraFieldLength As Integer
    FileCommentLength As Integer
    DiskNumberStart As Integer
    InternalFileAttributes As Integer
    ExternalFileAttributes As Long
    RelativeOffsetOfLocalHeader As Long

End Type

Private Type typCenteralDirEnd

    EndOFCentralDirSignature As Long
    NumberOfThisDisk As Integer
    NumberOfDiskWithCentralDir As Integer
    EntriesInTheCentralDirThisOnDisk As Integer
    EntriesInTheCentralDir As Integer
    SizeOfCentralDir As Long
    OffSetOfCentralDir As Long
    ZipFileCommentLength As Integer

End Type

Private Type typLocalFileHeader

    LocalFileHeaderSignature As Long
    VersionNeededToExtract As Integer
    GeneralPurposeBitFlag As Integer
    CompressionMethod As Integer
    LastModFileTime As Integer
    LastModFileDate As Integer
    CRC32 As Long
    CompressedSize As Long
    UnCompressedSize As Long
    FileNameLength As Integer
    ExtraFieldLength As Integer

End Type

Private Const EndOFCentralDirSignature    As Long = &H6054B50

Private Const CentralFileHeaderSigniature As Long = &H2014B50

Private Const LocalFileHeaderSignature    As Long = &H4034B50

Private CentralFileHeader                 As typCentralFileHeader

Private CentralDirEnd                     As typCenteralDirEnd

Private CentralDirEndPos                  As Long

Public Event Progress(Percent As Long, Cancel As Boolean)

Public Event Status(Text As String)

Public Event ZipError(Number As eZipError, Description As String)

Public Function OpenZip(ZipPath As String) As Boolean

    RaiseEvent Status("Opening Zip")
    CloseZip

    If Not FileExists(ZipPath) Then
        RaiseEvent ZipError(zeFileNotFound, "The file " & ZipPath & " doesn't exist")
        Exit Function

    End If

    fh = FreeFile
    Open ZipPath For Binary As #fh
   
    CentralDirEndPos = GetCentralDirEndPos(fh)

    If CentralDirEndPos > 0 Then
        OpenZip = True
        RaiseEvent Status("Zip Opened")
    Else
        RaiseEvent ZipError(zeNotZipFile, "The file " & ZipPath & " is not a Zip file")

    End If
   
End Function

Public Sub CloseZip()

    If fh <> 0 Then
        Close #fh
        fh = 0
        RaiseEvent Status("Zip Closed")

    End If

    CentralDirEndPos = 0
   
End Sub

Public Function Extract(FolderPath As String, _
                        Optional PreservePath As Boolean, _
                        Optional Overwrite As Boolean) As Boolean

    Dim l        As Long

    Dim FileName As String

    Dim FilePos  As Long

    Dim Cancel   As Boolean
   
    If Len(ZLibVersion) = 0 Then
        Exit Function

    End If
   
    RaiseEvent Status("Extracting Files")
   
    If CentralDirEndPos = 0 Then
        RaiseEvent ZipError(zeNoOpenZipFile, "There is no Zip File Open")
        Exit Function

    End If
   
    If Not FolderExists(FolderPath) Then
        If Not CreateFolder(FolderPath) Then
            RaiseEvent ZipError(zeCantCreateFolder, "Can't create the folder " & FolderPath)
            Exit Function

        End If

    End If

    If ReadCentralDirEnd(CentralDirEndPos) Then
        Seek #fh, CentralDirEnd.OffSetOfCentralDir + 1

        For l = 1 To CentralDirEnd.EntriesInTheCentralDir
            ReadCentralFileHeader FileName

            If CentralFileHeader.UnCompressedSize > 0 Then
                If PreservePath Then
                    CheckFolder FolderPath, GetFilePath(FileName)
                Else
                    FileName = GetFileName(FileName)

                End If

                RaiseEvent Status("Extracting ...\" & FileName)
                FilePos = Seek(fh)

                If FileExists(FolderPath & "\" & FileName) Then
                    If Overwrite Then
                        If RemoveFile(FolderPath & "\" & FileName) Then
                            ExtractFile FolderPath & "\" & FileName
                        Else
                            RaiseEvent ZipError(zeCantRemoveFile, "Can't remove the file " & FolderPath & "\" & FileName)

                        End If

                    Else
                        RaiseEvent ZipError(zeFileAlreadyExists, "The file " & FolderPath & "\" & FileName & " already exists")

                    End If

                Else
                    ExtractFile FolderPath & "\" & FileName

                End If

                Seek fh, FilePos

            End If

            DoEvents
            RaiseEvent Progress((l / CentralDirEnd.EntriesInTheCentralDir) * 100, Cancel)

            If Cancel Then
                Exit Function

            End If

        Next
        Extract = True

    End If

    RaiseEvent Status("Extraction Complete")

End Function

Private Function GetFileName(Path As String) As String
   
    Dim l As Long
   
    l = InStrRev(Path, "\")

    If l > 0 Then
        GetFileName = Right$(Path, Len(Path) - l)
    Else
        GetFileName = Path

    End If
   
End Function

Private Function GetFilePath(Path As String) As String
   
    Dim l As Long
   
    l = InStrRev(Path, "\")

    If l > 0 Then
        GetFilePath = Left$(Path, l - 1)

    End If
   
End Function

Private Sub CheckFolder(ByVal FolderPath As String, CheckPath As String)

    Dim s() As String

    Dim v   As Variant
   
    s = Split(CheckPath, "\")

    For Each v In s

        FolderPath = FolderPath & "\" & v

        If Not FolderExists(FolderPath) Then
            MkDir FolderPath

        End If

    Next
   
End Sub

Private Sub ReadCentralFileHeader(FileName As String)

    Dim ExtraField As String

    Dim Comment    As String
   
    Get #fh, , CentralFileHeader

    If CentralFileHeader.CentralFileHeaderSigniature = CentralFileHeaderSigniature Then
        FileName = Space(CentralFileHeader.FileNameLength)
        Get #fh, , FileName
        FileName = Replace(FileName, "/", "\")
        ExtraField = Space(CentralFileHeader.ExtraFieldLength)
        Get #fh, , ExtraField
        Comment = Space(CentralFileHeader.FileCommentLength)
        Get #fh, , Comment

    End If

End Sub

Private Function ReadCentralDirEnd(Position As Long) As Boolean

    Dim l          As Long

    Dim ZipComment As String
   
    Get #fh, Position, CentralDirEnd
    ZipComment = Space(CentralDirEnd.ZipFileCommentLength)
    Get #fh, , ZipComment
   
    ReadCentralDirEnd = CentralDirEnd.NumberOfThisDisk = CentralDirEnd.NumberOfDiskWithCentralDir

End Function

Private Function ExtractFile(Path As String) As Boolean

    Dim LocalFileHeader As typLocalFileHeader

    Dim b()             As Byte

    Dim FileName        As String

    Dim ExtraField      As String

    Get #fh, CentralFileHeader.RelativeOffsetOfLocalHeader + 1, LocalFileHeader

    If LocalFileHeader.LocalFileHeaderSignature = LocalFileHeaderSignature Then
        FileName = Space(LocalFileHeader.FileNameLength)
        Get #fh, , FileName
        ExtraField = Space(LocalFileHeader.ExtraFieldLength)
        Get #fh, , ExtraField
        ReDim b(LocalFileHeader.CompressedSize - 1)
        Get #fh, , b

        If CentralFileHeader.CompressionMethod = 0 Then 'No Compression
            SaveFile Path, b
        ElseIf CentralFileHeader.CompressionMethod = 8 Then 'Deflate Method

            If UnCompressBytes(b, LocalFileHeader.CompressedSize, LocalFileHeader.UnCompressedSize, LocalFileHeader.CRC32) Then
                SaveFile Path, b
            Else
                RaiseEvent ZipError(zeChecksumError, "Data checksum error in " & Path)

            End If

        Else
            RaiseEvent ZipError(zeUnsupportedCompressionMethod, "The compression Method for " & FileName & " is unsupported")

        End If

    End If
   
End Function

Private Function FileExists(Path) As Boolean

    FileExists = Not (Len(Dir$(Path, vbNormal)) = 0)

End Function

Private Function FolderExists(Path) As Boolean

    FolderExists = Not (Len(Dir$(Path, vbDirectory)) = 0)

End Function

Private Function CreateFolder(Path As String) As Boolean

    On Error GoTo eh
   
    MkDir Path
    CreateFolder = True
   
eh:

End Function

Private Function RemoveFile(Path As String) As Boolean

    On Error GoTo eh
   
    Kill Path
    RemoveFile = True
   
eh:

End Function

Private Function GetCentralDirEndPos(fh As Long) As Long

    Dim Data() As Byte

    Dim l      As Long

    Dim m      As Long

    ReDim Data(LOF(fh) - 1)
    Get #fh, , Data
   
    For l = UBound(Data) - 3 To LBound(Data) Step -1
        CopyMemory m, Data(l), 4

        If m = EndOFCentralDirSignature Then
            GetCentralDirEndPos = l + 1
            Exit Function

        End If

    Next

End Function

Private Function UnCompressBytes(Buffer() As Byte, _
                                 CompressedSize As Long, _
                                 UnCompressedSize As Long, _
                                 CRC32 As Long) As Boolean
   
    Dim b()        As Byte

    Dim BufferSize As Long

    Dim FileSize   As Long
   
    Dim crc        As Long

    Dim fh         As Long

    Dim r          As Long

    ReDim b(UBound(Buffer) + 2)
   
    'Zlib's Uncompress method expects the 2 byte head that the Compress method adds
    'so we put that on first. Luckily it's always the same value.
    b(0) = 120
    b(1) = 156
    CopyMemory b(2), Buffer(0), UBound(Buffer) + 1

    FileSize = UBound(Buffer) + 3
    BufferSize = CentralFileHeader.UnCompressedSize * 1.01 + 12
    ReDim Buffer(BufferSize - 1) As Byte
   
    r = UnCompress(Buffer(0), BufferSize, b(0), FileSize)

    ReDim Preserve Buffer(CentralFileHeader.UnCompressedSize - 1)
    crc = lCRC32(0&, Buffer(0), UBound(Buffer) + 1)

    If crc = CRC32 Then
        UnCompressBytes = True

    End If

End Function

Private Sub SaveFile(Path As String, Data() As Byte)

    Dim lfh As Long
   
    lfh = FreeFile
    Open Path For Binary As #lfh
    Put #lfh, , Data
    Close #lfh

End Sub

Private Function PointerToString(Pointer As Long) As String

    Dim l As Long

    Dim s As String
   
    l = lstrlen(Pointer)
    s = Space(l)
    l = lstrcpy(s, Pointer)

    If l > 0 Then
        PointerToString = s

    End If
   
End Function

Public Property Get ZLibVersion() As String

    On Error GoTo eh
   
    ZLibVersion = PointerToString(ZLibVer)

    Exit Property
eh:

    RaiseEvent ZipError(zeZLibNotInstalled, "Zlib is not installed")

End Property

Private Sub Class_Terminate()

    CloseZip
   
End Sub
