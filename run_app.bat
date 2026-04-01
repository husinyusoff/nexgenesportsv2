@echo off
set "JAVA_HOME=C:\Program Files\Java\jdk-24"
set "CATALINA_HOME=d:\nexgenesportsv2-1\.tools\tomcat"

echo Building the project using portable Maven...
call "d:\nexgenesportsv2-1\.tools\apache-maven-3.9.6\bin\mvn.cmd" clean package

echo Deploying the WAR to portable Tomcat...
copy /Y "d:\nexgenesportsv2-1\target\NexGenEsportsv2-1.0-SNAPSHOT.war" "d:\nexgenesportsv2-1\.tools\tomcat\webapps\NexGenEsportsv2.war"

echo Starting Tomcat Server...
call "d:\nexgenesportsv2-1\.tools\tomcat\bin\catalina.bat" start

echo.
echo =========================================================
echo DONE!
echo Your application should now be live at:
echo http://localhost:8080/NexGenEsportsv2
echo =========================================================
