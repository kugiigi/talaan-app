import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Component {
    id: dialogItemDetails
    Dialog {
        id: dialogue

        property string description
        
        Column {
            spacing: units.gu(3)
            
            ScrollView {
                
                property real heightLimit: units.gu(15)
                
                height: {
                    if (heightLimit > 0) {
                        if (messageLabel.height > heightLimit) {
                            heightLimit
                        } else {
                            messageLabel.height
                        }
                    } else {
                        messageLabel.height
                    }
                }
                
                anchors {
                    left: parent.left
                    right: parent.right
                }

                Flickable {
                    id: messageFlickable
                    boundsBehavior: Flickable.DragAndOvershootBounds
                    interactive: true
                    contentHeight: messageLabel.contentHeight + units.gu(2)
            
                    TextArea {
                        id: messageLabel
                        
//~                         text: description

        //~                 font.pixelSize: fontSize

        //~                 anchors {
        //~                     left: parent.left
        //~                     right: parent.right
        //~                     top: parent.top
        //~                 }
                        autoSize: true
                        readOnly: true
                        maximumLineCount: 0
                        verticalAlignment: TextEdit.AlignVCenter
                        wrapMode: TextEdit.WordWrap

                        /*Workaround for bug when autoSize is true, the line count is 1 and the font is too big.
                                            text is clipped horizontally*/
                        Component.onCompleted: {
                            text = "'\n"
                            text = description
                        }

                        onSelectedTextChanged: {
                            if (selectedText.length > 0) {
                                cursorVisible = true
                            }
                        }
                    }
                }
            }


            Button {
                text: i18n.tr("Close")
                color: UbuntuColors.warmGrey
                anchors {
                    left: parent.left
                    right: parent.right
                }
                onClicked: {
                    PopupUtils.close(dialogue)
                }
            }
        }
    }
}
