import QtQuick 2.4
import Ubuntu.Components 1.3

ListItem {
    id: root

    //Public APIs
    property bool bindValue
    property bool checkboxValue: bindValue
    property alias titleText: listItemLayout.title
    property alias subText: listItemLayout.subtitle

    width: parent.width
    highlightColor: switch(settings.currentTheme){
                    case "Default":
                        "#2D371300"
                        break;
                    case "Ambiance":
                        theme.palette.highlighted.background
                        break;
                    case "SuruDark":
                        theme.palette.highlighted.background
                        break;
                    default:
                        "#2D371300"
                    }

    ListItemLayout {
        id: listItemLayout
        title.color: switch (settings.currentTheme) {
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
        subtitle.color: switch (settings.currentTheme) {
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

        CheckBox {
            id: checkItem
            SlotsLayout.position: SlotsLayout.Leading

            //workaround where binding to status gets lost when the checkbox is clicked
            Component.onCompleted: checkItem.checked = bindValue
            Connections {
                target: root
                onBindValueChanged: {
                    checkItem.checked = bindValue
                }
            }
            onClicked: {
                checkboxValue = !bindValue
            }
        }
    }
    onClicked: {
        checkboxValue = !bindValue
    }
}
