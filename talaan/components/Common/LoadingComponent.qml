import QtQuick 2.4
import Lomiri.Components 1.3

Item {
    id: root

    property alias title: activityTitle.text
    property alias subTitle: activitySubTitle.text
    readonly property real widthLimit: units.gu(30)
    readonly property real heightLimit: units.gu(40)

    anchors.fill: parent

    onVisibleChanged: {
        if(visible){
            timer.start()
        }else{
            timer.stop()
            columnTexts.visible = false
        }
    }

    ActivityIndicator {
        id: loadingIndicator
        anchors.centerIn: parent
        running: root.visible
    }

    Timer {
        id: timer
        interval: 300
        running: false
        onTriggered: {
            columnTexts.visible = true
        }
    }

    Column{
        id: columnTexts

        //spacing: units.gu(1)
        visible: false

        opacity: parent.parent.height <= heightLimit ? 0 : 1

        anchors{
            top: loadingIndicator.bottom
            topMargin: units.gu(5)
            left: parent.left
            right: parent.right
        }

    Label {
        id: activityTitle
        anchors{
            left: parent.left
            right: parent.right
        }

        fontSize: parent.width <= widthLimit ? "medium" : "large"
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
    }

    Label {
        id: activitySubTitle

        fontSize: parent.width <= widthLimit ? "small" : "medium"
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter

        anchors{
            right: parent.right
            left: parent.left
        }
    }
    }

}
