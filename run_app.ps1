$env:JAVA_HOME="C:\Program Files\Java\jdk-24"
$toolsDir = "d:\nexgenesportsv2-1\.tools"
$env:CATALINA_HOME = "$toolsDir\tomcat"
& "$toolsDir\apache-maven-3.9.6\bin\mvn.cmd" clean package
Copy-Item "d:\nexgenesportsv2-1\target\NexGenEsportsv2-1.0-SNAPSHOT.war" -Destination "$toolsDir\tomcat\webapps\NexGenEsportsv2.war" -Force
Write-Host "Starting Tomcat..."
& "$toolsDir\tomcat\bin\catalina.bat" start
