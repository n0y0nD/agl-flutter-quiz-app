# AGL Flutter Quiz App

A Flutter application for Automotive Grade Linux (AGL) that displays 
system information and demonstrates AGL integration with a dashboard UI.

## Overview

This repository contains a Flutter application designed to run on the 
AGL platform. It displays the developer's name, AGL version, and kernel 
version. It features a dark automotive-themed dashboard UI with image 
display and audio playback functionality.

## Features

- Flutter UI optimized for automotive displays
- Displays AGL version (20.0 Terrific Trout) and kernel info
- Button-activated image display
- Button-activated sound playback via `mpg123`
- Animated dashboard with speedometer, RPM and fuel gauges
- Integrated into AGL image via Yocto recipe

## Prerequisites

- Ubuntu 22.04 LTS (Jammy Jellyfish)
- Git
- Python 3 and pip
- [meta-flutter/workspace-automation](https://github.com/meta-flutter/workspace-automation)
- Yocto Project tooling
- AGL master branch

## AGL Integration Details

### 1. Build AGL locally

Built the `agl-ivi-demo-flutter` image from AGL master branch and 
tested using QEMU (qemux86-64). For detailed instructions refer to the 
[AGL Official Documentation](https://docs.automotivelinux.org/en/trout/#01_Getting_Started/02_Building_AGL_Image/).

### 2. Add Yocto recipe for the Flutter app

Under `recipes-demo` folder, created a new directory named 
`agl-flutter-quiz`. This contains a `.bb` file with the following recipe:
