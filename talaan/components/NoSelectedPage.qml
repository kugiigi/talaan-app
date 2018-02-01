import QtQuick 2.4
import Ubuntu.Components 1.3

Page{
    property alias title: emptyState.title
    property alias subTitle: emptyState.subTitle
    property alias iconName: emptyState.iconName

    header: PageHeader{
        StyleHints {
            //foregroundColor: UbuntuColors.orange
            backgroundColor: "transparent"
            dividerColor:"transparent"// UbuntuColors.slate
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

