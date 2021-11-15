Attribute VB_Name = "Module1"
Option Explicit
'--------------------------------------------
'Autor: Leandro Ascierto
'Web: www.leandroascierto.com.ar
'Date: 01/11/2009
'--------------------------------------------
Private Declare Function LoadLibrary Lib "kernel32" Alias "LoadLibraryA" (ByVal lpLibFileName As String) As Long
Private Declare Function FreeLibrary Lib "kernel32" (ByVal hLibModule As Long) As Long
Private Declare Function GetProcAddress Lib "kernel32" (ByVal hModule As Long, ByVal lpProcName As String) As Long
Private Declare Function GdiplusStartup Lib "gdiplus" (Token As Long, inputbuf As GdiplusStartupInput, Optional ByVal outputbuf As Long = 0) As Long
Private Declare Function GdipLoadImageFromFile Lib "GdiPlus.dll" (ByVal mFilename As Long, ByRef mImage As Long) As Long
Private Declare Function GdipDisposeImage Lib "gdiplus" (ByVal image As Long) As Long
Private Declare Sub GdiplusShutdown Lib "gdiplus" (ByVal Token As Long)
Private Declare Function GdipSaveImageToFile Lib "gdiplus" (ByVal image As Long, ByVal FileName As Long, ByRef clsidEncoder As GUID, ByRef encoderParams As Any) As Long
Private Declare Function CLSIDFromString Lib "ole32" (ByVal str As Long, id As GUID) As Long

Private Type GUID
    Data1           As Long
    Data2           As Integer
    Data3           As Integer
    Data4(0 To 7)   As Byte
End Type

Private Type EncoderParameter
    GUID            As GUID
    NumberOfValues  As Long
    type            As Long
    Value           As Long
End Type

Private Type EncoderParameters
    Count           As Long
    Parameter(15)   As EncoderParameter
End Type

Private Type GdiplusStartupInput
    GdiplusVersion           As Long
    DebugEventCallback       As Long
    SuppressBackgroundThread As Long
    SuppressExternalCodecs   As Long
End Type


Const ImageCodecBMP = "{557CF400-1A04-11D3-9A73-0000F81EF32E}"
Const ImageCodecJPG = "{557CF401-1A04-11D3-9A73-0000F81EF32E}"
Const ImageCodecGIF = "{557CF402-1A04-11D3-9A73-0000F81EF32E}"
Const ImageCodecTIF = "{557CF405-1A04-11D3-9A73-0000F81EF32E}"
Const ImageCodecPNG = "{557CF406-1A04-11D3-9A73-0000F81EF32E}"

Const EncoderQuality = "{1D5BE4B5-FA4A-452D-9CDD-5DB35105E7EB}"
Const EncoderCompression = "{E09D739D-CCD4-44EE-8EBA-3FBF8BE4FC58}"

Const TiffCompressionNone = 6
Const EncoderParameterValueTypeLong = 4

Public Function ConvertFileImage(ByVal SrcPath As String, ByVal DestPath As String, Optional ByVal JPG_Quality As Long = 85) As Boolean
                                 
    On Error Resume Next
    Dim GDIsi As GdiplusStartupInput, gToken As Long, hBitmap As Long
    Dim tEncoder  As GUID
    Dim tParams     As EncoderParameters
    Dim sExt        As String
    Dim lPos        As Long

    DestPath = Trim(DestPath)
        
    lPos = InStrRev(DestPath, ".")
    If lPos Then
        sExt = UCase(Right(DestPath, Len(DestPath) - lPos))
    End If
    Debug.Print sExt
    Select Case sExt
        Case "PNG"
            CLSIDFromString StrPtr(ImageCodecPNG), tEncoder

        Case "TIF", "TIFF"
            CLSIDFromString StrPtr(ImageCodecTIF), tEncoder
            
            With tParams
                .Count = 1
                .Parameter(0).NumberOfValues = 1
                .Parameter(0).type = EncoderParameterValueTypeLong
                .Parameter(0).Value = VarPtr(TiffCompressionNone)
                CLSIDFromString StrPtr(EncoderCompression), .Parameter(0).GUID
            End With
            
        Case "BMP", "DIB"
            CLSIDFromString StrPtr(ImageCodecBMP), tEncoder
        
        Case "GIF"
            CLSIDFromString StrPtr(ImageCodecGIF), tEncoder
        
        Case "JPG", "JPEG", "JPE", "JFIF"
            
            If JPG_Quality > 100 Then JPG_Quality = 100
            If JPG_Quality < 0 Then JPG_Quality = 0
            
            CLSIDFromString StrPtr(ImageCodecJPG), tEncoder
            
            With tParams
                .Count = 1
                .Parameter(0).NumberOfValues = 1
                .Parameter(0).type = EncoderParameterValueTypeLong
                .Parameter(0).Value = VarPtr(JPG_Quality)
                CLSIDFromString StrPtr(EncoderQuality), .Parameter(0).GUID
            End With

        Case Else
            Exit Function
            
    End Select

    GDIsi.GdiplusVersion = 1&
    
    GdiplusStartup gToken, GDIsi

    If gToken Then
  
        If GdipLoadImageFromFile(StrPtr(SrcPath), hBitmap) = 0 Then
    
            If GdipSaveImageToFile(hBitmap, StrPtr(DestPath), tEncoder, ByVal tParams) = 0 Then
                ConvertFileImage = True
            End If
            
            GdipDisposeImage hBitmap
    
        End If
    
        GdiplusShutdown gToken
    End If
    
End Function


Public Function IsGdiPlusInstaled() As Boolean
    Dim hLib As Long
    
    hLib = LoadLibrary("gdiplus.dll")
    If hLib Then
        If GetProcAddress(hLib, "GdiplusStartup") Then
            IsGdiPlusInstaled = True
        End If
        FreeLibrary hLib
    End If
    
End Function

