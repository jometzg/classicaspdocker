# escape=`

FROM mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2019
SHELL ["powershell", "-command"]

RUN Install-WindowsFeature Web-ASP; `
    Install-WindowsFeature Web-CGI; `
    Install-WindowsFeature Web-ISAPI-Ext; `
    Install-WindowsFeature Web-ISAPI-Filter; `
    Install-WindowsFeature Web-Includes; `
    Install-WindowsFeature Web-HTTP-Errors; `
    Install-WindowsFeature Web-Common-HTTP; `
    Install-WindowsFeature Web-Performance; `
    Install-WindowsFeature WAS; `
    Import-module IISAdministration;

RUN md c:/msi;

RUN Invoke-WebRequest 'https://download.microsoft.com/download/1/2/8/128E2E22-C1B9-44A4-BE2A-5859ED1D4592/rewrite_amd64_en-US.msi' -OutFile c:/msi/urlrewrite2.msi; `
    Start-Process 'c:/msi/urlrewrite2.msi' '/qn' -PassThru | Wait-Process;

RUN Invoke-WebRequest 'https://download.microsoft.com/download/1/E/7/1E7B1181-3974-4B29-9A47-CC857B271AA2/English/X64/msodbcsql.msi' -OutFile c:/msi/msodbcsql.msi; 
RUN ["cmd", "/S", "/C", "c:\\windows\\syswow64\\msiexec", "/i", "c:\\msi\\msodbcsql.msi", "IACCEPTMSODBCSQLLICENSETERMS=YES", "ADDLOCAL=ALL", "/qn"];

EXPOSE 80

RUN Remove-Website -Name 'Default Web Site'; `
    md c:\mywebsite; `
    New-IISSite -Name "mywebsite" `
                -PhysicalPath 'c:\mywebsite' `
                -BindingInformation "*:80:";

RUN & c:\windows\system32\inetsrv\appcmd.exe `
    unlock config `
    /section:system.webServer/asp

RUN & c:\windows\system32\inetsrv\appcmd.exe `
      unlock config `
      /section:system.webServer/handlers

RUN & c:\windows\system32\inetsrv\appcmd.exe `
      unlock config `
      /section:system.webServer/modules
	  
	  	  

RUN Add-OdbcDsn -Name "SampleDSN" `
                -DriverName "\"ODBC Driver 13 For SQL Server\"" `
                -DsnType "System" ` 
                -SetPropertyValue @("\"Server=servername.database.windows.net\"", "\"Trusted_Connection=No\"");


ADD . c:\mywebsite
