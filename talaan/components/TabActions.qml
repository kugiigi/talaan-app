import QtQuick 2.4
import Lomiri.Components 1.3

ActionList {
    id: tabsActions

    function reset() {
        for (var i = 0; i < actions.length; i++) {
            actions[i].visible = true
        }
    }

    actions: [
        Action {
            id: actionTalaan
            property color iconColor: LomiriColors.blue

            iconName: "note"
            text: i18n.tr("Lists")
            onTriggered: mainLayout.switchTab(0)
        },
        Action {
            property color iconColor: LomiriColors.midAubergine
            iconName: "bookmark"
            text: i18n.tr("Saved")
            onTriggered: mainLayout.switchTab(1)
        },
        Action {
            iconName: "history"
            property color iconColor: LomiriColors.red
            text: i18n.tr("History")
            onTriggered: mainLayout.switchTab(2)
        },
        Action {
            iconName: "settings"
            property color iconColor: LomiriColors.coolGrey

            text: i18n.tr("Settings")
            onTriggered: mainLayout.switchTab(3)
        }
    ]
}
