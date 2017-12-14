#!/bin/sh

PATH=$PATH:~/Qt/5.9.1/ios/bin

lupdate ../christmassnow.pro -ts ../translations/christmassnow_ru.src.ts
lupdate ../qml               -ts ../translations/christmassnow_ru.qml.ts

lupdate ../christmassnow.pro -ts ../translations/christmassnow_de.src.ts
lupdate ../qml               -ts ../translations/christmassnow_de.qml.ts

lupdate ../christmassnow.pro -ts ../translations/christmassnow_fr.src.ts
lupdate ../qml               -ts ../translations/christmassnow_fr.qml.ts

lupdate ../christmassnow.pro -ts ../translations/christmassnow_zh.src.ts
lupdate ../qml               -ts ../translations/christmassnow_zh.qml.ts

lupdate ../christmassnow.pro -ts ../translations/christmassnow_es.src.ts
lupdate ../qml               -ts ../translations/christmassnow_es.qml.ts

lupdate ../christmassnow.pro -ts ../translations/christmassnow_it.src.ts
lupdate ../qml               -ts ../translations/christmassnow_it.qml.ts

lconvert ../translations/christmassnow_ru.src.ts ../translations/christmassnow_ru.qml.ts -o ../translations/christmassnow_ru.ts
lconvert ../translations/christmassnow_de.src.ts ../translations/christmassnow_de.qml.ts -o ../translations/christmassnow_de.ts
lconvert ../translations/christmassnow_fr.src.ts ../translations/christmassnow_fr.qml.ts -o ../translations/christmassnow_fr.ts
lconvert ../translations/christmassnow_zh.src.ts ../translations/christmassnow_zh.qml.ts -o ../translations/christmassnow_zh.ts
lconvert ../translations/christmassnow_es.src.ts ../translations/christmassnow_es.qml.ts -o ../translations/christmassnow_es.ts
lconvert ../translations/christmassnow_it.src.ts ../translations/christmassnow_it.qml.ts -o ../translations/christmassnow_it.ts
