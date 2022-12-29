import QtQuick 2.4
import Lomiri.Components 1.3

Item {
    property string title
    property string subtitle

    anchors.fill: parent

    Column {
        anchors{
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        //spacing: units.gu(0.5)

        Label {
            id: labelTitle
            text: title
            fontSizeMode: Text.HorizontalFit
            fontSize: "large"
            minimumPixelSize: units.gu(2)
            elide: Text.ElideRight
            width: parent !== null ? parent.width : 0
        }
        Label {
            id: labelSubTitle
            text: subtitle
            color: theme.palette.normal.baseText
            visible: subtitle === "" ? false: true
            fontSizeMode: Text.HorizontalFit
            fontSize: "small"
            minimumPixelSize: units.gu(1)
            elide: Text.ElideRight
            width: parent !== null ? parent.width : 0
        }
    }
}
