$CMQAQueryString = @"
WITH CTE AS (
    SELECT
        T2.CollectionName
        ,MAX(T2.SiteID) AS 'CollectionId'
        ,MAX(CAST(T1.EvaluationLength AS FLOAT)/1000) AS 'TimeSpentOnEvaluation'
    FROM Collections_L AS T1 WITH (nolock)
    INNER JOIN Collections_G AS T2 WITH (nolock) ON T2.CollectionId = T1.CollectionId
    GROUP BY T2.CollectionName, T2.CollectionId
)
SELECT
    CTE.CollectionId
    ,CTE.CollectionName
    ,CTE.TimeSpentOnEvaluation
    ,q.RuleName
    ,q.QueryExpression
FROM
    v_CollectionRuleQuery q
    LEFT JOIN CTE ON CTE.CollectionId = q.CollectionId
"@

Function Get-CMQAQueries{
    $DBServer = $Script:CMQASettings.CASDBServer
    $DBName = $Script:CMQASettings.CASDBName
    if([string]::IsNullOrEmpty($DBServer)){
        $DBServer = $Script:CMQASettings.PrimaryDBServer
        $DBName = $Script:CMQASettings.PrimaryDBName
    }
    $results = Invoke-CMQASQLQuery -Query $CMQAQueryString -Server $DBServer -DatabaseName $DBName
    foreach($query in $results){
        $NewQueryObject = [QAQuery]::new()
        $NewCollectionObject = [QACollection]::new()
        $NewCollectionObject.CollectionName = $Query.CollectionName
        $NewCollectionObject.CollectionId = $Query.CollectionId
        $NewCollectionObject.SecondsToEvaluateRules = $Query.TimeSpentOnEvaluation
        $NewQueryObject.Collection = $NewCollectionObject
        $NewQueryObject.QueryName = $Query.RuleName
        $NewQueryObject.QuerySQLString = $Query.QueryExpression
        $NewQueryObject
    }
}