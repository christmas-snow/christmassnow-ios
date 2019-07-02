import QtQuick 2.12

MouseArea {
    id:               purchaseDialog
    anchors.centerIn: parent
    visible:          false

    readonly property int parentWidth:  parent.width
    readonly property int parentHeight: parent.height

    signal opened()
    signal closed()

    signal purchaseFullVersion()
    signal restorePurchases()
    signal cancel()

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

        cancel();
        closed();
    }

    Image {
        id:               dialogImage
        anchors.centerIn: parent
        source:           "qrc:/resources/images/dialog/purchase_dialog.png"

        Column {
            anchors.centerIn: parent
            spacing:          8

            Image {
                id:     purchaseFullVersionButtonImage
                source: "qrc:/resources/images/dialog/purchase_dialog_button.png"

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        purchaseDialog.visible = false;

                        purchaseDialog.purchaseFullVersion();
                        purchaseDialog.closed();
                    }
                }

                Row {
                    anchors.fill: parent
                    leftPadding:  4
                    rightPadding: 4
                    spacing:      4

                    Image {
                        id:                     purchaseFullVersionImage
                        anchors.verticalCenter: parent.verticalCenter
                        width:                  sourceSize.width * (height / sourceSize.height)
                        height:                 parent.height - 8
                        source:                 "qrc:/resources/images/dialog/purchase_dialog_purchase.png"
                        fillMode:               Image.PreserveAspectFit
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        width:                  parent.width - purchaseFullVersionImage.width - parent.spacing -
                                                parent.leftPadding - parent.rightPadding
                        height:                 parent.height - 8
                        text:                   qsTr("Purchase full version")
                        color:                  "black"
                        font.pointSize:         16
                        font.family:            "Helvetica"
                        horizontalAlignment:    Text.AlignHCenter
                        verticalAlignment:      Text.AlignVCenter
                        wrapMode:               Text.Wrap
                        fontSizeMode:           Text.Fit
                        minimumPointSize:       8
                    }
                }
            }

            Image {
                id:     restorePurchasesButtonImage
                source: "qrc:/resources/images/dialog/purchase_dialog_button.png"

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        purchaseDialog.visible = false;

                        purchaseDialog.restorePurchases();
                        purchaseDialog.closed();
                    }
                }

                Row {
                    anchors.fill: parent
                    leftPadding:  4
                    rightPadding: 4
                    spacing:      4

                    Image {
                        id:                     restorePurchasesImage
                        anchors.verticalCenter: parent.verticalCenter
                        width:                  sourceSize.width * (height / sourceSize.height)
                        height:                 parent.height - 8
                        source:                 "qrc:/resources/images/dialog/purchase_dialog_restore.png"
                        fillMode:               Image.PreserveAspectFit
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        width:                  parent.width - restorePurchasesImage.width - parent.spacing -
                                                parent.leftPadding - parent.rightPadding
                        height:                 parent.height - 8
                        text:                   qsTr("Restore purchases")
                        color:                  "black"
                        font.pointSize:         16
                        font.family:            "Helvetica"
                        horizontalAlignment:    Text.AlignHCenter
                        verticalAlignment:      Text.AlignVCenter
                        wrapMode:               Text.Wrap
                        fontSizeMode:           Text.Fit
                        minimumPointSize:       8
                    }
                }
            }
        }
    }

    Image {
        id:                       cancelButtonImage
        anchors.horizontalCenter: dialogImage.horizontalCenter
        anchors.verticalCenter:   dialogImage.bottom
        width:                    64
        height:                   64
        z:                        dialogImage.z + 1
        source:                   "qrc:/resources/images/dialog/cancel.png"

        MouseArea {
            anchors.fill: parent

            onClicked: {
                purchaseDialog.visible = false;

                purchaseDialog.cancel();
                purchaseDialog.closed();
            }
        }
    }
}
