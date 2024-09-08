<#
    This script is responsible for setting up a bunch of tools in a windows sandbox
    Windows Sandbox https://learn.microsoft.com/en-us/windows/security/application-security/application-isolation/windows-sandbox/windows-sandbox-overview
#>

# PowerShell config
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

# Setup winget - https://learn.microsoft.com/en-us/windows/package-manager/winget/#install-winget-on-windows-sandbox
$progressPreference = 'silentlyContinue'
Write-Information "Downloading WinGet and its dependencies..."
Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx -OutFile Microsoft.UI.Xaml.2.8.x64.appx
Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
Add-AppxPackage Microsoft.UI.Xaml.2.8.x64.appx
Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle

# Winget install commands
winget install -e --id Microsoft.VisualStudioCode --override '/SILENT /mergetasks="!runcode,addcontextmenufiles,addcontextmenufolders"' --accept-package-agreements --accept-source-agreements
winget install -e --id Python.Python.3.11 --accept-package-agreements --accept-source-agreements
winget install -e --id Notepad++.Notepad++ --accept-package-agreements --accept-source-agreements
winget install -e --id baremetalsoft.baretail --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.Sysinternals.ProcessExplorer --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.Sysinternals.Autoruns --accept-package-agreements --accept-source-agreements

# Configuring explorer to show file extensions by default
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key Hidden 1
Set-ItemProperty $key HideFileExt 0
Set-ItemProperty $key ShowSuperHidden 1
Stop-Process -processname explorer
