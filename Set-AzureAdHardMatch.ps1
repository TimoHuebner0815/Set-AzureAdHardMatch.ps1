# .PARAMETER ObjectGUID
# AD DS User ObjectGUID
# .PARAMETER UserPrincipalName
# AD DS User UserPrincipalName
# .PARAMETER MSOnlineDomain
# M365 Domain

Param
(
    [Parameter(Mandatory=$true)]
    [GUID]$ObjectGUID,
    [String]$UserPrincipalName,
    [Parameter(Mandatory=$false)]
    [String]$MSOnlineDomain = 'MsOnline Domain'
)

#Check for MSOL Session is still open
Function MSOLConnected {
    Get-MsolDomain -ErrorAction SilentlyContinue | out-null
    return $?
}

#Convert ObjectGUID into Base64GUID
Function Convert-GUIDtoBase64 
{
    Param
    (
        [ObjectGUID]$ObjectGUID
    )

    $Base64GUID = [system.convert]::ToBase64String($ObjectGUID.ToByteArray())
    
    Write-Output $Base64GUID
}

#Import Module
Import-Module MSOnline
#Connect to MSOL if not Connectet
if (-not (MSOLConnected)) 
{
    Connect-MsolService
}

#Convert ObjectGUID into Base64GUID using Funktion
$Base64GUID = Convert-GUIDtoBase64 -ObjectGUID $ObjectGUID

#Set ImmutableId to MSOL User
try
{
        Set-MsolUser -UserPrincipalName $UserPrincipalName -ImmutableId $Base64GUID -Verbose -ErrorAction Stop
}
catch 
{
    $MSOnlineUser = $UserPrincipalName.Split('@')[0] + '@' +$MSOnlineDomain

    Set-MsolUser -UserPrincipalName $MSOnlineUser -ImmutableId $Base64GUID -Verbose

}
