import QtQuick 2.4
import Lomiri.Components 1.3
import Lomiri.Keyboard 0.1

Panel {
    id: addItemsBar

    property bool enabled: false

    property alias itemName: textFieldName
    property alias comments: textAreaComments
    property string mode: "add"
    property bool hideHint: false
    property alias isCommentsShown: btnAddComment.isCommentsShown

    signal showComments
    signal hideComments
    signal cancel
    signal saved
    signal collapseCompleted
    signal commitCompleted
    property real dialogHeight: addItemBar.height

    signal isExpanded
    signal isCollapsed

    align: Qt.AlignBottom
    animate: true
    hintSize: 0
    height: addItemBar.height

    anchors{
        left: parent.left
        right: parent.right
        bottom: parent.bottom
    }

    function reset() {
        addItemsBar.mode = "add"
        isCommentsShown = false
        addItemBar.height = units.gu(6)
        textFieldName.text = ""
        textAreaComments.text = ""
    }

    function panelClose(){

        /*WORKAROUND: keyboard doesn't close when comments text area is open*/
        if(btnAddComment.isCommentsShown){
            btnAddComment.action.trigger()
        }
        if(keyboard.target.visible){
            keyboard.hideKeyboard()
        }
        else{
            addItemsBar.close()
        }
    }

    onOpenedChanged: {
        if(opened){
            textFieldName.visible = true
            textFieldName.forceActiveFocus()
        }else{
            reset()
            textFieldName.visible = false
            textAreaComments.visible = false
        }
    }

    Rectangle {
        id: bottomEdgeHint

        color: switch (settings.currentTheme) {
               case "Default":
                   "#513838"
                   break
               case "Ambiance":
               case "System":
               case "SuruDark":
                   theme.palette.normal.foreground
                   break
               default:
                   "#513838"
               }
        width: units.gu(8)
        height: width
        radius: width/2
        visible: hideHint ? false : opacity === 0 ? false : true
        opacity: addItemsBar.opened || !addItemsBar.enabled || keyboard.target.visible ? 0 : 0.7
        z: -1

        Behavior on opacity {
            LomiriNumberAnimation {
                easing.type: Easing.OutCubic
                duration: LomiriAnimation.SlowDuration
            }
        }

        anchors{
            verticalCenter: parent.top
            horizontalCenter: parent.horizontalCenter
        }
        function trigger(){
            addItemsBar.open()
        }

        Icon {
            id: hintIcon
            width: units.gu(2)
            height: width
            name: "add"
            color: theme.palette.normal.raised
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: units.gu(0.5)
            }
            function trigger(){
                addItemsBar.open()
            }
        }
    }

    Rectangle {
        id: addItemBar
        color: switch (settings.currentTheme) {
               case "Default":
                   "#463030"
                   break
               case "Ambiance":
               case "System":
               case "SuruDark":
                   theme.palette.normal.foreground
                   break
               default:
                   "#463030"
               }

        property real startPosition: parent.height
        property real endPosition: parent.height - addItemBar.height

        height:  units.gu(6)
        y: startPosition
        anchors{
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        LomiriNumberAnimation on height {
            id: resizeBigAnimation
            from: units.gu(6)
            to: units.gu(16)
            duration: LomiriAnimation.BriskDuration
            easing: LomiriAnimation.StandardEasing
            running: false
        }
        LomiriNumberAnimation on height {
            id: resizeSmallAnimation
            from: units.gu(16)
            to: units.gu(6)
            duration: LomiriAnimation.BriskDuration
            easing: LomiriAnimation.StandardEasing
            running: false
        }

        Button {
            id: btnAddComment
            property bool isCommentsShown: false

            width: textFieldName.height
            height: width
            color: "transparent"
            activeFocusOnPress: false

            action: Action {
                iconName: "message"
                shortcut: "Ctrl+D"
                onTriggered: {
                    btnAddComment.isCommentsShown = !btnAddComment.isCommentsShown
                }
            }

            onIsCommentsShownChanged: {
                if (isCommentsShown) {
                    addItemsBar.showComments()
                    resizeBigAnimation.running = true
                    textAreaComments.visible = true
                    textAreaComments.openingAnimation.running = true
                    textAreaComments.forceActiveFocus()
                } else {
                    textAreaComments.visible = false
                    resizeSmallAnimation.running = true
                    addItemsBar.hideComments()
                    textFieldName.forceActiveFocus()
                }
            }

            anchors {
                left: parent.left
                leftMargin: units.gu(0.5)
                bottom: parent.bottom
                bottomMargin: units.gu(1)
            }
        }

        TextField {
            id: textFieldName
            // this value is to avoid letter being cut off
            height: units.gu(4.3)
            visible: false
            InputMethod.extensions: { "enterKeyText": i18n.dtr("talaan-app", addItemsBar.mode === "add" ? "Add" : "Save") }

            anchors {
                left: btnAddComment.right
                leftMargin: units.gu(0.5)
                right: btnGoDown.left
                rightMargin: units.gu(0.5)
                top: parent.top
                topMargin: units.gu(1)
            }

            placeholderText: i18n.tr("Enter item name")
            hasClearButton: true
        }

        Button {
            id: btnGoDown
            width: textFieldName.height
            height: width
            color: "transparent"
            activeFocusOnPress: false
            action: Action {
                iconName:  "close"
                shortcut: textFieldName.activeFocus || textAreaComments.activeFocus ? "Esc" : undefined
                onTriggered: {
                    addItemsBar.cancel()
                    addItemsBar.panelClose()
                }
            }
            anchors {
                right: btnAdd.left
                rightMargin: units.gu(0.5)
                bottom: parent.bottom
                bottomMargin: units.gu(1)
            }
        }

        Button {
            id: btnAdd
            width: textFieldName.height
            height: width
            activeFocusOnPress: false
            color: "transparent"
            action: Action {
                shortcut: textFieldName.activeFocus ? StandardKey.InsertParagraphSeparator : textAreaComments.activeFocus ? StandardKey.InsertLineSeparator : undefined
                iconName: addItemsBar.mode === "add" ? "ok" : "save"
                onTriggered: {
                    keyboard.target.commit()
                    save()
                }
            }
            anchors {
                right: parent.right
                rightMargin: units.gu(0.5)
                bottom: parent.bottom
                bottomMargin: units.gu(1)
            }
        }
        TextArea {
            id: textAreaComments
            property alias openingAnimation: openingAnimation
            placeholderText: i18n.tr("Add comments / notes")
            visible: false
            height: units.gu(8.6)
            maximumLineCount: 3
            anchors {
                left: textFieldName.left
                right: textFieldName.right
                top: textFieldName.bottom
                topMargin: units.gu(1)
            }

            LomiriNumberAnimation on opacity {
                id: openingAnimation
                from: 0
                to: 1
                duration: LomiriAnimation.SleepyDuration
                easing: LomiriAnimation.StandardEasing
                running: false
            }
        }

    }
    Connections {
        id: keyboard
        target: Qt.inputMethod

        property bool closedByFunction: false

        function hideKeyboard(){
            closedByFunction = true
            keyboard.target.hide()
            console.log("hideKyeboard")
        }

        onVisibleChanged:{
            if(!target.visible && closedByFunction){
                console.log("clinose")
                addItemsBar.close()
            }else{
                closedByFunction = false
            }
        }
    }
}
