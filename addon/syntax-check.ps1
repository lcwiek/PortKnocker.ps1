<#
    File:        syntax-check.ps1
    Company:     //coding.lifestyle Studio
    Description: PowerShell syntax validator for .ps1 scripts using the built-in parser
    License:     MIT License

    © 2025 coding.lifestyle. Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the “Software”), to deal in the Software without
    restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute,
    sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished
    to do so, subject to the following conditions:

    THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
    LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    
    Project repository: https://github.com/lcwiek/
#>

param (
    [string]$ScriptPath = "../*.ps1"
)

$code = Get-Content $ScriptPath -Raw
$errors = $null

[System.Management.Automation.Language.Parser]::ParseInput($code, [ref]$null, [ref]$errors)

if ($errors.Count -eq 0) {
    Write-Host "✅ Syntax OK"
    exit 0
} else {
    Write-Error "❌ Syntax errors:"
    $errors | ForEach-Object { Write-Error $_.Message }
    exit 1
}
