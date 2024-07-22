$xml = ""
$Usuario = ""
$Dominio = ""
$Source = ""
$SID = ""
$TipoObjeto = ""
# Adicione os SIDs dos grupos aqui
$sidArray = @(
    "S-1-5-32-544",  # Administradores
    "S-1-5-32-555",  # Usuários da área de trabalho remota
    "S-1-5-32-556",  # Operadores de configuração de rede
    "S-1-5-32-580"   # Usuários de Gerenciamento Remoto
)
$xml += "<WINGROUPS>`n"
foreach ($sid in $sidArray) {
    [string]$groupName = (Get-LocalGroup -SID $sid).Name
    $group = [ADSI]"WinNT://$env:COMPUTERNAME/$groupName"
    $members = $group.Invoke('Members') | ForEach-Object {
        $path = ([ADSI]$_).Path
        if ($path -like "WinNT://S-1-12-1-*") {
            $Source = 'Azure AD'
            $Usuario = $path -replace '^WinNT://'
            $Dominio = "Azure AD"
            $SID = $path -replace '^WinNT://'
            $TipoObjeto = "User"
        } else {
            $objUser = New-Object System.Security.Principal.NTAccount($([ADSI]$_).Name)
            $SID = ($objUser.Translate([System.Security.Principal.SecurityIdentifier])).Value
            $Dominio = $(Split-Path (Split-Path $path) -Leaf)
            $Usuario = $([ADSI]$_).Name
            $TipoObjeto = $([ADSI]$_).Class
            if ($Dominio -eq "MATEUS") {
                $Source = "AD"
            } else {
                $Source = "Local"
            }
        }

        [pscustomobject]@{
            Computer = $env:COMPUTERNAME
            Domain = $Dominio
            User = $Usuario
            Type = $TipoObjeto
            SID = $SID
            Source = $Source
        }
    }

    foreach ($member in $members) {
        $xml += "    <GROUPNAME>" + $groupName + "</GROUPNAME>`n"
        $xml += "    <NAME>" + $member.User + "</NAME>`n"
        $xml += "    <TYPE>" + $member.Type + "</TYPE>`n"
        $xml += "    <SOURCE>" + $member.Source + "</SOURCE>`n"
        $xml += "    <SID>" + $member.SID + "</SID>`n"
    }
}
$xml += "</WINGROUPS>`n"

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::WriteLine($xml)
