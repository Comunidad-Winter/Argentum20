Attribute VB_Name = "modCrafteos"

Option Explicit

Public Const MAX_SLOTS_CRAFTEO = 5

Public Sub SortIntegerArray(Data() As Integer, ByVal First As Integer, ByVal Last As Integer)
    
        On Error GoTo SortIntegerArray_Err:
    
        Dim Low As Integer, High As Integer
        Dim MidValue As Integer, Temp As Integer

100     Low = First
102     High = Last
104     MidValue = Data((First + Last) \ 2)
    
        Do
106         While Data(Low) < MidValue
108             Low = Low + 1
            Wend

110         While Data(High) > MidValue
112             High = High - 1
            Wend

114         If Low <= High Then
116             Temp = Data(Low)
118             Data(Low) = Data(High)
120             Data(High) = Temp
122             Low = Low + 1
124             High = High - 1
            End If
126     Loop While Low <= High

128     If First < High Then Call SortIntegerArray(Data, First, High)
130     If Low < Last Then Call SortIntegerArray(Data, Low, Last)
    
        Exit Sub
    
SortIntegerArray_Err:
132     Call TraceError(Err.Number, Err.Description, "modCrafteos.SortIntegerArray", Erl)
    
End Sub

Public Function GetRecipeKey(Data() As Integer) As String
    
        On Error GoTo GetRecipeKey_Err:
    
        Dim i As Integer
100     For i = LBound(Data) To UBound(Data)
102         GetRecipeKey = GetRecipeKey & Data(i) & ":"
        Next
    
        Exit Function
    
GetRecipeKey_Err:
104     Call TraceError(Err.Number, Err.Description, "modCrafteos.GetRecipeKey", Erl)
    
End Function

Public Sub ReturnCraftingItems(ByVal userindex As Integer)
    
        On Error GoTo ReturnCraftingItems_Err:
    
        Dim i As Integer, TmpObj As t_Obj

100     With UserList(userindex)

102         For i = 1 To UBound(.CraftInventory)
104             If .CraftInventory(i) <> 0 Then
106                 TmpObj.ObjIndex = .CraftInventory(i)
108                 TmpObj.amount = 1
            
110                 If Not MeterItemEnInventario(userindex, TmpObj) Then
112                     Call TirarItemAlPiso(.Pos, TmpObj)
                    End If
            
114                 .CraftInventory(i) = 0
                End If
            Next
        
116         If .CraftCatalyst.amount > 0 Then
118             If Not MeterItemEnInventario(userindex, .CraftCatalyst) Then
120                 Call TirarItemAlPiso(.Pos, .CraftCatalyst)
                End If
        
122             .CraftCatalyst.ObjIndex = 0
124             .CraftCatalyst.amount = 0
            End If

126         Set .CraftResult = Nothing

        End With
        
        Exit Sub
    
ReturnCraftingItems_Err:
128     Call TraceError(Err.Number, Err.Description, "modCrafteos.ReturnCraftingItems", Erl)
    
End Sub

Public Function CheckCraftingResult(ByVal userindex As Integer) As clsCrafteo
    
        On Error GoTo CheckCraftingResult_Err:
    
100     With UserList(userindex)
        
102         If Not Crafteos.Exists(.flags.Crafteando) Then Exit Function
        
            Dim CrafteosDeEsteTipo As Dictionary
104         Set CrafteosDeEsteTipo = Crafteos.Item(.flags.Crafteando)

            Dim Key As String
106         Key = GetRecipeKey(.CraftInventory)

108         If Not CrafteosDeEsteTipo.Exists(Key) Then Exit Function

110         Set CheckCraftingResult = CrafteosDeEsteTipo.Item(Key)

        End With

        Exit Function
    
CheckCraftingResult_Err:
112     Call TraceError(Err.Number, Err.Description, "modCrafteos.CheckCraftingResult", Erl)
    
End Function

Public Sub DoCraftItem(ByVal userindex As Integer)
    
        On Error GoTo DoCraftItem_Err:
    
100     With UserList(userindex)

102         If Not .CraftResult Is Nothing Then
104             If .CraftResult.Precio > .Stats.GLD Then
106                 Call WriteConsoleMsg(userindex, "No tienes el oro suficiente.", e_FontTypeNames.FONTTYPE_INFO)
                    ' TODO: Mensaje en la ventana de crafteo
                    Exit Sub
                End If

                Dim Porcentaje As Byte
108             Porcentaje = CalculateCraftProb(userindex, .CraftResult.Probabilidad)
            
110             If RandomNumber(1, 100) <= Porcentaje Then
                    Dim TmpObj As t_Obj
112                 TmpObj.ObjIndex = .CraftResult.Resultado
114                 TmpObj.amount = 1
                
116                 If Not MeterItemEnInventario(userindex, TmpObj) Then
118                     Call WriteConsoleMsg(userindex, "No tenés espacio suficiente en el inventario.", e_FontTypeNames.FONTTYPE_WARNING)
                        ' TODO: Mensaje en la ventana de crafteo
                        Exit Sub
                    End If
                
120                 Call WriteConsoleMsg(userindex, "La combinación ha sido exitosa.", e_FontTypeNames.FONTTYPE_INFO)
                    ' TODO: Mensaje en la ventana de crafteo y sonido (?
                Else
122                 Call WriteConsoleMsg(userindex, "La combinación ha fallado.", e_FontTypeNames.FONTTYPE_FIGHT)
                    ' TODO: Mensaje en la ventana de crafteo y sonido (?
                End If

124             .Stats.GLD = .Stats.GLD - .CraftResult.Precio
126             Call WriteUpdateGold(userindex)

                Dim i As Integer
128             For i = 1 To UBound(.CraftInventory)
130                 .CraftInventory(i) = 0
132                 Call WriteCraftingItem(userindex, i, 0)
                Next
            
134             .CraftCatalyst.amount = .CraftCatalyst.amount - 1
136             If .CraftCatalyst.amount <= 0 Then .CraftCatalyst.ObjIndex = 0

138             Call WriteCraftingCatalyst(userindex, .CraftCatalyst.ObjIndex, .CraftCatalyst.amount, 0)
            
140             Set .CraftResult = Nothing
142             Call WriteCraftingResult(userindex, 0)
            End If

        End With

        Exit Sub
    
DoCraftItem_Err:
144     Call TraceError(Err.Number, Err.Description, "modCrafteos.DoCraftItem", Erl)
    
End Sub

Public Function CalculateCraftProb(ByVal userindex As Integer, ByVal PorcentajeBase As Byte) As Byte
    
        On Error GoTo CalculateCraftProb_Err:
    
100     With UserList(userindex)

102         If .CraftCatalyst.ObjIndex <> 0 Then
104             If ObjData(.CraftCatalyst.ObjIndex).CatalizadorTipo = .flags.Crafteando Then
106                 CalculateCraftProb = Clamp(Fix(PorcentajeBase * (1 + ObjData(.CraftCatalyst.ObjIndex).CatalizadorAumento)), 0, 100)
                    Exit Function
                End If
            End If

108         CalculateCraftProb = PorcentajeBase
    
        End With

        Exit Function
    
CalculateCraftProb_Err:
110     Call TraceError(Err.Number, Err.Description, "modCrafteos.CalculateCraftProb", Erl)
    
End Function
