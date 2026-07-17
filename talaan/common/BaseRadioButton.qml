import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

RadioButton {
    id: customizedRadioButton

    enum Position {
        Right
        , Left
    }

    property alias label: mainLabel
    property int checkBoxPosition: BaseRadioButton.Position.Left
    property string color

    checked: false
    indicator: Item {}

    contentItem: RowLayout {
        layoutDirection: checkBoxPosition == BaseRadioButton.Position.Right ? Qt.LeftToRight : Qt.RightToLeft

        Label {
            id: mainLabel

            Layout.fillWidth: true
            text: customizedRadioButton.text
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            maximumLineCount: 2
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        RadioButton {
            id: radioButtonItem

            onCheckedChanged: customizedRadioButton.checked = checked
            Binding {
                target: radioButtonItem
                property: "checked"
                value: customizedRadioButton.checked
            }
        }
    }
}
