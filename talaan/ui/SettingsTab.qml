import QtQuick 2.4
import Lomiri.Components 1.3
import Lomiri.Components.ListItems 1.3 as ListItem
//import Lomiri.Layouts 1.0
import "../components"
import "../components/Common"

PageWithBottom {

    id: settingsPage
    property alias mainListView: navigationListView

    actions: [mainView.bottomMenuActions[4], mainView.bottomMenuActions[4], mainView.bottomMenuActions[1], mainView.bottomMenuActions[0], mainView.bottomMenuActions[2], mainView.bottomMenuActions[5]]
    hideLeadingActions: true

    header: PageHeader {
        title: i18n.tr("Settings")
        StyleHints {
            backgroundColor: switch (settings.currentTheme) {
                             case "Default":
                                 "#3D1400"
                                 break
                             case "System":
                             case "Ambiance":
                             case "SuruDark":
                                 theme.palette.normal.foreground
                                 break
                             default:
                                 "#3D1400"
                             }
            dividerColor: LomiriColors.slate
        }
        leadingActionBar {
            actions: Action {
                text: i18n.tr("Navigation Panel")
                iconName: "navigation-menu"
                visible: primaryLeftPage.isMultiColumn ? false : true
                onTriggered: {
                    mainView.navigationPanel.toggle()
                }
            }
        }
    }

    onActiveChanged: {
        if (!active) {

            navigationListView.currentIndex = -1
        }
    }

    ScrollView {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            topMargin: settingsPage.header.height
        }

        Flickable {
            id: settingsListView

            interactive: true
            clip: true
            contentHeight: _settingsColumn.height
            anchors.fill: parent

            LomiriNumberAnimation on opacity {
                running: settingsListView.visible
                from: 0
                to: 1
                easing: LomiriAnimation.StandardEasing
                duration: LomiriAnimation.FastDuration
            }

            function positionViewAtBeginning() {
                //FIXME: find a way to position at the beginning a flickable
                //dummy function
                contentY = 0
            }

            Column {
                id: _settingsColumn

                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    //bottom: parent.bottom
                }

                //Interface Settings
                ListItemSectionHeader {
                    title: i18n.tr("Interface")
                }

                CheckBoxItem {
                    titleText.text: i18n.tr("Hide completed items")
                    subText.text: i18n.tr("When opening lists")
                    bindValue: settings.listItemHideChecked
                    onCheckboxValueChanged: {
                        settings.listItemHideChecked = checkboxValue
                    }
                }

                CheckBoxItem {
                    titleText.text: i18n.tr("Show category colors")
                    subText.text: i18n.tr("Category color assignment")
                    bindValue: settings.categoryColors
                    onCheckboxValueChanged: {
                        settings.categoryColors = checkboxValue
                    }
                }

                ExpandableListItem {
                    id: themeExpandedListItem
                    listViewHeight: units.gu(28)
                    titleText.text: i18n.tr("Theme")
                    titleText.textSize: Label.Medium
                    subText.textSize: Label.Small
                    savedValue: settings.currentTheme
                    titleText.color: switch (settings.currentTheme) {
                                     case "Default":
                                         theme.palette.normal.background
                                         break
                                     case "System":
                                     case "Ambiance":
                                     case "SuruDark":
                                         theme.palette.normal.backgroundText
                                         break
                                     default:
                                         theme.palette.normal.background
                                     }
                    subText.color: switch (settings.currentTheme) {
                                   case "Default":
                                       theme.palette.normal.background
                                       break
                                   case "System":
                                   case "Ambiance":
                                   case "SuruDark":
                                       theme.palette.normal.backgroundText
                                       break
                                   default:
                                       theme.palette.normal.background
                                   }
                    listItemColor: switch (settings.currentTheme) {
                                   case "Default":
                                       theme.palette.normal.background
                                       break
                                   case "System":
                                   case "Ambiance":
                                   case "SuruDark":
                                       theme.palette.normal.backgroundText
                                       break
                                   default:
                                       theme.palette.normal.background
                                   }

                    onToggle: {
                        settings.currentTheme = newValue
                    }
                }

                ListModel {
                    id: themeModel
                    Component.onCompleted: initialise()

                    function initialise() {
                        themeModel.append({
                                              value: "Default",
                                              text: i18n.tr("Default")
                                          })
                        themeModel.append({
                                              value: "System",
                                              text: i18n.tr("System")
                                          })
                        themeModel.append({
                                              value: "Ambiance",
                                              text: i18n.tr("Ambiance")
                                          })
                        themeModel.append({
                                              value: "SuruDark",
                                              text: i18n.tr("Suru Dark")
                                          })
                        themeExpandedListItem.model = themeModel
                    }
                }

                //Accessibility Settings
                ListItemSectionHeader {
                    title: i18n.tr("Accessibility")
                }

                ExpandableListItem {
                    id: bottomMenuTypeExpandedListItem
                    listViewHeight: units.gu(14)
                    titleText.text: i18n.tr("Bottom Menu")
                    titleText.textSize: Label.Medium
                    subText.textSize: Label.Small
                    savedValue: settings.bottomMenuType
                    titleText.color: switch (settings.currentTheme) {
                                     case "Default":
                                         theme.palette.normal.background
                                         break
                                     case "System":
                                     case "Ambiance":
                                     case "SuruDark":
                                         theme.palette.normal.backgroundText
                                         break
                                     default:
                                         theme.palette.normal.background
                                     }
                    subText.color: switch (settings.currentTheme) {
                                   case "Default":
                                       theme.palette.normal.background
                                       break
                                   case "System":
                                   case "Ambiance":
                                   case "SuruDark":
                                       theme.palette.normal.backgroundText
                                       break
                                   default:
                                       theme.palette.normal.background
                                   }
                    listItemColor: switch (settings.currentTheme) {
                                   case "Default":
                                       theme.palette.normal.background
                                       break
                                   case "System":
                                   case "Ambiance":
                                   case "SuruDark":
                                       theme.palette.normal.backgroundText
                                       break
                                   default:
                                       theme.palette.normal.background
                                   }
                    onToggle: {
                        settings.bottomMenuType = newValue
                    }
                }

                ListModel {
                    id: bottomMenuTypeModel
                    Component.onCompleted: initialise()

                    function initialise() {
                        bottomMenuTypeModel.append({
                                                   value: "None",
                                                   text: i18n.tr("None")
                                               })
                        bottomMenuTypeModel.append({
                                                   value: "Radial",
                                                   text: i18n.tr("Radial")
                                               })
                        bottomMenuTypeExpandedListItem.model = bottomMenuTypeModel
                    }
                }

                ExpandableListItem {
                    id: bottomMenuExpandedListItem
                    listViewHeight: units.gu(28)
                    titleText.text: i18n.tr("Bottom Menu Hint")
                    titleText.textSize: Label.Medium
                    subText.textSize: Label.Small
                    savedValue: settings.bottomMenuHint
                    titleText.color: switch (settings.currentTheme) {
                                     case "Default":
                                         theme.palette.normal.background
                                         break
                                     case "System":
                                     case "Ambiance":
                                     case "SuruDark":
                                         theme.palette.normal.backgroundText
                                         break
                                     default:
                                         theme.palette.normal.background
                                     }
                    subText.color: switch (settings.currentTheme) {
                                   case "Default":
                                       theme.palette.normal.background
                                       break
                                   case "System":
                                   case "Ambiance":
                                   case "SuruDark":
                                       theme.palette.normal.backgroundText
                                       break
                                   default:
                                       theme.palette.normal.background
                                   }
                    listItemColor: switch (settings.currentTheme) {
                                   case "Default":
                                       theme.palette.normal.background
                                       break
                                   case "System":
                                   case "Ambiance":
                                   case "SuruDark":
                                       theme.palette.normal.backgroundText
                                       break
                                   default:
                                       theme.palette.normal.background
                                   }
                    onToggle: {
                        settings.bottomMenuHint = newValue
                    }
                }

                ListModel {
                    id: bottomMenuModel
                    Component.onCompleted: initialise()

                    function initialise() {
                        bottomMenuModel.append({
                                                   value: "None",
                                                   text: i18n.tr("None")
                                               })
                        bottomMenuModel.append({
                                                   value: "Autohide",
                                                   text: i18n.tr("Autohide")
                                               })
                        bottomMenuModel.append({
                                                   value: "Semihide",
                                                   text: i18n.tr("Semihide")
                                               })
                        bottomMenuModel.append({
                                                   value: "Always",
                                                   text: i18n.tr(
                                                             "Always Displayed")
                                               })
                        bottomMenuExpandedListItem.model = bottomMenuModel
                    }
                }

//                ExpandableListItem {
//                    id: bottomMenuAnchorExpandedListItem
//                    visible: settings.bottomMenuType === "Panel"
//                    listViewHeight: units.gu(21)
//                    titleText.text: i18n.tr("Bottom Menu Hint")
//                    titleText.textSize: Label.Medium
//                    subText.textSize: Label.Small
//                    savedValue: settings.bottomMenuAnchor
//                    titleText.color: switch (settings.currentTheme) {
//                                     case "Default":
//                                         theme.palette.normal.background
//                                         break
//                                     case "Ambiance":
//                                         theme.palette.normal.backgroundText
//                                         break
//                                     case "SuruDark":
//                                         theme.palette.normal.backgroundText
//                                         break
//                                     default:
//                                         theme.palette.normal.background
//                                     }
//                    subText.color: switch (settings.currentTheme) {
//                                   case "Default":
//                                       theme.palette.normal.background
//                                       break
//                                   case "Ambiance":
//                                       theme.palette.normal.backgroundText
//                                       break
//                                   case "SuruDark":
//                                       theme.palette.normal.backgroundText
//                                       break
//                                   default:
//                                       theme.palette.normal.background
//                                   }
//                    listItemColor: switch (settings.currentTheme) {
//                                   case "Default":
//                                       theme.palette.normal.background
//                                       break
//                                   case "Ambiance":
//                                       theme.palette.normal.backgroundText
//                                       break
//                                   case "SuruDark":
//                                       theme.palette.normal.backgroundText
//                                       break
//                                   default:
//                                       theme.palette.normal.background
//                                   }
//                    onToggle: {
//                        settings.bottomMenuAnchor = newValue
//                    }
//                }

//                ListModel {
//                    id: bottomMenuAnchorModel
//                    Component.onCompleted: initialise()

//                    function initialise() {
//                        bottomMenuAnchorModel.append({
//                                                   value: "Right",
//                                                   text: i18n.tr("Right")
//                                               })
//                        bottomMenuAnchorModel.append({
//                                                   value: "Left",
//                                                   text: i18n.tr("Left")
//                                               })
//                        bottomMenuAnchorExpandedListItem.model = bottomMenuAnchorModel
//                    }
//                }

                CheckBoxItem {
                    titleText.text: i18n.tr("Larger font size")
                    subText.text: i18n.tr("For list items")
                    bindValue: settings.listItemFontSize
                    onCheckboxValueChanged: {
                        settings.listItemFontSize = checkboxValue
                    }
                }

                CheckBoxItem {
                    titleText.text: i18n.tr("Toggle list items via surface")
                    subText.text: i18n.tr(
                                      "Only the checkbox is clickable if disabled")
                    bindValue: settings.listItemClickable
                    onCheckboxValueChanged: {
                        settings.listItemClickable = checkboxValue
                    }
                }
                LomiriListView {
                    id: navigationListView

                    interactive: false
                    currentIndex: -1
                    clip: true
                    highlightFollowsCurrentItem: true
                    highlight: ListViewHighlight {
                    }
                    highlightMoveDuration: LomiriAnimation.SnapDuration
                    highlightResizeDuration: LomiriAnimation.SnapDuration
                    height: contentHeight
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    model: navigationsModel

                    LomiriNumberAnimation on opacity {
                        running: navigationListView.visible
                        from: 0
                        to: 1
                        easing: LomiriAnimation.StandardEasing
                        duration: LomiriAnimation.FastDuration
                    }

                    delegate: NavigationItem {
                        id: categoriesNavigation
                        titleText.text: title
                        subText.text: subtitle

                        anchors {
                            left: parent.left
                            right: parent.right
                        }

                        action: Action {
                            onTriggered: {
                                navigationListView.currentIndex = index
                                mainLayout.selectItemFromMain(mainLayout.primaryPage,
                                                              Qt.resolvedUrl(page))
                            }
                        }
                    }
                }
            }
        }
    }

    ListModel {
        id: navigationsModel
        Component.onCompleted: initialise()

        function initialise() {
            navigationsModel.append({
                                        title: i18n.tr("Manage Categories"),
                                        subtitle: i18n.tr(
                                                      "Add, edit, and delete categories"),
                                        page: "ManageCategory.qml"
                                    })
            navigationsModel.append({
                                        title: i18n.tr("About Talaan"),
                                        subtitle: i18n.tr(
                                                      "Credits, report bugs, view source code, contact developer, donate"),
                                        page: "About.qml"
                                    })
        }
    }
}
