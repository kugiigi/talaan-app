import QtQuick 2.4
import Ubuntu.Components 1.3
//import Ubuntu.Layouts 1.0
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Components.Popups 1.0
import "../library/ProcessFunc.js" as Process

PageHeader {
    id: mainHeader

    property string mode
    property string sectionMode
    property bool searchActive: false
    property string searchPlaceHolderText
    //property ListModel selectionModel
    property alias selectedSection: searchSections.selectedSection
    property bool noCancel: false
    signal cancel
    signal search(string searchText, string searchCondition)

    onCancel: {
        stopSearch()
    }

    function startSearch() {
        if (textLoader.active) {
            textLoader.item.forceActiveFocus()
        }
        if (dateLoader.active) {
            dateLoader.item.actionCondition.trigger()
        }

        if (selectionLoader.active) {
            selectionLoader.item.actionCondition.trigger()
        }
    }

    function stopSearch() {

        //        console.log("stopSearch")
        searchActive = false

        if (textLoader.item !== null) {
            if (textLoader.item.text !== "") {
                search("", "")
            }

            textLoader.item.text = ""
            textLoader.item.focus = false
        }

        if (selectionLoader.item !== null) {
            if (selectionLoader.item.selectionLabel.text !== i18n.tr(
                        "Select a Category")) {
                search("", "")
            }
            selectionLoader.item.selectionLabel.text = i18n.tr(
                        "Select a Category")
        }

        if (dateLoader.item !== null) {
            if (dateLoader.item.conditionLabel.text !== "-") {
                search("", "")
            }
            dateLoader.item.conditionLabel.text = "-"
            dateLoader.item.conditionLabel.condition = ""
            dateLoader.item.targetDtLabel.text = Qt.formatDateTime(
                        dateLoader.item.targetDtLabel.date, "MMMM d yyyy")
        }
    }

    StyleHints {
        backgroundColor: switch (settings.currentTheme) {
                         case "Default":
                             "#3D1400"
                             break
                         case "Ambiance":
                             theme.palette.normal.background
                             break
                         case "SuruDark":
                             theme.palette.normal.foreground
                             break
                         default:
                             "#3D1400"
                         }
        dividerColor: UbuntuColors.slate
    }

    trailingActionBar {
        anchors.rightMargin: 0
        delegate: TextualButtonStyle {
        }
        actions: Action {
            id: actionCancel
            text: i18n.tr("Cancel")
            visible: noCancel ? false : true
            onTriggered: {
                cancel()
            }
        }
    }

    extension: SearchSections {
        id: searchSections
        mode: sectionMode

        onSelectedSectionChanged: {

            stopSearch()

            switch (selectedSection) {
            case "default":
                mainHeader.mode = "text"
                break
            case "category":
                mainHeader.mode = "selection"
                break
            case "creation_date":
                mainHeader.mode = "date"
                break
            case "target_date":
                mainHeader.mode = "date"
                break
            case "completion_date":
                mainHeader.mode = "date"
                break
            }
        }
    }

    contents: Item {
        id: layouts
        anchors.fill: parent

        ActivityIndicator {
            z: -1
            running: textLoader.active || dateLoader.active
                     || selectionLoader.active ? false : true
            visible: running
            anchors.centerIn: parent
        }

        Loader {
            id: textLoader
            active: mainHeader.mode === "text" ? true : false
            sourceComponent: textComponent
            asynchronous: true
            visible: status == Loader.Ready
            opacity: visible ? 1 : 0
            anchors {
                left: parent.left
                leftMargin: units.gu(1)
                right: parent.right
                verticalCenter: parent.verticalCenter
            }

            Behavior on opacity {
                UbuntuNumberAnimation {
                    easing: UbuntuAnimation.StandardEasing
                    duration: UbuntuAnimation.SnapDuration
                }
            }
        }

        Component {
            id: textComponent
            TextField {
                id: textField
                // Disable predictive text
                inputMethodHints: Qt.ImhNoPredictiveText

                placeholderText: searchPlaceHolderText

                primaryItem: Icon {
                    height: units.gu(2)
                    width: height
                    name: "search"
                }

                Keys.onPressed: {
                    if (event.key == Qt.Key_Escape) {
                        mainHeader.stopSearch()
                    }
                }

                onTextChanged: {
                    if (text === "") {
                        mainHeader.searchActive = false
                    } else {
                        mainHeader.searchActive = true
                        delayTimer.restart()
                    }
                }

                onVisibleChanged: {
                    if (!visible) {


                        //text = ""
                    } else {
                        if (actionCancel.visible) {
                            // Force active focus when this becomes the current PageHead state and
                            // show OSK if appropriate.
                            forceActiveFocus()
                        }
                        //delayTimer.restart()
                    }
                }

                onActiveFocusChanged: {
                    if (activeFocus && actionCancel.visible) {
                        actionCancel.shortcut = "Esc"
                    } else {
                        actionCancel.shortcut = undefined
                    }
                }

                //Timer to delay searching while typing
                Timer {
                    id: delayTimer
                    interval: 500
                    onTriggered: {
                        //console.log("searched: " + textField.text)
                        search(textField.text, "")
                    }
                }
            }
        }

        Loader {
            id: dateLoader
            active: mainHeader.mode === "date" ? true : false
            sourceComponent: dateComponent
            asynchronous: true
            visible: status == Loader.Ready
            anchors.fill: parent
            opacity: visible ? 1 : 0

            Behavior on opacity {
                UbuntuNumberAnimation {
                    easing: UbuntuAnimation.StandardEasing
                    duration: UbuntuAnimation.SnapDuration
                }
            }
        }

        Component {
            id: dateComponent
            Item {

                property alias conditionLabel: conditionLabel
                property alias targetDtLabel: targetDtLabel
                property alias actionCondition: actionCondition

                Label {
                    id: conditionLabel
                    property bool highlighted: false
                    property string condition

                    text: "-" //i18n.tr("On")
                    height: units.gu(3)
                    width: parent.width * 0.3
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    fontSizeMode: Text.HorizontalFit
                    minimumPixelSize: units.gu(2)
                    elide: Text.ElideRight
                    anchors {
                        left: parent.left
                        leftMargin: units.gu(1)
                        verticalCenter: parent.verticalCenter
                    }

                    //                    onVisibleChanged: {
                    //                        if (visible) {
                    //                            delayTimerDate.restart()
                    //                        }
                    //                    }
                    onTextChanged: {
                        if (text === "-") {
                            mainHeader.searchActive = false
                        } else {
                            mainHeader.searchActive = true
                            delayTimerDate.restart()
                        }
                    }

                    Rectangle {
                        z: -1
                        anchors.centerIn: parent
                        height: parent.height + units.gu(1)
                        width: parent.width + units.gu(1)
                        radius: units.gu(1)
                        color: conditionLabel.highlighted ? Theme.palette.normal.selection : theme.palette.normal.overlay
                    }
                    Action {
                        id: actionCondition
                        onTriggered: {
                            conditionLabel.highlighted = true
                            var popup = PopupUtils.open(componentPopover,
                                                        conditionLabel)
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        z: 1
                        onClicked: {
                            actionCondition.trigger()
                        }
                    }
                }
                Component {
                    id: componentPopover
                    ActionSelectionPopover {
                        id: conditionPopover
                        onVisibleChanged: {
                            if (!visible) {
                                conditionLabel.highlighted = false
                            }
                        }

                        target: conditionLabel
                        delegate: ListItem {
                            Label {
                                text: action.text
                                anchors.centerIn: parent
                            }
                        }
                        actions: ActionList {
                            Action {
                                text: i18n.tr("On")
                                onTriggered: {
                                    target.text = text
                                    conditionLabel.condition = "="
                                    PopupUtils.close(conditionPopover)
                                }
                            }
                            Action {
                                text: i18n.tr("Later than")
                                onTriggered: {
                                    target.text = text
                                    conditionLabel.condition = ">"
                                    PopupUtils.close(conditionPopover)
                                }
                            }
                            Action {
                                text: i18n.tr("Earlier than")
                                onTriggered: {
                                    target.text = text
                                    conditionLabel.condition = "<"
                                    PopupUtils.close(conditionPopover)
                                }
                            }
                        }
                    }
                }

                Label {
                    id: targetDtLabel
                    property date date: new Date()
                    property bool highlighted: false

                    anchors {
                        left: conditionLabel.right
                        leftMargin: units.gu(2)
                        right: parent.right
                        rightMargin: units.gu(1)
                        verticalCenter: parent.verticalCenter
                    }

                    onDateChanged: {
                        date.setHours(0, 0, 0, 0)
                    }

                    onTextChanged: {
                        if (conditionLabel.text !== "-") {
                            delayTimerDate.restart()
                        }
                    }

                    height: units.gu(3)
                    text: Qt.formatDateTime(date, "MMMM d yyyy")
                    color: Theme.palette.normal.foregroundText
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    fontSizeMode: Text.HorizontalFit
                    minimumPixelSize: units.gu(2)
                    elide: Text.ElideRight

                    Rectangle {
                        z: -1
                        anchors.centerIn: parent
                        height: parent.height + units.gu(1)
                        width: parent.width + units.gu(1)
                        radius: units.gu(1)
                        color: targetDtLabel.highlighted ? Theme.palette.normal.selection : theme.palette.normal.overlay
                    }

                    MouseArea {
                        anchors.fill: parent
                        z: 1
                        onClicked: {
                            var datePicker
                            var minimumDate = new Date()
                            minimumDate.setYear(1900)
                            targetDtLabel.highlighted = true
                            datePicker = PickerPanel.openDatePicker(
                                        targetDtLabel, "date",
                                        "Years|Months|Days")
                            datePicker.picker.minimum = minimumDate

                            var datePickerClosed = function () {
                                targetDtLabel.highlighted = false
                            }

                            datePicker.closed.connect(datePickerClosed)
                        }
                    }
                }
                //Timer to delay searching
                Timer {
                    id: delayTimerDate
                    interval: 400
                    onTriggered: {

                        //console.log("Searched")
                        search(Process.dateFormat(0, targetDtLabel.date),
                               conditionLabel.condition)
                    }
                }
            }
        }

        Loader {
            id: selectionLoader
            active: mainHeader.mode === "selection" ? true : false
            sourceComponent: selectionComponent
            asynchronous: true
            visible: status == Loader.Ready
            anchors.fill: parent

            opacity: visible ? 1 : 0

            Behavior on opacity {
                UbuntuNumberAnimation {
                    easing: UbuntuAnimation.StandardEasing
                    duration: UbuntuAnimation.SnapDuration
                }
            }
        }

        Component {
            id: selectionComponent
            Item {

                property alias selectionLabel: selectionLabel
                property alias actionCondition: actionCondition

                Label {
                    id: selectionLabel
                    property bool highlighted: false

                    anchors {
                        left: parent.left
                        leftMargin: units.gu(2)
                        right: parent.right
                        rightMargin: units.gu(2)
                        verticalCenter: parent.verticalCenter
                    }

                    height: units.gu(3)
                    text: i18n.tr("Select a Category")
                    color: Theme.palette.normal.foregroundText
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    fontSizeMode: Text.HorizontalFit
                    minimumPixelSize: units.gu(2)
                    elide: Text.ElideRight

                    onTextChanged: {
                        if (text === i18n.tr("Select a Category")) {
                            mainHeader.searchActive = false
                        } else {
                            mainHeader.searchActive = true
                            delayTimerSelection.restart()
                        }
                    }

                    //                    onVisibleChanged: {
                    //                        if (visible) {
                    //                            delayTimerSelection.restart()
                    //                        }
                    //                    }
                    Rectangle {
                        z: -1
                        anchors.centerIn: parent
                        height: parent.height + units.gu(1)
                        width: parent.width + units.gu(1)
                        radius: units.gu(1)
                        color: selectionLabel.highlighted ? Theme.palette.normal.selection : theme.palette.normal.overlay
                    }

                    Action {
                        id: actionCondition
                        onTriggered: {
                            if (mainView.listItems.modelCategories.count === 0) {
                                mainView.listItems.modelCategories.getCategories()
                            }

                            selectionLabel.highlighted = true

                            var popup = PopupUtils.open(
                                        selectionPopoverComponent,
                                        selectionLabel)
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        z: 1
                        onClicked: {
                            actionCondition.trigger()
                        }
                    }
                }

                Component {
                    id: selectionPopoverComponent
                    Popover {
                        id: selectionPopover

                        onVisibleChanged: {
                            if (!visible) {
                                selectionLabel.highlighted = false
                            }
                        }

                        UbuntuListView {
                            id: selectionListView
                            height: units.gu(20)
                            //width: units.gu(20)
                            interactive: true
                            clip: true
                            anchors {
                                left: parent.left
                                top: parent.top
                                right: parent.right
                            }
                            model: mainView.listItems.modelCategories //selectionModel
                            currentIndex: -1
                            delegate: ListItem {
                                id: listItem
                                color: "transparent"
                                action: Action {
                                    onTriggered: {
                                        selectionLabel.text = selectedLabel.text
                                        PopupUtils.close(selectionPopover)
                                    }
                                }

                                Label {
                                    id: selectedLabel
                                    text: listItem.ListView.view.model.get(
                                              index).categoryname
                                    anchors.centerIn: parent
                                }
                            }
                        }
                    }
                }
                //Timer to delay searching
                Timer {
                    id: delayTimerSelection
                    interval: 400
                    onTriggered: {
                        //console.log("Searched")
                        if (selectionLabel.text !== i18n.tr(
                                    "Select a Category")) {
                            search(selectionLabel.text, "")
                        } else {
                            search("", "")
                        }
                    }
                }
            }
        }
    }
}
