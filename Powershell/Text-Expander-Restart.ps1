Get-Process | Where-Object { $_.Name -eq "TextExpander" } | Select-Object -First 1 | Stop-Process
Invoke-Item "C:\Program Files\Smile\TextExpander\TextExpander.exe"
