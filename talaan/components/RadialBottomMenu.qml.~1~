import QtQuick 2.4
import Ubuntu.Components 1.3

RadialBottomEdge {
    id: root
    //hintSize: units.gu(6)
    hintColor: "#513838"
    hintIconColor: "white"
    bgColor: "black"
    bgOpacity: 0.3
    //visible: keyboard.target.visible ? false : mainLayout.columns === 1 ? true : false
    actionButtonDistance: units.gu(10)

    property ActionList menuActions
    property string mode: "Always"
    property int semiHideOPacity: 50

    Component.onCompleted: {
        timeoutTimer.restart()
    }

//    actions: [menuActions.actions[3]
//        ,RadialAction {
//            iconName: "settings"
//            iconColor: UbuntuColors.coolGrey
//            hide: true
//        }, menuActions.actions[0],

//        menuActions.actions[1],menuActions.actions[2],

//        RadialAction {
//            iconName: "stock_email"
//            iconColor: UbuntuColors.coolGrey
//            hide: true
//        }
//    ]

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        hoverEnabled: true
        preventStealing: false
        onContainsMouseChanged: {
            if (containsMouse) {
                root.opacity = 1
            } else {
                timeoutTimer.restart()
            }
        }
        onClicked: {
            trigger()
        }
    }

    Timer{
        id: timeoutTimer
        interval: 2000
        running: false
        onTriggered: {
            root.collapse()

            switch(root.mode){
            case "Autohide":
                root.opacity = 0
                break
            case "Semihide":
                root.opacity = root.semiHideOPacity / 100
                break
            }
        }
    }
}
