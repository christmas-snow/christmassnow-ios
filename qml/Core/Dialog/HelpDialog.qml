import QtQuick 2.12
import QtQuick.Controls 2.5

import "../../Util.js" as UtilScript

MultiPointTouchArea {
    id:               helpDialog
    anchors.centerIn: parent
    width:            dialogWidth(rotation, parent.width, parent.height)
    height:           dialogHeight(rotation, parent.width, parent.height)
    visible:          false

    signal opened()
    signal closed()

    signal ok()

    function dialogWidth(rotation, parent_width, parent_height) {
        if (rotation === 90 || rotation === 270) {
            return parent_height;
        } else {
            return parent_width;
        }
    }

    function dialogHeight(rotation, parent_width, parent_height) {
        if (rotation === 90 || rotation === 270) {
            return parent_width;
        } else {
            return parent_height;
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
        width:            UtilScript.pt(sourceSize.width)
        height:           UtilScript.pt(sourceSize.height)
        source:           "qrc:/resources/images/dialog/help_dialog.png"
        fillMode:         Image.PreserveAspectFit

        Flickable {
            id:                   helpTextFlickable
            anchors.fill:         parent
            anchors.margins:      UtilScript.pt(16)
            anchors.bottomMargin: UtilScript.pt(40)
            contentWidth:         helpText.width
            contentHeight:        helpText.height
            clip:                 true

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOn
            }

            Text {
                id:                  helpText
                width:               helpTextFlickable.width
                text:                "<b>" + qsTr("Christmas Snow Scenes") + "</b>" + "<br><br>" +
                                             qsTr("Have fun with a variety of Christmas Snow Scenes. Press Settings button to select a scene. Shake your phone to cause a snowfall. Control wind speed and direction by sliding your finger across a screen. Double tap on screen to hide buttons or show them again.")
                color:               "black"
                font.pointSize:      20
                font.family:         "Helvetica"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment:   Text.AlignVCenter
                wrapMode:            Text.Wrap
            }
        }
    }

    Image {
        id:                       okButtonImage
        anchors.horizontalCenter: dialogImage.horizontalCenter
        anchors.verticalCenter:   dialogImage.bottom
        z:                        1
        width:                    UtilScript.pt(64)
        height:                   UtilScript.pt(64)
        source:                   "qrc:/resources/images/dialog/ok.png"
        fillMode:                 Image.PreserveAspectFit

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
