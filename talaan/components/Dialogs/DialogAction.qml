import QtQuick 2.4
import Ubuntu.Components 1.3

Item {
    id: mainContents
    anchors {
        //fill: parent
        /*leftMargin: units.gu(2)
        topMargin: units.gu(1)
        rightMargin: units.gu(2)
        bottomMargin: units.gu(2)*/
    }
    property string iconName: "add"
    property color iconColor: "Black"
    property color backgroundColor: "White"
    property bool hide: false
    property string label: ""
    default property alias contents: mainContents.children
    property alias internalAnchors: mainContents.anchors
}
