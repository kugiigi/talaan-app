import QtQuick 2.12
import Lomiri.Components 1.3
import QtQuick.Controls 2.2 as QQC2
import QtQuick.Controls.Suru 2.2

BaseItemDelegate {
    id: customizedRadioDelegate

    transparentBackground: true
    checkable: true

    indicator: QQC2.RadioButton {
        id: radioButton

        onCheckedChanged: customizedRadioDelegate.checked = checked
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
            rightMargin: units.gu(2)
        }

        Binding {
            target: radioButton
            property: "checked"
            value: customizedRadioDelegate.checked
        }
    }
}
