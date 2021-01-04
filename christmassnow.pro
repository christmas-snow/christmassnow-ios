TEMPLATE = app
TARGET = full

QT += quick quickcontrols2 sql multimedia sensors
CONFIG += c++17

DEFINES += QT_DEPRECATED_WARNINGS QT_NO_CAST_FROM_ASCII QT_NO_CAST_TO_ASCII

INCLUDEPATH += \
    3rdparty/gif-h

SOURCES += \
    src/gifcreator.cpp \
    src/main.cpp \
    src/sparkcreator.cpp

HEADERS += \
    3rdparty/gif-h/gif.h \
    src/gifcreator.h \
    src/sharehelper.h \
    src/sparkcreator.h \
    src/storehelper.h

RESOURCES += \
    qml.qrc \
    resources.qrc \
    translations.qrc

TRANSLATIONS += \
    translations/christmassnow_de.ts \
    translations/christmassnow_es.ts \
    translations/christmassnow_fr.ts \
    translations/christmassnow_it.ts \
    translations/christmassnow_ru.ts \
    translations/christmassnow_zh.ts

QMAKE_CFLAGS += $$(QMAKE_CFLAGS_ENV)
QMAKE_CXXFLAGS += $$(QMAKE_CXXFLAGS_ENV)
QMAKE_LFLAGS += $$(QMAKE_LFLAGS_ENV)

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

ios {
    CONFIG += qtquickcompiler

    INCLUDEPATH += ios/frameworks
    DEPENDPATH += ios/frameworks

    OBJECTIVE_SOURCES += \
        src/sharehelper.mm \
        src/storehelper.mm

    LIBS += -F $$PWD/ios/frameworks \
            -framework UIKit \
            -framework StoreKit

    QMAKE_OBJECTIVE_CFLAGS += $$(QMAKE_OBJECTIVE_CFLAGS_ENV)

    IOS_SIGNATURE_TEAM.name = "Oleg Derevenets"
    IOS_SIGNATURE_TEAM.value = 87JNRRMN2P

    QMAKE_MAC_XCODE_SETTINGS += IOS_SIGNATURE_TEAM

    QMAKE_APPLE_DEVICE_ARCHS = arm64
    QMAKE_INFO_PLIST = ios/Info.plist
    QMAKE_IOS_DEPLOYMENT_TARGET = 12.0
    QMAKE_TARGET_BUNDLE_PREFIX = "com.derevenetz.oleg.christmassnow"
}
