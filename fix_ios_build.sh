#!/bin/sh

# cocoapods is black magic and regurlarly breaks the build, here is a list of command which should fix it
cd ios
pod deintegrate
pod repo update
pod install --repo-update