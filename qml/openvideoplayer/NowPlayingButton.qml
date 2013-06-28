import QtQuick 1.1
import com.nokia.meego 1.0

ToolButton {

    property bool replacePage: false

    platformStyle: ToolButtonStyle {
        textColor: Settings.activeColor
    }
    width: 300
    anchors.centerIn: parent
    iconSource: videoPlaybackPage.videoPaused ? "images/pause-accent-" + Settings.activeColorString + ".png" : videoPlaybackPage.videoStopped ? "images/stop-accent-" + Settings.activeColorString + ".png" : "images/play-accent-" + Settings.activeColorString + ".png"
    text: !videoPlaybackPage.currentVideo.title ? "" : videoPlaybackPage.currentVideo.title
    visible: playbackQueue.count > 0
    onClicked: {
        videoPlaybackPage.displayVideo();
        if (videoPlaybackPage.videoStopped) {
            videoPlaybackPage.startPlayback();
        }
        if (replacePage) {
            appWindow.pageStack.replace(videoPlaybackPage);
        }
        else {
            appWindow.pageStack.push(videoPlaybackPage);
        }
    }
}
