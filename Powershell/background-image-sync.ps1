Get-ChildItem -r -Path \\Fire\Snow\Pictures\Background -Filter *.* | Copy-Item -Destination C:\Users\$env:UserName\Pictures\Backgrounds
echo complete
