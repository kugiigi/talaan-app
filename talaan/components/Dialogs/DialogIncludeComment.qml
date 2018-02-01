import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Component {
    id: dialogComments
    Dialog {
        id: dialogue
        title: i18n.tr("Do you want to include the list item comments?")

        signal //        text: i18n.tr(
        //                  "All items under this list will also be deleted permanently.")
        proceed(bool answer)

        Row {
            id: buttonsRow
            spacing: width * 0.1

            Button {
                color: theme.palette.normal.negative
                text: i18n.tr("No")
                width: parent.width * 0.45
                onClicked: {
                    dialogue.proceed(false)
                    PopupUtils.close(dialogue)
                }
            }
            Button {
                text: i18n.tr("Yes")
                color: theme.palette.normal.positive
                width: parent.width * 0.45
                onClicked: {
                    dialogue.proceed(true)
                    PopupUtils.close(dialogue)
                }
            }
        }
    }
}
