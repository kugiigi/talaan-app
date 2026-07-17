import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "../../../common" as Common

Common.BaseToolbar {
    id: toolbar

    readonly property bool isFullyShown: y == (parent.height - height)

    Behavior on y {
        NumberAnimation {
            easing: Suru.animations.EasingOut
            duration: Suru.animations.FastDuration
        }
    }

    backgroundColor: Suru.backgroundColor
}
