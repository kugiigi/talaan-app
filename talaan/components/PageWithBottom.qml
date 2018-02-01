import QtQuick 2.4
import Ubuntu.Components 1.3


Page {
    id: root

    property list<RadialAction> actions
    property bool enableBottom: mainView.enableBottomMenu

    //hint mode
    property string bottomMode: settings.bottomMenuHint

    property string bottomType: settings.bottomMenuType
    property string bottomAnchor: settings.bottomMenuAnchor
    property string customActionsLabel: i18n.tr("Navigation")
    property string customActionsIcon: "navigation-menu"
    property bool hideLeadingActions: false
    property bool hideTrailingActions: false

    property int leadingActionsCount: root.header.leadingActionBar.actions.length
    property int trailingActionsCount: root.header.trailingActionBar.actions.length

    //    property alias bottomEdgeMenu: bottomEdgeMenu


    onTrailingActionsCountChanged: {
//        console.log("onTrailingActionsCountChanged");
        if (root.enableBottom) {
            if (bottomType === "Radial") {
                loadRadialModel()
            } else {
                loadModel()
            }
        }
    }

    onLeadingActionsCountChanged: {
//        console.log("onLeadingActionsCountChanged");
        if (root.enableBottom) {
            if (bottomType === "Radial") {
                loadRadialModel()
            } else {
                loadModel()
            }
        }
    }

    onBottomTypeChanged: setMode()

    function setMode(){
        bottomMenuLoader.active = false

        switch (root.bottomType) {
        case "Radial":
            bottomMenuLoader.setSource(Qt.resolvedUrl("RadialBottomEdge.qml"), {
                                           bgColor: "black",
                                           bgOpacity: 0.3,
                                           actionButtonDistance: units.gu(10),
                                           visible: keyboard.target.visible ? false : true,
                                                                              actions: root.actions,
                                                                              mode: root.bottomMode,
                                                                              semiHideOpacity: 30,
                                                                              timeoutSeconds: 2,
                                                                              hintColor: settings.currentTheme === "Default" ? "#513838" : settings.currentTheme === "Ambiance" ? theme.palette.highlighted.background : settings.currentTheme === "SuruDark" ? theme.palette.highlighted.background : "#513838",
                                                                                                                                                                                                                                                                hintIconColor: settings.currentTheme === "Default" ? "white" : settings.currentTheme === "Ambiance" ? theme.palette.highlighted.backgroundText : settings.currentTheme === "SuruDark" ? theme.palette.highlighted.backgroundText : "white"
                                       })
            break
        case "Panel":
            bottomMenuLoader.anchors.fill = undefined
            bottomMenuLoader.setSource(Qt.resolvedUrl("BottomEdgeMenu.qml"), {
                                           model: listModel,
                                           anchorSide: root.bottomAnchor
                                       })
            break
        }

        bottomMenuLoader.active = root.enableBottom
    }

    function loadModel() {

        console.log("bottom menu is loading!!!!");

        listModel.loadingStatus = "Loading"


        listModel.clear()


        var trailingActionBarActions = root.header.trailingActionBar.actions
        var leadingActionBarActions = root.header.leadingActionBar.actions
        var navigationActions = root.actions


        var msg = {'model': listModel, 'hideTrailingActions': root.hideTrailingActions,'hideTrailingActions': root.hideTrailingActions, 'trailing': trailingActionBarActions, 'leading': leadingActionBarActions,'navigation': navigationActions};
        workerScript.sendMessage(msg);

//        if (trailingActionBarActions.length > 0 && !root.hideTrailingActions) {

//            for (var i = trailingActionsCount - 1; i > -1; i--) {
//                if (trailingActionBarActions[i].visible) {
//                    listModel.append({
//                                         action: trailingActionBarActions[i]
//                                     })
//                }
//            }
//        }

//        if (leadingActionBarActions.length > 0 && !root.hideLeadingActions) {
//            for (var i = 0; i < leadingActionBarActions.length; i++) {
//                if (leadingActionBarActions[i].visible) {
//                    listModel.append({
//                                         action: leadingActionBarActions[i]
//                                     })
//                }
//            }
//        }

//        if (navigationActions.length > 0) {
//            listModel.append({
//                                 action: customActions
//                             })
//        }
    }

    function loadRadialModel() {

        listModel.clear()

        var leadingActionBarActions = root.header.leadingActionBar.actions

        if (leadingActionsCount > 0) {
            for (var i = 0; i < leadingActionBarActions.length; i++) {

                if (leadingActionBarActions[i].visible
                        && leadingActionBarActions[i].iconName === "back") {
                    listModel.append({
                                         action: leadingActionBarActions[i]
                                     })
                }
            }
        }

        if (bottomMenuLoader.item !== null) {
            bottomMenuLoader.item.leadingActions = listModel
        }
    }

    Component.onCompleted: {
        setMode()
    }

    WorkerScript {
        id: workerScript
        source: "../library/WorkerScripts/BottomMenuLoader.js"

        onMessage: {
            console.log("bottom menu loaded!");
            listModel.loadingStatus = "Ready"
        }
    }

    Action {
        id: customActions
        iconName: root.customActionsIcon
        text: root.customActionsLabel
        onTriggered: {


            //            customPanel.open()
        }
    }

    ListModel {
        id: listModel

        property string loadingStatus: "NotLoaded"
    }

    Loader {
        id: bottomMenuLoader
        //        active: root.enableBottom
        //        anchors.fill: parent
        z: 100
        //        sourceComponent: bottomMenuComponent
        asynchronous: true
        visible: keyboard.target.visible ? false : status == Loader.Ready ? true :false

        onLoaded: {
            if (root.bottomType === "Radial") {
                bottomMenuLoader.anchors.fill = Qt.binding(function () { return root.bottomType === "Radial" ? root : undefined})
                if(listModel.count == 1 && listModel.get(0).iconName === "back"){
                    bottomMenuLoader.item.leadingActions = listModel
                }
                bottomMenuLoader.item.hintColor = Qt.binding(function () {
                    var value
                    switch (settings.currentTheme) {
                    case "Default":
                        return "#513838"
                        break
                    case "Ambiance":
                        return theme.palette.highlighted.background
                        break
                    case "SuruDark":
                        return theme.palette.highlighted.background
                        break
                    default:
                        return "#513838"
                    }
                })
                bottomMenuLoader.item.hintIconColor = Qt.binding(function () {
                    switch (settings.currentTheme) {
                    case "Default":
                        return "white"
                        break
                    case "Ambiance":
                        return theme.palette.highlighted.backgroundText
                        break
                    case "SuruDark":
                        return theme.palette.highlighted.backgroundText
                        break
                    default:
                        return "white"
                    }
                })
                bottomMenuLoader.item.visible = Qt.binding(function () {
                    return keyboard.target.visible ? false : true
                })
                bottomMenuLoader.item.actions = Qt.binding(function () {
                    return root.actions
                })
                bottomMenuLoader.item.mode = Qt.binding(function () {
                    return root.bottomMode
                })
                bottomMenuLoader.item.opacity = Qt.binding(function () {
                    return root.bottomMode === "None" ? 0 : 1
                })
            } else {
                bottomMenuLoader.item.anchorSide = Qt.binding(function () {
                    return root.bottomAnchor
                })

                bottomMenuLoader.item.hintMode = Qt.binding(function () {
                    return root.bottomMode
                })

                bottomMenuLoader.anchors.right =  Qt.binding(function () { return root.bottomType === "Panel" ? bottomMenuLoader.item.anchorSide === "Right" ? root.right : undefined : undefined})
                bottomMenuLoader.anchors.left = Qt.binding(function () { return root.bottomType === "Panel" ? bottomMenuLoader.item.anchorSide === "Left" ? root.left : undefined : undefined})
                bottomMenuLoader.anchors.bottom = Qt.binding(function () {return root.bottom})

            }

        }
    }

    //    Component {
    //        id: bottomMenuComponent
    //        RadialBottomEdge {
    //            id: radialBottomMenu
    //            hintColor: switch (settings.currentTheme) {
    //                       case "Default":
    //                           "#513838"
    //                           break
    //                       case "Ambiance":
    //                           theme.palette.highlighted.background
    //                           break
    //                       case "SuruDark":
    //                           theme.palette.highlighted.background
    //                           break
    //                       default:
    //                           "#513838"
    //                       }
    //            hintIconColor: switch (settings.currentTheme) {
    //                           case "Default":
    //                               "white"
    //                               break
    //                           case "Ambiance":
    //                               theme.palette.highlighted.backgroundText
    //                               break
    //                           case "SuruDark":
    //                               theme.palette.highlighted.backgroundText
    //                               break
    //                           default:
    //                               "white"
    //                           }
    //            bgColor: "black"
    //            bgOpacity: 0.3
    //            actionButtonDistance: units.gu(10)
    //            visible: keyboard.target.visible ? false : true
    //            actions: root.actions
    //            mode: root.bottomMode
    //            semiHideOpacity: 30
    //            timeoutSeconds: 2
    //        }
    //    }

    //    BottomEdgeMenu {
    //        id: bottomEdgeMenu
    //        model: listModel
    //        anchorSide: root.bottomAnchor
    //    }
    Connections {
        id: keyboard
        target: Qt.inputMethod
    }
}
