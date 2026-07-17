import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import "../../../common/listitems" as ListItems
import "../../../library/functions.js" as Functions

ListView {
    id: contextActions

    property int previousIndex: 0
    property bool isWideLayout: false

    signal requestNewExpense
    signal requestNewQuickExpense

    spacing: Suru.units.gu(2)
    currentIndex: -1
    boundsBehavior: Flickable.OvershootBounds
    model: ListModel {}

    delegate: ListItems.BaseItemDelegate {
        id: itemDelegate

        anchors {
            left: parent.left
            right: parent.right
        }

        text: model.text
        rightSideText: index == 0 && ListView.view.currentIndex <= 0 ? newExpenseView.isWideLayout ? i18n.tr("↵ Enter")
                                                                                            : i18n.tr("↵")
                                                                     : ""

        highlighted: contextActions.currentIndex == index

        icon.name: model.type == "expense" ? "add" : "bookmark-new"
        icon.width: Suru.units.gu(2)
        icon.height: Suru.units.gu(2)

        onClicked: {
            if (model.type == "expense") {
                contextActions.requestNewExpense()
            } else {
                contextActions.requestNewQuickExpense()
            }
        }
    }

    Keys.onEnterPressed: currentItem.clicked()
    Keys.onReturnPressed: currentItem.clicked()

    onActiveFocusChanged: {
        if (!activeFocus) {
            previousIndex = currentIndex
            currentIndex = -1
        } else {
            if (previousIndex > -1) {
                currentIndex = previousIndex
            }
        }
    }

    onVisibleChanged: {
        if (!visible) {
            focus = false
            currentIndex = -1
            previousIndex = 0
        } else {
            currentIndex = 0
        }
    }

    Connections {
        target: newExpenseView

        onResultsIsEmptyChanged: {
            if (target.contextActionsShown) {
                let _trimmedText = target.searchText.trim()
                let _elidedText = Functions.elideText(_trimmedText, contextActions.isWideLayout ? 30 : 15)

                contextActions.model.clear()
                contextActions.model.append({
                                 type: "expense"
                                 , text: i18n.tr('Add "%1" as new expense').arg(_elidedText)
                             })
                /*
                contextActions.model.append({
                                 type: "quick"
                                 , text: i18n.tr('Add "%1" as new quick expense').arg(_elidedText)
                             })
               */ 
            }
        }
    }
}
