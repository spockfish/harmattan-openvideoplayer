import QtQuick 1.0
import com.nokia.meego 1.0
import QtMobility.systeminfo 1.1
import "scripts/createobject.js" as ObjectCreator

MyPageStackWindow {
    id: appWindow

    property int _SMALL_FONT_SIZE: 18
    property int _STANDARD_FONT_SIZE: 24
    property int _LARGE_FONT_SIZE: 40
    property string _BACKGROUND_COLOR: theme.inverted ? "black" : "white"
    property string _TEXT_COLOR: theme.inverted ? "white" : "black"
    property string _ICON_LOCATION: "/usr/share/themes/blanco/meegotouch/icons/"

    property bool videoPlaying : (pageStack.currentPage == videoPlaybackPage) && (videoPlaybackPage.videoDisplayed) && (platformWindow.viewMode == WindowState.Fullsize)

    Component.onCompleted: theme.inverted = (Settings.appTheme == "dark")

    function playVideos(videoList, replacePage) {
        videoPlaybackPage.setPlaylist(videoList);
        videoPlaybackPage.displayVideo();
        if (replacePage) {
            pageStack.replace(videoPlaybackPage);
        }
        else {
            pageStack.push(videoPlaybackPage);
        }
    }

    function appendPlaybackQueue(videoList) {
        videoPlaybackPage.appendPlaylist(videoList);
        messages.displayMessage(messages._ADDED_TO_PLAYBACK_QUEUE);
    }

    onVideoPlayingChanged: appWindow.videoPlaying ? screenSaver.setScreenSaverDelayed(true) : screenSaver.setScreenSaverDelayed(false)
    initialPage: homePage
    showStatusBar: false
    showToolBar: (!appWindow.videoPlaying) || (appWindow.inPortrait)
    platformStyle: PageStackWindowStyle {
        id: appStyle

        inverted: (theme.inverted) || ((appWindow.videoPlaying) && (!appWindow.inPortrait))
        cornersVisible: !((appWindow.videoPlaying) && (!appWindow.inPortrait))
        background: (theme.inverted) && ((!appWindow.videoPlaying) || (appWindow.inPortrait)) ? "image://theme/meegotouch-video-background" : "image://theme/meegotouch-applicationpage-background" + __invertedString
        backgroundFillMode: Image.Stretch
    }

    Connections {
        /* Connect to signals from C++ object Settings */

        target: Settings
        onAlert: messages.displayMessage(message)
        onAppThemeChanged: theme.inverted = (Settings.appTheme == "dark")
    }

    Connections {
        /* Connect to the platformWindow */

        target: platformWindow
        onViewModeChanged: {
            if (platformWindow.viewMode == WindowState.Thumbnail) {
                Settings.saveSettings();
            }
        }
    }    

    ListModel {
        id: playbackQueue

        /* Holds the media playback queue */
    }

    HomePage {
        id: homePage
    }

    VideoPlaybackPage {
        id: videoPlaybackPage
    }

    MyInfoBanner {
        id: messages
    }

    MinimizedInfo {}

    ScreenSaver {
        id: screenSaver
    }
}
