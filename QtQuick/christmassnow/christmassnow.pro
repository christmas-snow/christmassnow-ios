TARGET = ChristmasSnow
VERSION = 1.0.3

TEMPLATE = app
QT += core gui declarative
CONFIG += qt-components mobility
MOBILITY += sensors multimedia

SOURCES += main.cpp \
    csapplication.cpp
HEADERS += \
    csapplication.h
RESOURCES += \
    christmassnow.qrc
OTHER_FILES += \
    doc/help.html \
    images/snowflake-1-big.png \
    images/snowflake-1-small.png \
    images/snowflake-2-big.png \
    images/snowflake-2-small.png \
    images/snowflake-3-big.png \
    images/snowflake-3-small.png \
    images/snowflake-4-big.png \
    images/snowflake-4-small.png \
    images/help.png \
    images/settings.png \
    images/volume.png \
    images/volume-pressed.png \
    images/exit.png \
    images/ok.png \
    icon.png \
    icon.svg

symbian: {
    DEFINES += SYMBIAN_TARGET

    #TARGET.UID3 = 0xE29BCA98
    TARGET.UID3 = 0x2004B224
    TARGET.EPOCSTACKSIZE = 0x14000
    TARGET.EPOCHEAPSIZE = 0x020000 0x8000000
    TARGET.CAPABILITY += ReadDeviceData

    ICON = icon.svg

    # SIS header: name, uid, version
    packageheader = "$${LITERAL_HASH}{\"ChristmasSnow\"}, (0x2004B224), 1, 0, 3, TYPE=SA"
    # Vendor info: localised and non-localised vendor names
    vendorinfo = "%{\"Oleg Derevenetz\"}" ":\"Oleg Derevenetz\""

    my_deployment.pkg_prerules = packageheader vendorinfo
    DEPLOYMENT += my_deployment

    # SIS installer header: uid
    DEPLOYMENT.installer_header = 0x2002CCCF
}

contains(MEEGO_EDITION,harmattan) {
    DEFINES += MEEGO_TARGET

    target.path = /opt/christmassnow/bin

    launchericon.files = christmassnow.svg
    launchericon.path = /usr/share/themes/base/meegotouch/icons/

    INSTALLS += target launchericon
}

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# QML deployment
folder_qml.source = qml/christmassnow
folder_qml.target = qml
DEPLOYMENTFOLDERS = folder_qml

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

contains(MEEGO_EDITION,harmattan) {
    desktopfile.files = christmassnow.desktop
    desktopfile.path = /usr/share/applications
    INSTALLS += desktopfile
}
