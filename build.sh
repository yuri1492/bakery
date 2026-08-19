#!/bin/bash

set -e

echo "=== Maven build ==="
mvn clean package

echo "=== Create directories ==="
mkdir -p package-input
mkdir -p javafx-modules

echo "=== Copy JAR ==="
cp target/my-app-1.0.0.jar package-input/my-app-1.0.0.jar

echo "=== Copy JavaFX modules ==="

JAVAFX_VERSION=21.0.7
JAVAFX_REPO="$HOME/.m2/repository/org/openjfx"

cp "$JAVAFX_REPO/javafx-base/$JAVAFX_VERSION/javafx-base-$JAVAFX_VERSION-linux.jar" javafx-modules/
cp "$JAVAFX_REPO/javafx-controls/$JAVAFX_VERSION/javafx-controls-$JAVAFX_VERSION-linux.jar" javafx-modules/
cp "$JAVAFX_REPO/javafx-fxml/$JAVAFX_VERSION/javafx-fxml-$JAVAFX_VERSION-linux.jar" javafx-modules/
cp "$JAVAFX_REPO/javafx-graphics/$JAVAFX_VERSION/javafx-graphics-$JAVAFX_VERSION-linux.jar" javafx-modules/

echo "=== Remove old application ==="
rm -rf dist

echo "=== Create application ==="

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