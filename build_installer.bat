
REM Install Squirrel locally so that we can access squirrel.exe
nuget install Squirrel.Windows -o local/squirrel

REM Clean
DEL /F /Q build Releases

REM Build project
dotnet publish -c Release -o build || exit /b

REM Create .nupkg file from .nuspec
nuget pack MyProject.nuspec -Properties Configuration=Release || exit /b

REM Package it into a setup.msi and setup.exe (the latter doesn't require admin privileges to install), outputted to Releases/
local\squirrel\Squirrel.windows.2.0.1\tools\Squirrel.exe --releasify MyProject.1.0.0.nupkg || exit /b
