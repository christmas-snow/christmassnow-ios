import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Particles 2.12
import QtMultimedia 5.12
import QtSensors 5.12
import SparkCreator 1.0

import "Dialog"
import "Snow"

import "../Util.js" as UtilScript

Item {
    id:    snowPage
    state: pageState(bigSnowflakesCount, maxBigSnowflakesCount)

    readonly property bool appInForeground:        Qt.application.state === Qt.ApplicationActive
    readonly property bool pageActive:             StackView.status === StackView.Active

    readonly property int bannerViewHeight:        AdMobHelper.bannerViewHeight
    readonly property int maxBackgroundNum:        3
    readonly property int maxBigSnowflakesCount:   10
    readonly property int maxSmallSnowflakesCount: 80
    readonly property int ceaseTime:               5000

    readonly property real defaultSnowflakesAngle: 90.0
    readonly property real minSnowflakesVelocity:  UtilScript.dp(30.0)
    readonly property real maxSnowflakesVelocity:  UtilScript.dp(360.0)
    readonly property real accelShakeThreshold:    50.0

    property int currentBackgroundNum:             1
    property int bigSnowflakesCount:               10
    property int smallSnowflakesCount:             80

    property real snowflakesAngle:                 90.0
    property real snowflakesVelocity:              UtilScript.dp(30.0)

    property var sparksList:                       null

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
        if (appInForeground) {
            buttonImageRow.visible = true;
        }
    }

    onCurrentBackgroundNumChanged: {
        mainWindow.setSetting("BackgroundNum", currentBackgroundNum.toString(10));
    }

    function pageState(big_snowflakes_count, max_big_snowflakes_count) {
        if (big_snowflakes_count > (max_big_snowflakes_count * 4) / 5) {
            return "snowLevel0";
        } else if (big_snowflakes_count > (max_big_snowflakes_count * 3) / 5) {
            return "snowLevel1";
        } else if (big_snowflakes_count > (max_big_snowflakes_count * 2) / 5) {
            return "snowLevel2";
        } else if (big_snowflakes_count > (max_big_snowflakes_count * 1) / 5) {
            return "snowLevel3";
        } else {
            return "snowLevel4";
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
        waitArea.visible = true;

        if (!backgroundImage.grabToImage(function (result) {
            if (result.saveToFile(ShareHelper.imageFilePath)) {
                ShareHelper.showShareToView(ShareHelper.imageFilePath);
            } else {
                console.log("saveToFile() failed");
            }

            waitArea.visible = false;
        })) {
            console.log("grabToImage() failed");

            waitArea.visible = false;
        }
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
        id:             sparkCreator
        minSparksCount: 50
        maxSparksCount: 100
        imageFilePath:  ":/resources/images/snow/bg-%1-4.png".arg(snowPage.currentBackgroundNum)

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
            width:            Math.floor(imageWidth(sourceSize.width, sourceSize.height, parent.width, parent.height))
            height:           Math.floor(imageHeight(sourceSize.width, sourceSize.height, parent.width, parent.height))
            source:           "qrc:/resources/images/snow/bg-%1.png".arg(snowPage.currentBackgroundNum)
            fillMode:         Image.PreserveAspectCrop

            function imageWidth(src_width, src_height, dst_width, dst_height) {
                if (src_width > 0 && src_height > 0 && dst_width > 0 && dst_height > 0) {
                    if (dst_width / dst_height < src_width / src_height) {
                        return src_width * dst_height / src_height;
                    } else {
                        return dst_width;
                    }
                } else {
                    return 0;
                }
            }

            function imageHeight(src_width, src_height, dst_width, dst_height) {
                if (src_width > 0 && src_height > 0 && dst_width > 0 && dst_height > 0) {
                    if (dst_width / dst_height < src_width / src_height) {
                        return dst_height;
                    } else {
                        return src_height * dst_width / src_width;
                    }
                } else {
                    return 0;
                }
            }

            Image {
                id:               snowImage1
                anchors.centerIn: parent
                z:                1
                width:            Math.floor(imageWidth(sourceSize.width, sourceSize.height, parent.width, parent.height))
                height:           Math.floor(imageHeight(sourceSize.width, sourceSize.height, parent.width, parent.height))
                source:           "qrc:/resources/images/snow/bg-%1-1.png".arg(snowPage.currentBackgroundNum)
                fillMode:         Image.PreserveAspectCrop

                function imageWidth(src_width, src_height, dst_width, dst_height) {
                    if (src_width > 0 && src_height > 0 && dst_width > 0 && dst_height > 0) {
                        if (dst_width / dst_height < src_width / src_height) {
                            return src_width * dst_height / src_height;
                        } else {
                            return dst_width;
                        }
                    } else {
                        return 0;
                    }
                }

                function imageHeight(src_width, src_height, dst_width, dst_height) {
                    if (src_width > 0 && src_height > 0 && dst_width > 0 && dst_height > 0) {
                        if (dst_width / dst_height < src_width / src_height) {
                            return dst_height;
                        } else {
                            return src_height * dst_width / src_width;
                        }
                    } else {
                        return 0;
                    }
                }
            }

            Image {
                id:               snowImage2
                anchors.centerIn: parent
                z:                2
                width:            Math.floor(imageWidth(sourceSize.width, sourceSize.height, parent.width, parent.height))
                height:           Math.floor(imageHeight(sourceSize.width, sourceSize.height, parent.width, parent.height))
                source:           "qrc:/resources/images/snow/bg-%1-2.png".arg(snowPage.currentBackgroundNum)
                fillMode:         Image.PreserveAspectCrop

                function imageWidth(src_width, src_height, dst_width, dst_height) {
                    if (src_width > 0 && src_height > 0 && dst_width > 0 && dst_height > 0) {
                        if (dst_width / dst_height < src_width / src_height) {
                            return src_width * dst_height / src_height;
                        } else {
                            return dst_width;
                        }
                    } else {
                        return 0;
                    }
                }

                function imageHeight(src_width, src_height, dst_width, dst_height) {
                    if (src_width > 0 && src_height > 0 && dst_width > 0 && dst_height > 0) {
                        if (dst_width / dst_height < src_width / src_height) {
                            return dst_height;
                        } else {
                            return src_height * dst_width / src_width;
                        }
                    } else {
                        return 0;
                    }
                }
            }

            Image {
                id:               snowImage3
                anchors.centerIn: parent
                z:                3
                width:            Math.floor(imageWidth(sourceSize.width, sourceSize.height, parent.width, parent.height))
                height:           Math.floor(imageHeight(sourceSize.width, sourceSize.height, parent.width, parent.height))
                source:           "qrc:/resources/images/snow/bg-%1-3.png".arg(snowPage.currentBackgroundNum)
                fillMode:         Image.PreserveAspectCrop

                function imageWidth(src_width, src_height, dst_width, dst_height) {
                    if (src_width > 0 && src_height > 0 && dst_width > 0 && dst_height > 0) {
                        if (dst_width / dst_height < src_width / src_height) {
                            return src_width * dst_height / src_height;
                        } else {
                            return dst_width;
                        }
                    } else {
                        return 0;
                    }
                }

                function imageHeight(src_width, src_height, dst_width, dst_height) {
                    if (src_width > 0 && src_height > 0 && dst_width > 0 && dst_height > 0) {
                        if (dst_width / dst_height < src_width / src_height) {
                            return dst_height;
                        } else {
                            return src_height * dst_width / src_width;
                        }
                    } else {
                        return 0;
                    }
                }
            }

            Image {
                id:               snowImage4
                anchors.centerIn: parent
                z:                4
                width:            Math.floor(imageWidth(sourceSize.width, sourceSize.height, parent.width, parent.height))
                height:           Math.floor(imageHeight(sourceSize.width, sourceSize.height, parent.width, parent.height))
                source:           "qrc:/resources/images/snow/bg-%1-4.png".arg(snowPage.currentBackgroundNum)
                fillMode:         Image.PreserveAspectCrop

                function imageWidth(src_width, src_height, dst_width, dst_height) {
                    if (src_width > 0 && src_height > 0 && dst_width > 0 && dst_height > 0) {
                        if (dst_width / dst_height < src_width / src_height) {
                            return src_width * dst_height / src_height;
                        } else {
                            return dst_width;
                        }
                    } else {
                        return 0;
                    }
                }

                function imageHeight(src_width, src_height, dst_width, dst_height) {
                    if (src_width > 0 && src_height > 0 && dst_width > 0 && dst_height > 0) {
                        if (dst_width / dst_height < src_width / src_height) {
                            return dst_height;
                        } else {
                            return src_height * dst_width / src_width;
                        }
                    } else {
                        return 0;
                    }
                }
            }

            Image {
                id:               snowImage5
                anchors.centerIn: parent
                z:                6
                width:            Math.floor(imageWidth(sourceSize.width, sourceSize.height, parent.width, parent.height))
                height:           Math.floor(imageHeight(sourceSize.width, sourceSize.height, parent.width, parent.height))
                source:           "qrc:/resources/images/snow/bg-%1-4.png".arg(snowPage.currentBackgroundNum)
                fillMode:         Image.PreserveAspectCrop

                function imageWidth(src_width, src_height, dst_width, dst_height) {
                    if (src_width > 0 && src_height > 0 && dst_width > 0 && dst_height > 0) {
                        if (dst_width / dst_height < src_width / src_height) {
                            return src_width * dst_height / src_height;
                        } else {
                            return dst_width;
                        }
                    } else {
                        return 0;
                    }
                }

                function imageHeight(src_width, src_height, dst_width, dst_height) {
                    if (src_width > 0 && src_height > 0 && dst_width > 0 && dst_height > 0) {
                        if (dst_width / dst_height < src_width / src_height) {
                            return dst_height;
                        } else {
                            return src_height * dst_width / src_width;
                        }
                    } else {
                        return 0;
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
                size:         UtilScript.dp(32)
                emitRate:     snowPage.bigSnowflakesCount

                velocity: AngleDirection {
                    angle:              snowPage.snowflakesAngle
                    angleVariation:     30
                    magnitude:          snowPage.snowflakesVelocity
                    magnitudeVariation: UtilScript.dp(10)
                }
            }

            ImageParticle {
                z:       10
                system:  particleSystem1
                source:  "qrc:/resources/images/snow/snowflake-1-big.png"
                opacity: 0.75
            }

            ParticleSystem {
                id:      particleSystem2
                running: snowPage.pageActive
            }

            Emitter {
                anchors.fill: parent
                system:       particleSystem2
                lifeSpan:     1000
                size:         UtilScript.dp(32)
                emitRate:     snowPage.bigSnowflakesCount

                velocity: AngleDirection {
                    angle:              snowPage.snowflakesAngle
                    angleVariation:     30
                    magnitude:          snowPage.snowflakesVelocity
                    magnitudeVariation: UtilScript.dp(10)
                }
            }

            ImageParticle {
                z:       10
                system:  particleSystem2
                source:  "qrc:/resources/images/snow/snowflake-2-big.png"
                opacity: 0.75
            }

            ParticleSystem {
                id:      particleSystem3
                running: snowPage.pageActive
            }

            Emitter {
                anchors.fill: parent
                system:       particleSystem3
                lifeSpan:     1000
                size:         UtilScript.dp(32)
                emitRate:     snowPage.bigSnowflakesCount

                velocity: AngleDirection {
                    angle:              snowPage.snowflakesAngle
                    angleVariation:     30
                    magnitude:          snowPage.snowflakesVelocity
                    magnitudeVariation: UtilScript.dp(10)
                }
            }

            ImageParticle {
                z:       10
                system:  particleSystem3
                source:  "qrc:/resources/images/snow/snowflake-3-big.png"
                opacity: 0.75
            }

            ParticleSystem {
                id:      particleSystem4
                running: snowPage.pageActive
            }

            Emitter {
                anchors.fill: parent
                system:       particleSystem4
                lifeSpan:     1000
                size:         UtilScript.dp(32)
                emitRate:     snowPage.bigSnowflakesCount

                velocity: AngleDirection {
                    angle:              snowPage.snowflakesAngle
                    angleVariation:     30
                    magnitude:          snowPage.snowflakesVelocity
                    magnitudeVariation: UtilScript.dp(10)
                }
            }

            ImageParticle {
                z:       10
                system:  particleSystem4
                source:  "qrc:/resources/images/snow/snowflake-4-big.png"
                opacity: 0.75
            }

            ParticleSystem {
                id:      particleSystem5
                running: snowPage.pageActive
            }

            Emitter {
                anchors.fill: parent
                system:       particleSystem5
                lifeSpan:     1000
                size:         UtilScript.dp(16)
                emitRate:     snowPage.smallSnowflakesCount

                velocity: AngleDirection {
                    angle:              snowPage.snowflakesAngle
                    angleVariation:     30
                    magnitude:          snowPage.snowflakesVelocity
                    magnitudeVariation: UtilScript.dp(10)
                }
            }

            ImageParticle {
                z:       10
                system:  particleSystem5
                source:  "qrc:/resources/images/snow/snowflake-1-small.png"
                opacity: 0.75
            }

            ParticleSystem {
                id:      particleSystem6
                running: snowPage.pageActive
            }

            Emitter {
                anchors.fill: parent
                system:       particleSystem6
                lifeSpan:     1000
                size:         UtilScript.dp(16)
                emitRate:     snowPage.smallSnowflakesCount

                velocity: AngleDirection {
                    angle:              snowPage.snowflakesAngle
                    angleVariation:     30
                    magnitude:          snowPage.snowflakesVelocity
                    magnitudeVariation: UtilScript.dp(10)
                }
            }

            ImageParticle {
                z:       10
                system:  particleSystem6
                source:  "qrc:/resources/images/snow/snowflake-2-small.png"
                opacity: 0.75
            }

            ParticleSystem {
                id:      particleSystem7
                running: snowPage.pageActive
            }

            Emitter {
                anchors.fill: parent
                system:       particleSystem7
                lifeSpan:     1000
                size:         UtilScript.dp(16)
                emitRate:     snowPage.smallSnowflakesCount

                velocity: AngleDirection {
                    angle:              snowPage.snowflakesAngle
                    angleVariation:     30
                    magnitude:          snowPage.snowflakesVelocity
                    magnitudeVariation: UtilScript.dp(10)
                }
            }

            ImageParticle {
                z:       10
                system:  particleSystem7
                source:  "qrc:/resources/images/snow/snowflake-3-small.png"
                opacity: 0.75
            }

            ParticleSystem {
                id:      particleSystem8
                running: snowPage.pageActive
            }

            Emitter {
                anchors.fill: parent
                system:       particleSystem8
                lifeSpan:     1000
                size:         UtilScript.dp(16)
                emitRate:     snowPage.smallSnowflakesCount

                velocity: AngleDirection {
                    angle:              snowPage.snowflakesAngle
                    angleVariation:     30
                    magnitude:          snowPage.snowflakesVelocity
                    magnitudeVariation: UtilScript.dp(10)
                }
            }

            ImageParticle {
                z:       10
                system:  particleSystem8
                source:  "qrc:/resources/images/snow/snowflake-4-small.png"
                opacity: 0.75
            }

            MouseArea {
                id:           snowfallMouseArea
                anchors.fill: parent
                z:            15

                property int pressEventX:       0
                property int pressEventY:       0

                property double pressEventTime: (new Date()).getTime()

                onPressed: {
                    pressEventX    = mouse.x;
                    pressEventY    = mouse.y;
                    pressEventTime = (new Date()).getTime();
                }

                onPositionChanged: {
                    var denom = (new Date()).getTime() - pressEventTime;

                    if (denom > 0) {
                        var velocity = Math.sqrt(Math.pow(mouse.x - pressEventX, 2) + Math.pow(mouse.y - pressEventY, 2)) * 1000 / denom;

                        snowPage.snowflakesAngle    = (Math.atan2(mouse.y - pressEventY, mouse.x - pressEventX) * 180) / Math.PI;
                        snowPage.snowflakesVelocity = velocity < snowPage.maxSnowflakesVelocity ? velocity : snowPage.maxSnowflakesVelocity;
                    }
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

        Image {
            id:                  adSettingsButtonImage
            anchors.top:         parent.top
            anchors.right:       parent.right
            anchors.topMargin:   Math.max(snowPage.bannerViewHeight + UtilScript.dp(8), UtilScript.dp(34))
            anchors.rightMargin: UtilScript.dp(8)
            z:                   1
            width:               UtilScript.dp(32)
            height:              UtilScript.dp(32)
            source:              "qrc:/resources/images/snow/button_ad_settings.png"
            fillMode:            Image.PreserveAspectFit

            MouseArea {
                id:           adSettingsButtonMouseArea
                anchors.fill: parent

                onClicked: {
                    adMobConsentDialog.open();
                }
            }
        }

        Row {
            id:                       buttonImageRow
            anchors.bottom:           parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin:     UtilScript.dp(30)
            z:                        1
            spacing:                  UtilScript.dp(16)

            Image {
                id:       settingsButtonImage
                width:    UtilScript.dp(64)
                height:   UtilScript.dp(64)
                source:   "qrc:/resources/images/snow/button_settings.png"
                fillMode: Image.PreserveAspectFit

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
                id:       captureImageButtonImage
                width:    UtilScript.dp(64)
                height:   UtilScript.dp(64)
                source:   "qrc:/resources/images/snow/button_capture_image.png"
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    id:           captureImageButtonMouseArea
                    anchors.fill: parent

                    onClicked: {
                        snowPage.captureImage();
                    }
                }
            }

            Image {
                id:       captureGIFButtonImage
                width:    UtilScript.dp(64)
                height:   UtilScript.dp(64)
                source:   "qrc:/resources/images/snow/button_capture_gif.png"
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    id:           captureGIFButtonMouseArea
                    anchors.fill: parent

                    onClicked: {
                        captureGIFTimer.start();
                    }
                }
            }

            Image {
                id:       helpButtonImage
                width:    UtilScript.dp(64)
                height:   UtilScript.dp(64)
                source:   "qrc:/resources/images/snow/button_help.png"
                fillMode: Image.PreserveAspectFit

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
            id:                     settingsListRectangle
            anchors.verticalCenter: parent.verticalCenter
            anchors.left:           parent.left
            z:                      2
            width:                  UtilScript.dp(96)
            height:                 Math.min(parent.height * 5 / 8, settingsListView.contentHeight)
            color:                  "black"
            clip:                   true
            opacity:                0.75
            visible:                false

            ListView {
                id:           settingsListView
                anchors.fill: parent
                orientation:  ListView.Vertical

                model: ListModel {
                    id: settingsListModel
                }

                delegate: Image {
                    id:       settingsItemDelegate
                    width:    settingsListRectangle.width
                    height:   sourceSize.width > 0 ? (width / sourceSize.width) * sourceSize.height : 0
                    source:   "qrc:/resources/images/snow/bg-%1.png".arg(settingNumber)
                    fillMode: Image.PreserveAspectFit

                    MouseArea {
                        id:           settingsItemMouseArea
                        anchors.fill: parent

                        onClicked: {
                            if (mainWindow.fullVersion || settingNumber === 1) {
                                snowPage.currentBackgroundNum = settingNumber;
                                snowPage.bigSnowflakesCount   = snowPage.maxBigSnowflakesCount;
                                snowPage.smallSnowflakesCount = snowPage.maxSmallSnowflakesCount;

                                snowPage.resetParticleSystems();
                            } else {
                                purchaseDialog.open();
                            }
                        }
                    }
                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOn
                }
            }
        }

        MultiPointTouchArea {
            id:           waitArea
            anchors.fill: parent
            z:            3
            visible:      false

            Rectangle {
                anchors.fill: parent
                color:        "black"
                opacity:      0.75
            }

            BusyIndicator {
                anchors.centerIn: parent
                z:                1
                implicitWidth:    UtilScript.dp(64)
                implicitHeight:   UtilScript.dp(64)
                running:          parent.visible
            }
        }
    }

    PurchaseDialog {
        id: purchaseDialog
        z:  1

        onPurchaseFullVersionSelected: {
            fullVersionProduct.purchase();
        }

        onRestorePurchasesSelected: {
            store.restorePurchases();
        }
    }

    HelpDialog {
        id: helpDialog
        z:  1
    }

    Accelerometer {
        id:       accelerometer
        dataRate: 10
        active:   snowPage.appInForeground && snowPage.pageActive

        property real lastReadingX: 0.0
        property real lastReadingY: 0.0
        property real lastReadingZ: 0.0

        onReadingChanged: {
            if ((lastReadingX !== 0.0 || lastReadingY !== 0.0 || lastReadingZ !== 0.0) &&
                (Math.abs(reading.x - lastReadingX) > snowPage.accelShakeThreshold ||
                 Math.abs(reading.y - lastReadingY) > snowPage.accelShakeThreshold ||
                 Math.abs(reading.z - lastReadingZ) > snowPage.accelShakeThreshold)) {
                snowPage.bigSnowflakesCount   = snowPage.maxBigSnowflakesCount;
                snowPage.smallSnowflakesCount = snowPage.maxSmallSnowflakesCount;

                snowPage.resetParticleSystems();
            }

            lastReadingX = reading.x;
            lastReadingY = reading.y;
            lastReadingZ = reading.z;
        }
    }

    Timer {
        id:               captureGIFTimer
        interval:         200
        repeat:           true
        triggeredOnStart: true

        readonly property int framesCount: 5

        property int frameNumber:          0
        property int capturedFramesCount:  0

        onRunningChanged: {
            if (running) {
                waitArea.visible = true;

                frameNumber         = 0;
                capturedFramesCount = 0;
            } else {
                if (capturedFramesCount >= framesCount) {
                    if (GIFCreator.createGIF(framesCount, interval / 10)) {
                        ShareHelper.showShareToView(GIFCreator.gifFilePath);
                    } else {
                        console.log("createGIF() failed");
                    }
                }

                waitArea.visible = false;
            }
        }

        onTriggered: {
            if (frameNumber < framesCount) {
                var frame_number = frameNumber;

                if (!backgroundImage.grabToImage(function (result) {
                    if (result.saveToFile(GIFCreator.imageFilePathMask.arg(frame_number))) {
                        capturedFramesCount = capturedFramesCount + 1;

                        if (capturedFramesCount >= framesCount) {
                            stop();
                        }
                    } else {
                        console.log("saveToFile() failed for frame %1".arg(frame_number));

                        stop();
                    }
                })) {
                    console.log("grabToImage() failed for frame %1".arg(frame_number));

                    stop();
                }

                frameNumber = frameNumber + 1;
            }
        }
    }

    Timer {
        id:       snowflakesCountTimer
        running:  true
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
        running:  true
        interval: 100
        repeat:   true

        onTriggered: {
            var angle    = Math.abs(snowPage.snowflakesAngle) < snowPage.defaultSnowflakesAngle ? snowPage.snowflakesAngle + (180 / (snowPage.ceaseTime / interval)) :
                                                                                                  snowPage.snowflakesAngle - (180 / (snowPage.ceaseTime / interval));
            var velocity = snowPage.snowflakesVelocity - snowPage.maxSnowflakesVelocity / (snowPage.ceaseTime / interval);

            snowPage.snowflakesAngle    = angle < -180 ? 180 : angle;
            snowPage.snowflakesVelocity = velocity < snowPage.minSnowflakesVelocity ? snowPage.minSnowflakesVelocity : velocity;
        }
    }

    Connections {
        target: ShareHelper

        onShareToViewCompleted: {
            StoreHelper.requestReview();
        }
    }

    Component.onCompleted: {
        var background_num = parseInt(mainWindow.getSetting("BackgroundNum", "1"), 10);

        if (background_num <= maxBackgroundNum) {
            currentBackgroundNum = background_num;
        }

        settingsListModel.clear();

        for (var i = 1; i <= snowPage.maxBackgroundNum; i++) {
            settingsListModel.append({"settingType": "background", "settingNumber": i});
        }

        if (mainWindow.getSetting("ShowHelpOnStartup", "true") === "true") {
            helpDialog.open();

            mainWindow.setSetting("ShowHelpOnStartup", "false");
        }
    }
}
