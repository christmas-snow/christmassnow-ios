TEMPLATE = app
TARGET = christmassnow

QT += quick quickcontrols2 sql multimedia sensors purchasing
CONFIG += c++17

DEFINES += QT_DEPRECATED_WARNINGS QT_NO_CAST_FROM_ASCII QT_NO_CAST_TO_ASCII

INCLUDEPATH += 3rdparty

SOURCES += \
    src/contextguard.cpp \
    src/gifcreator.cpp \
    src/main.cpp \
    src/sparkcreator.cpp

OBJECTIVE_SOURCES += \
    src/admobhelper.mm \
    src/sharehelper.mm \
    src/storehelper.mm

HEADERS += \
    3rdparty/gif-h/gif.h \
    src/admobhelper.h \
    src/contextguard.h \
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

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

ios {
    CONFIG += qtquickcompiler

    INCLUDEPATH += ios/frameworks
    DEPENDPATH += ios/frameworks

    LIBS += -F $$PWD/ios/frameworks \
            -framework GoogleAppMeasurement \
            -framework GoogleMobileAds \
            -framework GoogleUtilities \
            -framework nanopb \
            -framework UIKit \
            -framework StoreKit

    QMAKE_LFLAGS += -ObjC

    QMAKE_APPLE_DEVICE_ARCHS = arm64
    QMAKE_INFO_PLIST = ios/Info.plist
}
