import QtQuick 1.0

Rectangle {
    id: highlight

    anchors { fill: parent; bottomMargin: 1; topMargin: 1 }
    color: !parent.checked ? "#4d4d4d" : Settings.activeColor
    opacity: 0.5
    smooth: true
}
