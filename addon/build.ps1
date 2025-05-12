<#
    File:        PoctKnocker.ps1
    Company:     //coding.Lifestyle Studio
    Description: Port knocking utility with GUI
    License:     MIT License

    © 2024 Coding Lifestyle. Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the “Software”), to deal in the Software without
    restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute,
    sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished
    to do so, subject to the following conditions:

    THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
    LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#>

param(
    [string]$InputFile = "../PortKnocker.ps1",
    [string]$OutputFile = "../PortKnocker.exe"
)

if (-not (Get-Module -ListAvailable -Name ps2exe)) {
    Write-Host "Installing ps2exe module..."
    Install-Module -Name ps2exe -Scope CurrentUser -Force
}

Import-Module ps2exe -Force

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
