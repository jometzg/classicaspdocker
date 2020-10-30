# Classic ASP Docker

This is an updated version of this repo https://github.com/ImranMA/CodeSamples/tree/master/aspClassic-Docker. To demonstrate how a classic ASP application can be containerised and then deployed to a web app for containers (with a Windows service plan)


## Changes
1. Dockerfile has a fixed download reference
2. Added some Classic ASP code to enumerate environment variables to see how these may be injected by Azure Web Apps for Containers.

## Environment variables
Following the article here https://docs.microsoft.com/en-us/azure/app-service/configure-custom-container?pivots=container-windows#configure-environment-variables some code was added to the asp page to enumerate the environment variables:

```
  <p class="w3-opacity"><i>
        <%
        Set objWSH =  CreateObject("WScript.Shell")
        Set objSystemVariables = objWSH.Environment("SYSTEM")
        For Each strItem In objSystemVariables
            response.write("<p>" & strItem & "</p>")
        Next
        %>
        <p class="w3-opacity"><i>USER</i></p>
        <%
        Set objSystemVariables = objWSH.Environment("USER")
        For Each strItem In objSystemVariables
            response.write("<p>" & strItem & "</p>")
        Next
        %>
      </i></p>
```

In the web app configuration a custom application setting was added:
![Web App for Containers settings](https://github.com/jometzg/classicaspdocker/blob/master/appsettings.png)

When the web page is displayed, you can see this has been picked up.
![Picked up by code](https://github.com/jometzg/classicaspdocker/blob/master/onpage.png)

As can be seen, the value _APPSETTING_DATABASE_CONNECTION_STRING=this_is_the_connection_string_ gets correctly injected into the container. This will allow connection strings and other settings to be injected into the application. 

## Accessing an Azure SQL Database
It's often the case that an application need to access an SQL database. For migration to Azure, Azure SQL database is a really good option. This section covers how to setup the database driver so that ADODB code can use an Azure SQL database.

Firstly, the driver needs to be installed in the container. There are several ways to do this, but the following creates a systme DSN that the application can use. I followed some advice from here https://dotnet-cookbook.cfapps.io/kubernetes/asp-with-odbc/
```
RUN Add-OdbcDsn -Name "SampleDSN" `
                -DriverName "\"ODBC Driver 13 For SQL Server\"" `
                -DsnType "System" ` 
                -SetPropertyValue @("\"Server=yourservername.database.windows.net\"", "\"Trusted_Connection=No\"");
```
This creates a DSN named "SampleDSN".

In the ASP code on the page, this DSN is then used to access the database:
```
Dim objConn
      Set objConn = Server.CreateObject("ADODB.Connection")
      objConn.open("DSN=SampleDSN;UID={username};PWD={password};DATABASE=the-database-name")
      Set objCmd = Server.CreateObject("ADODB.Command")
      objCmd.CommandText = "SELECT * FROM dbo.person"
      objCmd.ActiveConnection = objConn

      Set objRS = objCmd.Execute

      Do While Not objRS.EOF
        %><%= objRS("FirstName") %><br><%
        objRS.MoveNext()
      Loop
```
In the above, I had a sample table "person" in the database with a few rows of data.

## Other samples
Here is a repo https://github.com/MicrosoftDocs/Virtualization-Documentation/tree/master/windows-container-samples with a large number of sample Dockerfiles which may be used as a starting point for containerising Windows-based workloads.
