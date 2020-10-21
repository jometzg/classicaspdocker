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
![Web App for Containers settings](https://github.com/jometzg/classicaspdocker/master/appsettings.png)

When the web page is displayed, you can see this has been picked up.
![Picked up by code](https://github.com/jometzg/classicaspdocker/master/onpage.png)

APPSETTING_DATABASE_CONNECTION_STRING=this_is_the_connection_string

