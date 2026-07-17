import QtQuick 2.12
import QtQuick.Controls 2.12 as QQC2
import Lomiri.Components 1.3
import ".." as Common

QQC2.Menu {
    id: customMenu

    readonly property real defaultWidth: Math.max(minimumWidth, Math.min(preferredWidth, maximumWidth))
    property real availWidth: parent.width
    property real availHeight: parent.height
    property string iconName
    property real minimumWidth: showShortcuts ? units.gu(40) : units.gu(32)
    property real maximumWidth: showShortcuts ? units.gu(50) : units.gu(42)
    property real preferredWidth: parent.width * 0.25

    property bool showShortcuts: keyboardModel && keyboardModel.count > 0 ? true : false

    width: defaultWidth
    margins: units.gu(2)
    currentIndex: -1
    delegate: BaseMenuItem{}
    onAboutToShow: currentIndex = -1

    Common.FilteredKeyboardModel {
        id: keyboardModel
    }
}
