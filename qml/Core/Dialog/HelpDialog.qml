import QtQuick 2.12
import QtQuick.Controls 2.5

MouseArea {
    id:               helpDialog
    anchors.centerIn: parent
    visible:          false

    property int parentWidth:  parent.width
    property int parentHeight: parent.height

    signal opened()
    signal closed()

    signal ok()

    onParentWidthChanged: {
        if (typeof(parent) !== "undefined" && parent !== null) {
            if (rotation === 0 || rotation === 180) {
                width  = parent.width;
                height = parent.height;
            } else if (rotation === 90 || rotation === 270) {
                width  = parent.height;
                height = parent.width;
            }
        }
    }

    onParentHeightChanged: {
        if (typeof(parent) !== "undefined" && parent !== null) {
            if (rotation === 0 || rotation === 180) {
                width  = parent.width;
                height = parent.height;
            } else if (rotation === 90 || rotation === 270) {
                width  = parent.height;
                height = parent.width;
            }
        }
    }

    onRotationChanged: {
        if (typeof(parent) !== "undefined" && parent !== null) {
            if (rotation === 0 || rotation === 180) {
                width  = parent.width;
                height = parent.height;
            } else if (rotation === 90 || rotation === 270) {
                width  = parent.height;
                height = parent.width;
            }
        }
    }

    function open() {
        visible = true;

        opened();
    }

    function close() {
        visible = false;

        ok();
        closed();
    }

    Image {
        id:               dialogImage
        anchors.centerIn: parent
        source:           "qrc:/resources/images/dialog/help_dialog.png"

        Flickable {
            id:                   helpTextFlickable
            anchors.fill:         parent
            anchors.margins:      24
            anchors.bottomMargin: 40
            contentWidth:         helpText.width
            contentHeight:        helpText.height
            clip:                 true

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOn
            }

            Text {
                id:                   helpText
                width:                helpTextFlickable.width
                text:                 "<b>" + qsTr("Christmas Snow Scenes") + "</b>" + "<br><br>" +
                                              qsTr("Have fun with a variety of Christmas Snow Scenes. Press Settings button to select a scene. Shake your phone to cause a snowfall. Control wind speed and direction by sliding your finger across a screen. Double tap on screen to hide buttons or show them again.")
                color:                "black"
                font.pixelSize:      24
                font.family:         "Helvetica"
                horizontalAlignment:  Text.AlignHCenter
                verticalAlignment:    Text.AlignVCenter
                wrapMode:             Text.Wrap
            }
        }
    }

    Image {
        id:                       okButtonImage
        anchors.horizontalCenter: dialogImage.horizontalCenter
        anchors.verticalCenter:   dialogImage.bottom
        width:                    64
        height:                   64
        z:                        dialogImage.z + 1
        source:                   "qrc:/resources/images/dialog/ok.png"

        MouseArea {
            anchors.fill: parent

            onClicked: {
                helpDialog.visible = false;

                helpDialog.ok();
                helpDialog.closed();
            }
        }
    }
}
