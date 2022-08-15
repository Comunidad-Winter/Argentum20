Attribute VB_Name = "Database"
Option Explicit

Private Database_Connection As ADODB.Connection
Private Command             As ADODB.Command
Public QueryData           As ADODB.Recordset
Private RecordsAffected     As Long

Private QueryBuilder        As cStringBuilder
Private ConnectedOnce       As Boolean

Public Sub Database_Connect()

        '************************************************************************************
        'Author: Juan Andres Dalmasso
        'Last Modification: 17/10/2020
        '21/09/2019 Jopi - Agregue soporte a conexion via DSN. Solo para usuarios avanzados.
        '17/10/2020 WyroX - Agrego soporte a multiples statements en la misma query
        '************************************************************************************
        On Error GoTo ErrorHandler

        Dim Database_DataSource As String
        Dim Database_Host As String
        Dim Database_Name As String
        Dim Database_Username As String
        Dim Database_Password As String

        Database_DataSource = GetVar(App.Path & "\..\re20-server\Database.ini", "DATABASE", "DSN")
        Database_Host = GetVar(App.Path & "\..\re20-server\Database.ini", "DATABASE", "Host")
        Database_Name = GetVar(App.Path & "\..\re20-server\Database.ini", "DATABASE", "Name")
        Database_Username = GetVar(App.Path & "\..\re20-server\Database.ini", "DATABASE", "Username")
        Database_Password = GetVar(App.Path & "\..\re20-server\Database.ini", "DATABASE", "Password")
 
100     Set Database_Connection = New ADODB.Connection
    
102     If Len(Database_DataSource) <> 0 Then
    
104         Database_Connection.ConnectionString = "DATA SOURCE=" & Database_DataSource & ";"
        
        Else
    
106         Database_Connection.ConnectionString = "DRIVER={MySQL ODBC 8.0 ANSI Driver};" & _
                                                   "SERVER=" & Database_Host & ";" & _
                                                   "DATABASE=" & Database_Name & ";" & _
                                                   "USER=" & Database_Username & ";" & _
                                                   "PASSWORD=" & Database_Password & ";" & _
                                                   "OPTION=3;MULTI_STATEMENTS=1"
                                               
        End If
    
108     Debug.Print Database_Connection.ConnectionString
    
110     Database_Connection.CursorLocation = adUseClient
    
112     Call Database_Connection.Open

114     ConnectedOnce = True

        Exit Sub
    
ErrorHandler:
116     Call LogDatabaseError("Database Error: " & Err.Number & " - " & Err.Description)
    
118     If Not ConnectedOnce Then
120         Call MsgBox("No se pudo conectar a la base de datos. Mas información en Errores.log", vbCritical, "OBDC - Error")
122         End
        End If

End Sub

Public Sub Database_Close()

        '***************************************************
        'Author: Juan Andres Dalmasso
        'Last Modification: 18/09/2018
        'Nota by WyroX: Cerrar la conexion tambien libera
        'los recursos y cierra los RecordSet generados
        '***************************************************
        On Error GoTo ErrorHandler
    
100     Set Command = Nothing
        
102     If Database_Connection.State <> adStateClosed Then
104         Call Database_Connection.Close
        End If
        
106     Set Database_Connection = Nothing
     
        Exit Sub
     
ErrorHandler:
108     'Call LogDatabaseError("Unable to close Mysql Database: " & Err.Number & " - " & Err.Description)

End Sub

Public Function MakeQuery(Query As String, ByVal NoResult As Boolean, ParamArray Query_Parameters() As Variant) As Boolean
        ' 17/10/2020 Autor: Alexis Caraballo (WyroX)
        ' Hace una unica query a la db. Asume una conexion.
        ' Si NoResult = False, el metodo lee el resultado de la query
        ' Guarda el resultado en QueryData
    
        On Error GoTo ErrorHandler
    
        'If frmMain.chkLogDbPerfomance.Value = 1 Then Call GetElapsedTime
        Dim Params As Variant

100     Set Command = New ADODB.Command
    
102     With Command

104         .ActiveConnection = Database_Connection
106         .CommandType = adCmdText
108         .NamedParameters = False
110         .CommandText = Query
        
112         If UBound(Query_Parameters) < 0 Then
114             Params = Null
            
            Else
                Params = Query_Parameters
                
                If IsArray(Query_Parameters(0)) Then
122                 Params = Query_Parameters(0)
                End If

                .Prepared = True
            End If

124         If NoResult Then
                Call .Execute(RecordsAffected, Params, adExecuteNoRecords)
            Else
128             Set QueryData = .Execute(RecordsAffected, Params)
    
130             If QueryData.BOF Or QueryData.EOF Then
132                 Set QueryData = Nothing
                End If
    
            End If
        
        End With
        'If frmMain.chkLogDbPerfomance.Value = 1 Then Call LogPerformance("Query: " & query & vbNewLine & " - Tiempo transcurrido: " & Round(GetElapsedTime(), 1) & " ms" & vbNewLine)
    
        Exit Function
    
ErrorHandler:

        Dim errNumber As Long, ErrDesc As String
134     errNumber = Err.Number
136     ErrDesc = Err.Description

138     If Not adoIsConnected(Database_Connection) Then
140        ' Call LogDatabaseError("Alerta en MakeQuery: Se perdió la conexión con la DB. Reconectando.")
142         Call Database_Connect
144         Resume
        
        Else
146         Call LogDatabaseError("Query = '" & Query & "'. " & errNumber & " - " & ErrDesc)

        End If

End Function

Function adoIsConnected(adoCn As ADODB.Connection) As Boolean

        '----------------------------------------------------------------
        '#PURPOSE: Checks whether the supplied db connection is alive and
        '          hasn't had it's TCP connection forcibly closed by remote
        '          host, for example, as happens during an undock event
        '#RETURNS: True if the supplied db is connected and error-free,
        '          False otherwise
        '#AUTHOR:  Belladonna
        '----------------------------------------------------------------

        ' No sacar
        On Error Resume Next

        Dim i As Long
        Dim cmd As New ADODB.Command

        'Set up SQL command to return 1
100     cmd.CommandText = "SELECT 1"
102     cmd.ActiveConnection = adoCn

        'Run a simple query, to test the connection
        
104     i = cmd.Execute.Fields(0)
        On Error GoTo 0

        'Tidy up
106     Set cmd = Nothing

        'If i is 1, connection is open
108     If i = 1 Then
110         adoIsConnected = True
        Else
112         adoIsConnected = False
        End If

End Function
