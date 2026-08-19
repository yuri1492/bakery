$ErrorActionPreference = "Stop"

Write-Host "=== Maven build ==="
mvn clean package

Write-Host "=== Create directories ==="
New-Item -ItemType Directory -Force package-input | Out-Null
New-Item -ItemType Directory -Force javafx-modules | Out-Null

Write-Host "=== Copy JAR ==="
Copy-Item target\my-app-1.0.0.jar package-input\my-app-1.0.0.jar -Force

Write-Host "=== Copy JavaFX modules ==="

$javafxVersion = "21.0.7"
$javafxRepo = "$env:USERPROFILE\.m2\repository\org\openjfx"

Copy-Item `
    "$javafxRepo\javafx-base\$javafxVersion\javafx-base-$javafxVersion-win.jar" `
    javafx-modules\ -Force

Copy-Item `
    "$javafxRepo\javafx-controls\$javafxVersion\javafx-controls-$javafxVersion-win.jar" `
    javafx-modules\ -Force

Copy-Item `
    "$javafxRepo\javafx-fxml\$javafxVersion\javafx-fxml-$javafxVersion-win.jar" `
    javafx-modules\ -Force

Copy-Item `
    "$javafxRepo\javafx-graphics\$javafxVersion\javafx-graphics-$javafxVersion-win.jar" `
    javafx-modules\ -Force

Write-Host "=== Remove old application ==="
Remove-Item -Recurse -Force dist -ErrorAction SilentlyContinue

Write-Host "=== Create application ==="

jpackage `
    --type app-image `
    --name BakeryGame `
    --input package-input `
    --main-jar my-app-1.0.0.jar `
    --main-class Main `
    --module-path javafx-modules `
    --add-modules javafx.controls,javafx.fxml `
    --dest dist `
    --verbose

Write-Host "=== Build completed ==="