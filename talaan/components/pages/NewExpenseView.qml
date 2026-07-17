import QtQuick 2.12
import Lomiri.Components 1.3 as UT
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "newexpenseview"
import ".." as Components
import "../../common" as Common
import "../../common/gestures" as Gestures
import "../../library/functions.js" as Functions

FocusScope {
    id: newExpenseView

    readonly property bool resultsIsEmpty: quickListGridView.model.count == 0
                                                    && historyGridView.model.count == 0 && !searchDelay.running
    readonly property bool contextActionsShown: (resultsIsEmpty || internal.forceContextActions) && searchText !== ""
    readonly property bool isGridDisplay: displayType == QuickListGridView.GridType.Rectangle
    readonly property bool isOpen: internal.isOpen
    readonly property bool isEditMode: internal.currentExpenseID > -1 && entryMode
    readonly property bool animating: showAnimation.running
    readonly property bool hasTravelData: internal.expenseData.travelData.rate > 0 && internal.expenseData.travelData.value > 0
    readonly property bool processTravelData: hasTravelData || (isTravelMode && !isEditMode)

    property string currentHomeCurrency
    property string currentTravelCurrency
    property real currentExchangeRate
    property alias view: mainFlickable
    property alias searchText: searchField.text
    property bool isColoredText: false
    property bool isTravelMode: false
    property bool entryMode: false
    property bool searchMode: false
    property real dragDistance: 0
    property bool isWideLayout: false
    property int displayType: QuickListGridView.GridType.Rectangle

    focus: isOpen
    opacity: isOpen || dragDistance > 0 || animating ? 1 : 0
    visible: opacity > 0

    QtObject {
        id: internal

        readonly property bool tall: newExpenseView.height >= units.gu(80)
        readonly property real partialShowY: newExpenseView.height / 3

        property bool isOpen: false
        property bool partiallyShown: false
        property bool forceContextActions: false
        property Components.ExpenseData expenseData: expenseDataObj
        property int currentExpenseID: expenseData.expenseID

        function selectFirstItem() {
            if (contextActionsListView.visible) {
                contextActionsListView.currentIndex = 0
                contextActionsListView.currentItem.clicked()
                return
            }

            if (quickListGridView.visible) {
                let _firstItem = quickListGridView.itemAt(0, 0)
                _firstItem.clicked()
                return
            }

            if (historyGridView.visible) {
                let _firstItem = historyGridView.itemAt(0, 0)
                _firstItem.clicked()
                return
            }
        }

        function checkRequiredFields(asQuickOnly = false) {
            if (nameField.text.trim() == "") {
                nameField.forceActiveFocus()
                return false
            }

            if (valueField.text.trim() == "" && !asQuickOnly) {
                valueField.forceActiveFocus()
                return false
            }

            categoryField.accepted()
            if (categoryField.currentIndex == -1) {
                categoryField.forceActiveFocus()
                return false
            }

            return true
        }

        function focusRelevantField() {
            if (nameField.text.trim() == "") {
                nameField.forceActiveFocus()
                return
            }

            categoryField.forceActiveFocus()
        }

        function saveAsQuick() {
            /*Commits the OSK*/
            mainView.keyboard.commit()

            if (!checkRequiredFields(true)) {
                mainView.tooltip.display(i18n.tr("Please fill required fields"))
                return
            } else {
                let _txtName = nameField.text
                let _txtDescr = descriptionField.text
                let _txtCategory = categoryField.currentText
                let _realValue = valueField.text.trim() == "" ? 0 : Functions.cleanExpenseValue(valueField.text)

                internal.expenseData.name = _txtName
                internal.expenseData.description = _txtDescr
                internal.expenseData.category = _txtCategory
                internal.expenseData.value = _realValue

                newExpenseView.createQuickExpense()
            }
        }
    }

    Components.ExpenseData {
        id: expenseDataObj
    }

    Components.Currency {
        id: travelCurrencyObj
        currencyID: currentTravelCurrency
    }

    Components.Currency {
        id: homeCurrencyObj
        currencyID: currentHomeCurrency
    }

    function createNewExpense() {
        if (mainView.expenses.add(internal.expenseData)) {
            mainView.tooltip.display(i18n.tr("New expense added"))
            close()
        } else {
            mainView.tooltip.display(i18n.tr("New expense failed"))
        }
    }

    function createQuickExpense() {
        let _result = mainView.quickExpenses.add(internal.expenseData)
        if (_result.success) {
            mainView.tooltip.display(i18n.tr("Quick expense added"))
        } else {
            if (_result.exists) {
                mainView.tooltip.display(i18n.tr("Already exists"))
            } else {
                mainView.tooltip.display(i18n.tr("New Quick expense failed"))
            }
        }
    }

    function updateExpense() {
        if (mainView.expenses.edit(internal.expenseData)) {
            mainView.tooltip.display(i18n.tr("Expense updated"))
            close()
        } else {
            mainView.tooltip.display(i18n.tr("Update failed"))
        }
    }

    function switchToEntryMode() {
        entryMode = true
    }

    function exitEntryMode() {
        entryMode = false
        internal.expenseData.reset()
    }

    function save() {
        if (entryMode) {
            /*Commits the OSK*/
            mainView.keyboard.commit()

            if (!internal.checkRequiredFields(false)) {
                mainView.tooltip.display(i18n.tr("Please fill required fields"))
                return
            } else {
                let _txtName = nameField.text
                let _txtDescr = descriptionField.text
                let _txtCategory = categoryField.currentText
                let _realValue = Functions.cleanExpenseValue(valueField.text)
                let _txtDate = Functions.getToday()

                if (!dateField.checked || isEditMode) {
                    _txtDate = Functions.formatDateForDB(dateField.dateValue)
                }

                internal.expenseData.entryDate = _txtDate
                internal.expenseData.name = _txtName
                internal.expenseData.description = _txtDescr
                internal.expenseData.category = _txtCategory

                if (valueField.processTravelData) {
                    internal.expenseData.value = valueField.convertedValue
                    internal.expenseData.travelData.value = _realValue
                } else {
                    internal.expenseData.value = _realValue
                }

                if (isEditMode) {
                    updateExpense()
                } else {
                    createNewExpense()
                }
            }
        }
    }

    function reset() {
        view.resetScroll()
        view.focus = false        
        contextActionsListView.currentIndex = -1
        quickListGridView.currentIndex = -1
        historyGridView.currentIndex = -1

        // Reset fields
        dateField.dateValue = new Date()
        dateField.checkState = Qt.Checked

        searchText = ""
        internal.isOpen = false
        internal.partiallyShown = false
        internal.forceContextActions = false
        travelCurrencyObj.currencyID = currentTravelCurrency
        homeCurrencyObj.currencyID = currentHomeCurrency
        searchMode = false
        exitEntryMode()
    }

    function open() {
        if (searchMode) {
            focusSearchInput()
        }

        if (searchMode || entryMode) {
            animateToFull()
        } else {
            if (internal.tall) {
                animateToPartial()
            } else {
                animateToFull()
            }
        }

        forceActiveFocus()
    }

    function openInSearchMode() {
        searchMode = true
        open()
    }

    function openInEditMode(expenseDataForEdit) {
        internal.expenseData.reset()
        internal.expenseData.expenseID = expenseDataForEdit.expenseID
        internal.expenseData.entryDate = expenseDataForEdit.entryDate
        internal.expenseData.name = expenseDataForEdit.name
        internal.expenseData.description = expenseDataForEdit.description
        internal.expenseData.category = expenseDataForEdit.category
        internal.expenseData.value = expenseDataForEdit.value
        internal.expenseData.travelData.rate = expenseDataForEdit.travelData.rate
        internal.expenseData.travelData.homeCur = expenseDataForEdit.travelData.homeCur
        internal.expenseData.travelData.travelCur = expenseDataForEdit.travelData.travelCur
        internal.expenseData.travelData.value = expenseDataForEdit.travelData.value

        // Set date/time fields to current values
        dateField.dateValue = Functions.convertDBToDate(expenseDataForEdit.entryDate)
        dateField.checkState = Qt.Unchecked

        travelCurrencyObj.currencyID = expenseDataForEdit.travelData.travelCur

        switchToEntryMode()
        open()
    }

    function close() {
        reset()
    }

    function animateToFull() {
        internal.partiallyShown = false
        showAnimation.to = 0
        showAnimation.restart()
    }

    function animateToPartial() {
        internal.partiallyShown = true
        searchMode = false
        showAnimation.to = height / 3
        showAnimation.restart()
    }

    function focusSearchInput() {
        searchMode = true
        searchField.selectAll();
        searchField.forceActiveFocus()
    }

    onSearchModeChanged: {
        if (internal.partiallyShown && searchMode) {
            animateToFull()
        }
    }

    onEntryModeChanged: {
        if (entryMode) {
            if (internal.partiallyShown) {
                animateToFull()
            }

            internal.focusRelevantField()
        } else {
            // Remove focus from the entry fields
            mainFlickable.forceActiveFocus()
        }
    }

    Keys.onPressed: {
        if (newExpenseView.focus) {
            switch (event.key) {
                case Qt.Key_Escape:
                    closeAction.triggered()
                    return;
            }
            if (event.text.trim() !== "") {
                focusSearchInput();
                searchText = event.text;
            }

            event.accepted = true;
        }
    }

    Behavior on opacity {
        NumberAnimation {
            easing: Suru.animations.EasingIn
            duration: Suru.animations.SnapDuration
        }
    }

    Common.BackgroundBlur {
        visible: opacity > 0
        anchors.fill: parent
        color: Suru.foregroundColor
        blurRadius: Suru.units.gu(5)
        backgroundOpacity: 0.1
        sourceItem: mainView.mainSurface
        blurRect: Qt.rect(0, 0, sourceItem.width, sourceItem.height)
        occluding: false

        MouseArea {
            anchors.fill: parent
            preventStealing: true
            onClicked: newExpenseView.close()
        }
    }

    Label {
        Suru.textLevel: Suru.HeadingOne
        visible: opacity > 0
        opacity: height > Suru.units.gu(6) && !closeSwipeAreaLoader.dragging ? 1 : 0
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: {
            if (newExpenseView.searchMode || newExpenseView.entryMode) {
                if (newExpenseView.isEditMode) {
                    return i18n.tr("Edit Expense")
                }

                return i18n.tr("New Expense")
            }

            return i18n.tr("Quick Expense")
        }
        color: Suru.foregroundColor
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: mainLayout.top
        }

        Behavior on opacity {
            NumberAnimation {
                easing: Suru.animations.EasingIn
                duration: Suru.animations.SnapDuration
            }
        }
    }

    ColumnLayout {
        id: mainLayout

        readonly property real preferrredWidth: Suru.units.gu(100)

        y: {
            if (internal.isOpen) {
                if (closeSwipeAreaLoader.dragging && ((closeSwipeAreaLoader.distance >= 0 && !internal.partiallyShown) || internal.partiallyShown)) {
                    if (internal.partiallyShown) {
                        let _newValue = closeSwipeAreaLoader.distance + internal.partialShowY
                        return _newValue > 0 ? _newValue : 0
                    } else {
                        if (closeSwipeAreaLoader.distance >= 0) {
                            return closeSwipeAreaLoader.distance
                        }
                     }

                     return closeSwipeAreaLoader.distance
                 }

                 return showAnimation.to
             }

            return parent.height - newExpenseView.dragDistance
        }

        height: newExpenseView.entryMode ? parent.height - mainView.keyboardRectangle.height : parent.height
        width: Math.min(preferrredWidth, parent.width)
        anchors.horizontalCenter: parent.horizontalCenter
        
        NumberAnimation on y {
            id: showAnimation

            running: false
            to: 0
            easing: Suru.animations.EasingOut
            duration: Suru.animations.SnapDuration
            onStopped: internal.isOpen = true
        }
        
        Behavior on y {
            enabled: newExpenseView.dragDistance == 0 && internal.isOpen
            NumberAnimation {
                easing: Suru.animations.EasingOut
                duration: Suru.animations.SnapDuration
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.margins: Suru.units.gu(1)
            Layout.topMargin: searchField.visible ? Suru.units.gu(5) : 0
            Layout.preferredHeight: searchField.visible ? searchField.height : 0

            Behavior on Layout.topMargin {
                NumberAnimation {
                    easing: Suru.animations.EasingOut
                    duration: Suru.animations.SnapDuration
                }
            }

            Behavior on Layout.preferredHeight {
                NumberAnimation {
                    easing: Suru.animations.EasingOut
                    duration: Suru.animations.SnapDuration
                }
            }

            TextField {
                id: searchField

                Layout.fillWidth: true

                visible: newExpenseView.searchMode && !newExpenseView.entryMode
                placeholderText: i18n.tr("Enter expense name")
                inputMethodHints: Qt.ImhNoPredictiveText

                KeyNavigation.down: {
                    if (contextActionsListView.visible) {
                        return contextActionsListView
                    }
                    if (quickListGridView.visible) {
                        return quickListGridView
                    }

                    return historyGridView
                }

                focus: visible
                onTextChanged: {
                    var trimmedText = text.trim()
                    internal.forceContextActions = false

                    if (trimmedText) {
                        if (text.substr(text.length - 2) == "  ") { // Trailing double space
                            internal.forceContextActions = true
                        }
                    }

                    if (text.charAt(text.length - 1) == " ") { // Trailing single space
                        searchDelay.triggered()
                    } else {
                        searchDelay.restart()
                    }
                }
                onAccepted: internal.selectFirstItem()

                Timer {
                    id: searchDelay
                    interval: 300
                    onTriggered: {
                        let _trimmedText = searchField.text.trim()
                        mainFlickable.resetScroll()
                        quickListGridView.model.update(_trimmedText)
                        mainView.mainModels.historyEntryExpensesModel.searchText = _trimmedText
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Common.BaseFlickable {
                id: mainFlickable
                
                readonly property real defaultTopMargin: Suru.units.gu(2)

                anchors.fill: parent

                boundsBehavior: Flickable.DragOverBounds
                boundsMovement: Flickable.StopAtBounds
                clip: true
                topMargin: defaultTopMargin
                bottomMargin: toolbar.height
                contentHeight: contentsColumnLayout.height
                interactive: !internal.partiallyShown

                function resetScroll() {
                    contentY = -defaultTopMargin
                }

                onMovingChanged: {
                    if (moving && searchField.text.trim() == "" && !internal.tall && !newExpenseView.isWideLayout) {
                        newExpenseView.searchMode = false
                    }
                }

                ColumnLayout {
                    id: contentsColumnLayout

                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    ColumnLayout {
                        Layout.fillHeight: false

                        visible: !newExpenseView.entryMode

                        ContextActionsListView {
                            id: contextActionsListView

                            Layout.fillWidth: true
                            Layout.margins: Suru.units.gu(1)
                            Layout.topMargin: 0
                            Layout.preferredHeight: contentHeight

                            visible: newExpenseView.contextActionsShown
                            isWideLayout: newExpenseView.isWideLayout

                            function requestExpense() {
                                internal.expenseData.reset()
                                internal.expenseData.entryDate = Functions.getToday()
                                internal.expenseData.name = searchField.text

                                newExpenseView.switchToEntryMode()
                            }

                            onRequestNewExpense: requestExpense()
                            onRequestNewQuickExpense: requestExpense()
                        }

                        QuickListGridView {
                            id: quickListGridView

                            Layout.fillWidth: true
                            Layout.preferredHeight: contentHeight

                            visible: count > 0
                            gridType: newExpenseView.displayType
                            flickable: mainFlickable
                            type: QuickListGridView.Type.QuickList
                            isTravelMode: newExpenseView.isTravelMode
                            travelCurrency: newExpenseView.currentTravelCurrency
                            exchangeRate: newExpenseView.currentExchangeRate
                            baseModel: mainView.mainModels.quickExpensesModel
                            expenseData: internal.expenseData
                            KeyNavigation.up: contextActionsListView.visible ? contextActionsListView : searchField
                            KeyNavigation.down: historyGridView.count > 0 ? historyGridView : null

                            onRequestNewExpense: newExpenseView.switchToEntryMode()
                            onCreateNewExpense: newExpenseView.createNewExpense()
                            onRequestClose: newExpenseView.close()
                        }

                        QuickListGridView {
                            id: historyGridView

                            Layout.fillWidth: true
                            Layout.preferredHeight: contentHeight

                            visible: count > 0
                            gridType: newExpenseView.displayType
                            flickable: mainFlickable
                            type: QuickListGridView.Type.History
                            isTravelMode: newExpenseView.isTravelMode
                            travelCurrency: newExpenseView.currentTravelCurrency
                            exchangeRate: newExpenseView.currentExchangeRate
                            baseModel: mainView.mainModels.historyEntryExpensesModel
                            expenseData: internal.expenseData
                            KeyNavigation.up: {
                                if (quickListGridView.visible) {
                                    return quickListGridView
                                }

                                if (contextActionsListView.visible) {
                                    return contextActionsListView
                                }

                                return searchField
                            }

                            onRequestNewExpense: newExpenseView.switchToEntryMode()
                            onCreateNewExpense: newExpenseView.createNewExpense()
                            onRequestClose: newExpenseView.close()
                        }
                    }

                    ColumnLayout {
                        Layout.fillHeight: false
                        Layout.topMargin: Suru.units.gu(5)
                        Layout.bottomMargin: Suru.units.gu(2)
                        Layout.leftMargin: Suru.units.gu(2)
                        Layout.rightMargin: Suru.units.gu(2)

                        spacing: Suru.units.gu(2)
                        visible: newExpenseView.entryMode

                        TravelDataFields {
                            id: travelDataFields

                            Layout.fillWidth: true
                            Layout.preferredHeight: Suru.units.gu(6)
                            visible: newExpenseView.processTravelData
                            isEditMode: newExpenseView.isEditMode
                            homeCurrency: newExpenseView.isTravelMode && !isEditMode ? newExpenseView.currentHomeCurrency : internal.expenseData.travelData.homeCur
                            travelCurrency: newExpenseView.isTravelMode && !isEditMode ? newExpenseView.currentTravelCurrency : internal.expenseData.travelData.travelCur
                            rate: newExpenseView.isTravelMode && !isEditMode ? newExpenseView.currentExchangeRate : internal.expenseData.travelData.rate
                        }

                        DateField {
                            id: dateField

                            Layout.fillWidth: true
                            showToggle: !newExpenseView.isEditMode
                        }

                        NameField {
                            id: nameField

                            Layout.fillWidth: true
                            flickable: mainFlickable
                            text: internal.expenseData.name
                        }

                        CategoryField {
                            id: categoryField

                            Layout.fillWidth: true
                            flickable: mainFlickable
                            currentIndex: internal.expenseData.category ? model.find(internal.expenseData.category, "value") : 0
                            onVisibleChanged: {
                                if (!visible) {
                                    // Rebind value
                                    currentIndex = Qt.binding( function() { return internal.expenseData.category ? model.find(internal.expenseData.category, "value") : 0 } )
                                }
                            }
                        }

                        ValueField {
                            id: valueField

                            readonly property real mainValue: hasTravelData ? travelData.value : internal.expenseData.value

                            Layout.fillWidth: true

                            isColoredText: newExpenseView.isColoredText
                            flickable: mainFlickable
                            hasTravelData: newExpenseView.hasTravelData
                            processTravelData: newExpenseView.processTravelData
                            isTravelMode: newExpenseView.isTravelMode
                            travelData: internal.expenseData.travelData
                            homeCurrencyData: homeCurrencyObj.currencyData
                            travelCurrencyData: travelCurrencyObj.currencyData
                            text: mainValue == 0 ? "" : mainValue
                            convertedValue: hasTravelData ? internal.expenseData.value : 0 //Only useful when travel mode is on or has travel data
                            onVisibleChanged: {
                                if (visible) {
                                    // Rebind value
                                    convertedValue = Qt.binding( function() { return hasTravelData ? internal.expenseData.value : 0 } )
                                }
                            }
                        }

                        DescriptionField {
                            id: descriptionField

                            Layout.fillWidth: true
                            flickable: mainFlickable
                            text: internal.expenseData.description
                        }
                    }
                }
            }
        }
    }

    Loader {
        id: closeSwipeAreaLoader

        readonly property bool dragging: item && item.dragging
        readonly property real distance: item ? item.distance : 0
        readonly property int direction: item ? item.direction : -1

        asynchronous: true
        anchors.fill: mainLayout
        sourceComponent: Gestures.SwipeGestureHandler {
            readonly property int stageTrigger: {
                if (direction == UT.SwipeArea.Vertical) {
                    return usePhysicalUnit ? 3 : 2
                }

                return usePhysicalUnit ? 4 : 3
            }
            readonly property int stagePartialTrigger: internal.tall ? usePhysicalUnit ? 2 : 1
                                                                : 99 // Trigger for switching to partial show

            enabled: newExpenseView.view.contentY == -newExpenseView.view.defaultTopMargin
            direction: internal.partiallyShown ? UT.SwipeArea.Vertical : UT.SwipeArea.Downwards
            immediateRecognition: false
            usePhysicalUnit: true

            onStageChanged: {
                if (stage == stageTrigger && !newExpenseView.entryMode) Common.Haptics.play()
            }

            onDraggingChanged: {
                if (!dragging) {
                    if (direction == UT.SwipeArea.Downwards) {
                        if (towardsDirection) {
                            if (stage >= stageTrigger && !newExpenseView.entryMode) {
                                newExpenseView.close()
                            } else {
                                if (distance > 0) {
                                    newExpenseView.animateToPartial()
                                }
                            }
                        }
                    } else if (direction == UT.SwipeArea.Vertical) {
                        if (distance > 0 && towardsDirection && !newExpenseView.entryMode) {
                            newExpenseView.close()
                        } else if (distance < 0) {
                            newExpenseView.animateToFull()
                        }
                    }
                }
            }
        }
    }

    QuickListToolbar {
        id: toolbar

        height: Suru.units.gu(7)
        anchors {
            left: mainLayout.left
            right: mainLayout.right
        }

        state: internal.isOpen ? "shown" : "hidden"

        states: [
            State {
                name: "hidden"
                PropertyChanges {
                    target: toolbar
                    y: toolbar.parent.height
                }
            },
            State {
                name: "shown"
                PropertyChanges {
                    target: toolbar
                    y: toolbar.parent.height - toolbar.height - mainView.keyboardRectangle.height
                }
            }
        ]

        leftActions: [ closeAction ]

        rightActions: [
            Common.BaseAction {
                text: newExpenseView.isGridDisplay ? i18n.tr("Show list") : i18n.tr("Show grid")
                shortText: newExpenseView.isGridDisplay ? i18n.tr("List") : i18n.tr("Grid")
                icon.name: newExpenseView.isGridDisplay ? "view-list-symbolic" : "view-grid-symbolic"
                triggerOnTriggered: false
                visible: !newExpenseView.entryMode

                onTrigger: {
                    if (newExpenseView.isGridDisplay) {
                        newExpenseView.displayType = QuickListGridView.GridType.List
                    } else {
                        newExpenseView.displayType = QuickListGridView.GridType.Rectangle
                    }
                }
            }
            , Common.BaseAction {
                text: i18n.tr("Save as Quick Expense")
                iconName: "starred"
                triggerOnTriggered: false
                visible: newExpenseView.entryMode && !newExpenseView.isEditMode

                onTrigger: internal.saveAsQuick()
            }
            , Common.BaseAction {
                text: i18n.tr("Save")
                iconName: "save"
                triggerOnTriggered: false
                visible: newExpenseView.entryMode
                shortcut: StandardKey.Save

                onTrigger: newExpenseView.save();
            }
            , Common.BaseAction {
                text: i18n.tr("Search or create new expense")
                iconName: "compose"
                triggerOnTriggered: false
                visible: !newExpenseView.entryMode && !searchField.activeFocus

                onTrigger: newExpenseView.focusSearchInput();
            }
        ]
    }

    Common.BaseAction {
        id: closeAction

        text: newExpenseView.entryMode ? i18n.tr("Cancel") : i18n.tr("Close")
        iconName: newExpenseView.entryMode ? "cancel" : "close"
        triggerOnTriggered: false

        onTrigger: { 
            if (newExpenseView.entryMode && !newExpenseView.isEditMode) {
                newExpenseView.exitEntryMode()
            } else {
                newExpenseView.close()
            }
        }
    }
}
