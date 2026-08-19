$ErrorActionPreference = "Stop"

Write-Host "=== Maven build ==="
mvn clean package

Write-Host "=== Update JAR ==="
Copy-Item target\my-app-1.0.0.jar package-input\my-app-1.0.0.jar -Force

Write-Host "=== Remove old application ==="
if (Test-Path .\dist) {
    Remove-Item -Recurse -Force .\dist
}

Write-Host "=== Build Windows application ==="

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

Write-Host ""
Write-Host "=== Build completed ==="
Write-Host "dist\BakeryGame\BakeryGame.exe"