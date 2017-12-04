import QtQuick 2.9

Image {
    id:     spark
    /*
    width:  sourceSize.width
    height: sourceSize.height
    */
    width:  48
    height: 48
    source: "qrc:/resources/images/snow/sparks/spark_%1.png".arg(sparkType)

    property int sparkType:    1
    property int maxSparkType: 7

    SequentialAnimation {
        id: twinkleSequentialAnimation

        onStopped: {
            var spark_type = spark.sparkType + 1;

            if (spark_type > spark.maxSparkType) {
                spark_type = 1;
            }

            spark.sparkType = spark_type;

            start();
        }

        PropertyAnimation {
            target:   spark
            property: "opacity"
            from:     0.4
            to:       0.0
            duration: 1000
        }

        PropertyAnimation {
            target:   spark
            property: "opacity"
            from:     0.0
            to:       0.4
            duration: 1000
        }
    }

    Timer {
        id:       twinkleAnimationTimer
        interval: 5000 + Math.floor(5000 * Math.random())

        onTriggered: {
            twinkleSequentialAnimation.start();
        }
    }

    Component.onCompleted: {
        twinkleAnimationTimer.start();
    }
}
