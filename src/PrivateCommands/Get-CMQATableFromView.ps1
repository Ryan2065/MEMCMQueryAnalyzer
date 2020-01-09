$Script:PrimaryViewToTableSchemaArray = New-Object System.Collections.Generic.List[object]
$Script:CASViewToTableSchemaArray = New-Object System.Collections.Generic.List[object]
Function Get-CMQATableFromView {
    [CmdletBinding()]
    Param(
        [string]$ViewName,
        [string]$ViewColumn,
        [ref]$ColumnObject
    )
    if($Script:PrimaryViewToTableSchemaArray.Count -eq 0 -and ![string]::IsNullOrEmpty($Script:CMQASettings.PrimaryDBServer)) {
        $DBServer = $Script:CMQASettings.PrimaryDBServer
        $DBName = $Script:CMQASettings.PrimaryDBName
        $Results = $results = Invoke-CMQASQLQuery -Query 'SELECT * FROM INFORMATION_SCHEMA.VIEW_COLUMN_USAGE' -Server $DBServer -DatabaseName $DBName
        foreach($r in $Results){
            $PrimaryViewToTableSchemaArray.Add($r)
        }
    }
    if($Script:CASViewToTableSchemaArray.Count -eq 0 -and ![string]::IsNullOrEmpty($Script:CMQASettings.CASDBServer)){
        $DBServer = $Script:CMQASettings.CASDBServer
        $DBName = $Script:CMQASettings.CASDBName
        $Results = $results = Invoke-CMQASQLQuery -Query 'SELECT * FROM INFORMATION_SCHEMA.VIEW_COLUMN_USAGE' -Server $DBServer -DatabaseName $DBName
        foreach($r in $Results){
            $CASViewToTableSchemaArray.Add($r)
        }
    }
    if($Script:CASViewToTableSchemaArray.Count -gt 0){
        foreach($result in $Script:CASViewToTableSchemaArray){
            if($result.VIEW_NAME -eq $ViewName -and $result.COLUMN_NAME -eq $ViewColumn){
                $ColumnObject.Value.Table = $result.TABLE_NAME
                $ColumnObject.Value.TableColumnName = $result.COLUMN_NAME
            }
        }
    }
    if($Script:PrimaryViewToTableSchemaArray.Count -gt 0 -and [string]::IsNullOrEmpty($ColumnObject.Value.Table)){
        foreach($result in $Script:PrimaryViewToTableSchemaArray){
            if($result.VIEW_NAME -eq $ViewName -and $result.COLUMN_NAME -eq $ViewColumn){
                $ColumnObject.Value.Table = $result.TABLE_NAME
                $ColumnObject.Value.TableColumnName = $result.COLUMN_NAME
            }
        }
    }
    if([string]::IsNullOrEmpty($ColumnObject.Value.Table)){
        $ColumnObject.Value.Table = $ViewName
        $ColumnObject.Value.TableColumnName = $ViewColumn
    }
}