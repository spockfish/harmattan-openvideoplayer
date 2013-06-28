import QtQuick 1.1
import com.nokia.meego 1.0
import "scripts/dateandtime.js" as DT

Item {
    id: delegate

    signal clicked
    signal pressAndHold

    Image {
        id: thumb

        height: Math.floor((width / 16) * 9)
        anchors { left: parent.left; right: parent.right; margins: mouseArea.pressed ? 20 : 10 }
        source: "file:///home/user/.thumbnails/video-grid/" + Qt.md5(url) + ".jpeg"
        smooth: true
        onStatusChanged: if (thumb.status == Image.Error) thumb.source = "image://theme/meegotouch-video-placeholder";

//        Image {
//            id: durationLabel

//            width: durationText.width + 20
//            anchors { top: thumb.top; right: thumb.right; margins: 10 }
//            source: "image://theme/meegotouch-video-duration-background"
//            smooth: true

//            Label {
//                id: durationText

//                anchors.centerIn: durationLabel
//                font.pixelSize: _SMALL_FONT_SIZE
//                color: resumePosition === 0 ? "white" : Settings.activeColor
//                horizontalAlignment: Text.AlignHCenter
//                verticalAlignment: Text.AlignVCenter
//                smooth: true
//                text: DT.getDuration(duration - resumePosition)
//            }
//        }
    }

    Label {
        id: titleText

        anchors { bottom: parent.bottom; left: parent.left; right: parent.right; margins: 10 }
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        elide: Text.ElideRight
        color: (videoPlaybackPage.playlistPosition == index) && (videoPlaybackPage.currentVideo.title) && (videoPlaybackPage.currentVideo.title == title) ? Settings.activeColor : _TEXT_COLOR
        text: title
        clip: true
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        onClicked: parent.clicked()
        onPressAndHold: parent.pressAndHold()
    }
}

