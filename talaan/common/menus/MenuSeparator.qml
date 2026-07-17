import QtQuick.Controls 2.12

MenuSeparator {
    id: customMenuSeparator

    topPadding: 0
    bottomPadding: 0
    visible: customMenuSeparator.enabled
    height: visible ? implicitHeight : 0
}
