Attribute VB_Name = "dx_utils"
' Copyright (C) 2022  Pablo Marquez
'
'    This program is free software: you can redistribute it and/or modify
'    it under the terms of the GNU Affero General Public License as
'    published by the Free Software Foundation, either version 3 of the
'    License, or (at your option) any later version.
'
'    This program is distributed in the hope that it will be useful,
'    but WITHOUT ANY WARRANTY; without even the implied warranty of
'    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'    GNU Affero General Public License for more details.
'
'    You should have received a copy of the GNU Affero General Public License
'    along with this program.  If not, see <https://www.gnu.org/licenses/>.
    
Option Explicit

Public Sub list_modes(ByRef d3d As Direct3D8)
    Dim tmpDispMode As D3DDISPLAYMODE
    Dim i As Long
    For i = 0 To d3d.GetAdapterModeCount(0) - 1 'primary adapter
        Call d3d.EnumAdapterModes(0, i, tmpDispMode)
        Debug.Print tmpDispMode.Width & "x" & tmpDispMode.Height
    Next i
End Sub

Public Function init_dx_objects() As Long
On Error Resume Next
    
    Err.Clear
    Set DirectX = New DirectX8
    If Err.Number <> 0 Then
                Call MsgBox("Fatal error creating DirectX8 objetct", vbCritical, App.title)
                Debug.Print "Error Number Returned: " & Err.Number
                Exit Function
    End If
    
    Set DirectD3D = DirectX.Direct3DCreate()
    If Err.Number <> 0 Then
                Call MsgBox("Fatal error creating DirectD3D objetct", vbCritical, App.title)
                Debug.Print "Error Number Returned: " & Err.Number
                Exit Function
    End If
    
    Set DirectD3D8 = New D3DX8
    If Err.Number <> 0 Then
                Call MsgBox("Fatal error creating DirectD3D8 objetct", vbCritical, App.title)
                Debug.Print "Error Number Returned: " & Err.Number
                Exit Function
    End If
    init_dx_objects = Err.Number
    
End Function

Public Function init_dx_device() As Long
On Error Resume Next
    Dim Caps As D3DCAPS8
    Dim DevType As CONST_D3DDEVTYPE
    Dim DevBehaviorFlags As Long
    Dim d3dDispMode  As D3DDISPLAYMODE
    Err.Clear
    DirectD3D.GetDeviceCaps D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, Caps
    If Err.Number = D3DERR_NOTAVAILABLE Then
        Debug.Print "HAL Is Not available, using; software; vertex; processing"
        DevType = D3DDEVTYPE_REF
        DevBehaviorFlags = D3DCREATE_SOFTWARE_VERTEXPROCESSING
    Else
        DevType = D3DDEVTYPE_HAL
        Debug.Print "VertexProcessingCaps = " & Caps.VertexProcessingCaps
        If Caps.VertexProcessingCaps = 0 Then
            Debug.Print "HAL Is available, " & "Using; software; vertex; processing"
            DevBehaviorFlags = D3DCREATE_SOFTWARE_VERTEXPROCESSING
        ElseIf Caps.VertexProcessingCaps = &H4B Then
            Debug.Print "HAL Is available, " & "Using; hardware; vertex; processing; "
            DevBehaviorFlags = D3DCREATE_HARDWARE_VERTEXPROCESSING
        Else
            Debug.Print "HAL Is available, " & "Using; mixed; vertex; processing; "
            DevBehaviorFlags = D3DCREATE_MIXED_VERTEXPROCESSING
        End If
    End If
    DirectD3D.GetAdapterDisplayMode D3DADAPTER_DEFAULT, d3dDispMode

    Debug.Print "Using; Windowed; mode"
    D3DWindow.Windowed = 1
    D3DWindow.BackBufferWidth = 1024
    D3DWindow.BackBufferHeight = 768
    D3DWindow.SwapEffect = D3DSWAPEFFECT_DISCARD
    D3DWindow.BackBufferFormat = d3dDispMode.format
    D3DWindow.BackBufferCount = 1
    D3DWindow.hDeviceWindow = frmMain.renderer.hwnd
    D3DWindow.EnableAutoDepthStencil = 1
    D3DWindow.AutoDepthStencilFormat = D3DFMT_D16
    Err.Clear
    Set DirectDevice = DirectD3D.CreateDevice(D3DADAPTER_DEFAULT, DevType, frmMain.renderer.hwnd, DevBehaviorFlags, D3DWindow)
    Debug.Print "Create; Direct3D; device: ", Err
    init_dx_device = Err.Number

End Function






