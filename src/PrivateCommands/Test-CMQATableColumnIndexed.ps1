$Script:PrimaryIndexedColumns = New-Object System.Collections.Generic.List[object]
$Script:CASIndexedColumns = New-Object System.Collections.Generic.List[object]

$IndexedQuery = @'
SELECT 
     TableName = t.name,
     IndexName = ind.name,
     IndexId = ind.index_id,
     ColumnId = ic.index_column_id,
     ColumnName = col.name,
     ind.*,
     ic.*,
     col.* 
FROM 
     sys.indexes ind 
INNER JOIN 
     sys.index_columns ic ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
INNER JOIN 
     sys.columns col ON ic.object_id = col.object_id and ic.column_id = col.column_id 
INNER JOIN 
     sys.tables t ON ind.object_id = t.object_id 
'@

Function Test-CMQATableColumnIndexed{
    Param(
        [ref]$ColumnObject
    )
    if($Script:PrimaryIndexedColumns.Count -eq 0 -and ![string]::IsNullOrEmpty($Script:CMQASettings.PrimaryDBServer)) {
        $DBServer = $Script:CMQASettings.PrimaryDBServer
        $DBName = $Script:CMQASettings.PrimaryDBName
        $Results = $results = Invoke-CMQASQLQuery -Query $IndexedQuery -Server $DBServer -DatabaseName $DBName
        foreach($r in $Results){
            $PrimaryIndexedColumns.Add($r)
        }
    }
    if($Script:CASIndexedColumns.Count -eq 0 -and ![string]::IsNullOrEmpty($Script:CMQASettings.CASDBServer)){
        $DBServer = $Script:CMQASettings.CASDBServer
        $DBName = $Script:CMQASettings.CASDBName
        $Results = $results = Invoke-CMQASQLQuery -Query $IndexedQuery -Server $DBServer -DatabaseName $DBName
        foreach($r in $Results){
            $CASIndexedColumns.Add($r)
        }
    }
    foreach($instance in $Script:CASIndexedColumns){
        if($instance.TableName -eq $ColumnObject.Value.Table -and $instance.ColumnName -eq $ColumnObject.Value.TableColumnName){
            $ColumnObject.Value.IsIndexed = $true
            $ColumnObject.Value.IsIncludeIndex = $instance.Is_Include_Column
        }
    }
    foreach($instance in $Script:PrimaryIndexedColumns){
        if($instance.TableName -eq $ColumnObject.Value.Table -and $instance.ColumnName -eq $ColumnObject.Value.TableColumnName){
            $ColumnObject.Value.IsIndexed = $true
            $ColumnObject.Value.IsIncludeIndex = $instance.Is_Include_Column
        }
    }
}