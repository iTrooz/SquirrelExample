
REM Install Squirrel locally so that we can access squirrel.exe
nuget install Squirrel.Windows -o build/squirrel

REM Clean
DEL /F /Q build\publish_output build\Releases || exit /b

REM Build project
if "%~1" == "" (
    REM note: --self-contained increases the size A LOT, but I don't want to depend on the right .NET version being installed on the user's computer
    set SELF_CONTAINED=--self-contained
) else (
    REM note: argument passed, disabling self-contained build
    set SELF_CONTAINED=--no-self-contained
)
dotnet publish -c Release -o build/publish_output -r win-x64 %SELF_CONTAINED% || exit /b

REM Create .nupkg file from .nuspec
nuget pack SquirrelExampleAvalonia.nuspec -Properties Configuration=Release -OutputDirectory build || exit /b

REM Package it into a setup.msi and setup.exe (the latter doesn't require admin privileges to install), outputted to Releases/
build\squirrel\Squirrel.windows.2.0.1\tools\Squirrel.exe --releasify build/SquirrelExampleAvalonia.1.0.0.nupkg -r build/Releases || exit /b

echo Done ! See files in build/Releases/
