import QtQuick 2.12
import Lomiri.Components 1.3 as UT
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Suru 2.2
import ".." as Common

BaseItemDelegate {
    id: navigationDelegate

    property alias label: mainLabel
    readonly property Common.IconGroupedProperties progressionIcon: Common.IconGroupedProperties {
        name: "go-next"
        width: Suru.units.gu(2)
        height: Suru.units.gu(2)
        color: Suru.foregroundColor
    }

    icon {
        width: Suru.units.gu(2)
        height: Suru.units.gu(2)
        color: Suru.foregroundColor
    }

    transparentBackground: true

    contentItem: RowLayout {
        spacing: units.gu(1)

        UT.Icon {
            id: primaryIconItem

            visible: name ? true : false
            name: navigationDelegate.icon.name
            width: navigationDelegate.icon.width
            height: navigationDelegate.icon.height
            color: navigationDelegate.icon.color
        }

        Label {
            id: mainLabel

            Layout.fillWidth: true
            text: navigationDelegate.text
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            maximumLineCount: 2
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        UT.Icon {
            id: progressionIconItem

            visible: name ? true : false
            name: progressionIcon.name
            width: progressionIcon.width
            height: progressionIcon.height
            color: progressionIcon.color
        }
    }
}
