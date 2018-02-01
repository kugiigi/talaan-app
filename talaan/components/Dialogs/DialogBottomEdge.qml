import QtQuick 2.4
import Ubuntu.Components 1.3
//import QtGraphicalEffects 1.0
import "../../library/ProcessFunc.js" as Process

Item {
    id: bottomEdge

    property int hintSize: units.gu(8)
    property color hintColor: Theme.palette.normal.overlay
    property string hintIconName: "view-grid-symbolic"
    property alias hintIconSource: hintIcon.source
    property alias edgeState: bottomEdgeHint.state
    property color hintIconColor: UbuntuColors.coolGrey
    property bool bottomEdgeEnabled: true
    property color bgColor: "black"
    property real bgOpacity: 0.6
    property real dialogHeight
    property real dialogWidth
    property real opacityLevel: keyboard.target.visible === true ? 0 : (Math.abs(collapsedPosition - bottomEdgeHint.y) / Math.abs(collapsedPosition - expandedPosition))
    property real dialogFullHeight: contentsContainer.anchors.topMargin + bottomEdgeHint.height + dialogHeight
    property real expandedPosition: 0.5 * height
    property real collapsedPosition: height - hintSize/2

    property DialogAction contents
    property RadialAction leftAction
    property RadialAction rightAction

    property real actionButtonSize: units.gu(7)
    property real actionButtonDistance: 1.5* hintSize


    anchors.fill: parent


    signal isExpanded();
    signal isCollapsed();

    onEdgeStateChanged: {
        if(edgeState == "floating" || edgeState === "collapsed"){
            hintIcon.width = hintSize/4
            keyboard.target.hide()
        }else{
            hintIcon.width = hintSize/2
        }
    }

    Rectangle {
        id: bgVisual

        z: 1
        color: bgColor
        anchors.fill: parent
        visible: bottomEdgeHint.y !== collapsedPosition
        opacity: keyboard.target.visible === true ?  bgOpacity :  bgOpacity * ((collapsedPosition - bottomEdgeHint.y) / (collapsedPosition - expandedPosition))//bgOpacity * (((bottomEdge.height - bottomEdgeHint.y) / bottomEdge.height) * 2)
        MouseArea {
            anchors.fill: parent
            enabled: bgVisual.visible
            //onClicked: bottomEdgeHint.state = "collapsed"
            onClicked: console.log((collapsedPosition - bottomEdgeHint.y) + " - " + (collapsedPosition - expandedPosition))
            z: 1
        }
    }

    Item{
        id: contentsContainer
        z:2
        children: contents
        width:childrenRect.width//units.gu(20)
        height: childrenRect.height//units.gu(40)
        opacity: (Math.abs(collapsedPosition - bottomEdgeHint.y) / Math.abs(collapsedPosition - expandedPosition))
        anchors{
            top: bottomEdgeHint.bottom
           topMargin: units.gu(2)
            horizontalCenter: bottomEdgeHint.horizontalCenter
            horizontalCenterOffset: units.gu(-17) //parent.width * -0.25
        }
    }

    Rectangle {
        id: bottomEdgeHint

        color: hintColor
        width: hintSize
        height: width
        radius: width/2
        visible: bottomEdgeEnabled
        opacity: 0.7

        anchors.horizontalCenter: parent.horizontalCenter
        y: collapsedPosition
        z: parent.z + 1

        Icon {
            id: hintIcon
            width: hintSize/4
            height: width
            name: hintIconName
            color: hintIconColor
            anchors {
                centerIn: parent
                verticalCenterOffset: keyboard.target.visible === true ? 0 : width * ((bottomEdgeHint.y - expandedPosition)
                                               /(expandedPosition - collapsedPosition))
            }
        }

        property real actionListDistance: -actionButtonDistance * ((bottomEdgeHint.y - collapsedPosition)
                                                                   /(collapsedPosition - expandedPosition))

        Rectangle{
            id: recLeftAction
            z: 2
            width: height
            height: actionButtonSize//bottomEdgeHint.height * 0.80
            radius: height
            color: leftAction.backgroundColor
            opacity: (Math.abs(collapsedPosition - bottomEdgeHint.y) / Math.abs(collapsedPosition - expandedPosition))
            anchors{
                verticalCenter: bottomEdgeHint.verticalCenter
                right: bottomEdgeHint.left
                margins: actionButtonDistance//units.gu(3)
            }
            Icon{
                name: leftAction.iconName
                anchors.centerIn: parent
                width: height
                height: parent.height * 0.50
                color: leftAction.iconColor
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    leftAction.triggered(null)
                }
            }
        }
        Rectangle{
            id: recRightAction
            z: 2
            width: height
            height: actionButtonSize//bottomEdgeHint.height * 0.80
            radius: height
            color: rightAction.backgroundColor
            opacity: (Math.abs(collapsedPosition - bottomEdgeHint.y) / Math.abs(collapsedPosition - expandedPosition))
            anchors{
                verticalCenter: bottomEdgeHint.verticalCenter
                left: bottomEdgeHint.right
                margins: actionButtonDistance//units.gu(3)
            }
            Icon{
                name: rightAction.iconName
                anchors.centerIn: parent
                width: height
                height: parent.height * 0.50
                color: rightAction.iconColor
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    rightAction.triggered(null)
                }
            }
        }


        MouseArea {
            id: mouseArea

            property real previousY: -1
            property string dragDirection: "None"

            z: 1
            anchors.fill: parent
            visible: bottomEdgeEnabled

            preventStealing: true
            drag {
                axis: Drag.YAxis
                target: bottomEdgeHint
                minimumY: expandedPosition
                maximumY: collapsedPosition
            }

            onReleased: {
                if ((dragDirection === "BottomToTop") &&
                        bottomEdgeHint.y < collapsedPosition) {
                    bottomEdgeHint.state = "expanded"

                } else {
                    if (bottomEdgeHint.state === "collapsed") {
                        bottomEdgeHint.y = collapsedPosition
                    }
                    bottomEdgeHint.state = "collapsed"
                }
                previousY = -1
                dragDirection = "None"
            }

            onClicked: {
                if (bottomEdgeHint.y === collapsedPosition)
                    bottomEdgeHint.state = "expanded"
                else
                    bottomEdgeHint.state = "collapsed"
            }

            onPressed: {
                previousY = bottomEdgeHint.y
                contents.visible = true;
                bottomEdgeHint.opacity = 1
            }

            onMouseYChanged: {
                var yOffset = previousY - bottomEdgeHint.y
                if (Math.abs(yOffset) <= units.gu(2)) {
                    return
                }
                previousY = bottomEdgeHint.y
                dragDirection = yOffset > 0 ? "BottomToTop" : "TopToBottom"
            }
        }

        state: "collapsed"
        states: [
            State {
                name: "collapsed"
                PropertyChanges {
                    target: bottomEdgeHint
                    y: collapsedPosition
                    opacity: 0.7
                }
            },
            State {
                name: "expanded"
                PropertyChanges {
                    target: bottomEdgeHint
                    y: expandedPosition
                    opacity: 1
                }
            },

            State {
                name: "floating"
                when: mouseArea.drag.active
                PropertyChanges {
                    target: bottomEdgeHint
                    opacity: 1
                }
            }
        ]

        transitions: [
            Transition {
                id: transi
                to: "expanded"
                /*SpringAnimation {
                    target: bottomEdgeHint
                    property: "y"
                    spring: 2
                    damping: 0.2
                }*/
                SmoothedAnimation {
                    id:anim
                    target: bottomEdgeHint
                    property: "y"
                    duration: UbuntuAnimation.BriskDuration
                }
                onRunningChanged:  {

                    if(!running){
                        isExpanded();
                    }
                }
            },

            Transition {
                to: "collapsed"
                SmoothedAnimation {
                    target: bottomEdgeHint
                    property: "y"
                    duration: UbuntuAnimation.BriskDuration
                }
                onRunningChanged:  {

                    if(!running){
                        isCollapsed();
                    }
                }
            }
        ]
    }
    UbuntuNumberAnimation on expandedPosition {
        id: anchorKeyboardAnimation

        from: bottomEdge.height * 0.5
        to: (bottomEdge.parent.height / 1.5) - dialogFullHeight - units.gu(7)
        duration: UbuntuAnimation.FastDuration//BriskDuration
        easing: UbuntuAnimation.StandardEasing
        running: false

    }

    UbuntuNumberAnimation on expandedPosition {
        id: unanchorKeyboardAnimation

        from:  (bottomEdge.parent.height / 1.5) - dialogFullHeight - units.gu(7)
        to: bottomEdge.height * 0.5
        duration: UbuntuAnimation.FastDuration//BriskDuration
        easing: UbuntuAnimation.StandardEasing
        running: false
    }
    Connections {
        id: keyboard
        target: Qt.inputMethod

        onVisibleChanged: {
            if(target.visible){
                anchorKeyboardAnimation.running = true
            }else{
                unanchorKeyboardAnimation.running = true
                //expandedPosition = bottomEdge.height * 0.5
            }

            console.log("OSK visible: " + target.visible);
        }
    }
}
