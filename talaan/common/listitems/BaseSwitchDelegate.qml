import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Suru 2.2

BaseItemDelegate {
    id: customizedSwitchDelegate

    enum Position {
        Right
        , Left
    }

    property alias label: mainLabel
    property int switchPosition: BaseSwitchDelegate.Position.Right

    transparentBackground: true
    checkable: true

    contentItem: RowLayout {
        layoutDirection: switchPosition == BaseSwitchDelegate.Position.Right ? Qt.LeftToRight : Qt.RightToLeft

        Label {
            id: mainLabel

            Layout.fillWidth: true
            text: customizedSwitchDelegate.text
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            maximumLineCount: 2
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        Switch {
            id: switchItem
            
            onCheckedChanged: customizedSwitchDelegate.checked = checked
            Binding {
                target: switchItem
                property: "checked"
                value: customizedSwitchDelegate.checked
            }
        }
    }
}
