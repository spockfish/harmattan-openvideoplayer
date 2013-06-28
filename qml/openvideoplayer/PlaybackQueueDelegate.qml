import QtQuick 1.1
import com.nokia.meego 1.0
import "scripts/dateandtime.js" as DT

Item {
    id: delegate

    property bool checked
    signal clicked
    signal pressAndHold

    width: parent.width
    height: 80
    smooth: true

    ListHighlight {
        visible: (mouseArea.pressed) || (delegate.checked)
    }

    Label {
        id: titleLabel

        anchors { left: parent.left; leftMargin: 10; verticalCenter: parent.verticalCenter; right: durationLabel.left; rightMargin: 10 }
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        color: index == nowPlayingPage.playlistPosition ? Settings.activeColor : _TEXT_COLOR
        text: title
    }

    Label {
        id: durationLabel

        anchors { right: parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter }
        verticalAlignment: Text.AlignVCenter
        color: titleLabel.color
        text: DT.getDuration(duration)
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        onClicked: parent.clicked()
        onPressAndHold: parent.pressAndHold()
    }
}

