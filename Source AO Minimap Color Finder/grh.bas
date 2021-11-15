Attribute VB_Name = "modGrh"
Option Explicit

Private Declare Function GetPixel Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long) As Long
Private Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long

Private Declare Function SelectObject Lib "gdi32" (ByVal hdc As Long, ByVal hObject As Long) As Long
Private Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hdc As Long) As Long
Private Declare Function DeleteDC Lib "gdi32" (ByVal hdc As Long) As Long
Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long

Public Type tGrhData
    sX As Integer
    sY As Integer
    FileNum As Long
    pixelWidth As Integer
    pixelHeight As Integer
    NumFrames As Integer
    Frames() As Long
    Speed As Single
    Active  As Boolean
End Type

Public Type tCabecera
    Desc As String * 255
    CRC As Long
    MagicWord As Long
End Type

Public Type tColor
    R As Long
    G As Long
    B As Long
End Type

Public GrhData() As tGrhData
Public grhCount As Long
Dim MiCabecera As tCabecera
Dim fileVersion As Long

Function LoadGrh() As Boolean
    Dim Grh As Long
    Dim frame As Long
    Dim handle As Integer
    
    handle = FreeFile
    frmMain.lblstatus.Visible = False
    frmMain.Command1.Enabled = False
    
    Open App.Path & "\..\recursos\INIT\Graficos.ind" For Binary Access Read Lock Write As handle
    
    Get handle, , MiCabecera
    Seek handle, 1
    Get handle, , fileVersion
    Get handle, , grhCount

    'Resize arrays
    ReDim GrhData(1 To grhCount) As tGrhData
    
    While Not EOF(handle)
        Get handle, , Grh
        If Grh <> 0 Then
            GrhData(Grh).Active = True
            With GrhData(Grh)
                Get handle, , .NumFrames
                ReDim .Frames(1 To GrhData(Grh).NumFrames)
                If .NumFrames > 1 Then
                    For frame = 1 To .NumFrames
                        Get handle, , .Frames(frame)
                    Next frame
                    Get handle, , .Speed
                    .pixelHeight = GrhData(.Frames(1)).pixelHeight
                    .pixelWidth = GrhData(.Frames(1)).pixelWidth
                Else
                    Get handle, , .FileNum
                    Get handle, , GrhData(Grh).sX
                    Get handle, , .sY
                    Get handle, , .pixelWidth
                    Get handle, , .pixelHeight
                    .Frames(1) = Grh
                End If
            End With
        End If
    Wend
    
    Close handle
    
    LoadGrh = True
    frmMain.lblstatus.Visible = True
    frmMain.Command1.Enabled = True

End Function

Function Grh_GetColor(ByVal grh_index As Long) As Long

On Error Resume Next
    
    Dim X As Long, Y As Long
    Dim file_path As String
    Dim hdcsrc As Long, OldObj As Long
    Dim R As Currency, B As Currency, G As Currency
    Dim InvalidPixels As Long, size As Long
    Dim TempColor As tColor
    Dim tempGetPixel As Long
    
    If grh_index = 0 Then Exit Function
    If GrhData(grh_index).NumFrames > 1 Then grh_index = GrhData(grh_index).Frames(1)
        
   ' file_path = App.Path & "\..\recursos\GRAFICOS\" & GrhData(grh_index).FileNum & ".png"
    
    If Not File_Exists(App.Path & "\temp\" & GrhData(grh_index).FileNum & ".jpg", vbNormal) Then
        Call ConvertFileImage(App.Path & "\..\recursos\GRAFICOS\" & GrhData(grh_index).FileNum & ".png", App.Path & "\temp\" & GrhData(grh_index).FileNum & ".jpg", 100)
        file_path = App.Path & "\temp\" & GrhData(grh_index).FileNum & ".jpg"
    Else
    Debug.Print "existia"
    file_path = App.Path & "\temp\" & GrhData(grh_index).FileNum & ".jpg"
    End If
    'Debug.Print file_path
    
    If File_Exists(file_path, vbNormal) Then
        hdcsrc = CreateCompatibleDC(frmMain.Picture1.hdc)
        OldObj = SelectObject(hdcsrc, LoadPicture(file_path))
        BitBlt frmMain.Picture1.hdc, 0, 0, GrhData(grh_index).pixelWidth, GrhData(grh_index).pixelHeight, hdcsrc, GrhData(grh_index).sX, GrhData(grh_index).sY, vbSrcCopy
        DeleteObject SelectObject(hdcsrc, OldObj)
        DeleteDC hdcsrc
        
        DoEvents
               
        For X = 1 To GrhData(grh_index).pixelWidth
            For Y = 1 To GrhData(grh_index).pixelHeight
                tempGetPixel = GetPixel(frmMain.Picture1.hdc, X, Y)
                If tempGetPixel = vbBlack Then
                    InvalidPixels = InvalidPixels + 1
                Else
                    TempColor = Long2RGB(tempGetPixel)
                    R = R + TempColor.R
                    G = G + TempColor.G
                    B = B + TempColor.B
                End If
                DoEvents
            Next Y
        Next X
        
        If InvalidPixels > 0 Then
            size = GrhData(grh_index).pixelWidth * GrhData(grh_index).pixelHeight - InvalidPixels
        Else
            size = GrhData(grh_index).pixelWidth * GrhData(grh_index).pixelHeight
        End If
        
        If size = 0 Then size = 1
        
        Grh_GetColor = RGB(CByte(R / size), CByte(G / size), CByte(B / size))
        frmMain.Picture2.BackColor = Grh_GetColor
        Dim bmpguardado As Integer
 Debug.Print GrhData(grh_index).FileNum
        If GrhData(grh_index + 1).FileNum <> GrhData(grh_index).FileNum Then
        Debug.Print GrhData(grh_index).FileNum
            Kill App.Path & "\temp\" & GrhData(grh_index).FileNum & ".jpg"
        End If
    End If
    

End Function

Private Function Long2RGB(ByVal Color As Long) As tColor
    Long2RGB.R = Color And &HFF
    Long2RGB.G = (Color And &HFF00&) \ &H100&
    Long2RGB.B = (Color And &HFF0000) \ &H10000
End Function

Public Function File_Exists(ByVal file_path As String, ByVal file_type As VbFileAttribute) As Boolean
    If Dir(file_path, file_type) = "" Then
        File_Exists = False
    Else
        File_Exists = True
    End If
End Function
