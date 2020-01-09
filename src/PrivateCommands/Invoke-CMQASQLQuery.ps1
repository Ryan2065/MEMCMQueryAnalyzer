Function Invoke-CMQASQLQuery {
    Param(
        [string]$Query,
        [string]$Server,
        [string]$DatabaseName,
        [Hashtable]$QueryParameters
    )
    $Connection = New-Object -TypeName System.Data.SqlClient.SqlConnection
    $Connection.ConnectionString = "Server=$($Server);Database=$($DatabaseName);Integrated Security=True"
    $Connection.Open()
    $SqlCommand = New-Object -TypeName System.Data.SqlClient.SqlCommand -ArgumentList $Query, $Connection
    if($QueryParameters){
        foreach($key in $QueryParameters.Keys){
            $null = $SqlCommand.Parameters.AddWithValue($key, $QueryParameters[$key])
        }
    }
    $Reader = $SqlCommand.ExecuteReader()
    $AdditionalResults = $true
    while($AdditionalResults){
        while($Reader.HasRows){
            $DT = New-Object -TypeName System.Data.DataTable
            $DT.Load($Reader)
            $Dt
        }
        try{
            if(!$Reader.NextResult()){
                $AdditionalResults = $false
            }
        }
        catch{
            $AdditionalResults = $false
        }
    }
}