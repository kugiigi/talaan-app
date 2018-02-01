import QtQuick 2.4
import Ubuntu.Components 1.3

Item {
    id: root

    property int searchTotal: 0

    anchors.fill: parent

    Label {
        id: label
        text: i18n.tr("Results found: ") + searchTotal
        color: UbuntuColors.blue
        fontSizeMode: Text.HorizontalFit
        textSize: Label.Medium
        minimumPixelSize: units.gu(2)
        elide: Text.ElideRight
        //width: parent !== null ? parent.width : 0
        anchors{
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: units.gu(2)
            right: parent.right
            rightMargin: units.gu(2)
        }

        verticalAlignment: Text.AlignVCenter
    }
}
