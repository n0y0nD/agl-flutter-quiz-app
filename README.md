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

# Screenshots

<img width="1211" height="741" alt="agl_main_page" src="https://github.com/user-attachments/assets/9de6a21a-ceff-4bbc-8690-89cd43419c3f" />

<img width="1211" height="741" alt="agl_apps" src="https://github.com/user-attachments/assets/607dee5f-8f77-47ae-b50b-90c84225d49a" />

<img width="1218" height="741" alt="agl_app_main" src="https://github.com/user-attachments/assets/f358a7fe-5aca-4007-961c-da5f5cc8f593" />

<img width="1218" height="741" alt="agl_photo" src="https://github.com/user-attachments/assets/c6b2502d-621b-42a5-af24-866a8d912d5a" />

<img width="1218" height="741" alt="agl_sound" src="https://github.com/user-attachments/assets/8bedecec-4928-4d84-a764-e5caba4aa402" />








