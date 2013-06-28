import QtQuick 1.1
import com.nokia.meego 1.0
import "scripts/dateandtime.js" as DT

Item {
    id: delegate

    property bool useMarqueeText

    signal clicked
    signal pressAndHold

    Image {
        id: thumb

        height: Math.floor((width / 16) * 9)
        anchors { left: parent.left; right: parent.right; margins: mouseArea.pressed ? 20 : 10 }
        source: "file:///home/user/.thumbnails/video-grid/" + Qt.md5(url) + ".jpeg"
        smooth: true
        onStatusChanged: if (thumb.status == Image.Error) thumb.source = "image://theme/meegotouch-video-placeholder";
    }

    Marquee {
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right; margins: 10 }
        textColor: (videoPlaybackPage.playlistPosition == index) && (videoPlaybackPage.currentVideo.fileName) && (videoPlaybackPage.currentVideo.fileName == fileName) ? Settings.activeColor : _TEXT_COLOR
        text: fileName.slice(0, fileName.lastIndexOf("."))
        enableScrolling: useMarqueeText
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        onClicked: parent.clicked()
        onPressAndHold: parent.pressAndHold()
    }
}

