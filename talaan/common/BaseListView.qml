import QtQuick 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import Lomiri.Components 1.3
import "pages" as PageComponents

ListView {
    id: baseListView

    property PageComponents.BasePageHeader pageHeader
    property bool enableScrollPositioner: true

    boundsBehavior: Flickable.DragOverBounds
    boundsMovement: Flickable.StopAtBounds
    maximumFlickVelocity: Suru.units.gu(500)

    PullDownFlickableConnections {
        pageHeader: baseListView.pageHeader
        target: baseListView
    }

    Loader {
        active: baseListView.parent instanceof Layout ? false : baseListView.enableScrollPositioner
        z: 1
        parent: baseListView.parent

        anchors {
            right: active ? parent.right : undefined
            rightMargin: Suru.units.gu(2)
            bottom: active ? parent.bottom : undefined
            bottomMargin: Suru.units.gu(3) //+ baseListView.bottomMargin
        }

        sourceComponent: ScrollPositioner {
            id: scrollPositioner

            target: baseListView
            mode: "Down"
        }
    }
}
