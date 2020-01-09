$null = [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.Management.SqlParser')

$Classes = Get-ChildItem -Path "$PSScriptRoot\Classes" -Filter '*.ps1'

Foreach($ClassFile in $Classes){
    . $ClassFile.FullName
}

$PrivateCommands = Get-ChildItem -Path "$PSScriptRoot\PrivateCommands" -Filter '*.ps1'

Foreach($PrivateCommandFile in $PrivateCommands){
    . $PrivateCommandFile.FullName
}

$Commands = Get-ChildItem -Path "$PSScriptRoot\Commands" -Filter '*.ps1'

Foreach($CommandFile in $Commands){
    . $CommandFile.FullName
}

Export-ModuleMember -Function $Commands.BaseName
