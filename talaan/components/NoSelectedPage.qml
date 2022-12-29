import QtQuick 2.4
import Lomiri.Components 1.3

Page{
    property alias title: emptyState.title
    property alias subTitle: emptyState.subTitle
    property alias iconName: emptyState.iconName

    header: PageHeader{
        StyleHints {
            //foregroundColor: LomiriColors.orange
            backgroundColor: "transparent"
            dividerColor:"transparent"// LomiriColors.slate
        }
    }


    EmptyState {
        id: emptyState

        anchors {
            right: parent.right
            left: parent.left
            verticalCenter: parent.verticalCenter
            margins: units.gu(1)
        }
    }
    //}
}

