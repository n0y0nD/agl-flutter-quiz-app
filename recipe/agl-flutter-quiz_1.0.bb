SUMMARY = "AGL Flutter Quiz App"
HOMEPAGE = "https://github.com/n0y0nD/agl-flutter-quiz-app"
LICENSE = "CLOSED"
SECTION = "graphics"

SRC_URI = "git://github.com/n0y0nD/agl-flutter-quiz-app.git;protocol=https;branch=main"
SRC_URI += "file://sound.mp3"
FILESEXTRAPATHS:prepend := "${THISDIR} /files:"

SRCREV = "${AUTOREV}"
S = "${WORKDIR}/git"

inherit flutter-app agl-app

DEPENDS += " \
    glib-2.0 \
    dbus \
"

RDEPENDS:${PN} += " mpg123 \
"
FILES:${PN} += "/usr/share/agl_flutter_quiz"

PUBSPEC_APPNAME = "agl_flutter_quiz_app"
PUBSPEC_IGNORE_LOCKFILE = "1"
FLUTTER_APPLICATION_INSTALL_PREFIX = "/usr/share/flutter"
FLUTTER_BUILD_ARGS = "bundle -v"
FLUTTER_PUB_CMD = "get"

AGL_APP_TEMPLATE = "agl-app-flutter"
AGL_APP_ID = "agl_flutter_quiz_app"
AGL_APP_NAME = "AGL Flutter Quiz"


do_install:append() {
    install -d ${D}/usr/share/agl_flutter_quiz
    install -m 0644 ${WORKDIR}/sound.mp3 ${D}/usr/share/agl_flutter_quiz/
}

