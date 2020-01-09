Function Get-CMQAParsedSQLQuery {
    Param($QueryString)
    $ParseOptions = New-Object -TypeName Microsoft.SqlServer.Management.SqlParser.Parser.ParseOptions
    $ParseOptions.BatchSeparator = 'GO'
    $Parser = [Microsoft.SqlServer.Management.SqlParser.Parser.Scanner]::new($ParseOptions)
    $Parser.SetSource($QueryString,0)
    $Token = [Microsoft.Sqlserver.Management.SqlParser.Parser.Tokens]::TOKEN_SET
    $Start = 0
    $End = 0
    $State = 0
    $IsMatched = $false
    $IsExecAutoParamHelp = $false
    while( ( $Token = $Parser.GetNext([ref]$State, [ref]$Start, [ref]$End, [ref]$IsMatched, [ref]$IsExecAutoParamHelp) ) -ne [Microsoft.SqlServer.Management.SqlParser.Parser.Tokens]::EOF){
        $object = [QAParsedObject]::new()
        $object.TokenId = $Token
        $object.String = $QueryString.SubString($start, ($end-$Start)+1)
        try{
            $object.Token = [Microsoft.SqlServer.Management.SqlParser.Parser.Tokens]$Token
        }
        catch {  }
        $object
    }
}