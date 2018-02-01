import QtQuick 2.4

Item {
    property color bgColor: "#371300"
    property string size: "Large"
    property real bgOpacity: 0.4
    property bool noImage: false

    anchors.fill: parent
    z:parent.z - 1
    Image {
        id: imgSplash
        visible: !noImage
        source: size === "Large" ? "../assets/images/background.png" : size === "Medium" ? "../assets/images/background@medium.png" : "../assets/images/background@small.png"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
    }
    Rectangle {
        id: backgroundRec
        color: bgColor //"#2E2020"
        visible: true
        anchors.fill: parent
        opacity: bgOpacity // 0.4
    }
}
