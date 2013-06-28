import QtQuick 1.1
import com.nokia.meego 1.0

Item {

    property string playbackState: videoPlaybackPage.videoStopped ? "Stopped" : videoPlaybackPage.videoPaused ? "Paused" : "Playing"

    anchors.fill: parent
    visible: (platformWindow.viewMode == WindowState.Thumbnail) && !((pageStack.currentPage == videoPlaybackPage) && (videoPlaybackPage.videoDisplayed) && (playbackState == "Playing"))

    Rectangle {
        anchors.fill: parent
        color: _BACKGROUND_COLOR
        opacity: 0.8
    }

    Label {
        id: nowPlayingLabel

        anchors.fill: parent
        font.pixelSize: 72
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: Settings.activeColor
        font.bold: true
        wrapMode: Text.WordWrap
        text: (!videoPlaybackPage.currentVideo) || (!videoPlaybackPage.currentVideo.title) ? qsTr("Nothing playing")
                                              : videoPlaybackPage.currentVideo.title
                                                + "<br><br>" + playbackState
    }
}
