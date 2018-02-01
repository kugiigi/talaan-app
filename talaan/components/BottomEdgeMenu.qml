import QtQuick 2.4
import Ubuntu.Components 1.3

Panel {
    id: root

    property alias model: ubuntuListView.model
    property string anchorSide: "Right"
    property string hintMode: "Always"
    property int semiHideOpacity: 50
    property int timeoutSeconds: 2


    locked: model.count > 0 ? false : true
    z: 1000
//    anchors {
//        right: anchorSide === "Right" ? parent.right : undefined
//        left: anchorSide === "Left" ? parent.left : undefined

//        bottom: parent.bottom
//    }
    width: units.gu(5)
    triggerSize: units.gu(5)
    hideTimeout: 4000
    height: ubuntuListView.contentHeight

    Component.onCompleted: timeoutTimer.restart()

    onOpenedChanged: {
        if(opened){
           hint.switchToNormal()
        }else{
           timeoutTimer.restart()
        }
    }

    onHintModeChanged: {
        root.close()
        switch (hintMode){
        case "Always":
        hint.switchToNormal()
            break
        case "Autohide":
        case "Semihide":
            timeoutTimer.restart()
            break
        }
    }

    Icon{
        id: hint
        name: "toolkit_bottom-edge-hint"
        width: units.gu(3)
        height: width
        visible: root.hintMode !== "None" && !root.opened ? true : false
        anchors{
            bottom: parent.top
            right: root.anchorSide === "Right" ? parent.right : undefined
            rightMargin: root.anchorSide === "Right" ? triggerSize : 0
            left: root.anchorSide === "Left" ? parent.left : undefined
            leftMargin: root.anchorSide === "Left" ? triggerSize : 0
        }

        function switchToNormal(){
            opacity = 1
        }
    }

    Rectangle {
        id: mainRec

        width: units.gu(22)
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: root.anchorSide === "Right" ? parent.right : undefined
            left: root.anchorSide === "Left" ? parent.left : undefined
        }
        color: theme.palette.normal.foreground
        UbuntuListView {
            id: ubuntuListView

            anchors.fill: parent
            currentIndex: -1
            clip: true
//            model: listModel
            delegate: ListItem {
                id: listItem
                width: parent.width
                highlightColor: switch (settings.currentTheme) {
                                case "Default":
                                    "#2D371300"
                                    break
                                case "Ambiance":
                                    theme.palette.highlighted.background
                                    break
                                case "SuruDark":
                                    theme.palette.highlighted.background
                                    break
                                default:
                                    "#2D371300"
                                }

                SlotsLayout {
                    anchors.fill: parent

                    mainSlot: Label {
                        text: modelData.text
                        color: switch (settings.currentTheme) {
                               case "Default":
                                   theme.palette.normal.background
                                   break
                               case "Ambiance":
                                   theme.palette.normal.backgroundText
                                   break
                               case "SuruDark":
                                   theme.palette.normal.backgroundText
                                   break
                               default:
                                   theme.palette.normal.background
                               }
                        //                            font.weight: Font.Normal
                    }

                    Icon {
                        SlotsLayout.position: SlotsLayout.Leading
                        name: modelData.iconName
                        width: units.gu(3)
                        color: switch (settings.currentTheme) {
                               case "Default":
                                   theme.palette.normal.overlay
                                   break
                               case "Ambiance":
                                   theme.palette.normal.overlayText
                                   break
                               case "SuruDark":
                                   theme.palette.normal.overlayText
                                   break
                               default:
                                   theme.palette.normal.overlay
                               }
                    }
                }

                onClicked: {
                    modelData.trigger()
                    root.close()
                }
            }
        }
        InverseMouseArea {
            enabled: root.opened
            anchors.fill: parent
            onClicked: {
                root.close()
            }
        }
    }

    Timer {
        id: timeoutTimer
        interval: timeoutSeconds * 1000
        running: false
        onTriggered: {

            switch (root.hintMode) {
            case "Autohide":
                hint.opacity = 0
                break
            case "Semihide":
                hint.opacity = root.semiHideOpacity / 100
                break
            }
        }
    }
}
