import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Particles 2.0
import QtMultimedia 5.9
import QtSensors 5.9
import SparkCreator 1.0

import "Dialog"
import "Snow"

Item {
    id:    snowPage
    state: "snowLevel0"

    property bool appInForeground:        Qt.application.active
    property bool pageActive:             false

    property int bannerViewHeight:        AdMobHelper.bannerViewHeight
    property int currentBackgroundNum:    1
    property int maxBackgroundNum:        3
    property int bigSnowflakesCount:      10
    property int bigSnowflakesCountMax:   10
    property int smallSnowflakesCount:    80
    property int smallSnowflakesCountMax: 80
    property int ceaseTime:               5000

    property real snowflakesAngle:        90.0
    property real defaultSnowflakesAngle: 90.0
    property real snowflakesVelocity:     30.0
    property real snowflakesVelocityMin:  30.0
    property real snowflakesVelocityMax:  360.0
    property real accelShakeThreshold:    50.0

    property var sparksList:              null

    states: [
        State {
            name: "snowLevel0"

            PropertyChanges {
                target:  snowImage1
                visible: false
            }

            PropertyChanges {
                target:  snowImage2
                visible: false
            }

            PropertyChanges {
                target:  snowImage3
                visible: false
            }

            PropertyChanges {
                target:  snowImage4
                visible: false
            }

            PropertyChanges {
                target:  snowImage5
                visible: false
            }

        },

        State {
            name: "snowLevel1"

            PropertyChanges {
                target:  snowImage1
                visible: true
            }

            PropertyChanges {
                target:  snowImage2
                visible: false
            }

            PropertyChanges {
                target:  snowImage3
                visible: false
            }

            PropertyChanges {
                target:  snowImage4
                visible: false
            }

            PropertyChanges {
                target:  snowImage5
                visible: false
            }
        },

        State {
            name: "snowLevel2"

            PropertyChanges {
                target:  snowImage1
                visible: true
            }

            PropertyChanges {
                target:  snowImage2
                visible: true
            }

            PropertyChanges {
                target:  snowImage3
                visible: false
            }

            PropertyChanges {
                target:  snowImage4
                visible: false
            }

            PropertyChanges {
                target:  snowImage5
                visible: false
            }
        },

        State {
            name: "snowLevel3"

            PropertyChanges {
                target:  snowImage1
                visible: true
            }

            PropertyChanges {
                target:  snowImage2
                visible: true
            }

            PropertyChanges {
                target:  snowImage3
                visible: true
            }

            PropertyChanges {
                target:  snowImage4
                visible: false
            }

            PropertyChanges {
                target:  snowImage5
                visible: false
            }
        },

        State {
            name: "snowLevel4"

            PropertyChanges {
                target:  snowImage1
                visible: true
            }

            PropertyChanges {
                target:  snowImage2
                visible: true
            }

            PropertyChanges {
                target:  snowImage3
                visible: true
            }

            PropertyChanges {
                target:  snowImage4
                visible: true
            }

            PropertyChanges {
                target:  snowImage5
                visible: true
            }
        }
    ]

    transitions: [
        Transition {
            from: "snowLevel0"
            to:   "snowLevel1"

            NumberAnimation {
                target:     snowImage1
                properties: "opacity"
                from:       0.0
                to:         1.0
                duration:   5000
            }
        },

        Transition {
            from: "snowLevel1"
            to:   "snowLevel2"

            NumberAnimation {
                target:     snowImage2
                properties: "opacity"
                from:       0.0
                to:         1.0
                duration:   5000
            }
        },

        Transition {
            from: "snowLevel2"
            to:   "snowLevel3"

            NumberAnimation {
                target:     snowImage3
                properties: "opacity"
                from:       0.0
                to:         1.0
                duration:   5000
            }
        },

        Transition {
            from: "snowLevel3"
            to:   "snowLevel4"

            NumberAnimation {
                target:     snowImage4
                properties: "opacity"
                from:       0.0
                to:         1.0
                duration:   5000
            }

            NumberAnimation {
                target:     snowImage5
                properties: "opacity"
                from:       0.0
                to:         0.4
                duration:   5000
            }
        }
    ]

    onStateChanged: {
        if (state === "snowLevel4") {
            sparkCreator.createRandomSparks();
        } else {
            if (sparksList !== null) {
                for (var i = 0; i < sparksList.length; i++) {
                    sparksList[i].destroy();
                }

                sparksList = null;
            }
        }
    }

    onAppInForegroundChanged: {
        if (appInForeground && pageActive) {
            var background_num = mainWindow.getSetting("BackgroundNum", 1);

            if (background_num <= maxBackgroundNum) {
                currentBackgroundNum = background_num;
            }

            buttonImageRow.visible = true;

            helpOnStartupTimer.restart();
            snowflakesCountTimer.restart();
            snowflakesAngleVelocityTimer.restart();
        }
    }

    onPageActiveChanged: {
        if (appInForeground && pageActive) {
            var background_num = mainWindow.getSetting("BackgroundNum", 1);

            if (background_num <= maxBackgroundNum) {
                currentBackgroundNum = background_num;
            }

            buttonImageRow.visible = true;

            helpOnStartupTimer.restart();
            snowflakesCountTimer.restart();
            snowflakesAngleVelocityTimer.restart();
        }
    }

    onBigSnowflakesCountChanged: {
        if (bigSnowflakesCount > (bigSnowflakesCountMax * 4) / 5) {
            state = "snowLevel0";
        } else if (bigSnowflakesCount > (bigSnowflakesCountMax * 3) / 5) {
            state = "snowLevel1";
        } else if (bigSnowflakesCount > (bigSnowflakesCountMax * 2) / 5) {
            state = "snowLevel2";
        } else if (bigSnowflakesCount > (bigSnowflakesCountMax * 1) / 5) {
            state = "snowLevel3";
        } else {
            state = "snowLevel4";
        }
    }

    function resetParticleSystems() {
        particleSystem1.reset();
        particleSystem2.reset();
        particleSystem3.reset();
        particleSystem4.reset();
        particleSystem5.reset();
        particleSystem6.reset();
        particleSystem7.reset();
        particleSystem8.reset();
    }

    function captureImage() {
        waitRectangle.visible = true;

        if (!backgroundImage.grabToImage(function (result) {
            result.saveToFile(ShareHelper.imageFilePath);

            ShareHelper.showShareToView(ShareHelper.imageFilePath);

            waitRectangle.visible = false;
        })) {
            console.log("grabToImage() failed");

            waitRectangle.visible = false;
        }
    }

    function shareToViewCompleted() {
        StoreHelper.requestReview();
    }

    Audio {
        volume:   1.0
        muted:    !snowPage.appInForeground || !snowPage.pageActive
        source:   "qrc:/resources/sound/snow/music.mp3"
        autoPlay: true
        loops:    Audio.Infinite

        onError: {
            console.log(errorString);
        }
    }

    SparkCreator {
        id:                     sparkCreator
        minSparksCount:         50
        maxSparksCount:         100
        imageFilePath:          ":/resources/images/snow/bg-%1-4.png".arg(snowPage.currentBackgroundNum)

        onError: {
            console.log(errorString);
        }

        onRandomSparksCreated: {
            if (snowPage.sparksList !== null) {
                for (var i = 0; i < snowPage.sparksList.length; i++) {
                    snowPage.sparksList[i].destroy();
                }

                snowPage.sparksList = null;
            }

            snowPage.sparksList = [];

            var scale_width  = backgroundImage.width  / backgroundImage.sourceSize.width;
            var scale_height = backgroundImage.height / backgroundImage.sourceSize.height;

            for (var j = 0; j < sparks.length; j++) {
                var component = Qt.createComponent("Snow/Spark.qml");

                if (component.status === Component.Ready) {
                    var spark = component.createObject(backgroundImage, {"z": 5, "opacity": 0.0});

                    spark.x         = Math.floor(sparks[j].x * scale_width)  - spark.width  / 2;
                    spark.y         = Math.floor(sparks[j].y * scale_height) - spark.height / 2;
                    spark.sparkType = Math.floor(spark.maxSparkType * Math.random()) + 1;

                    snowPage.sparksList.push(spark);
                } else {
                    console.log(component.errorString());
                }
            }
        }
    }

    Rectangle {
        id:           backgroundRectangle
        anchors.fill: parent
        color:        "black"

        Image {
            id:               backgroundImage
            anchors.centerIn: parent
            width:            parent.width
            height:           parent.height
            source:           "qrc:/resources/images/snow/bg-%1.png".arg(snowPage.currentBackgroundNum)
            fillMode:         Image.PreserveAspectCrop

            property bool geometrySettled: false

            onPaintedWidthChanged: {
                if (!geometrySettled && width > 0 && height > 0 && paintedWidth > 0 && paintedHeight > 0) {
                    geometrySettled = true;

                    width  = paintedWidth;
                    height = paintedHeight;
                }
            }

            onPaintedHeightChanged: {
                if (!geometrySettled && width > 0 && height > 0 && paintedWidth > 0 && paintedHeight > 0) {
                    geometrySettled = true;

                    width  = paintedWidth;
                    height = paintedHeight;
                }
            }

            Image {
                id:               snowImage1
                anchors.centerIn: parent
                z:                1
                width:            parent.width
                height:           parent.height
                source:           "qrc:/resources/images/snow/bg-%1-1.png".arg(snowPage.currentBackgroundNum)
                fillMode:         Image.PreserveAspectCrop

                property bool geometrySettled: false

                onPaintedWidthChanged: {
                    if (!geometrySettled && width > 0 && height > 0 && paintedWidth > 0 && paintedHeight > 0) {
                        geometrySettled = true;

                        width  = paintedWidth;
                        height = paintedHeight;
                    }
                }

                onPaintedHeightChanged: {
                    if (!geometrySettled && width > 0 && height > 0 && paintedWidth > 0 && paintedHeight > 0) {
                        geometrySettled = true;

                        width  = paintedWidth;
                        height = paintedHeight;
                    }
                }
            }

            Image {
                id:               snowImage2
                anchors.centerIn: parent
                z:                2
                width:            parent.width
                height:           parent.height
                source:           "qrc:/resources/images/snow/bg-%1-2.png".arg(snowPage.currentBackgroundNum)
                fillMode:         Image.PreserveAspectCrop

                property bool geometrySettled: false

                onPaintedWidthChanged: {
                    if (!geometrySettled && width > 0 && height > 0 && paintedWidth > 0 && paintedHeight > 0) {
                        geometrySettled = true;

                        width  = paintedWidth;
                        height = paintedHeight;
                    }
                }

                onPaintedHeightChanged: {
                    if (!geometrySettled && width > 0 && height > 0 && paintedWidth > 0 && paintedHeight > 0) {
                        geometrySettled = true;

                        width  = paintedWidth;
                        height = paintedHeight;
                    }
                }
            }

            Image {
                id:               snowImage3
                anchors.centerIn: parent
                z:                3
                width:            parent.width
                height:           parent.height
                source:           "qrc:/resources/images/snow/bg-%1-3.png".arg(snowPage.currentBackgroundNum)
                fillMode:         Image.PreserveAspectCrop

                property bool geometrySettled: false

                onPaintedWidthChanged: {
                    if (!geometrySettled && width > 0 && height > 0 && paintedWidth > 0 && paintedHeight > 0) {
                        geometrySettled = true;

                        width  = paintedWidth;
                        height = paintedHeight;
                    }
                }

                onPaintedHeightChanged: {
                    if (!geometrySettled && width > 0 && height > 0 && paintedWidth > 0 && paintedHeight > 0) {
                        geometrySettled = true;

                        width  = paintedWidth;
                        height = paintedHeight;
                    }
                }
            }

            Image {
                id:               snowImage4
                anchors.centerIn: parent
                z:                4
                width:            parent.width
                height:           parent.height
                source:           "qrc:/resources/images/snow/bg-%1-4.png".arg(snowPage.currentBackgroundNum)
                fillMode:         Image.PreserveAspectCrop

                property bool geometrySettled: false

                onPaintedWidthChanged: {
                    if (!geometrySettled && width > 0 && height > 0 && paintedWidth > 0 && paintedHeight > 0) {
                        geometrySettled = true;

                        width  = paintedWidth;
                        height = paintedHeight;
                    }
                }

                onPaintedHeightChanged: {
                    if (!geometrySettled && width > 0 && height > 0 && paintedWidth > 0 && paintedHeight > 0) {
                        geometrySettled = true;

                        width  = paintedWidth;
                        height = paintedHeight;
                    }
                }
            }

            Image {
                id:               snowImage5
                anchors.centerIn: parent
                z:                6
                width:            parent.width
                height:           parent.height
                source:           "qrc:/resources/images/snow/bg-%1-4.png".arg(snowPage.currentBackgroundNum)
                fillMode:         Image.PreserveAspectCrop

                property bool geometrySettled: false

                onPaintedWidthChanged: {
                    if (!geometrySettled && width > 0 && height > 0 && paintedWidth > 0 && paintedHeight > 0) {
                        geometrySettled = true;

                        width  = paintedWidth;
                        height = paintedHeight;
                    }
                }

                onPaintedHeightChanged: {
                    if (!geometrySettled && width > 0 && height > 0 && paintedWidth > 0 && paintedHeight > 0) {
                        geometrySettled = true;

                        width  = paintedWidth;
                        height = paintedHeight;
                    }
                }
            }

            ParticleSystem {
                id:      particleSystem1
                running: snowPage.pageActive
            }

            Emitter {
                anchors.fill: parent
                system:       particleSystem1
                lifeSpan:     1000
                size:         32
                emitRate:     snowPage.bigSnowflakesCount

                velocity: AngleDirection {
                    angle:              snowPage.snowflakesAngle
                    angleVariation:     30
                    magnitude:          snowPage.snowflakesVelocity
                    magnitudeVariation: 10
                }

                ImageParticle {
                    z:       10
                    opacity: 0.75
                    system:  particleSystem1
                    source:  "qrc:/resources/images/snow/snowflake-1-big.png"
                }
            }

            ParticleSystem {
                id:      particleSystem2
                running: snowPage.pageActive
            }

            Emitter {
                anchors.fill: parent
                system:       particleSystem2
                lifeSpan:     1000
                size:         32
                emitRate:     snowPage.bigSnowflakesCount

                velocity: AngleDirection {
                    angle:              snowPage.snowflakesAngle
                    angleVariation:     30
                    magnitude:          snowPage.snowflakesVelocity
                    magnitudeVariation: 10
                }

                ImageParticle {
                    z:       10
                    opacity: 0.75
                    system:  particleSystem2
                    source:  "qrc:/resources/images/snow/snowflake-2-big.png"
                }
            }

            ParticleSystem {
                id:      particleSystem3
                running: snowPage.pageActive
            }

            Emitter {
                anchors.fill: parent
                system:       particleSystem3
                lifeSpan:     1000
                size:         32
                emitRate:     snowPage.bigSnowflakesCount

                velocity: AngleDirection {
                    angle:              snowPage.snowflakesAngle
                    angleVariation:     30
                    magnitude:          snowPage.snowflakesVelocity
                    magnitudeVariation: 10
                }

                ImageParticle {
                    z:       10
                    opacity: 0.75
                    system:  particleSystem3
                    source:  "qrc:/resources/images/snow/snowflake-3-big.png"
                }
            }

            ParticleSystem {
                id:      particleSystem4
                running: snowPage.pageActive
            }

            Emitter {
                anchors.fill: parent
                system:       particleSystem4
                lifeSpan:     1000
                size:         32
                emitRate:     snowPage.bigSnowflakesCount

                velocity: AngleDirection {
                    angle:              snowPage.snowflakesAngle
                    angleVariation:     30
                    magnitude:          snowPage.snowflakesVelocity
                    magnitudeVariation: 10
                }

                ImageParticle {
                    z:       10
                    opacity: 0.75
                    system:  particleSystem2
                    source:  "qrc:/resources/images/snow/snowflake-4-big.png"
                }
            }

            ParticleSystem {
                id:      particleSystem5
                running: snowPage.pageActive
            }

            Emitter {
                anchors.fill: parent
                system:       particleSystem5
                lifeSpan:     1000
                size:         16
                emitRate:     snowPage.smallSnowflakesCount

                velocity: AngleDirection {
                    angle:              snowPage.snowflakesAngle
                    angleVariation:     30
                    magnitude:          snowPage.snowflakesVelocity
                    magnitudeVariation: 10
                }

                ImageParticle {
                    z:       10
                    opacity: 0.75
                    system:  particleSystem5
                    source:  "qrc:/resources/images/snow/snowflake-1-small.png"
                }
            }

            ParticleSystem {
                id:      particleSystem6
                running: snowPage.pageActive
            }

            Emitter {
                anchors.fill: parent
                system:       particleSystem6
                lifeSpan:     1000
                size:         16
                emitRate:     snowPage.smallSnowflakesCount

                velocity: AngleDirection {
                    angle:              snowPage.snowflakesAngle
                    angleVariation:     30
                    magnitude:          snowPage.snowflakesVelocity
                    magnitudeVariation: 10
                }

                ImageParticle {
                    z:       10
                    opacity: 0.75
                    system:  particleSystem6
                    source:  "qrc:/resources/images/snow/snowflake-2-small.png"
                }
            }

            ParticleSystem {
                id:      particleSystem7
                running: snowPage.pageActive
            }

            Emitter {
                anchors.fill: parent
                system:       particleSystem7
                lifeSpan:     1000
                size:         16
                emitRate:     snowPage.smallSnowflakesCount

                velocity: AngleDirection {
                    angle:              snowPage.snowflakesAngle
                    angleVariation:     30
                    magnitude:          snowPage.snowflakesVelocity
                    magnitudeVariation: 10
                }

                ImageParticle {
                    z:       10
                    opacity: 0.75
                    system:  particleSystem7
                    source:  "qrc:/resources/images/snow/snowflake-3-small.png"
                }
            }

            ParticleSystem {
                id:      particleSystem8
                running: snowPage.pageActive
            }

            Emitter {
                anchors.fill: parent
                system:       particleSystem8
                lifeSpan:     1000
                size:         16
                emitRate:     snowPage.smallSnowflakesCount

                velocity: AngleDirection {
                    angle:              snowPage.snowflakesAngle
                    angleVariation:     30
                    magnitude:          snowPage.snowflakesVelocity
                    magnitudeVariation: 10
                }

                ImageParticle {
                    z:       10
                    opacity: 0.75
                    system:  particleSystem8
                    source:  "qrc:/resources/images/snow/snowflake-4-small.png"
                }
            }

            MouseArea {
                id:           snowfallMouseArea
                anchors.fill: parent
                z:            15

                property int pressedX:     0
                property int pressedY:     0

                property real pressedTime: (new Date).getTime()

                onPositionChanged: {
                    var velocity = Math.sqrt(Math.pow(mouse.x - pressedX, 2) + Math.pow(mouse.y - pressedY, 2)) * 1000 / ((new Date).getTime() - pressedTime);

                    snowPage.snowflakesAngle    = (Math.atan2(mouse.y - pressedY, mouse.x - pressedX) * 180) / Math.PI;
                    snowPage.snowflakesVelocity = velocity < snowPage.snowflakesVelocityMax ? velocity : snowPage.snowflakesVelocityMax;
                }

                onPressed: {
                    pressedX    = mouse.x;
                    pressedY    = mouse.y;
                    pressedTime = (new Date).getTime();
                }

                onDoubleClicked: {
                    if (buttonImageRow.visible && !settingsListRectangle.visible) {
                        buttonImageRow.visible = false;
                    } else {
                        buttonImageRow.visible = true;
                    }
                }
            }
        }

        Row {
            id:                       buttonImageRow
            anchors.bottom:           parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            z:                        20
            spacing:                  16

            Image {
                id:     settingsButtonImage
                width:  64
                height: 64
                source: "qrc:/resources/images/snow/button_settings.png"

                MouseArea {
                    id:           settingsButtonMouseArea
                    anchors.fill: parent

                    onClicked: {
                        if (settingsListRectangle.visible) {
                            settingsListRectangle.visible = false;
                            settingsButtonImage.source    = "qrc:/resources/images/snow/button_settings.png";
                        } else {
                            settingsListRectangle.visible = true;
                            settingsButtonImage.source    = "qrc:/resources/images/snow/button_settings_pressed.png";
                        }
                    }
                }
            }

            Image {
                id:     captureImageButtonImage
                width:  64
                height: 64
                source: "qrc:/resources/images/snow/button_capture_image.png"

                MouseArea {
                    id:           captureImageButtonMouseArea
                    anchors.fill: parent

                    onClicked: {
                        snowPage.captureImage();
                    }
                }
            }

            Image {
                id:     captureGIFButtonImage
                width:  64
                height: 64
                source: "qrc:/resources/images/snow/button_capture_gif.png"

                MouseArea {
                    id:           captureGIFButtonMouseArea
                    anchors.fill: parent

                    onClicked: {
                        captureGIFTimer.start();
                    }
                }
            }

            Image {
                id:     helpButtonImage
                width:  64
                height: 64
                source: "qrc:/resources/images/snow/button_help.png"

                MouseArea {
                    id:           helpButtonMouseArea
                    anchors.fill: parent

                    onClicked: {
                        helpDialog.open();
                    }
                }
            }
        }

        Rectangle {
            id:                   settingsListRectangle
            anchors.top:          parent.top
            anchors.bottom:       buttonImageRow.top
            anchors.topMargin:    Math.max(snowPage.bannerViewHeight + 8, 34)
            anchors.bottomMargin: 16
            width:                96
            z:                    25
            clip:                 true
            color:                "black"
            opacity:              0.75
            visible:              false

            ListView {
                id:           settingsListView
                anchors.fill: parent
                orientation:  ListView.Vertical
                model:        settingsVisualDataModel

                VisualDataModel {
                    id: settingsVisualDataModel

                    model: ListModel {
                        id: settingsListModel
                    }

                    delegate: Image {
                        id:     settingsItemDelegate
                        width:  settingsListRectangle.width
                        height: sourceSize.width > 0 ? (width / sourceSize.width) * sourceSize.height : 0
                        source: "qrc:/resources/images/snow/bg-%1.png".arg(settingNumber)

                        MouseArea {
                            id:           settingsItemMouseArea
                            anchors.fill: parent

                            onClicked: {
                                if (mainWindow.fullVersion || settingNumber === 1) {
                                    snowPage.currentBackgroundNum = settingNumber;
                                    snowPage.bigSnowflakesCount   = snowPage.bigSnowflakesCountMax;
                                    snowPage.smallSnowflakesCount = snowPage.smallSnowflakesCountMax;

                                    snowPage.resetParticleSystems();

                                    mainWindow.setSetting("BackgroundNum", snowPage.currentBackgroundNum);
                                } else {
                                    purchaseDialog.open();
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
             id:           waitRectangle
             anchors.fill: parent
             z:            30
             color:        "black"
             opacity:      0.75
             visible:      false

             BusyIndicator {
                 anchors.centerIn: parent
                 running:          parent.visible
             }

             MouseArea {
                 anchors.fill: parent
             }
         }
    }

    PurchaseDialog {
        id: purchaseDialog
        z:  35

        onPurchaseFullVersion: {
            mainWindow.purchaseFullVersion();
        }

        onRestorePurchases: {
            mainWindow.restorePurchases();
        }
    }

    HelpDialog {
        id: helpDialog
        z:  35
    }

    Accelerometer {
        id:       accelerometer
        dataRate: 10
        active:   snowPage.appInForeground && snowPage.pageActive

        property real lastReadingX: 0.0
        property real lastReadingY: 0.0
        property real lastReadingZ: 0.0

        onReadingChanged: {
            if (lastReadingX !== 0.0 || lastReadingY !== 0.0 || lastReadingZ !== 0.0) {
                if (Math.abs(reading.x - lastReadingX) > snowPage.accelShakeThreshold ||
                    Math.abs(reading.y - lastReadingY) > snowPage.accelShakeThreshold ||
                    Math.abs(reading.z - lastReadingZ) > snowPage.accelShakeThreshold) {
                    snowPage.bigSnowflakesCount   = snowPage.bigSnowflakesCountMax;
                    snowPage.smallSnowflakesCount = snowPage.smallSnowflakesCountMax;

                    snowPage.resetParticleSystems();
                }
            }

            lastReadingX = reading.x;
            lastReadingY = reading.y;
            lastReadingZ = reading.z;
        }
    }

    Timer {
        id:       helpOnStartupTimer
        interval: 100

        onTriggered: {
            if (mainWindow.getSetting("ShowHelpOnStartup", "true") === "true") {
                helpDialog.open();
            }

            mainWindow.setSetting("ShowHelpOnStartup", "false");
        }
    }

    Timer {
        id:               captureGIFTimer
        interval:         200
        repeat:           true
        triggeredOnStart: true

        property bool lastRunning: false

        property int frameNumber:  0
        property int framesCount:  5

        onRunningChanged: {
            if (running && !lastRunning) {
                waitRectangle.visible = true;

                frameNumber = 0;
            } else if (!running && lastRunning) {
                if (frameNumber >= framesCount) {
                    if (GIFCreator.createGIF(framesCount, interval / 10)) {
                        ShareHelper.showShareToView(GIFCreator.gifFilePath);
                    } else {
                        console.log("createGIF() failed");
                    }
                }

                waitRectangle.visible = false;
            }

            lastRunning = running;
        }

        onTriggered: {
            if (frameNumber < framesCount) {
                var frame_number = frameNumber;

                if (!backgroundImage.grabToImage(function (result) {
                    result.saveToFile(GIFCreator.imageFilePathMask.arg(frame_number));
                })) {
                    console.log("grabToImage() failed for frame %1".arg(frame_number));
                }

                frameNumber = frameNumber + 1;
            } else {
                stop();
            }
        }
    }

    Timer {
        id:       snowflakesCountTimer
        interval: 1000
        repeat:   true

        onTriggered: {
            if (snowPage.bigSnowflakesCount > 1) {
                snowPage.bigSnowflakesCount = snowPage.bigSnowflakesCount - 1;
            }
            if (snowPage.smallSnowflakesCount > 4) {
                snowPage.smallSnowflakesCount = snowPage.smallSnowflakesCount - 4;
            }
        }
    }

    Timer {
        id:       snowflakesAngleVelocityTimer
        interval: 100
        repeat:   true

        onTriggered: {
            var angle    = Math.abs(snowPage.snowflakesAngle) < snowPage.defaultSnowflakesAngle ? snowPage.snowflakesAngle + (180 / (snowPage.ceaseTime / interval)) :
                                                                                                  snowPage.snowflakesAngle - (180 / (snowPage.ceaseTime / interval));
            var velocity = snowPage.snowflakesVelocity - snowPage.snowflakesVelocityMax / (snowPage.ceaseTime / interval);

            snowPage.snowflakesAngle    = angle < -180 ? 180 : angle;
            snowPage.snowflakesVelocity = velocity < snowPage.snowflakesVelocityMin ? snowPage.snowflakesVelocityMin : velocity;
        }
    }

    Component.onCompleted: {
        ShareHelper.shareToViewCompleted.connect(shareToViewCompleted);

        settingsListModel.clear();

        for (var i = 1; i <= snowPage.maxBackgroundNum; i++) {
            settingsListModel.append({"settingType": "background", "settingNumber": i});
        }
    }
}
