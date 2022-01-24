<!DOCTYPE html>
<html lang="en">
<title>W3.CSS Template</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Lato">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style>
  body {
    font-family: "Lato", sans-serif
  }

  .mySlides {
    display: none
  }
</style>

<body>
<%
CONFIG_FILE_PATH="web.config"  
Function GetConfigValue(sectionName, attrName)
    Dim oXML, oNode, oChild, oAttr, dsn
    Set oXML=Server.CreateObject("Microsoft.XMLDOM")
    oXML.Async = "false"
    oXML.Load(Server.MapPath(CONFIG_FILE_PATH))
    Set oNode = oXML.GetElementsByTagName(sectionName).Item(0) 
    Set oChild = oNode.GetElementsByTagName("add")
    ' Get the first match
    For Each oAttr in oChild 
        If  oAttr.getAttribute("key") = attrName then
            dsn = oAttr.getAttribute("value")
            GetConfigValue = dsn
            Exit Function
        End If
    Next
End Function  
%>  
  <!--#include file='header.asp'-->

  <!-- Page content -->
  <div class="w3-content" style="max-width:2000px;margin-top:46px">


    <!-- The Band Section -->
    <div class="w3-container w3-content w3-center w3-padding-64" style="max-width:800px" id="band">
      <h2 class="w3-wide">Classic ASP Test Page v8 for MOD</h2>
      <h2 class="w3-wide">Windows Container</h2>
      <p class="w3-opacity"><i>web.config</i></p>
      <%
        settingValue = GetConfigValue("appSettings", "APPSETTING_JM_TEST_APPSETTING")
        Response.Write(settingValue)
        %>
      <p></p>
      <%
      Dim objConn
      Set objConn = Server.CreateObject("ADODB.Connection")
      objConn.open("DSN=Air_DSR;UID=jjtestmod;PWD={password};DATABASE=Air_DASR")
      Set objCmd = Server.CreateObject("ADODB.Command")
      objCmd.CommandText = "SELECT * FROM dbo.person"
      objCmd.ActiveConnection = objConn

      Set objRS = objCmd.Execute

      Do While Not objRS.EOF
        %><%= objRS("FirstName") %><br><%
        objRS.MoveNext()
      Loop
      'conn.open("Provider=MSOLEDBSQL;Data Source=tcp:jjmodtest.database.windows.net,1433;Initial Catalog=myDatabase;Authentication=SqlPassword;User ID=jjtestmod;Password=Superseven07;Use Encryption for Data=true;")
      %>	

      <p class="w3-justify">We have created a fictional band website. Lorem ipsum dolor sit amet, consectetur adipiscing
        elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud
        exercitation ullamco laboris nisi ut aliquip
        ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat
        nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim
        id est laborum consectetur
        adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
        quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
      <div class="w3-row w3-padding-32">
        <div class="w3-third">
          <p>Name 1</p>
          <p>Slide1</p>
        </div>
        <div class="w3-third">
          <p>Name 1</p>
          <p>Slide1</p>
        </div>
        <div class="w3-third">
          <p>Name 1</p>
          <p>Slide1</p>
        </div>
      </div>
    </div>

  </div>

  <!-- End Page Content -->
  </div>

  <!-- Footer -->
  <footer class="w3-container w3-padding-64 w3-center w3-opacity w3-light-grey w3-xlarge">
    <i class="fa fa-facebook-official w3-hover-opacity"></i>
    <i class="fa fa-instagram w3-hover-opacity"></i>
    <i class="fa fa-snapchat w3-hover-opacity"></i>
    <i class="fa fa-pinterest-p w3-hover-opacity"></i>
    <i class="fa fa-twitter w3-hover-opacity"></i>
    <i class="fa fa-linkedin w3-hover-opacity"></i>
  </footer>

  <script>
    // Automatic Slideshow - change image every 4 seconds
    var myIndex = 0;
    carousel();

    function carousel() {
      var i;
      var x = document.getElementsByClassName("mySlides");
      for (i = 0; i < x.length; i++) {
        x[i].style.display = "none";
      }
      myIndex++;
      if (myIndex > x.length) { myIndex = 1 }
      x[myIndex - 1].style.display = "block";
      setTimeout(carousel, 4000);
    }

    // Used to toggle the menu on small screens when clicking on the menu button
    function myFunction() {
      var x = document.getElementById("navDemo");
      if (x.className.indexOf("w3-show") == -1) {
        x.className += " w3-show";
      } else {
        x.className = x.className.replace(" w3-show", "");
      }
    }

    // When the user clicks anywhere outside of the modal, close it
    var modal = document.getElementById('ticketModal');
    window.onclick = function (event) {
      if (event.target == modal) {
        modal.style.display = "none";
      }
    }
  </script>

</body>

</html>
