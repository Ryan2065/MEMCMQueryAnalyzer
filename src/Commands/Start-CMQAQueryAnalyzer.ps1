Function Start-CMQAQueryAnalyzer {
    Write-Progress "Getting Queries"
    $Queries = Get-CMQAQueries
    for ($i = 0; $i -lt $Queries.Count; $i++) {
        Write-Progress -Activity 'Processing queries' -PercentComplete ( ($i / $Queries.Count) * 100 )
        $query = $Queries[$i]
        $ParsedObjects = Get-CMQAParsedSQLQuery -QueryString $Query.QuerySQLString
        $Queries[$i].QueryColumnsThatShouldBeIndexed = Get-CMQASQLIndexColumns -ParsedObjects $ParsedObjects
        $Queries[$i].UsesAllIndexedColumns = $true
        foreach($instance in $Queries[$i].QueryColumnsThatShouldBeIndexed){
            if($false -eq $instance.IsIndexed){
                $Queries[$i].UsesAllIndexedColumns = $false
            }
        }
    }
    $Queries
}