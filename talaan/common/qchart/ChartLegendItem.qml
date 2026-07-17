import QtQuick 2.9
import Lomiri.Components 1.3

Row {
    id: root

    property alias title: titleLabel.text
    property alias legendColor: legendColor.color

    height: units.gu(2.5)
    spacing: units.gu(0.5)


    LomiriShape {
        id: legendColor

        height: root.height * 0.80
        width: height * 1.5
        relativeRadius: 0.50
        anchors.verticalCenter: root.verticalCenter
    }

    Label {
        id: titleLabel

        anchors.verticalCenter: root.verticalCenter
        textSize: Label.XSmall
        font.weight: Text.Normal
        fontSizeMode: Text.HorizontalFit
        minimumPixelSize: units.gu(2)
        elide: Text.ElideRight
    }

}
