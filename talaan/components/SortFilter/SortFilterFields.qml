import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Themes.Ambiance 1.3

Item {
    id: root

    property string mode: "talaan"

    property alias sortModel: sortModel
    property alias filterModel: filterModel
    property alias optionSort: optionSort
    property alias optionFilter: optionFilter
    property alias checkReverse: checkReverse
    property bool sortReady: false
    property bool filterReady: false
    property bool componentReady: sortReady && filterReady ? true : false
    property real topBottomMargin: 0

    signal fieldTriggered

    height: fieldsColumn.height + (topBottomMargin * 2)

    onModeChanged: {
        sortModel.initialize()
        filterModel.initialize()
    }

    ListModel {
        id: sortModel

        Component.onCompleted: {
            initialize()
        }

        function initialize() {

            sortModel.clear()

            root.sortReady = false

            switch (root.mode) {
            case "talaan":
                sortModel.append({
                                     name: i18n.tr("By Name (A-Z)"),
                                     value: "name"
                                 })
                sortModel.append({
                                     name: i18n.tr("By Category (A-Z)"),
                                     value: "category"
                                 })
                sortModel.append({
                                     name: i18n.tr(
                                               "By Creation Date (Latest First)"),
                                     value: "creation_date"
                                 })
                sortModel.append({
                                     name: i18n.tr(
                                               "By Target Date (Latest First)"),
                                     value: "target_date"
                                 })
                break
            case "saved":
                sortModel.append({
                                     name: i18n.tr("By Name (A-Z)"),
                                     value: "name"
                                 })
                sortModel.append({
                                     name: i18n.tr("By Category (A-Z)"),
                                     value: "category"
                                 })
                sortModel.append({
                                     name: i18n.tr(
                                               "By Creation Date (Latest First)"),
                                     value: "creation_date"
                                 })
                break
            case "history":
                sortModel.append({
                                     name: i18n.tr("By Name (A-Z)"),
                                     value: "name"
                                 })
                sortModel.append({
                                     name: i18n.tr(
                                               "By Completion Date (Latest First)"),
                                     value: "completion_date"
                                 })
                sortModel.append({
                                     name: i18n.tr("By Category (A-Z)"),
                                     value: "category"
                                 })
                sortModel.append({
                                     name: i18n.tr(
                                               "By Target Date (Latest First)"),
                                     value: "target_date"
                                 })
                break
            }

            root.sortReady = true
        }
    }

    ListModel {
        id: filterModel

        Component.onCompleted: {
            initialize()
        }

        function initialize() {

            filterModel.clear()

            root.filterReady = false

            switch (root.mode) {
            case "talaan":
                filterModel.append({
                                       name: i18n.tr("All"),
                                       value: "all"
                                   })
                filterModel.append({
                                       name: i18n.tr("Normal Lists Only"),
                                       value: "normal"
                                   })
                filterModel.append({
                                       name: i18n.tr("Checklists Only"),
                                       value: "checklist"
                                   })
                break
            }
            root.filterReady = true
        }
    }

    Column {
        id: fieldsColumn
        spacing: units.gu(2)

        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: root.verticalCenter
        }

        OptionSelector {
            id: optionSort

            containerHeight: itemHeight * 3
            delegate: optionSortDelegate
            model: sortModel


            anchors {
                left: parent.left
                right: parent.right
            }

            onSelectedIndexChanged: {
                root.fieldTriggered()
            }

            onCurrentlyExpandedChanged: {
                optionFilter.currentlyExpanded = false
            }

            function selectSpecific(selectedSort) {
                if (model.count !== 0) {
                    var intCurCat = -1
                    var i = 0
                    while (selectedSort !== model.get(i).value
                           && i != model.count - 1) {
                        i++
                    }
                    intCurCat = i
                    selectedIndex = intCurCat
                    currentlyExpanded = false
                }
            }
        }
        Component {
            id: optionSortDelegate
            OptionSelectorDelegate {
                text: name
            }
        }

        OptionSelector {
            id: optionFilter
            //text: i18n.tr("Filter")
            visible: filterModel.count !== 0 ? true : false
            containerHeight: itemHeight * 3
            delegate: optionFilterDelegate
            model: filterModel

            anchors {
                left: parent.left
                right: parent.right
            }

            onSelectedIndexChanged: {
                root.fieldTriggered()
            }

            onCurrentlyExpandedChanged: {
                optionSort.currentlyExpanded = false
            }
            function selectSpecific(selectedSort) {
                if (model.count !== 0) {
                    var intCurCat = -1
                    var i = 0
                    while (selectedSort !== model.get(i).value
                           && i != model.count - 1) {
                        i++
                    }
                    intCurCat = i

                    selectedIndex = intCurCat

                    currentlyExpanded = false
                }
            }
        }
        Component {
            id: optionFilterDelegate
            OptionSelectorDelegate {
                text: name
            }
        }

        Row {
            id: rowOrder
            spacing: units.gu(1)

            CheckBox {
                id: checkReverse
                checked: false
                onCheckedChanged: root.fieldTriggered()
            }
            Label {
                text: i18n.tr("Reverse Order")
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        checkReverse.checked = !checkReverse.checked
                        root.fieldTriggered()
                    }
                }
            }
        }
    }
}
