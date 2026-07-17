import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import Lomiri.Components 1.3 as UT
import QtQuick.Layouts 1.12

Item {
    id: emptyState

    // Public APIs
    property string iconName
    property alias iconSource: emptyIcon.source
    property alias iconColor: emptyIcon.color
    property alias title: emptyLabel.text
    property alias subTitle: emptySublabel.text
    property string loadingTitle
    property string loadingSubTitle
    property alias isLoading: loading.visible
    property alias shown: emptyItem.visible

    readonly property real widthLimit: Suru.units.gu(30)
    readonly property real heightLimit: Suru.units.gu(40)

    height: isLoading ? loading.height : shown ? emptyItem.height : 0

    LoadingComponent {
        id: loading

        visible: false
        title: loadingTitle
        subTitle: loadingSubTitle
        anchors {
            left: parent.left
            right: parent.right
        }
    }

    ColumnLayout {
        id: emptyItem

        visible: false
        anchors {
            left: parent.left
            right: parent.right
        }
        spacing: Suru.units.gu(2)

        UT.Icon {
            id: emptyIcon
            
            Layout.alignment: Qt.AlignHCenter
            name: emptyState.iconName
            height: visible ? parent.width <= widthLimit ? (parent.width * 0.3) : Suru.units.gu(
                                                               10) : 0
            width: height
            visible: parent.parent.height <= heightLimit
                     || emptyState.iconName === "" ? false : true
            color: "#BBBBBB"
        }

        Label {
            id: emptyLabel
            
            Layout.fillWidth: true

            Suru.textLevel: parent.width <= widthLimit ? Suru.HeadingThree : Suru.HeadingTwo
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            visible: isLoading ? false : true
        }

        Label {
            id: emptySublabel
            
            Layout.fillWidth: true

            Suru.textLevel: parent.width <= widthLimit ? Suru.Small : Suru.HeadingThree
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            visible: isLoading ? false : true
        }
    }
}
