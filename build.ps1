# build.ps1

param(
    [string]$InputFile = "PortKnocker.ps1",
    [string]$OutputFile = "PortKnocker.exe"
)

# Ensure module is installed
if (-not (Get-Module -ListAvailable -Name ps2exe)) {
    Write-Host "Installing ps2exe module..."
    Install-Module -Name ps2exe -Scope CurrentUser -Force
}

# Import module
Import-Module ps2exe -Force

# Build executable
ps2exe -inputFile $InputFile `
       -outputFile $OutputFile `
       -noConsole `
       -x64 `
       -STA `
       -title "PortKnocker" `
       -description "Simple knock utility" `
       -product "PortKnocker" `
       -version "1.0.0.0"

if (Test-Path $OutputFile) {
    Write-Host "✅ Build successful: $OutputFile"
} else {
    Write-Error "❌ Build failed"
}
