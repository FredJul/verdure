#!/bin/sh

flutter build appbundle --obfuscate --split-debug-info=debug-info/android
flutter build ios --obfuscate --split-debug-info=debug-info/ios
