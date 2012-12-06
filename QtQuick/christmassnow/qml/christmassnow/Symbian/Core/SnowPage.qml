import QtQuick 1.1
import QtMultimediaKit 1.1
import com.nokia.symbian 1.0
import QtMobility.sensors 1.1
import Qt.labs.particles 1.0

Page {
    id:              snowPage
    anchors.fill:    parent
    orientationLock: PageOrientation.LockPortrait
    state:           "snowLevel0"

    property int currentBackgroundNum:    1
    property int maxBackgroundNum:        3
    property int bigSnowflakesCount:      20
    property int bigSnowflakesCountMax:   20
    property int bigSnowflakesCountInc:   5
    property int smallSnowflakesCount:    80
    property int smallSnowflakesCountMax: 80
    property int smallSnowflakesCountInc: 20
    property int ceaseTime:               5000

    property real snowflakesAngle:        90.0
    property real defaultSnowflakesAngle: 90.0
    property real snowflakesVelocity:     30.0
    property real snowflakesVelocityMin:  30.0
    property real snowflakesVelocityMax:  360.0
    property real accelShakeThreshold:    10.0

    property bool appInForeground:        true

    property string backgroundDir:        "360x640"

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
        }
    ]

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

    function initBackground(background_num) {
        if (background_num <= maxBackgroundNum) {
            currentBackgroundNum = background_num;
        }
    }

    Audio {
        id:     audio
        source: "../../sound/music.mp3"
        volume: 0.5
        muted:  snowPage.appInForeground ? false : true

        onStopped: {
            position = 0;

            play();
        }

        onError: {
            position = 0;

            play();
        }
    }

    Rectangle {
        id:           backgroundRectangle
        anchors.fill: parent
        color:        "black"

        Image {
            id:           backgroundImage
            anchors.fill: parent
            source:       "../../images/" + snowPage.backgroundDir + "/bg-" + snowPage.currentBackgroundNum + ".png"
            fillMode:     Image.PreserveAspectFit
            smooth:       true
        }

        Image {
            id:           snowImage1
            anchors.fill: parent
            z:            1
            source:       "../../images/" + snowPage.backgroundDir + "/bg-" + snowPage.currentBackgroundNum + "-1.png"
            fillMode:     Image.PreserveAspectFit
            smooth:       true
        }

        Image {
            id:           snowImage2
            anchors.fill: parent
            z:            2
            source:       "../../images/" + snowPage.backgroundDir + "/bg-" + snowPage.currentBackgroundNum + "-2.png"
            fillMode:     Image.PreserveAspectFit
            smooth:       true
        }

        Image {
            id:           snowImage3
            anchors.fill: parent
            z:            3
            source:       "../../images/" + snowPage.backgroundDir + "/bg-" + snowPage.currentBackgroundNum + "-3.png"
            fillMode:     Image.PreserveAspectFit
            smooth:       true
        }

        Image {
            id:           snowImage4
            anchors.fill: parent
            z:            4
            source:       "../../images/" + snowPage.backgroundDir + "/bg-" + snowPage.currentBackgroundNum + "-4.png"
            fillMode:     Image.PreserveAspectFit
            smooth:       true
        }

        MouseArea {
            id:           snowfallMouseArea
            anchors.fill: parent
            z:            10

            property int pressedX:     0
            property int pressedY:     0

            property real pressedTime: (new Date).getTime()

            Particles {
                id:                bigSnowflakes1
                anchors.fill:      parent
                source:            "qrc:/resources/images/snowflake-1-big.png"
                lifeSpan:          1000
                count:             snowPage.bigSnowflakesCount
                angle:             snowPage.snowflakesAngle
                angleDeviation:    30
                velocity:          snowPage.snowflakesVelocity
                velocityDeviation: 10

                ParticleMotionWander {
                    xvariance: 30
                    pace:      100
                }
            }

            Particles {
                id:                smallSnowflakes1
                anchors.fill:      parent
                source:            "qrc:/resources/images/snowflake-1-small.png"
                opacity:           0.75
                lifeSpan:          1000
                count:             snowPage.smallSnowflakesCount
                angle:             snowPage.snowflakesAngle
                angleDeviation:    30
                velocity:          snowPage.snowflakesVelocity
                velocityDeviation: 10

                ParticleMotionWander {
                    xvariance: 30
                    pace:      100
                }
            }

            Particles {
                id:                bigSnowflakes2
                anchors.fill:      parent
                source:            "qrc:/resources/images/snowflake-2-big.png"
                lifeSpan:          1000
                count:             snowPage.bigSnowflakesCount
                angle:             snowPage.snowflakesAngle
                angleDeviation:    30
                velocity:          snowPage.snowflakesVelocity
                velocityDeviation: 10

                ParticleMotionWander {
                    xvariance: 30
                    pace:      100
                }
            }

            Particles {
                id:                smallSnowflakes2
                anchors.fill:      parent
                source:            "qrc:/resources/images/snowflake-2-small.png"
                opacity:           0.5
                lifeSpan:          1000
                count:             snowPage.smallSnowflakesCount
                angle:             snowPage.snowflakesAngle
                angleDeviation:    30
                velocity:          snowPage.snowflakesVelocity
                velocityDeviation: 10

                ParticleMotionWander {
                    xvariance: 30
                    pace:      100
                }
            }

            Particles {
                id:                bigSnowflakes3
                anchors.fill:      parent
                source:            "qrc:/resources/images/snowflake-3-big.png"
                lifeSpan:          1000
                count:             snowPage.bigSnowflakesCount
                angle:             snowPage.snowflakesAngle
                angleDeviation:    30
                velocity:          snowPage.snowflakesVelocity
                velocityDeviation: 10

                ParticleMotionWander {
                    xvariance: 30
                    pace:      100
                }
            }

            Particles {
                id:                smallSnowflakes3
                anchors.fill:      parent
                source:            "qrc:/resources/images/snowflake-3-small.png"
                opacity:           0.5
                lifeSpan:          1000
                count:             snowPage.smallSnowflakesCount
                angle:             snowPage.snowflakesAngle
                angleDeviation:    30
                velocity:          snowPage.snowflakesVelocity
                velocityDeviation: 10

                ParticleMotionWander {
                    xvariance: 30
                    pace:      100
                }
            }

            Particles {
                id:                bigSnowflakes4
                anchors.fill:      parent
                source:            "qrc:/resources/images/snowflake-4-big.png"
                lifeSpan:          1000
                count:             snowPage.bigSnowflakesCount
                angle:             snowPage.snowflakesAngle
                angleDeviation:    30
                velocity:          snowPage.snowflakesVelocity
                velocityDeviation: 10

                ParticleMotionWander {
                    xvariance: 30
                    pace:      100
                }
            }

            Particles {
                id:                smallSnowflakes4
                anchors.fill:      parent
                source:            "qrc:/resources/images/snowflake-4-small.png"
                opacity:           0.25
                lifeSpan:          1000
                count:             snowPage.smallSnowflakesCount
                angle:             snowPage.snowflakesAngle
                angleDeviation:    30
                velocity:          snowPage.snowflakesVelocity
                velocityDeviation: 10

                ParticleMotionWander {
                    xvariance: 30
                    pace:      100
                }
            }

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
        }

        Image {
            id:           helpButtonImage
            anchors.top:  parent.top
            anchors.left: parent.left
            width:        48
            height:       48
            z:            15
            source:       "qrc:/resources/images/help.png"

            MouseArea {
                id:           helpButtonMouseArea
                anchors.fill: parent

                onClicked: {
                    mainPageStack.replace(helpPage);
                }
            }
        }

        Image {
            id:            settingsButtonImage
            anchors.top:   parent.top
            anchors.right: parent.right
            width:         48
            height:        48
            z:             15
            source:        "qrc:/resources/images/settings.png"

            MouseArea {
                id:           settingsButtonMouseArea
                anchors.fill: parent

                onClicked: {
                    if (snowPage.currentBackgroundNum < snowPage.maxBackgroundNum) {
                        snowPage.currentBackgroundNum = snowPage.currentBackgroundNum + 1;
                    } else {
                        snowPage.currentBackgroundNum = 1;
                    }

                    mainWindow.setSetting("BackgroundNum", snowPage.currentBackgroundNum);
                }
            }
        }

        Slider {
            id:             volumeSlider
            anchors.top:    parent.verticalCenter
            anchors.bottom: volumeButtonImage.top
            anchors.left:   parent.left
            width:          volumeButtonImage.width
            z:              15
            orientation:    Qt.Vertical
            minimumValue:   0.0
            maximumValue:   1.0
            value:          0.5
            stepSize:       0.1
            inverted:       true
            visible:        false

            onValueChanged: {
                audio.volume = value;
            }
        }

        Image {
            id:             volumeButtonImage
            anchors.bottom: parent.bottom
            anchors.left:   parent.left
            width:          48
            height:         48
            z:              15
            source:         "qrc:/resources/images/volume.png"

            MouseArea {
                id:           volumeButtonMouseArea
                anchors.fill: parent

                onClicked: {
                    if (volumeSlider.visible) {
                        volumeSlider.visible     = false;
                        volumeButtonImage.source = "qrc:/resources/images/volume.png";
                    } else {
                        volumeSlider.visible     = true;
                        volumeButtonImage.source = "qrc:/resources/images/volume-pressed.png";
                    }
                }
            }
        }

        Image {
            id:             exitButtonImage
            anchors.bottom: parent.bottom
            anchors.right:  parent.right
            width:          48
            height:         48
            z:              15
            source:         "qrc:/resources/images/exit.png"

            MouseArea {
                id:           exitButtonMouseArea
                anchors.fill: parent

                onClicked: {
                    Qt.quit();
                }
            }
        }
    }

    Accelerometer {
        id: accelerometer

        property real lastReadingX: 0.0
        property real lastReadingY: 0.0
        property real lastReadingZ: 0.0

        onReadingChanged: {
            if (lastReadingX !== 0.0 || lastReadingY !== 0.0 || lastReadingZ !== 0.0) {
                if (Math.abs(reading.x - lastReadingX) > snowPage.accelShakeThreshold ||
                    Math.abs(reading.y - lastReadingY) > snowPage.accelShakeThreshold ||
                    Math.abs(reading.z - lastReadingZ) > snowPage.accelShakeThreshold) {

                    if (snowPage.bigSnowflakesCount < snowPage.bigSnowflakesCountMax - snowPage.bigSnowflakesCountInc) {
                        snowPage.bigSnowflakesCount = snowPage.bigSnowflakesCount + snowPage.bigSnowflakesCountInc;
                    } else {
                        snowPage.bigSnowflakesCount = snowPage.bigSnowflakesCountMax;
                    }
                    if (snowPage.smallSnowflakesCount < snowPage.smallSnowflakesCountMax - snowPage.smallSnowflakesCountInc) {
                        snowPage.smallSnowflakesCount = snowPage.smallSnowflakesCount + snowPage.smallSnowflakesCountInc;
                    } else {
                        snowPage.smallSnowflakesCount = snowPage.smallSnowflakesCountMax;
                    }
                }
            }

            lastReadingX = reading.x;
            lastReadingY = reading.y;
            lastReadingZ = reading.z;
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

    Connections {
        target: CSApplication

        onAppInBackground: {
            snowPage.appInForeground = false;
        }

        onAppInForeground: {
            snowPage.appInForeground = true;
        }
    }

    Component.onCompleted: {
        if ((screen.displayWidth === 360 && screen.displayHeight === 640) ||
            (screen.displayWidth === 640 && screen.displayHeight === 360)) {
            snowPage.backgroundDir = "360x640";
        } else if ((screen.displayWidth === 480 && screen.displayHeight === 854) ||
                   (screen.displayWidth === 854 && screen.displayHeight === 480)) {
            snowPage.backgroundDir = "480x854";
        } else {
            snowPage.backgroundDir = "360x640";
        }

        audio.play();
        accelerometer.start();
        snowflakesCountTimer.start();
        snowflakesAngleVelocityTimer.start();
    }
}
