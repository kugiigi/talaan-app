import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.3


ColumnLayout {
    id: sectionItem

    property alias text: label.text

    height: Suru.units.gu(6)
    spacing: Suru.units.gu(1)
    anchors {
        left: parent.left
        right: parent.right
    }

    Label {
        id: label

        Layout.alignment: Qt.AlignVCenter
        Layout.leftMargin: Suru.units.gu(2)

        Suru.textLevel: Suru.HeadingThree
        elide: Text.ElideRight
    }
}   
