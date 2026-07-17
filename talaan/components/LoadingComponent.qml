import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12

Item {
    id: root

    property alias title: activityTitle.text
    property alias subTitle: activitySubTitle.text
    readonly property real widthLimit: Suru.units.gu(30)
    readonly property real heightLimit: Suru.units.gu(40)

    height: childrenRect.height

    onVisibleChanged: {
        if (visible) {
            timer.start()
        } else {
            timer.stop()
            columnTexts.visible = false
        }
    }

    BusyIndicator {
        id: loadingIndicator

        anchors.horizontalCenter: parent.horizontalCenter
        running: root.visible
        visible: false
    }


    Timer {
        id: timer

        interval: 300
        running: false
        onTriggered: {
            if (!loadingIndicator.visible) {
                loadingIndicator.visible = true
                restart()
            } else {
                columnTexts.visible = true
            }
        }
    }

    ColumnLayout {
        id: columnTexts

        visible: false

        opacity: !parent.parent.parent ? 1 : parent.parent.parent.height <= heightLimit ? 0 : 1

        anchors {
            top: loadingIndicator.bottom
            topMargin: Suru.units.gu(5)
            left: parent.left
            right: parent.right
        }

        Label {
            id: activityTitle
            
            Layout.fillWidth: true

            Suru.textLevel: parent.width <= widthLimit ? Suru.HeadingThree : Suru.HeadingTwo
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
        }

        Label {
            id: activitySubTitle

            Layout.fillWidth: true

            Suru.textLevel: parent.width <= widthLimit ? Suru.Small : Suru.HeadingThree
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
