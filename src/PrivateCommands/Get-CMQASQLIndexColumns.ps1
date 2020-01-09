Function Get-CMQASQLIndexColumns {
    Param(
        $ParsedObjects
    )
    $FoundFrom = $false
    $SkipTo = 0
    $AliasHash = @{}
    for($i = 0; $i -lt $ParsedObjects.count;$i++){
        if($ParsedObjects[$i].TokenId -eq 203){
            # 203 = AS, so it's x AS y and can then be looked up with AliasHash[y] which gives x
            $AliasHash[( $ParsedObjects[$i+1].String )] = $ParsedObjects[$i-1].String
        }
        if($true -eq $FoundFrom) {
            # Optimization from indexing happens best on joins or in the where clause
            if($ParsedObjects[$i].TokenId -eq 173 -and $ParsedObjects[$i-1].TokenId -eq 46 -and $ParsedObjects[$i+1] -ne 46){
                # if current object is type object (meaning Table/View, Column, Schema, Server, etc)
                # and if previous object is a period and the next object is NOT a period
                # Looking for patterns of:  <Table>.<Column>
                $Column = [QAQueryColumnsUsed]::new()
                $Column.ViewColumnName = $ParsedObjects[$i].String
                $Column.View = $AliasHash[$ParsedObjects[$i-2].String].String
                $Column.TableQueryAlias = $ParsedObjects[$i-2]
                if([string]::IsNullOrEmpty($Column.View)) {
                    $Column.View = $Column.TableQueryAlias
                }
                Write-Verbose 'test'
                Get-CMQATableFromView -ViewName $Column.View -ViewColumn $Column.ViewColumnName -ColumnObject ([ref]$Column)
                Test-CMQATableColumnIndexed -ColumnObject ([ref]$Column)
                $Column
            }
            
        }
        if($ParsedObjects[$i].TokenId -eq 244){
            $FoundFrom = $true
        }
        if($ParsedObjects[$i].TokenId -eq 288){
            $FoundFrom = $false
        }
    }

}