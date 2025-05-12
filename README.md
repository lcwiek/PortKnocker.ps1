# PortKnocker

**PortKnocker** is a simple graphical utility written in PowerShell that performs port knocking – a technique to stealthily signal a server (e.g., MikroTik router) by connecting to a specific sequence of ports.

This repository includes:
- `PortKnocker.ps1` — the PowerShell GUI script
- `build.ps1` — a helper script that compiles the `.ps1` script into a standalone `.exe` using the [ps2exe](https://github.com/MScholtes/PS2EXE) module

---

## Features

- Define any target host (IP or domain)
- Enter any number of TCP/UDP ports to knock
- Choose between TCP or UDP protocols
- Configure delay between knocks
- Visual log, progress bar, and status indicator
- Output log to `knock_log.txt`
- Compile to `.exe` for standalone use on Windows

---

## Requirements

- Windows 10/11
- PowerShell 5.1 or PowerShell Core + .NET Framework
- Internet access (for downloading ps2exe module)

---

## Running as Script

You can run it directly using PowerShell:

```powershell
.\PortKnocker.ps1
```

> ⚠️ Ensure STA threading is used (e.g., by running in PowerShell ISE or setting `[Threading.Thread]::CurrentThread.ApartmentState = 'STA'`)

---

## Compiling to .EXE

Use the provided `build.ps1` to compile `PortKnocker.ps1` into a native `.exe`:

```powershell
.build.ps1
```

This will:

- Check and install the `ps2exe` module (if missing)
- Compile to `PortKnocker.exe` with GUI and metadata
- Output to the same folder

### Optional Parameters

```powershell
.build.ps1 -InputFile "script.ps1" -OutputFile "out.exe"
```

---

## Syntax Check (Optional)

To verify script syntax without executing it:

```powershell
$code = Get-Content .\PortKnocker.ps1 -Raw
$errors = $null
[System.Management.Automation.Language.Parser]::ParseInput($code, [ref]$null, [ref]$errors)

if ($errors.Count -eq 0) {
    Write-Host "✅ Syntax OK"
} else {
    $errors | ForEach-Object { Write-Error $_.Message }
}
```

---

## Disclaimer

This tool is for educational and testing purposes. Ensure your use of port knocking complies with your network and organizational policies.

---

## License

MIT (see LICENSE file if provided)