Attribute VB_Name = "modWinFlot"
'Actualizador By Ladder
'Echo en tan solo 2 dias. :P
'Recuerden esta frase que ami me sirvio de mucho "Si lo queres a tu manera, hacelo vos"
'Lo libero el 01/5/07
'Suerte para todos!
'Comentarios a pablito_3_15@hotmail.com
'Jessi te amo (l)

Option Explicit

Public Declare Function SetWindowPos _
               Lib "USER32" (ByVal hwnd As Long, _
                             ByVal hWndInsertAfter As Long, _
                             ByVal X As Long, _
                             ByVal Y As Long, _
                             ByVal cx As Long, _
                             ByVal cy As Long, _
                             ByVal wFlags As Long) As Long

'primer plano
Public Const HWND_TOPMOST = -1

'estas dos últimas constantes son para que al ejecutar
'la funcion no varie su tamaño y posición
Public Const SWP_NOSIZE = &H1

Public Const SWP_NOMOVE = &H2

