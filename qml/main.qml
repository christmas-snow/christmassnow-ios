import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.LocalStorage 2.12
import QtPurchasing 1.0

import "BuildSettings.js" as BuildSettingsScript

ApplicationWindow {
    id:         mainWindow
    title:      qsTr("Snow Scenes")
    visibility: Window.FullScreen
    visible:    true

    property bool fullVersion: false

    onFullVersionChanged: {
        setSetting("FullVersion", fullVersion ? "true" : "false");

        if (mainStackView.depth > 0 && typeof mainStackView.currentItem.bannerViewHeight === "number") {
            if (fullVersion) {
                AdMobHelper.hideBannerView();
            } else {
                AdMobHelper.showBannerView();
            }
        } else {
            AdMobHelper.hideBannerView();
        }
    }

    function setSetting(key, value) {
        var db = LocalStorage.openDatabaseSync("ChristmasSnowDB", "1.0", "ChristmasSnowDB", 1000000);

        db.transaction(function(tx) {
            tx.executeSql("CREATE TABLE IF NOT EXISTS SETTINGS(KEY TEXT PRIMARY KEY, VALUE TEXT)");

            tx.executeSql("REPLACE INTO SETTINGS (KEY, VALUE) VALUES (?, ?)", [key, value]);
        });
    }

    function getSetting(key, defaultValue) {
        var value = defaultValue;
        var db    = LocalStorage.openDatabaseSync("ChristmasSnowDB", "1.0", "ChristmasSnowDB", 1000000);

        db.transaction(function(tx) {
            tx.executeSql("CREATE TABLE IF NOT EXISTS SETTINGS(KEY TEXT PRIMARY KEY, VALUE TEXT)");

            var res = tx.executeSql("SELECT VALUE FROM SETTINGS WHERE KEY=?", [key]);

            if (res.rows.length > 0) {
                value = res.rows.item(0).VALUE;
            }
        });

        return value;
    }

    Store {
        id: store

        Product {
            id:         fullVersionProduct
            identifier: "christmassnow.version.full"
            type:       Product.Unlockable

            onPurchaseSucceeded: {
                mainWindow.fullVersion = true;

                transaction.finalize();
            }

            onPurchaseRestored: {
                mainWindow.fullVersion = true;

                transaction.finalize();
            }

            onPurchaseFailed: {
                if (transaction.failureReason === Transaction.ErrorOccurred) {
                    console.log(transaction.errorString);
                }

                transaction.finalize();
            }
        }
    }

    StackView {
        id:           mainStackView
        anchors.fill: parent

        onCurrentItemChanged: {
            for (var i = 0; i < depth; i++) {
                var item = get(i, StackView.DontLoad);

                if (item !== null) {
                    item.focus = false;
                }
            }

            if (depth > 0) {
                currentItem.forceActiveFocus();

                if (typeof currentItem.bannerViewHeight === "number") {
                    if (mainWindow.fullVersion) {
                        AdMobHelper.hideBannerView();
                    } else {
                        AdMobHelper.showBannerView();
                    }
                } else {
                    AdMobHelper.hideBannerView();
                }
            } else {
                AdMobHelper.hideBannerView();
            }
        }
    }

    MultiPointTouchArea {
        anchors.fill: parent
        z:            1
        enabled:      mainStackView.busy
    }

    Component.onCompleted: {
        if (BuildSettingsScript.VERSION_FULL) {
            fullVersion = true;
        } else {
            fullVersion = (getSetting("FullVersion", "false") === "true");
        }

        var component = Qt.createComponent("Core/SnowPage.qml");

        if (component.status === Component.Ready) {
            mainStackView.push(component);
        } else {
            console.log(component.errorString());
        }
    }
}
