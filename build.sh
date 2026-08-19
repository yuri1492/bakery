#!/bin/bash

set -e

echo "=== Maven build ==="
mvn clean package

echo "=== Copy JAR ==="
cp target/my-app-1.0.0.jar app/my-app-1.0.0.jar
cp target/my-app-1.0.0.jar package-input/my-app-1.0.0.jar

echo "=== Create application ==="
rm -rf dist/BakeryGame

jpackage \
  --type app-image \
  --name BakeryGame \
  --input package-input \
  --main-jar my-app-1.0.0.jar \
  --main-class Main \
  --module-path javafx-modules \
  --add-modules javafx.controls,javafx.fxml \
  --dest dist

echo "=== Build completed ==="