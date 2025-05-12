param (
    [string]$ScriptPath = "PortKnocker.ps1"
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
