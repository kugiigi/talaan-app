import QtQuick 2.4
import Lomiri.Components 1.3

PageHeader {
    id: mainHeader

    signal cancel
    signal search(string searchText)

    StyleHints {
        backgroundColor: switch (settings.currentTheme) {
                         case "Default":
                             "#3D1400"
                             break
                         case "System":
                         case "Ambiance":
                         case "SuruDark":
                             theme.palette.normal.foreground
                             break
                         default:
                             "#3D1400"
                         }
        dividerColor: LomiriColors.slate
    }

    trailingActionBar {
        anchors.rightMargin: 0
        delegate: TextualButtonStyle {
        }
        actions: Action {
            id: actionCancel

            text: i18n.tr("Cancel")
            onTriggered: {
                cancel()
            }
        }
    }


    contents: TextField {
        id: textField

        // Disable predictive text
        inputMethodHints: Qt.ImhNoPredictiveText

        placeholderText: i18n.tr("Find...")

        anchors {
            left: parent.left
            leftMargin: units.gu(1)
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        onVisibleChanged: {
            if (!visible) {
                text = ""
            } else {
                // Force active focus when this becomes the current PageHead state and
                // show OSK if appropriate.
                forceActiveFocus()
                delayTimer.restart()
            }
        }

        onActiveFocusChanged: {
            if(activeFocus){
                actionCancel.shortcut = "Esc"
            }else{
                actionCancel.shortcut = undefined
            }
        }

        primaryItem: Icon {
            height: units.gu(2)
            width: height
            name: "find"
        }

        onTextChanged: {
            delayTimer.restart()
        }

        //Timer to delay searching while typing
        Timer {
            id: delayTimer

            running: false
            interval: 300
            onTriggered: {
                console.log("Finding: " + textField.text)
                search(textField.text)
            }
        }
    }
}
