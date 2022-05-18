<#
New-Item -Path $profile -Type File -Force
ise $profile
Copy and paste the content in the new Microsoft.PowerShellISE_profile.ps1
#>

function Test-IsAdministrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    return (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function Set-ConsoleStyle{
    param($Account)
    # Style default PowerShell Console
    $shell = $Host.UI.RawUI
    $shell.WindowTitle     = "Running Custom PowerShell ISE as $($Account)"
    $shell.BackgroundColor = "Black"
    #$shell.ForegroundColor = "White"
}

function prompt{
    if (Test-IsAdministrator) {
        $color   = 'Red'
        $account = 'Admin'
    }else{
        $color   = 'Green'
        $account = 'User'
        #Start-Process "$psHome\powershell_ise.exe" -Verb Runas -Wait
    }
    $null = Set-ConsoleStyle -Account $account
    $history = Get-History -ErrorAction Ignore
    $Version = "$($PSVersionTable.PSVersion.ToString().Substring(0,6))"
    Write-Host "[$($history.count[-1])] " -NoNewline
    Write-Host ("[$(($env:ComputerName).ToUpper())]") -NoNewline -ForegroundColor $color
    Write-Host (" I ") -NoNewline
    Write-Host (([char]9829) ) -ForegroundColor $color -NoNewline
    Write-Host (" PS $Version ") -NoNewline
    Write-Host ("$(Get-Location) ") -ForegroundColor $color -NoNewline
    Write-Host (">") -NoNewline -ForegroundColor $color
    $error.Clear()
    return " "
}
