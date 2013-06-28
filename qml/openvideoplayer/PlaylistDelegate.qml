import QtQuick 1.1
import com.nokia.meego 1.0
import com.meego.extras 1.0

Item {
    id: delegate

    signal clicked
    signal pressAndHold

    width: parent.width
    height: 80

    ListHighlight {
        visible: mouseArea.pressed
    }

    Label {
        id: titleText

        anchors { left: parent.left; leftMargin: countBubble.width + 20; verticalCenter: parent.verticalCenter; right: countBubble.left; rightMargin: 10 }
        elide: Text.ElideRight
        text: fileName.slice(0, fileName.lastIndexOf("."))
        color: _TEXT_COLOR
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    CountBubble {
        id: countBubble

        anchors { right: parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter }
        value: trackCount
    }

    MouseArea {
        id: mouseArea

        anchors.fill: delegate
        onClicked: parent.clicked()
        onPressAndHold: parent.pressAndHold()
    }
}
