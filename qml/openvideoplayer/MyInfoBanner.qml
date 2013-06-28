import QtQuick 1.1
import com.meego.extras 1.0

InfoBanner {
    id: banner

    property string _ADDED_TO_PLAYBACK_QUEUE: qsTr("Video added to playback queue")
    property string _VIDEO_METADATA_UPDATED: qsTr("Video metadata updated")
    property string _SHARED_VIA_FACEBOOK: qsTr("Video shared on facebook")
    property string _SHARED_VIA_TWITTER: qsTr("Video shared on twitter")
    property string _NETWORK_ERROR: qsTr("Unable to establish a network connection")
    property string _FORMAT_ERROR: qsTr("Video format not suitable. Skipping")
    property string _PLAYBACK_ERROR: qsTr("Video cannot be played. Skipping")

    function displayMessage(message) {
        /* Display a notification using the message banner */

        banner.text = message;
        banner.show();
    }

    MouseArea {
        anchors.fill: banner
        onClicked: {
            if (banner.text == banner._ADDED_TO_PLAYBACK_QUEUE) {
                videoPlaybackPage.displayQueue();
                appWindow.pageStack.push(videoPlaybackPage);
            }
        }
    }
}
