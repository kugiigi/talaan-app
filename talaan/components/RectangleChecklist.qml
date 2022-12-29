import QtQuick 2.4
import Lomiri.Components 1.3
import "../components"

Row {
    id: rectangleChecklist
    property alias bgcolor: backgroundRectangle.color
    property alias itemname: labelItem.text

    //property alias comments
    Item {
        id: itemChecklist
        width: (circleImage.width / 2) + backgroundRectangle.width
        height: backgroundRectangle.height
        CircleImage {
            id: circleImage
            z: 1
            width: units.gu(6)
            height: width
            anchors.verticalCenter: backgroundRectangle.verticalCenter
            source: Qt.resolvedUrl("../assets/images/ubuntu_logo.png")
            //control: Switch {
            //    anchors.verticalCenter: parent.verticalCenter
            // }
            /*CheckBox{
                                            id: checkbox
                                                                                            anchors{
                                                                                                                                                                centerIn: parent
                                                                                                                                                                                                                                                    }

                                                                                                                                                                                                                                                                                                                                                    }*/
        }

        Rectangle {
            id: backgroundRectangle
            width: units.gu(25)
            height: labelItem.height + units.gu(2)
            anchors.left: circleImage.horizontalCenter

            MouseArea {
                id: recMouse
                anchors.fill: parent
                onClicked: {
                    checkbox.checked = !checkbox.checked
                }
            }

            Label {
                id: labelItem
                anchors {
                    top: backgroundRectangle.top
                    left: backgroundRectangle.left
                    right: backgreoundRectangle.right
                    leftMargin: (circleImage.width / 2) + units.gu(1)
                    topMargin: units.gu(1)
                    rightMargin: units.gu(1)
                    bottomMargin: units.gu(1)
                }

                //text: "Hello, world! habaan pa naten bilis bilis bilisan nmomomomomom"
                fontSize: "large"
                wrapMode: Text.WordWrap
            }
        }
    }
}
