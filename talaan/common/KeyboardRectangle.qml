import QtQuick 2.12
import QtQuick.Window 2.2

Item {
	id: keyboardRectangle

    property alias keyboard: keyboardConnection.target

    // Use if AA_EnableHighDpiScaling is enabled
	// height: keyboardConnection.target.visible ? keyboardConnection.target.keyboardRectangle.height / Screen.devicePixelRatio : 0
	height: keyboardConnection.target.visible ? keyboardConnection.target.keyboardRectangle.height : 0

	anchors{
		left: parent.left
		right: parent.right
		bottom: parent.bottom
	}

    Connections {
        id: keyboardConnection
        target: Qt.inputMethod
    }
}
