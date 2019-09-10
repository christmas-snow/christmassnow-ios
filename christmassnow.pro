TEMPLATE = app
TARGET = christmassnow.full

QT += quick quickcontrols2 sql multimedia sensors
CONFIG += c++11

DEFINES += QT_DEPRECATED_WARNINGS QT_NO_CAST_FROM_ASCII QT_NO_CAST_TO_ASCII

SOURCES += src/main.cpp \
    src/sparkcreator.cpp \
    src/gifcreator.cpp

OBJECTIVE_SOURCES += \
    src/sharehelper.mm \
    src/storehelper.mm

HEADERS += \
    src/sharehelper.h \
    src/storehelper.h \
    src/gif.h \
    src/gifcreator.h \
    src/sparkcreator.h

RESOURCES += \
    qml.qrc \
    resources.qrc \
    translations.qrc

TRANSLATIONS += \
    translations/christmassnow_ru.ts \
    translations/christmassnow_de.ts \
    translations/christmassnow_fr.ts \
    translations/christmassnow_zh.ts \
    translations/christmassnow_es.ts \
    translations/christmassnow_it.ts

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

ios {
    CONFIG += qtquickcompiler

    INCLUDEPATH += $$PWD/ios/frameworks
    DEPENDPATH += $$PWD/ios/frameworks

    LIBS += -F $$PWD/ios/frameworks \
            -framework UIKit \
            -framework StoreKit

    QMAKE_APPLE_DEVICE_ARCHS = arm64
    QMAKE_INFO_PLIST = ios/Info.plist
}
