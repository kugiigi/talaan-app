import QtQuick 2.4
import Lomiri.Components 1.3
import "../library/DataProcess.js" as DataProcess
import "../library/ProcessFunc.js" as Process

Item {
    id: itemContents
    //Layouts.item: "listItem"
    anchors {
        verticalCenter: parent.verticalCenter
        left: parent.left
        right: parent.right
        leftMargin: units.gu(2)
        rightMargin: units.gu(2)
    }

    Icon {
        id: checkItem

        color: theme.palette.normal.foregroundText
        width: units.gu(2)
        height: width
        name: status === 0 ? "select-none" : "tick"
        visible: pageMode !== "talaan" && pageMode !== "history" ? false : true
        enabled: pageMode === "history" ? false : true

        asynchronous: true

        anchors {
           left: parent.left
           verticalCenter: parent.verticalCenter
        }
    }

    Label {
        id: labelName
        text: itemName
        fontSize: "medium"
        visible: true
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        font.strikeout: checkItem.visible === true
                        && status !== 0 ? true : false
        color: switch(settings.currentTheme){
               case "Default":
                   checkItem.visible === true
                      && status !== 0 ? theme.palette.normal.backgroundSecondaryText : theme.palette.normal.foregroundText
                   break;
               case "Ambiance":
                   checkItem.visible === true
                      && status !== 0 ? "blue" : "red"
                   break;
               case "System":
               case "SuruDark":
                   checkItem.visible === true
                      && status !== 0 ? theme.palette.normal.backgroundSecondaryText : theme.palette.normal.foregroundText
                   break;
               default:
                   checkItem.visible === true
                      && status !== 0 ? theme.palette.normal.backgroundSecondaryText : theme.palette.normal.foregroundText
               }
        verticalAlignment: Text.AlignVCenter
        anchors {
            left: checkItem.visible === true ? checkItem.right : parent.left
            leftMargin: units.gu(2)
            right: labelSkipped.left
            rightMargin: units.gu(1)
            verticalCenter: parent.verticalCenter
        }
    }
    Label {
        id: labelSkipped
        text: checkItem.visible === true && status === 2 ? i18n.tr(
                                                               "Skipped") : ""
        fontSize: "small"
        color: "red"
        font.bold: true
        font.italic: true
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        anchors {
            right: mouseComment.left
            rightMargin: units.gu(1)
            verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        id: mouseComment

        visible: comments === "" ? false : true
        width: units.gu(6)
        height: width
        preventStealing: true
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
        }

        onClicked: {
            var mapped = listWithActions.mapToItem(commentBubble,
                                                   commentBubble.x,
                                                   commentBubble.y)
            if ((commentBubble.y === mapped.y + listWithActions.height
                 || commentBubble.y === mapped.y - commentBubble.height / 2)
                    && commentBubble.notifyLoaderItem !== null) {
                commentBubble.hideNotification()
            } else {
                commentBubble.y = mapped.y + listWithActions.height
                commentBubble.startPosition = commentBubble.parent.width
                commentBubble.endPosition = commentBubble.parent.width
                        - commentBubble.bubbleWidth - units.gu(1)
                commentBubble.message = comments
                console.log("Parent: " + pageItems.height + " Comment: " + commentBubble.y)
                if (commentBubble.y + commentBubble.height >= pageItems.height) {
                    commentBubble.y = mapped.y - commentBubble.height / 2
                }
                commentBubble.showNotification("", "#513838")
            }
        }
        onReleased: {
            iconComment.color = "#513838"
        }

        onPressed: {
            iconComment.color = "white"
        }

        Icon {
            id: iconComment
            name: "message"
            color: "#513838"
            width: mouseComment.height / 1.5
            height: width
            anchors.centerIn: parent
        }
    }
}
