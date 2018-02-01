import QtQuick 2.4
import Ubuntu.Components 1.3
import "../ui"

BottomEdge {
    id: bottomEdge

    property QtObject contentPage
    property var _realPage: null

    hint{
        visible: false
        enabled: false
    }

    height: parent ? parent.height : 0
    enabled: false
    visible: false

    contentComponent: Item {
        id: pageContent
        implicitWidth: bottomEdge.width
        implicitHeight: bottomEdge.height
        children: bottomEdge._realPage
    }

    function commitWithProperties(properties) {
        _realPage.destroy()
        _realPage = contentComponentPage.createObject(null, properties)
        commit()
    }

    Component.onCompleted: {
        _realPage = contentComponentPage.createObject(null)
    }

    Component.onDestruction: {
        _realPage.destroy()
    }

    onCollapseCompleted: {
        _realPage.active = false
        _realPage.destroy()
        _realPage = contentComponentPage.createObject(null)
    }

    onCommitCompleted:{
        _realPage.active = true
    }


    Component {
     id: contentComponentPage
              AddChecklist {
                  id: addchecklistPage
                  anchors.fill: parent
                  onCancel: bottomEdge.collapse()
                  onSaved: bottomEdge.collapse()
              }
     }

}

