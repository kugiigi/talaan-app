import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import ".." as Common

BaseDialog {
    id: dialogWithContents

    default property alias data: contentColumn.data
    readonly property real preferredHeight: contentColumn.height + Suru.units.gu(12)
    readonly property alias flickable: baseFlickable

    property real contentHorizontalMargin: Suru.units.gu(2)
    property bool destroyOnClose: false

    topPadding: Suru.units.gu(2)
    bottomPadding: Suru.units.gu(2)
    leftPadding: Suru.units.gu(2) + contentHorizontalMargin
    rightPadding: Suru.units.gu(2) + contentHorizontalMargin
    standardButtons: Dialog.NoButton
    height: Math.min(availableVerticalSpace, preferredHeight, parent.height)

    onClosed: if (destroyOnClose) destroy()

    Common.BaseFlickable {
        id: baseFlickable

        clip: true
        anchors.fill: parent
        contentHeight: contentColumn.height
        boundsBehavior: Flickable.StopAtBounds
        enableScrollPositioner: false

        ColumnLayout {
            id: contentColumn

            spacing: units.gu(3)
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
        }
    }
}
