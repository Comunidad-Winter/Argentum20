Attribute VB_Name = "modPassword"
Option Explicit

Private Const PASS_SIZE = 200

Public Function GetPassword() As String
    Dim Data(1 To PASS_SIZE) As Byte
    
    Dim Handle As Integer
    Handle = FreeFile

    Open App.Path & "/../Recursos/OUTPUT/AO.bin" For Binary Access Read As #Handle
    
    Get #Handle, , Data
    
    Close #Handle
    
    Dim Length As Integer
    Length = Data(UBound(Data)) + Data(UBound(Data) - 1) * 256

    Dim i As Integer
    
    For i = 1 To Length
        GetPassword = GetPassword & Chr(Data(i * 3 - 1) Xor 37)
    Next
End Function

Public Sub SavePassword(Password As String)
    Dim RandomJunk As String
    RandomJunk = "c99b59c65a5501b5a19a5245d5db68c1af2831337f9f5191f792ae367484cdd51a50135229d79ea74550b3e7dad671a42154d50077b077f8dcd582cd0d7710c99b59c65a5501b5a19a5245d5db68c1af2831337f9f5191f792ae367484cdd51a50135229d79ea74550b3e7dad671a42154d50077b077f8dcd582cd0d7710"

    Dim Data(1 To PASS_SIZE) As Byte
    
    Dim i As Integer
    ' La contraseña intercalada con basura y xor 37
    For i = 1 To Len(Password)
        Data(i * 3 - 2) = Asc(mid(RandomJunk, i * 2 - 1, 1)) Xor 37
        Data(i * 3 - 1) = Asc(mid(Password, i, 1)) Xor 37
        Data(i * 3) = Asc(mid(RandomJunk, i * 2, 1)) Xor 37
    Next
    
    ' Basura hasta completar PASS_SIZE - 2 bytes
    For i = Len(Password) * 3 + 1 To UBound(Data) - 2
        Data(i) = Asc(mid(RandomJunk, ((i * 2) Mod Len(RandomJunk)) + 1, 1)) Xor 37
    Next
    
    ' 2 Bytes con la longitud de la password
    Data(UBound(Data) - 1) = Len(Password) \ 256
    Data(UBound(Data)) = Len(Password) And 255

    Dim Handle As Integer
    Handle = FreeFile

    Open frmBinary.OUTPUT_PATH & "AO.bin" For Binary Access Write As #Handle
    
    Put #Handle, , Data
    
    Close #Handle
End Sub
