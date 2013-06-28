import QtQuick 1.0
import com.nokia.meego 1.0
import QtMobility.gallery 1.1
import "scripts/createobject.js" as ObjectCreator

Page {
    id: page

    function showPlaylistVideos(title, url) {
        var videoList = ObjectCreator.createObject(Qt.resolvedUrl("PlaylistVideosPage.qml"), appWindow.pageStack);
        videoList.setPlaylist(title, url);
        appWindow.pageStack.push(videoList);
    }

    function showNewPlaylistDialog() {
        var newPlaylistDialog = ObjectCreator.createObject(Qt.resolvedUrl("NewPlaylistDialog.qml"), appWindow.pageStack);
        newPlaylistDialog.open();
    }

    function playPlaylist(url) {
        var playlistVideos = Utils.getPlaylistVideos(url);
        playVideos(playlistVideos);
    }

    function addPlaylistToPlaybackQueue(url) {
        var playlistVideos = Utils.getPlaylistVideos(url);
        appendPlaybackQueue(playlistVideos);
    }

    function showDeletePlaylistDialog(fileName, url) {
        var deletePlaylistDialog = ObjectCreator.createObject(Qt.resolvedUrl("DeletePlaylistDialog.qml"), appWindow.pageStack);
        deletePlaylistDialog.playlist = {"title": fileName.slice(0, fileName.lastIndexOf(".")), "url": url };
        deletePlaylistDialog.open();
    }

    orientationLock: appWindow.pageStack.currentPage == videoPlaybackPage ? PageOrientation.Automatic
                     : (Settings.screenOrientation == "landscape")
                     ? PageOrientation.LockLandscape
                     : (Settings.screenOrientation == "portrait")
                       ? PageOrientation.LockPortrait
                       : PageOrientation.Automatic

    tools: ToolBarLayout {
        id: toolBar

        ToolIcon {
            platformIconId: "toolbar-back"
            onClicked: appWindow.pageStack.pop()
        }

        NowPlayingButton {}

        ToolIcon {
            platformIconId: "toolbar-add"
            onClicked: showNewPlaylistDialog()
        }
    }

    Connections {
        /* Connect to signals from C++ object Utils */

        target: Utils
        onPlaylistCreated: reloadTimer.restart()
        onPlaylistDeleted: reloadTimer.restart()
        onAddedToPlaylist: reloadTimer.restart()
        onDeletedFromPlaylist: reloadTimer.restart()
    }

    Timer {
        id: reloadTimer

        interval: 5000
        onTriggered: playlistModel.reload()
    }

    ContextMenu {
        id: contextMenu

        MenuLayout {

            MenuItem {
                text: qsTr("Play")
                onClicked: playPlaylist(playlistModel.get(repeater.selectedIndex).url)
            }

            MenuItem {
                text: qsTr("Add to playback queue")
                onClicked: addPlaylistToPlaybackQueue(playlistModel.get(repeater.selectedIndex).url)
            }

            MenuItem {
                text: qsTr("Delete")
                onClicked: showDeletePlaylistDialog(playlistModel.get(repeater.selectedIndex).fileName, playlistModel.get(repeater.selectedIndex).url)
            }
        }
    }

    Flickable {
        id: flicker

        anchors { fill: parent; topMargin: 10 }
        boundsBehavior: Flickable.DragOverBounds
        contentWidth: width
        contentHeight: column.height

        Column {
            id: column

            anchors { left: parent.left; top: parent.top; right: parent.right }
            spacing: 20

            Label {
                id: heading

                x: 10
                width: parent.width - 20
                elide: Text.ElideRight
                font.pixelSize: _LARGE_FONT_SIZE
                color: _TEXT_COLOR
                text: qsTr("Playlists")
            }

            Rectangle {
                x: 10
                width: parent.width - 20
                height: 1
                color: "#4d4d4d"
                opacity: 0.5
            }

            Column {
                width: column.width

                Repeater {
                    id: repeater

                    property int selectedIndex

                    model: DocumentGalleryModel {
                        id: playlistModel

                        rootType: DocumentGallery.Playlist
                        properties: ["path", "url", "fileName", "trackCount"]
                        sortProperties: ["+fileName"]
                        filter: GalleryContainsFilter {
                            property: "filePath"
                            value: "Music"
                            negated: true
                        }
                    }

                    PlaylistDelegate {
                        id: delegate

                        width: column.width
                        onClicked: showPlaylistVideos(fileName.slice(0, fileName.lastIndexOf(".")), url)
                        onPressAndHold: {
                            repeater.selectedIndex = index;
                            contextMenu.open();
                        }
                    }
                }
            }
        }
    }

    ScrollDecorator {
        flickableItem: flicker
    }

    BusyIndicator {
        anchors.centerIn: flicker
        running: visible
        visible: playlistModel.status == DocumentGalleryModel.Active
        platformStyle: BusyIndicatorStyle {
            inverted: theme.inverted
            size: "large"
        }
    }

    Label {
        anchors.centerIn: flicker
        font.pixelSize: _LARGE_FONT_SIZE
        font.bold: true
        color: "#4d4d4d"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: qsTr("No playlists found")
        visible: (playlistModel.status == DocumentGalleryModel.Finished) && (playlistModel.count == 0)
    }
}
