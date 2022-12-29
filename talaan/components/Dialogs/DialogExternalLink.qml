import QtQuick 2.4
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3

Component {
    id: dialogExternalLink
    Dialog {
        id: dialogue

        property string externalURL

        title: i18n.tr("Open external link")
        text: i18n.tr("You are about to open an external link. Do you wish to continue?") + "<br><br>" + externalURL

        signal proceed(bool answer)

        Row {
            id: buttonsRow
            spacing: width * 0.1

            Button {
                color: theme.palette.normal.negative
                text: i18n.tr("Cancel")
                width: parent.width * 0.45
                onClicked: {
                    dialogue.proceed(false)
                    PopupUtils.close(dialogue)
                }
            }
            Button {
                text: i18n.tr("OK")
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
