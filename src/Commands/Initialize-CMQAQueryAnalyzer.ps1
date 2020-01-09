Function Initialize-CMQAQueryAnalyzer{
    Param(
        [string]$PrimaryDBServer,
        [string]$PrimaryDBName,
        [string]$CASDBServer,
        [string]$CASDBName
    )
    $Script:CMQASettings = @{
        'PrimaryDBServer' = $PrimaryDBServer
        'PrimaryDBName' = $PrimaryDBName
        'CASDBServer' = $CASDBServer
        'CASDBName' = $CASDBName
    }
}