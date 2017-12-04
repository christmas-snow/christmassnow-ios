QT += quick quickcontrols2 sql multimedia sensors purchasing
CONFIG += c++11

DEFINES += QT_DEPRECATED_WARNINGS WEBRTC_POSIX

SOURCES += src/main.cpp \
    src/sparkcreator.cpp

OBJECTIVE_SOURCES += \
    src/admobhelper.mm \
    src/sharehelper.mm \
    src/gifcreator.mm

HEADERS += \
    src/admobhelper.h \
    src/sharehelper.h \
    src/gif.h \
    src/gifcreator.h \
    src/sparkcreator.h

RESOURCES += \
    qml.qrc \
    resources.qrc \
    translations.qrc

#TRANSLATIONS += \
#    translations/christmassnow_ru.ts \
#    translations/christmassnow_de.ts \
#    translations/christmassnow_fr.ts \
#    translations/christmassnow_zh.ts

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

ios {
    LIBS += -F $$PWD/admob -framework GoogleMobileAds \
                -framework AdSupport \
                -framework CFNetwork \
                -framework CoreMotion \
                -framework CoreTelephony \
                -framework GLKit \
                -framework MediaPlayer \
                -framework MessageUI \
                -framework SystemConfiguration

    QMAKE_APPLE_DEVICE_ARCHS = arm64
    QMAKE_INFO_PLIST = ios/Info.plist
}

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
