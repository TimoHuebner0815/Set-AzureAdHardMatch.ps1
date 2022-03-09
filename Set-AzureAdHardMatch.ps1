# .PARAMETER User
# AD DS User SamAccountName
# .PARAMETER GUID
# AD DS User ObjectGUID
# .PARAMETER UserPrincipalName
# AD DS User UserPrincipalName

Param
(
    [Parameter(Mandatory=$true)]
    [String]$User,
    [GUID]$GUID,
    [String]$UserPrincipalName
)

#Import Module
Import-Module MSOnline

#Check for MSOL Session is still opne
Function MSOLConnected {
    Get-MsolDomain -ErrorAction SilentlyContinue | out-null
    return $?
}

#Convert GUID into Base64
Function Convert-GUIDtoBase64 
{
    Param
    (
        [GUID]$GUID
    )

    $Base64GUID = [system.convert]::ToBase64String($GUID.ToByteArray())
    
    Write-Output $Base64GUID
}

$Base64GUID = Convert-GUIDtoBase64 -GUID $GUID

#Connect to MSOL if not Connectet
if (-not (MSOLConnected)) 
{
    Connect-MsolService
}

#Set ImmutableId to MSOL User
Set-MsolUser -UserPrincipalName $UserPrincipalName -ImmutableId $Base64GUID -Verbose