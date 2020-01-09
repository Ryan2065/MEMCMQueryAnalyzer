Import-Module "$PSSCriptRoot\MEMCMQueryAnlayzer.psm1" -Force

Initialize-CMQAQueryAnalyzer -PrimaryDBServer 'Lab-CM.Home.Lab' -PrimaryDBName 'CM_PS1'

$r = Start-CMQAQueryAnalyzer

