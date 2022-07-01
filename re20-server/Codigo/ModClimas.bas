Attribute VB_Name = "ModClimas"

Public IntensidadDeNubes   As Byte

Public IntensidadDeLluvias As Byte

Public CapasLlueveEn       As Integer

Public TimerMeteorologico  As Byte

Public DuracionDeLLuvia    As Integer

Public ServidorNublado     As Boolean

Public ProbabilidadNublar  As Byte

Public ProbabilidadLLuvia  As Byte

Public Sub ResetMeteo()
        
        On Error GoTo ResetMeteo_Err
        
100     Call AgregarAConsola("Servidor > Meteorologia reseteada")
102     frmMain.TimerMeteorologia.Enabled = True
104     frmMain.Truenos.Enabled = False
106     TimerMeteorologico = 30
108     ServidorNublado = False
110     Lloviendo = False

        
        Exit Sub

ResetMeteo_Err:
112     Call TraceError(Err.Number, Err.Description, "ModClimas.ResetMeteo", Erl)

        
End Sub
