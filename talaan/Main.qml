import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.Window 2.2
import Qt.labs.settings 1.0
import "components"
import "ui"
import "library/MetaData.js" as MetaData
import "library/DataProcess.js" as DataProcess
import "library"


MainView {
    id: mainView
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "Talaan"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "talaan.kugiigi"

    width: Screen.desktopAvailableWidth < units.gu(130) ? units.gu(50) : units.gu(130)
    height: units.gu(89)

    anchorToKeyboard: true
    theme.name: {
        switch (settings.currentTheme) {
        case "Default":
            "Ubuntu.Components.Themes.SuruDark"
            break
        case "Ambiance":
            "Ubuntu.Components.Themes.Ambiance"
            break
        case "SuruDark":
            "Ubuntu.Components.Themes.SuruDark"
            break
        default:
            "Ubuntu.Components.Themes.SuruDark"
        }
    }

    property string current_version: "2.30"
    property alias listItems: listItems
    property alias notification: notificationLoader.item
    property alias mainLayout: mainAdaptLayout
    property alias navigationPage: navigationPageLoader.item
    property bool enableBottomMenu: settings.bottomMenuType !== "None"
                                    && mainAdaptLayout.columns === 1 ? true : false
    property list<RadialAction> bottomActions
    property alias bottomMenuActions: bottomMenuActions.actions

    property alias defaultTab: defaultTabLoader.item
    property alias savedTab: savedTabLoader.item
    property alias historyTab: historyTabLoader.item
    property alias settingsTab: settingsTabLoader.item
    property alias remindersPage: remindersPageLoader.item
    property alias itemsPage: itemsPageLoader.item
    property alias navigationPanel: panelLoader.item
    property alias navigationflickable: navigationflickableLoader.item

    Component.onCompleted: {
        //Meta data processing
        MetaData.createInitialData()
        DataProcess.cleanSaved()
        DataProcess.cleanNormalLists()
        MetaData.executeUserVersion1()
        MetaData.executeUserVersion2()
        MetaData.executeUserVersion3()

        //        mainAdaptLayout.switchTab(0)
        //        navigationflickableLoader.active = true
        defaultTabLoader.active = true
        //        panelLoader.active = true
        //        savedTabLoader.active = true
        //        historyTabLoader.active = true
    }

    Keys.onPressed: {
        switch (true) {
        case primaryLeftPage.isMultiColumn:
            switch (true) {
            case event.key == Qt.Key_S && event.modifiers == Qt.ControlModifier:
                //event.accepted = true;
                navigationPageLoader.item.header.startSearch()
                break
            }
            //break /*commented out to allow other keys to process*/
        case itemsPage && itemsPage.visible:
            switch (true) {
            case event.key == Qt.Key_H && event.modifiers == Qt.ControlModifier:
                //event.accepted = true;
                itemsPage.switchSection()
                break
            }
            break
        }
    }

    Item {
        id: settings

        property bool listItemClickable: true
        property bool listItemFontSize: false
        property bool listItemHideChecked: false
        property bool panelSplit: true
        property bool categoryColors: false
        property string radialBottomMenu: "Always" //Old
        property string bottomMenuHint: "Always"
        property string bottomMenuType: "Radial"
        property string bottomMenuAnchor: "Right"
        property string currentTheme: "Default"

        Settings {
            property alias listItemClickable: settings.listItemClickable
            property alias listItemFontSize: settings.listItemFontSize
            property alias listItemHideChecked: settings.listItemHideChecked
            property alias panelSplit: settings.panelSplit
            property alias categoryColors: settings.categoryColors
            property alias radialBottomMenu: settings.radialBottomMenu
            property alias bottomMenuHint: settings.bottomMenuHint
            property alias bottomMenuType: settings.bottomMenuType
            property alias bottomMenuAnchor: settings.bottomMenuAnchor
            property alias currentTheme: settings.currentTheme
        }
    }

    ListModels {
        id: listItems
        visible: false
    }

    PageBackGround {
        id: pageBackground
        noImage: switch (settings.currentTheme) {
                 case "Default":
                     false
                     break
                 case "Ambiance":
                     true
                     break
                 case "SuruDark":
                     true
                     break
                 default:
                     false
                 }
        bgColor: switch (settings.currentTheme) {
                 case "Default":
                     "#371300"
                     break
                 case "Ambiance":
                     theme.palette.normal.background
                     break
                 case "SuruDark":
                     theme.palette.normal.background
                     break
                 default:
                     "#371300"
                 }
        bgOpacity: switch (settings.currentTheme) {
                   case "Default":
                       0.4
                       break
                   case "Ambiance":
                       1.0
                       break
                   case "SuruDark":
                       1.0
                       break
                   default:
                       0.4
                   }
    }

    Loader {
        id: notificationLoader

        z: 100

        asynchronous: true
        visible: status == Loader.Ready

        anchors {
            top: parent.top
            //bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            margins: units.gu(2)
        }

        Component.onCompleted: {
            setSource(Qt.resolvedUrl("../components/NotificationBubble.qml"), {
                          bubbleOffset: units.gu(8)
                      })
        }
    }

    Loader {
        id: panelLoader

        active: false
        asynchronous: true
        source: Qt.resolvedUrl("../components/NavigationPanel.qml")

        visible: status == Loader.Ready
        z: 100
        width: parent.width >= units.gu(60) ? units.gu(30) : parent.width * 0.7
        anchors {
            left: parent.left
            topMargin: mainAdaptLayout.primaryPage.header.extension
                       !== null ? mainAdaptLayout.primaryPage.header.height
                                  - mainAdaptLayout.primaryPage.header.extension.height : mainAdaptLayout.primaryPage.header.height
            top: parent.top
            bottom: parent.bottom
        }

        onLoaded: item.navigationFlickable = Qt.binding(function () {
            return primaryLeftPage.isMultiColumn ? null : navigationflickable
        })
    }

    ActionList {
        id: bottomMenuActions

        actions: [
            RadialAction {
                iconName: "note"
                label: i18n.tr("Lists")
                iconColor: "white"
                backgroundColor: UbuntuColors.blue
                onTriggered: {
                    mainLayout.switchTab(0)
                }
            },
            RadialAction {
                iconName: "history"
                label: i18n.tr("History")
                iconColor: "white"
                backgroundColor: UbuntuColors.red
                onTriggered: {
                    mainLayout.switchTab(2)
                    console.log("history")
                }
            },
            RadialAction {
                iconName: "bookmark"
                label: i18n.tr("Saved")
                iconColor: "white"
                backgroundColor: UbuntuColors.midAubergine
                onTriggered: {
                    mainLayout.switchTab(1)
                }
            },
            RadialAction {
                label: i18n.tr("Settings")
                iconName: "settings"
                iconColor: "white"
                backgroundColor: UbuntuColors.coolGrey
                onTriggered: {
                    mainLayout.switchTab(3)
                }
            },
            RadialAction {
                iconName: "cancel"
                iconColor: UbuntuColors.coolGrey
                hide: true
            },
            RadialAction {
                iconName: "cancel"
                iconColor: UbuntuColors.coolGrey
                hide: true
            }
        ]
    }

    AdaptivePageLayout {
        id: mainAdaptLayout

        property bool multiColumn: columns > 1
        property bool noSelected: true

        layouts: [
            PageColumnsLayout {
                when: width > units.gu(80) && width < units.gu(
                          130) // && !portrait
                // column #0
                PageColumn {
                    minimumWidth: units.gu(40)
                    maximumWidth: units.gu(60)
                    preferredWidth: width > units.gu(
                                        90) ? units.gu(45) : units.gu(40)
                }
                // column #1
                PageColumn {
                    fillWidth: true
                }
            },
            PageColumnsLayout {
                when: width >= units.gu(130) // && !portrait
                // column #0
                PageColumn {
                    minimumWidth: units.gu(65)
                    maximumWidth: units.gu(110)
                    preferredWidth: units.gu(70)
                }
                // column #1
                PageColumn {
                    fillWidth: true
                }
                // column #2
                /*dummy column as a workaround since AdaptivePageLayout does not adjust when both layouts have th same number of columns*/
                //                PageColumn {
                //                    minimumWidth: units.gu(0)
                //                    maximumWidth: units.gu(1)
                //                    preferredWidth: units.gu(0)
                //                    //fillWidth: true
                //                }
            }
        ]
        anchors.fill: parent
        primaryPage: primaryLeftPage

        property int selectedTabIndex: 100

        Loader {
            id: itemsPageLoader

            property var pageProperties

            active: true

            asynchronous: true
            source: Qt.resolvedUrl("../ui/ItemsPage.qml")

            visible: status == Loader.Ready

//            onLoaded: {
//                showItemsPage(pageProperties)
//            }

            function showItemsPage(properties) {
//                if (!active) {
//                    pageProperties = properties
//                    active = true
//                } else {
                    mainLayout.selectItemFromMain(mainLayout.primaryPage, item,
                                                  properties)
//                }
            }
        }

        NoSelectedPage {
            id: noSelectedPage
        }

        Loader {
            id: navigationflickableLoader

            active: false
            asynchronous: true
            source: Qt.resolvedUrl("../components/NavigationFlickable.qml")

            visible: status == Loader.Ready

            onLoaded: {
                panelLoader.active = true;
            }
        }

        function switchTab(index) {
            selectedTabIndex = index
            if (navigationflickable) {
                navigationflickable.currentTab = index
            }
            clearitemsPage()
        }

        function checkNoSelected() {
            if (multiColumn) {
                mainAdaptLayout.clearitemsPage()
                if (noSelected) {
                    switch (selectedTabIndex) {
                    case 0:

                    case 1:

                    case 2:
                        primaryPage.pageStack.addPageToNextColumn(
                                    primaryPage, noSelectedPage, {
                                        iconName: "stock_note",
                                        title: i18n.tr("No list selected"),
                                        subTitle: i18n.tr(
                                                      "Select a list from the left column")
                                    })
                        break
                    case 3:
                        primaryPage.pageStack.addPageToNextColumn(
                                    primaryPage, noSelectedPage, {
                                        iconName: "settings",
                                        title: i18n.tr("No list selected"),
                                        subTitle: i18n.tr(
                                                      "Select an item from the List, Saved or History tab")
                                    })
                        break
                    }
                }
            } else {
                if (noSelected) {
                    removePages(primaryPage)
                }
            }
        }

        function resetCurrentIndex() {
            defaultTab.mainListView.currentIndex = -1
            savedTab.mainListView.currentIndex = -1
            historyTab.mainListView.currentIndex = -1
            settingsTab.mainListView.currentIndex = -1
        }

        function selectItemFromMain(pageSource, page, properties) {
            noSelected = false
            mainAdaptLayout.clearitemsPage()

            var incubator = primaryPage.pageStack.addPageToNextColumn(
                        pageSource, page, properties)
            if (incubator && incubator.status == Component.Loading) {
                incubator.onStatusChanged = function (status) {
                    if (status == Component.Ready) {
                        // connect page's destruction to decrement model
                        incubator.object.Component.destruction.connect(
                                    function () {
                                        if (!multiColumn) {
                                            noSelected = true
                                        }
                                    })
                    }
                }
            }

            if (page.mainListView !== undefined) {
                page.mainListView.positionViewAtBeginning()
            }
        }

        function showThirdColumn(pageSource, page, properties) {
            var incubator = primaryPage.pageStack.addPageToNextColumn(
                        pageSource, page, properties)
            if (incubator && incubator.status == Component.Loading) {
                incubator.onStatusChanged = function (status) {
                    if (status == Component.Ready) {
                        // connect page's destruction to decrement model
                        incubator.object.Component.destruction.connect(
                                    function () {
                                        if (!multiColumn) {
                                            noSelected = true
                                        }
                                    })
                    }
                }
            }
        }

        function switchNoSelected(boolFlag) {
            noSelected = boolFlag
            checkNoSelected()
        }

        function clearitemsPage() {
            //console.log("items page cleared")
            if (itemsPageLoader.item) {
                itemsPage.currentID = ""
                itemsPage.currentChecklist = ""
                itemsPage.currentCategory = ""
                itemsPage.currentDescr = ""
                itemsPage.currentStatus = ""
                itemsPage.currentTargetDate = ""
                itemsPage.currentTotal = 0
                itemsPage.totalChecked = 0
                itemsPage.searchText = ""
            }
        }

        onColumnsChanged: {
            multiColumn = columns > 1
            if (!multiColumn && noSelected) {
                console.log("removed the noselected")
                removePages(noSelectedPage)
            } else if (noSelected) {
                checkNoSelected()
            }
        }

        onSelectedTabIndexChanged: {
            switch (selectedTabIndex) {
            case 0:
                removePages()
                defaultTab.mainListView.positionViewAtBeginning()
                primaryLeftPage.setPage(defaultTab)
                switchNoSelected(true)
                break
            case 1:
                removePages()
                savedTab.mainListView.positionViewAtBeginning()
                primaryLeftPage.setPage(savedTab)
                switchNoSelected(true)
                break
            case 2:
                removePages()
                historyTab.mainListView.positionViewAtBeginning()
                primaryLeftPage.setPage(historyTab)
                switchNoSelected(true)
                break
            case 3:
                removePages()
                settingsTab.mainListView.positionViewAtBeginning()
                primaryLeftPage.setPage(settingsTab)
                switchNoSelected(true)
                break
            }
        }

        PrimaryPage {
            id: primaryLeftPage
        }

        Loader {
            id: defaultTabLoader

            active: false
            asynchronous: true
            source: Qt.resolvedUrl("../ui/DefaultTab.qml")

            visible: status == Loader.Ready

            onLoaded: {
                mainAdaptLayout.switchTab(0)
                navigationflickableLoader.active = true
                savedTabLoader.active = true
                historyTabLoader.active = true
                settingsTabLoader.active = true
            }
        }

        Loader {
            id: savedTabLoader

            active: false
            asynchronous: true
            source: Qt.resolvedUrl("../ui/SavedTab.qml")

            visible: status == Loader.Ready
        }

        Loader {
            id: historyTabLoader

            active: false
            asynchronous: true
            source: Qt.resolvedUrl("../ui/HistoryTab.qml")

            visible: status == Loader.Ready
        }

        Loader {
            id: settingsTabLoader

            active: false
            asynchronous: true
            source: Qt.resolvedUrl("../ui/SettingsTab.qml")

            visible: status == Loader.Ready
        }

        Loader {
            id: navigationPageLoader

            active: primaryLeftPage.isMultiColumn ? true : false
            source: Qt.resolvedUrl("../ui/NavigationSplitPage.qml")
            asynchronous: true
            visible: status == Loader.Ready

            onLoaded: {
                item.navigationFlickable = Qt.binding(function () {
                    return primaryLeftPage.isMultiColumn ? navigationflickable : null
                })
                primaryLeftPage.adaptLayout.primaryPage = item
                primaryLeftPage.adaptLayout.switchToTwoColumn()
            }
        }

        Loader {
            id: remindersPageLoader

            property string pagemode: "all"

            active: false
            asynchronous: true
            source: Qt.resolvedUrl("../ui/RemindersPage.qml")

            visible: status == Loader.Ready

            onLoaded: {
                showRemindersPage(pagemode)
            }

            function showRemindersPage(mode) {
                if (!active) {
                    pagemode = mode
                    active = true
                } else {
                    if (mode === "all") {
                        primaryLeftPage.adaptLayout.addPageToCurrentColumn(
                                    primaryLeftPage.adaptLayout.primaryPage,
                                    remindersPage, {
                                        pagemode: mode
                                    })
                        mainView.mainLayout.switchNoSelected(true)
                    } else {

                        mainView.mainLayout.addPageToNextColumn(itemsPage,
                                                                remindersPage, {
                                                                    pagemode: mode
                                                                })
                    }
                }
            }
        }

        //WORKAROUND: Dummy Alarm component to avoid issues on apparmor denial
        Alarm {
            id: dummyAlarm
        }
    }

    //    Connections {
    //        id: keyboard
    //        target: Qt.inputMethod
    //    }
}
