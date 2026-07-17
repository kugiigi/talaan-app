import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Suru 2.2

BaseItemDelegate {
    id: customizedCheckBoxDelegate

    enum Position {
        Right
        , Left
    }

    property alias checkState: checkBoxItem.checkState
    property alias label: mainLabel
    property int checkBoxPosition: BaseCheckBoxDelegate.Position.Right
    property int alignment: Qt.AlignLeft

    checkable: true

    contentItem: Item {
        implicitHeight: layout.height
        implicitWidth: layout.width
        
        RowLayout {
            id: layout

            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: customizedCheckBoxDelegate.alignment == Qt.AlignCenter ? parent.horizontalCenter : undefined
            layoutDirection: checkBoxPosition == BaseCheckBoxDelegate.Position.Right ? Qt.LeftToRight : Qt.RightToLeft

            Label {
                id: mainLabel

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter

                Suru.textLevel: customizedCheckBoxDelegate.Suru.textLevel
                text: customizedCheckBoxDelegate.text
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
                maximumLineCount: 2
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }

            CheckBox {
                id: checkBoxItem

                Layout.alignment: Qt.AlignVCenter

                onCheckedChanged: customizedCheckBoxDelegate.checked = checked
                Binding {
                    target: checkBoxItem
                    property: "checked"
                    value: customizedCheckBoxDelegate.checked
                }
            }
        }
    }
}
