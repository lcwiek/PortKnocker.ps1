<#
    File:        PoctKnocker.ps1
    Company:     //coding.lifestyle Studio
    Description: Port knocking utility with GUI
    License:     MIT License

    © 2025 //coding.lifestyle Studio. Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the “Software”), to deal in the Software without
    restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute,
    sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished
    to do so, subject to the following conditions:

    THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
    LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
#>

if ([Threading.Thread]::CurrentThread.ApartmentState -ne 'STA') {
    Write-Warning "This script requires STA mode. Relaunch it in PowerShell ISE or with -STA (e.g. via ps2exe)."
}

Add-Type -AssemblyName System.Windows.Forms

$form = New-Object Windows.Forms.Form
$form.Text = "Port Knocker"
$form.Size = New-Object Drawing.Size(360,380)
$form.StartPosition = "CenterScreen"
$form.AutoSize = $true
$form.AutoSizeMode = "GrowAndShrink"

# Host/IP
$labelHost = New-Object Windows.Forms.Label
$labelHost.Text = "Host/IP:"
$labelHost.Location = New-Object Drawing.Point(10,20)
$labelHost.AutoSize = $true
$form.Controls.Add($labelHost)

$textHost = New-Object Windows.Forms.TextBox
$textHost.Location = New-Object Drawing.Point(80,18)
$textHost.Width = 250
$form.Controls.Add($textHost)

# Ports
$labelPorts = New-Object Windows.Forms.Label
$labelPorts.Text = "Ports (comma separated):"
$labelPorts.Location = New-Object Drawing.Point(10,50)
$labelPorts.AutoSize = $true
$form.Controls.Add($labelPorts)

$textPorts = New-Object Windows.Forms.TextBox
$textPorts.Location = New-Object Drawing.Point(10,70)
$textPorts.Width = 320
$form.Controls.Add($textPorts)

# Protocol
$labelProto = New-Object Windows.Forms.Label
$labelProto.Text = "Protocol:"
$labelProto.Location = New-Object Drawing.Point(10,100)
$labelProto.AutoSize = $true
$form.Controls.Add($labelProto)

$comboProto = New-Object Windows.Forms.ComboBox
$comboProto.Items.Add("TCP") | Out-Null
$comboProto.Items.Add("UDP") | Out-Null
$comboProto.SelectedIndex = 0
$comboProto.Location = New-Object Drawing.Point(80,98)
$comboProto.Width = 80
$form.Controls.Add($comboProto)

# Delay
$labelDelay = New-Object Windows.Forms.Label
$labelDelay.Text = "Delay (ms):"
$labelDelay.Location = New-Object Drawing.Point(170,100)
$labelDelay.AutoSize = $true
$form.Controls.Add($labelDelay)

$textDelay = New-Object Windows.Forms.TextBox
$textDelay.Text = "200"
$textDelay.Location = New-Object Drawing.Point(240,98)
$textDelay.Width = 60
$form.Controls.Add($textDelay)

# Log
$logBox = New-Object Windows.Forms.TextBox
$logBox.Multiline = $true
$logBox.ScrollBars = "Vertical"
$logBox.Location = New-Object Drawing.Point(10,130)
$logBox.Size = New-Object Drawing.Size(330, 150)
$form.Controls.Add($logBox)

# Progress bar
$progress = New-Object Windows.Forms.ProgressBar
$progress.Location = New-Object Drawing.Point(10,290)
$progress.Size = New-Object Drawing.Size(330,20)
$progress.Minimum = 0
$progress.Step = 1
$form.Controls.Add($progress)

# Status label
$labelStatus = New-Object Windows.Forms.Label
$labelStatus.Text = "Ready."
$labelStatus.Location = New-Object Drawing.Point(10,320)
$labelStatus.AutoSize = $true
$form.Controls.Add($labelStatus)

# Button
$button = New-Object Windows.Forms.Button
$button.Text = "Knock"
$button.Location = New-Object Drawing.Point(10,345)
$form.Controls.Add($button)

$button.Add_Click({
    $targetHost = $textHost.Text.Trim()
    $portText = $textPorts.Text.Trim()
    $protocol = $comboProto.SelectedItem
    $delay = [int]$textDelay.Text
    $logBox.Clear()
    $labelStatus.Text = "Knocking in progress..."
    $labelStatus.ForeColor = "Blue"

    $logPath = Join-Path -Path (Get-Location) -ChildPath "knock_log.txt"
    Add-Content $logPath ("--- Knock started [" + (Get-Date) + "] ---")

    if (-not $targetHost -or -not $portText) {
        $logBox.AppendText("Please enter a host and port list.`r`n")
        $labelStatus.Text = "Error: Missing input"
        $labelStatus.ForeColor = "Red"
        return
    }

    try {
        $ports = $portText -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^\d+$' } | ForEach-Object { [int]$_ }
        $progress.Maximum = $ports.Count
        $progress.Value = 0

        foreach ($port in $ports) {
            try {
                if ($protocol -eq "TCP") {
                    $client = [System.Net.Sockets.TcpClient]::new()
                    $async = $client.BeginConnect($targetHost, $port, $null, $null)
                    if ($async.AsyncWaitHandle.WaitOne(500, $false)) {
                        $client.EndConnect($async)
                        $msg = "Successfully knocked port $port (TCP)"
                    } else {
                        $msg = "Timeout knocking port $port (TCP)"
                    }
                    $client.Close()
                } else {
                    $udp = [System.Net.Sockets.UdpClient]::new()
                    $udp.Send([byte[]]@(0), 0, $targetHost, $port) | Out-Null
                    $udp.Close()
                    $msg = "Knocked port $port (UDP)"
                }
                $msg = "Successfully knocked port $port ($protocol)"
            } catch {
                $msg = "Failed to knock port $port ($protocol)"
            }
            $logBox.AppendText("$msg`r`n")
            Add-Content $logPath $msg
            $progress.PerformStep()
            Start-Sleep -Milliseconds $delay
        }
        $labelStatus.Text = "Knocking completed."
        $labelStatus.ForeColor = "Green"
    } catch {
        $logBox.AppendText("Error: $_`r`n")
        $labelStatus.Text = "Error occurred."
        $labelStatus.ForeColor = "Red"
    }

    Add-Content $logPath "--- Knock finished ---`n"
})

[void]$form.ShowDialog()
