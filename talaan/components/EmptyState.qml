import QtQuick 2.4
import Ubuntu.Components 1.3

/*
 Component which displays an empty state (approved by design). It offers an
 icon, title and subtitle to describe the empty state.
*/

Item {
    id: emptyState

    // Public APIs
    property alias iconName: emptyIcon.name
    property alias iconSource: emptyIcon.source
    property alias iconColor: emptyIcon.color
    property alias title: emptyLabel.text
    property alias subTitle: emptySublabel.text
    property alias shown: emptyState.visible

    readonly property real widthLimit: units.gu(30)
    readonly property real heightLimit: units.gu(40)

    height: childrenRect.height
    anchors.left: parent.left
    anchors.right: parent.right

    Icon {
        id: emptyIcon
        anchors.horizontalCenter: parent.horizontalCenter
        //anchors.top: parent.top
        height: parent.width <= widthLimit ? (parent.width * 0.3 ) : units.gu(10)
        width: height
        visible: parent.parent.height <= heightLimit ? false : true
        color: "#BBBBBB"
    }

    Label {
        id: emptyLabel
        anchors.top: emptyIcon.bottom
        anchors.topMargin: units.gu(5)
        anchors.left: parent.left
        anchors.right: parent.right
        //anchors.horizontalCenter: parent.horizontalCenter
        fontSize: parent.width <= widthLimit ? "medium" : "large"
        font.bold: true
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
    }

    Label {
        id: emptySublabel
        anchors.top: emptyLabel.bottom
        //anchors.horizontalCenter: parent.horizontalCenter
        fontSize: parent.width <= widthLimit ? "small" : "medium"
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        anchors.left: parent.left
        anchors.right: parent.right
    }
}
