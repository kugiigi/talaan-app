import QtQuick 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "pages" as PageComponents

Flickable {
    id: baseFlickable

    property PageComponents.BasePageHeader pageHeader
    property bool enableScrollPositioner: true

    boundsBehavior: Flickable.DragOverBounds
    boundsMovement: Flickable.StopAtBounds
    maximumFlickVelocity: Suru.units.gu(500)

    PullDownFlickableConnections {
        pageHeader: baseFlickable.pageHeader
        target: baseFlickable
    }

    function scrollToItem(item, topMargin=0,  bottomMargin=0) {
        let _mappedY = 0
        let _itemHeightY = 0
        let _currentViewport = 0
        let _intendedContentY = 0
        let _maxContentY = 0
        let _targetContentY = contentY

        _mappedY = item.mapToItem(baseFlickable.contentItem, 0, 0).y
        _itemHeightY = _mappedY + item.height
        _currentViewport = baseFlickable.contentY - baseFlickable.originY + baseFlickable.height - baseFlickable.bottomMargin + baseFlickable.topMargin

        if (_itemHeightY > _currentViewport) {
            _maxContentY = baseFlickable.contentHeight - baseFlickable.height + baseFlickable.bottomMargin
            _intendedContentY = _itemHeightY - baseFlickable.height + item.height + baseFlickable.bottomMargin + bottomMargin

            if (_intendedContentY > _maxContentY) {
                _targetContentY = _maxContentY
            } else {
                _targetContentY = _intendedContentY
            }
        } else if (_mappedY < baseFlickable.contentY) {
            _targetContentY = _mappedY - topMargin - baseFlickable.topMargin
        }

        scrollAnimation.startAnimation(_targetContentY)
    }
    
    NumberAnimation {
        id: scrollAnimation

        target: baseFlickable
        property: "contentY"
        easing: Suru.animations.EasingOut
        duration: Suru.animations.FastDuration

        function startAnimation(targetContentY) {
            to = targetContentY
            restart()
        }
    }

    Loader {
        active: baseFlickable.parent instanceof Layout ? false : baseFlickable.enableScrollPositioner
        z: 1
        parent: baseFlickable.parent

        anchors {
            right: active ? parent.right : undefined
            rightMargin: Suru.units.gu(2)
            bottom: active ? parent.bottom : undefined
            bottomMargin: Suru.units.gu(3) + baseFlickable.bottomMargin
        }

        sourceComponent: ScrollPositioner {
            id: scrollPositioner

            target: baseFlickable
            mode: "Down"
        }
    }
}
