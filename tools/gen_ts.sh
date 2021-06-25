#!/bin/sh

PATH="$PATH:$HOME/Qt/5.12.11/ios/bin"

lupdate -locations absolute ../christmassnow.pro -ts ../translations/christmassnow_de.src.ts
lupdate -locations absolute ../qml               -ts ../translations/christmassnow_de.qml.ts

lupdate -locations absolute ../christmassnow.pro -ts ../translations/christmassnow_es.src.ts
lupdate -locations absolute ../qml               -ts ../translations/christmassnow_es.qml.ts

lupdate -locations absolute ../christmassnow.pro -ts ../translations/christmassnow_fr.src.ts
lupdate -locations absolute ../qml               -ts ../translations/christmassnow_fr.qml.ts

lupdate -locations absolute ../christmassnow.pro -ts ../translations/christmassnow_it.src.ts
lupdate -locations absolute ../qml               -ts ../translations/christmassnow_it.qml.ts

lupdate -locations absolute ../christmassnow.pro -ts ../translations/christmassnow_ru.src.ts
lupdate -locations absolute ../qml               -ts ../translations/christmassnow_ru.qml.ts

lupdate -locations absolute ../christmassnow.pro -ts ../translations/christmassnow_zh.src.ts
lupdate -locations absolute ../qml               -ts ../translations/christmassnow_zh.qml.ts

lconvert ../translations/christmassnow_de.src.ts ../translations/christmassnow_de.qml.ts -o ../translations/christmassnow_de.ts
lconvert ../translations/christmassnow_es.src.ts ../translations/christmassnow_es.qml.ts -o ../translations/christmassnow_es.ts
lconvert ../translations/christmassnow_fr.src.ts ../translations/christmassnow_fr.qml.ts -o ../translations/christmassnow_fr.ts
lconvert ../translations/christmassnow_it.src.ts ../translations/christmassnow_it.qml.ts -o ../translations/christmassnow_it.ts
lconvert ../translations/christmassnow_ru.src.ts ../translations/christmassnow_ru.qml.ts -o ../translations/christmassnow_ru.ts
lconvert ../translations/christmassnow_zh.src.ts ../translations/christmassnow_zh.qml.ts -o ../translations/christmassnow_zh.ts
