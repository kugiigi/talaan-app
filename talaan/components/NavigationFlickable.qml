import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItemOld
import "../components/Common"
import "../components/SortFilter"

ScrollView {

    id: flickable

    property list<Action> actions
    property alias currentTab: listView.currentIndex

    signal itemSelected

    anchors.fill: parent

    Loader {
        id: tabActionsLoader

        active: true
        asynchronous: true
        source: Qt.resolvedUrl("../components/TabActions.qml")

        visible: status == Loader.Ready

        onLoaded: flickable.actions = item.actions
    }

    PageBackGround {
        id: background
        size: "Small"
        bgColor: switch (settings.currentTheme) {
                 case "Default":
                     "#4c341a"
                     break
                 case "Ambiance":
                     theme.palette.normal.background
                     break
                 case "SuruDark":
                     theme.palette.normal.background
                     break
                 default:
                     theme.palette.normal.background
                 }
        bgOpacity: switch (settings.currentTheme) {
                   case "Default":
                       0.6
                       break
                   case "Ambiance":
                       1.0
                       break
                   case "SuruDark":
                       1.0
                       break
                   default:
                       0.6
                   }
    }

    Flickable {

        contentHeight: column.childrenRect.height + units.gu(3)
        anchors.fill: parent
        clip: true
        interactive: true

        Column {
            id: column
            width: parent.width

            UbuntuListView {
                id: listView
                model: actions
                interactive: false
                clip: true
                highlightFollowsCurrentItem: true
                highlight: ListViewHighlight {
                }
                highlightMoveDuration: UbuntuAnimation.SnapDuration
                highlightResizeDuration: UbuntuAnimation.SnapDuration

                anchors {
                    right: parent.right
                    left: parent.left
                }

                height: units.gu(29)
                delegate: ListItem {
                    id: listItem
                    enabled: modelData.enabled
                    width: parent.width
                    highlightColor: switch (settings.currentTheme) {
                                    case "Default":
                                        "#2D371300"
                                        break
                                    case "Ambiance":
                                        theme.palette.highlighted.background
                                        break
                                    case "SuruDark":
                                        theme.palette.highlighted.background
                                        break
                                    default:
                                        "#2D371300"
                                    }

                    ListViewHover {
                        id: itemHighlight
                        actionsPosition: "Middle-Right"
                        z: 10
                        alreadyHighlighted: listView.currentIndex === index ? true : false
                        opacity: switch (settings.currentTheme) {
                                 case "Default":
                                     1.0
                                     break
                                 case "Ambiance":
                                     0.5
                                     break
                                 case "SuruDark":
                                     0.5
                                     break
                                 default:
                                     1.0
                                 }
                    }

                    SlotsLayout {
                        anchors.fill: parent

                        mainSlot: Label {
                            text: modelData.text
                            color: switch (settings.currentTheme) {
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
                            font.weight: Font.Normal
                        }

                        Icon {
                            SlotsLayout.position: SlotsLayout.Leading
                            name: modelData.iconName
                            width: units.gu(3)
                            color: switch (settings.currentTheme) {
                                   case "Default":
                                       theme.palette.normal.overlay
                                       break
                                   case "Ambiance":
                                       theme.palette.normal.overlayText
                                       break
                                   case "SuruDark":
                                       theme.palette.normal.overlayText
                                       break
                                   default:
                                       theme.palette.normal.overlay
                                   }
                        }
                    }

                    onClicked: {
                        modelData.trigger()
                        listView.currentIndex = index
                        itemSelected()
                    }
                }
            }

            ListItemOld.ThinDivider {
                visible: sortFilterLoader.active
                height: units.gu(0.5)
            }

            Loader {
                id: sortFilterLoader
                active: primaryLeftPage.isMultiColumn
                        && flickable.currentTab < 3 ? true : false
                sourceComponent: componentSortFilter
                asynchronous: true
                visible: status == Loader.Ready
                anchors {
                    left: parent.left
                    right: parent.right
                }
            }

            Component {
                id: componentSortFilter
                ExpandableListItem {
                    id: sortFilterExpandable
                    titleText.text: i18n.tr("Sort and Filter")
                    titleText.textSize: Label.Medium
                    titleText.font.weight: Font.Normal
                    subText.textSize: Label.Small
                    titleText.color: switch (settings.currentTheme) {
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
                    subText.color: switch (settings.currentTheme) {
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
                    delegateChild: Loader {
                        /*WORKAROUND: Bug where selecting specific shows black when interacted in non-search and switch to search*/
                        sourceComponent: sortFilterComponent
                        asynchronous: true
                        visible: status == Loader.Ready
                    }
                    expansionBottomDivider: false
                    iconName: "sort-listitem"
                    iconColor: switch (settings.currentTheme) {
                               case "Default":
                                   theme.palette.normal.overlay
                                   break
                               case "Ambiance":
                                   theme.palette.normal.overlayText
                                   break
                               case "SuruDark":
                                   theme.palette.normal.overlayText
                                   break
                               default:
                                   theme.palette.normal.overlay
                               }

                    Connections {
                        target: switch (flickable.currentTab) {
                                case 0:
                                    defaultTab
                                    break
                                case 1:
                                    savedTab
                                    break
                                case 2:
                                    historyTab
                                    break
                                default:
                                    defaultTab
                                    break
                                }
                        onSearchActiveChanged: {
                            /*WORKAROUND: Bug where selecting specific shows black when interacted in non-search and switch to search*/
                            sortFilterExpandable.delegateItem.active = false
                            sortFilterExpandable.delegateItem.active = true

                            switch (flickable.currentTab) {
                            case 0:
                                delegateItem.item.initializeValues(defaultTab)
                                break
                            case 1:
                                delegateItem.item.initializeValues(savedTab)
                                break
                            case 2:
                                delegateItem.item.initializeValues(historyTab)
                                break
                            default:
                                break
                            }
                        }
                    }
                }
            }

            Component {
                id: sortFilterComponent

                SortFilterFields {
                    id: sortFilterFields

                    topBottomMargin: units.gu(2)

                    property bool initial: true

                    anchors {
                        left: parent !== null ? parent.left : undefined
                        leftMargin: units.gu(2)
                        right: parent !== null ? parent.right : undefined
                        rightMargin: units.gu(2)
                    }

                    mode: {
                        switch (flickable.currentTab) {
                        case 0:
                            "talaan"
                            break
                        case 1:
                            "saved"
                            break
                        case 2:
                            "history"
                            break
                        default:
                            "talaan"
                            break
                        }
                    }

                    function initializeValues(page) {

                        sortFilterFields.initial = true //stop triggering sort and filter

                        var groupings
                        var filter
                        var order

                        if (page.searchActive) {
                            if (page.searchGroupings !== undefined) {
                                groupings = page.searchGroupings
                            }

                            if (page.searchFilter !== undefined) {
                                filter = page.searchFilter
                            }

                            if (page.searchOrder !== undefined) {
                                order = (page.searchOrder === "normal" ? false : true)
                            }
                        } else {
                            if (page.groupings !== undefined) {
                                groupings = page.groupings
                            }

                            if (page.filter !== undefined) {
                                filter = page.filter
                            }

                            if (page.order !== undefined) {
                                order = (page.order === "normal" ? false : true)
                            }
                        }

                        if (page.groupings !== undefined) {
                            optionSort.selectSpecific(groupings)
                        }

                        if (page.filter !== undefined) {
                            console.log("filter: " + filter)
                            optionFilter.selectSpecific(filter)
                        }

                        if (page.order !== undefined) {
                            checkReverse.checked = (order)
                        }

                        sortFilterFields.initial = false //allow triggering sort and filter
                    }

                    function setSortFilter(page, sort, filter, reverse) {

                        if (page.searchActive) {

                            if (page.searchGroupings !== undefined) {
                                page.searchGroupings = sort
                            }

                            if (page.searchFilter !== undefined) {
                                page.searchFilter = filter
                            }

                            if (page.searchOrder !== undefined) {
                                page.searchOrder = reverse ? "reverse" : "normal"
                            }
                        } else {
                            if (page.groupings !== undefined) {
                                page.groupings = sort
                            }

                            if (page.filter !== undefined) {
                                page.filter = filter
                            }

                            if (page.order !== undefined) {
                                page.order = reverse ? "reverse" : "normal"
                            }
                        }

                        /*commented-out for now. Let's see if there's any bad effect*/
                        page.loadChecklist()
                    }

                    onComponentReadyChanged: {
                        if (componentReady) {

                            //initiate all values
                            switch (flickable.currentTab) {
                            case 0:
                                initializeValues(defaultTab)
                                break
                            case 1:
                                initializeValues(savedTab)
                                break
                            case 2:
                                initializeValues(historyTab)
                                break
                            default:
                                break
                            }
                        }
                    }

                    onFieldTriggered: {

                        var sort = ""
                        var filter = ""
                        var reverse = ""

                        if (sortFilterFields.sortModel.count > 0) {
                            sort = sortFilterFields.sortModel.get(
                                        sortFilterFields.optionSort.selectedIndex).value
                        }

                        if (sortFilterFields.filterModel.count > 0) {
                            filter = sortFilterFields.filterModel.get(
                                        sortFilterFields.optionFilter.selectedIndex).value
                        }

                        reverse = sortFilterFields.checkReverse.checked

                        if (!sortFilterFields.initial) {

                            switch (flickable.currentTab) {
                            case 0:
                                setSortFilter(defaultTab, sort, filter, reverse)
                                break
                            case 1:
                                setSortFilter(savedTab, sort, filter, reverse)
                                break
                            case 2:
                                setSortFilter(historyTab, sort, filter, reverse)
                                break
                            default:
                                break
                            }
                        }
                    }
                }
            }
        }
    }
}
