import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "../../../common" as Common

ColumnLayout {
    id: root

    property alias color: colorPicker.selectedColor

    spacing: Suru.units.gu(1)

    Label {
        id: nameLabel

        Layout.fillWidth: true
        Suru.textLevel: Suru.HeadingThree
        text: i18n.tr("Color")
        color: Suru.foregroundColor
    }

    Common.ColorPicker {
        id: colorPicker

        Layout.fillWidth: true
    }

}
