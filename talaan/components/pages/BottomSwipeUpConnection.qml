import QtQuick 2.12
import "../../common" as Common

Connections {
    ignoreUnknownSignals: true

    onStageChanged: {
        if (target.dragging) {
            switch (target.stage) {
                case 0:
                    break
                case 1:
                case 2:
                case 3:
                    if (mainView.newExpenseView.searchMode) {
                        Common.Haptics.playSubtle()
                    }
                    mainView.newExpenseView.searchMode = false
                    break
                case 4:
                    if (!mainView.newExpenseView.searchMode) {
                        Common.Haptics.play()
                    }
                    mainView.newExpenseView.searchMode = true
                    break
                case 5:
                default:
                    break
            }
        }
    }

    onDraggingChanged: {
        if (!target.dragging && target.towardsDirection 
                && target.stage >= 1) {
            mainView.newExpenseView.open()
        }
    }
}
