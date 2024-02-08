include .env 

.PHONY: init format dev launch_icon build_apk build_runner

init:
	flutter clean
	flutter pub get
	make build_runner

format:
	dart format .

dev:
	flutter run lib/main.dart

build_apk:
	flutter build apk

launch_icon:
	dart run flutter_launcher_icons

build_runner:
	dart run build_runner build --delete-conflicting-outputs