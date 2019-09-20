import QtQuick 2.12

import "../../Util.js" as UtilScript

Image {
    id:       spark
    width:    UtilScript.dp(sourceSize.width)
    height:   UtilScript.dp(sourceSize.height)
    source:   "qrc:/resources/images/snow/sparks/spark_%1.png".arg(sparkType)
    fillMode: Image.PreserveAspectFit

    readonly property int maxSparkType: 7

    property int sparkType:             1

    SequentialAnimation {
        id:    sparkSequentialAnimation
        loops: Animation.Infinite

        NumberAnimation {
            target:   spark
            property: "opacity"
            from:     0.4
            to:       0.0
            duration: 1000
        }

        NumberAnimation {
            target:   spark
            property: "opacity"
            from:     0.0
            to:       0.4
            duration: 1000
        }

        ScriptAction {
            script: {
                var spark_type = spark.sparkType + 1;

                if (spark_type > spark.maxSparkType) {
                    spark_type = 1;
                }

                spark.sparkType = spark_type;
            }
        }
    }

    Timer {
        id:       sparkAnimationTimer
        running:  true
        interval: 5000 + Math.floor(5000 * Math.random())

        onTriggered: {
            sparkSequentialAnimation.start();
        }
    }
}
