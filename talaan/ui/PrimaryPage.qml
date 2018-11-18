import QtQuick 2.4
import Ubuntu.Components 1.3

Page {
    id: mainPage

    header: PageHeader {
        visible: false
        extension: mainAdaptLayout.primaryPage
                   !== null ? mainAdaptLayout.primaryPage.header.extension
                              !== null ? dummySections : null : null
    }

    property alias adaptLayout: mainAdaptLayout
    property bool isMultiColumn: mainAdaptLayout.columns === 2

    function setPage(page) {
        mainAdaptLayout.changeLayout()
    }

    Sections {
        id: dummySections
    }

    ActivityIndicator {
        id: activity
        anchors.centerIn: parent
        visible: running

        running: mainAdaptLayout.primaryPage === null || mainView.itemsPage === null
    }

    onIsMultiColumnChanged: {
        if(isMultiColumn){
            mainAdaptLayout.primaryPage = null
        }else{
            if(mainAdaptLayout.primaryPage.searchActive){
                /*WORKAROUND: Delay setting searchMode to true to let searchHeader reposition properly*/
                workerWait.sendMessage({
                                           duration: 100
                                       })
            }
        }
    }

    WorkerScript {
        id: workerWait
        source: "../library/wait.js"

        onMessage: mainAdaptLayout.primaryPage.searchMode = true
    }

    AdaptivePageLayout {
        id: mainAdaptLayout
        property bool multiColumn: columns > 1

        function changeLayout() {
            if (columns === 2) {
                switchToTwoColumn()
            } else {
                switchToOneColumn()
            }
        }

        function switchToOneColumn() {
            switch (mainLayout.selectedTabIndex) {
            case 0:
                primaryPage = defaultTab
                break
            case 1:
                primaryPage = savedTab
                break
            case 2:
                primaryPage = historyTab
                break
            case 3:
                primaryPage = settingsTab
                break
            }
        }

        function switchToTwoColumn() {

            switch (mainLayout.selectedTabIndex) {
            case 0:
                addPageToNextColumn(primaryPage, defaultTab, "")
                break
            case 1:
                addPageToNextColumn(primaryPage, savedTab, "")
                break
            case 2:
                addPageToNextColumn(primaryPage, historyTab, "")
                break
            case 3:
                addPageToNextColumn(primaryPage, settingsTab, "")
                break
            }
        }

        layouts: [
            PageColumnsLayout {
                when: width > units.gu(60) && mainLayout.width >= units.gu(130)
                // column #0
                PageColumn {
                    minimumWidth: units.gu(20)
                    maximumWidth: units.gu(50)
                    preferredWidth: units.gu(25)
                }
                // column #1
                PageColumn {
                    fillWidth: true
                }
            }
        ]
        anchors.fill: parent

        onColumnsChanged: {
            if (columns === 2) {
                if(panelLoader.status === Loader.Ready){
                    navigationPanel.close()
                }
            } else {
                switchToOneColumn()
            }
        }

        primaryPage: null
    }
}
