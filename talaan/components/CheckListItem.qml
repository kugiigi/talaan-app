import QtQuick 2.4
import Ubuntu.Components 1.3
import "../library/DataProcess.js" as DataProcess
import "../library/ProcessFunc.js" as Process

Item {
    id: itemContents
    property string filter
    property string mode
    property alias rightActionsList: itemHighlight.rightActionsList
    property alias leftActionsList: itemHighlight.leftActionsList
    property bool itemHighlighted: false

    anchors.fill: parent
    Component.onCompleted: {
        if (filter === "category" && target_dt !== "") {
            lblName.anchors.right = rowDate.left
        } else {
            lblName.anchors.right = undefined
        }
    }

    ListViewHover {
        id: itemHighlight
        actionsPosition: "Top-Right"
        rightActionsList: trailingActions.actions
        leftActionsList: leadingActions.actions
        alreadyHighlighted: itemHighlighted
    }

    Rectangle{
        id: categoryColorRec
        width: units.gu(3)
        height: width
        color: categoryColor
        transform: Rotation { origin.x: categoryColorRec.width; origin.y: categoryColorRec.height; angle: 45}
        visible: !settings.categoryColors || filter === "category" ? false : true
        anchors {
            verticalCenter: parent.top
            right: parent.left
        }

          //TODO: add ability to show category name when hovered
//        MouseArea {
//            id: hoverArea

//            z: -1
//            anchors.fill: parent
//            acceptedButtons: Qt.NoButton
//            hoverEnabled: true

//            onContainsMouseChanged: {
//                if (containsMouse) {
//                    //console.log("nasa loob mouse")
//                    loader.active = true
//                } else {
//                    loader.active = false
//                    //console.log("nassa labas mouse")
//                }
//            }
//        }
    }

    Label {
        id: lblName

        text: checklist
        color: switch (settings.currentTheme) {
               case "Default":
                   theme.palette.normal.background
                   break
               case "Ambiance":
               case "System":
               case "SuruDark":
                   theme.palette.normal.backgroundText
                   break
               default:
                   theme.palette.normal.background
               }
        fontSize: "large"
        elide: Text.ElideRight
        fontSizeMode: Text.HorizontalFit
        minimumPixelSize: units.gu(2)
        width: itemContents.width - units.gu(18)
        verticalAlignment: Text.AlignVCenter
        anchors {
            top: parent.top
            topMargin: units.gu(1)
            left: parent.left
            leftMargin: units.gu(1)
            bottom: !descr ? parent.bottom : undefined
        }
    }
    Label {
        id: lblDescr
        text: descr
        visible: descr ? true : false
        color: switch (settings.currentTheme) {
               case "Default":
                   theme.palette.normal.background
                   break
               case "Ambiance":
               case "System":
               case "SuruDark":
                   theme.palette.normal.backgroundText
                   break
               default:
                   theme.palette.normal.background
               }
        fontSize: "small"
        elide: Text.ElideRight
        wrapMode: Text.WordWrap
        maximumLineCount: 2
        anchors {
            topMargin: units.gu(1)
            top: lblName.bottom
            left: parent.left
            leftMargin: units.gu(1)
            right: rowItems.left
            rightMargin: units.gu(1)
        }
    }

    Row {
        id: rowDate

        visible: itemHighlight.containsMouse ? false : true
        spacing: units.gu(0.5)
        anchors {
            top: parent.top
            topMargin: units.gu(1)
            right: parent.right
            rightMargin: units.gu(1)
        }
        Icon {
            name: "stock_event"
            visible: target_dt === '' ? false : true
            height: itemContents.height * 0.2
            width: height
            color: switch (settings.currentTheme) {
                   case "Default":
                       status !== 'complete' && overdue ? theme.palette.normal.negative : theme.palette.normal.background
                       break
                   case "Ambiance":
                   case "System":
                   case "SuruDark":
                       status !== 'complete' && overdue ? theme.palette.normal.negative : theme.palette.normal.backgroundText
                       break
                   default:
                       status !== 'complete' && overdue ? theme.palette.normal.negative : theme.palette.normal.background
                   }
        }

        Label {
            id: lblDate
            color: switch (settings.currentTheme) {
                   case "Default":
                       theme.palette.normal.background
                       break
                   case "Ambiance":
                   case "System":
                   case "SuruDark":
                       theme.palette.normal.backgroundText
                       break
                   default:
                       theme.palette.normal.background
                   }
            fontSize: "small"
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
            text: target_dt === '' ? '' : Process.relativeDate(target_dt,"ddd, MMM d, yyyy","Basic")
        }
    }
    Label {
        id: lblStatus
        visible: false
        text: status
        fontSize: "small"
        anchors {
            right: parent.right
            rightMargin: units.gu(1)
            bottom: parent.bottom
            bottomMargin: units.gu(1)
        }
    }
    Row {
        id: rowItems

        spacing: units.gu(1)
        width: childrenRect.width

        anchors {
            right: parent.right
            rightMargin: units.gu(1)
            bottom: parent.bottom
            bottomMargin: units.gu(1)
        }
        Icon {
            id: iconItems

            width: units.gu(2)
            height: width
            name: status === "normal" ? "note" : "tick"
            color: switch (settings.currentTheme) {
                   case "Default":
                       theme.palette.normal.background
                       break
                   case "Ambiance":
                   case "System":
                   case "SuruDark":
                       theme.palette.normal.backgroundText
                       break
                   default:
                       theme.palette.normal.background
                   }
        }
        Label {
            id: lblItemsupdate

            visible: true
            color: switch (settings.currentTheme) {
                   case "Default":
                       theme.palette.normal.background
                       break
                   case "Ambiance":
                   case "System":
                   case "SuruDark":
                       theme.palette.normal.backgroundText
                       break
                   default:
                       theme.palette.normal.background
                   }
            text: status === "normal"
                  || mode === "saved" ? total : completed + " / " + total
            wrapMode: Text.WordWrap
            fontSize: "small"
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
