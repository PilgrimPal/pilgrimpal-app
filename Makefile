include .env 

.PHONY: init format dev build_apk build_runner

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

build_runner:
	dart run build_runner build --delete-conflicting-outputs