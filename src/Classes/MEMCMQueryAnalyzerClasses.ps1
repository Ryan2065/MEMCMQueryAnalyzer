Class QACollection {
    [string]$CollectionName
    [string]$CollectionId
    [double]$SecondsToEvaluateRules
}

Class QAQueryColumnsUsed {
    [string]$TableColumnName
    [string]$Table
    [string]$View
    [string]$ViewColumnName
    [string]$TableQueryAlias
    [bool]$IsIndexed
    [bool]$IsIncludeIndex
}

Class QAQuery {
    [QACollection]$Collection
    [string]$QueryName
    [string]$QuerySQLString
    [QAQueryColumnsUsed[]]$QueryColumnsThatShouldBeIndexed
    [bool]$UsesAllIndexedColumns
    [bool]$WildCardsNotUsedPoorly
}

Class QAParsedObject {
    [Microsoft.SqlServer.Management.SqlParser.Parser.Tokens]$Token
    [int]$TokenId
    [string]$String
}