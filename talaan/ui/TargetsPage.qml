import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.Layouts 1.1
import Ubuntu.Components.Themes.Ambiance 1.3
import "../components"
import "../components/Common"
import "../library"
import Ubuntu.Components.Popups 1.3
import "../library/DataProcess.js" as DataProcess
import "../library/ProcessFunc.js" as Process

//PageWithBottom {
Page{
    id: pageTargets

    property string pagemode
    property string currentCategory
    property string currentDescription
    property string currentIcon
    property string dialogResponse
    property bool noBackground: false

//    actions: [mainView.bottomMenuActions[4],mainView.bottomMenuActions[4],mainView.bottomMenuActions[1],mainView.bottomMenuActions[2],mainView.bottomMenuActions[3],mainView.bottomMenuActions[5]]

    header: PageHeader {
        title: i18n.tr("Targets")
        StyleHints {
            backgroundColor: switch(settings.currentTheme){
                             case "Default":
                                 "#3D1400"
                                 break;
                             case "Ambiance":
                                 theme.palette.normal.background
                                 break;
                             case "SuruDark":
                                 theme.palette.normal.foreground
                                 break;
                             default:
                                 "#3D1400"
                             }

            dividerColor: UbuntuColors.slate
        }


        trailingActionBar {
            actions: [
                Action {
                    iconName: settings.panelSplit ? "lock-broken" : "lock"
                    visible: !primaryLeftPage.isMultiColumn ? false : navigationPage.isReadyForSplit ? true : false
                    text: settings.panelSplit ? i18n.tr("Unpin window") : i18n.tr("Pin Window")
                    onTriggered: settings.panelSplit = !settings.panelSplit
                }
            ]
        }


        extension: Sections {
            id: mainSections

            model: [i18n.tr("Upcoming"), i18n.tr("Overdue")]
            onSelectedIndexChanged: {
                switch (selectedIndex) {
                case 0:
                    sortedTargets.filter.pattern = /false/
                    break
                case 1:
                    sortedTargets.filter.pattern = /true/
                    break
                }
            }
        }
    }

    //functions
    function loadTargets() {
        mainView.listItems.modelTargets.getTargets()
        //sortedTargets.filter.pattern = /false/ /*workaround SortFilterModel not reloading after original model is loaded*/
    }

    onVisibleChanged: {
        if (visible) {
            loadTargets()
        }
    }

    Component.onCompleted: {
        loadTargets()
    }

    Connections{
        target: mainView.listItems.modelTargets
        onCountChanged:{
            sortedTargets.filter.pattern = /false/ /*workaround SortFilterModel not reloading after original model is loaded*/
        }
    }

    SortFilterModel {
        id: sortedTargets
        model: mainView.listItems.modelTargets
        filter.property: "overdue"
        filter.pattern: /false/
    }

    EmptyState {
        id: emptyState
        iconName: "event"
        title: mainSections.selectedIndex === 0 ? i18n.tr("You have no upcoming targets") : i18n.tr("You have no overdue targets")
        subTitle: mainSections.selectedIndex === 0 ? i18n.tr("All your upcoming targets will be listed here") : i18n.tr("All your overdue targets will be listed here")
        anchors {
            //top: parent.top
            right: parent.right
            left: parent.left
            //bottom: parent.bottom
            verticalCenter: parent.verticalCenter
            margins: units.gu(1)
        }
        shown: sortedTargets.count === 0 && listItems.modelTargets.loadingStatus === 'Ready'
    }

//    ActivityIndicator{
//        anchors.centerIn: parent
//        running: listItems.modelTargets.loadingStatus !== "Ready"
//    }

    LoadingComponent{
        visible: listItems.modelTargets.loadingStatus !== "Ready"
        title: i18n.tr("Loading Targets")
        subTitle: i18n.tr("Please wait")
    }

    PageBackGround {
        id: pageBackground
        visible: !pageTargets.noBackground
        bgColor: switch(settings.currentTheme){
                 case "Default":
                     "#371300"
                     break;
                 case "Ambiance":
                     theme.palette.normal.background
                     break;
                 case "SuruDark":
                     theme.palette.normal.background
                     break;
                 default:
                     theme.palette.normal.background
                 }
        bgOpacity: switch(settings.currentTheme){
                       case "Default":
                           0.6
                           break;
                       case "Ambiance":
                           1.0
                           break;
                       case "SuruDark":
                           1.0
                           break;
                       default:
                           0.6
                       }
    }

    ScrollView {
        id: scrollTargetList
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            topMargin: pageTargets.header.height
        }
        UbuntuListView {
            id: targetList

            property string category

            anchors.fill: parent
            interactive: true
            model: sortedTargets
            clip: true
            currentIndex: -1
            highlightFollowsCurrentItem: true
            highlight: ListViewHighlight {
            }
            highlightMoveDuration: UbuntuAnimation.SnapDuration
            highlightResizeDuration: UbuntuAnimation.SnapDuration

            UbuntuNumberAnimation on opacity {
                running: targetList.count > 0
                from: 0
                to: 1
                easing: UbuntuAnimation.StandardEasing
                duration: UbuntuAnimation.FastDuration
            }

            delegate: ListItem {
                id: listWithActions
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
                property int currentIndex: index

                ListItemLayout {
                    id: layout
                    title.text: checklist
                    title.color: switch(settings.currentTheme){
                                 case "Default":
                                     theme.palette.normal.background
                                     break;
                                 case "Ambiance":
                                     theme.palette.normal.backgroundText
                                     break;
                                 case "SuruDark":
                                     theme.palette.normal.backgroundText
                                     break;
                                 default:
                                     theme.palette.normal.background
                                 }
                    subtitle.text: Qt.formatDate(target_dt,"ddd, MMMM d, yyyy")
                    subtitle.color: switch(settings.currentTheme){
                                    case "Default":
                                        theme.palette.normal.background
                                        break;
                                    case "Ambiance":
                                        theme.palette.normal.backgroundText
                                        break;
                                    case "SuruDark":
                                        theme.palette.normal.backgroundText
                                        break;
                                    default:
                                        theme.palette.normal.background
                                    }
                    //                    Icon {
                    //                        id: iconImage
                    //                        SlotsLayout.position: SlotsLayout.Trailing
                    //                        width: listWithActions.height * 0.4
                    //                        height: width
                    //                        name: "reminder"
                    //                        visible: reminder ? true : false
                    //                        color: theme.palette.normal.base
                    //                    }
                }
            }
            section.property: "header" //"target_dt"
            section.criteria: ViewSection.FullString
            section.labelPositioning: ViewSection.InlineLabels
                                      || ViewSection.CurrentLabelAtStart
            section.delegate: ListItem {
                height: units.gu(4)
                divider.visible: true
                divider.height: units.gu(0.2)
                //color: "#2A666666"
                highlightColor: "transparent"
                Label {
                    color: switch(settings.currentTheme){
                           case "Default":
                               theme.palette.normal.background
                               break;
                           case "Ambiance":
                               theme.palette.normal.backgroundText
                               break;
                           case "SuruDark":
                               theme.palette.normal.backgroundText
                               break;
                           default:
                               theme.palette.normal.background
                           }
                    fontSize: "small"
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                    fontSizeMode: Text.HorizontalFit
                    minimumPixelSize: units.gu(2)
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: units.gu(1)
                    }
                    text: section //Process.historyDate(section)
                }
            }
        }
    }
}
