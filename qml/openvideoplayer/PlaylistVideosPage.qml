import QtQuick 1.0
import com.nokia.meego 1.0
import "scripts/createobject.js" as ObjectCreator

Page {
    id: root

    property url playlistUrl

    function setPlaylist(title, url) {
        playlistUrl = url;
        videoListModel.loading = true;
        titleText.text = title;
        var playlistVideos = Utils.getPlaylistVideos(url);
        videoListModel.loading = false;
        for (var i = 0; i < playlistVideos.length; i++) {
            videoListModel.append(playlistVideos[i]);
        }
    }

    function playPlaylist() {
        var list = [];
        for (var i = 0; i < videoListModel.count; i++) {
            list.push(ObjectCreator.cloneObject(videoListModel.get(i)));
        }
        playVideos(list);
    }

    function deleteFromPlaylist(index) {
        var video = videoListModel.get(index);
        Utils.deleteVideoFromPlaylist(index, video.fileName, playlistUrl)
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
    }

    Connections {
        /* Connect to signals from C++ object Utils */

        target: Utils
        onDeletedFromPlaylist: reloadTimer.restart()
    }

    Timer {
        id: reloadTimer

        interval: 3000
        onTriggered: videoListModel.reload()
    }

    ContextMenu {
        id: contextMenu

        MenuLayout {

            MenuItem {
                text: qsTr("View details")
                onClicked: showVideoDetails(videoListModel.get(videoList.selectedIndex).itemId)
            }

            MenuItem {
                text: qsTr("Add to playback queue")
                onClicked: appendPlaybackQueue([ObjectCreator.cloneVideoObject(videoListModel.get(videoList.selectedIndex))])
            }

            MenuItem {
                text: qsTr("Delete from playlist")
                onClicked: deleteFromPlaylist(videoList.selectedIndex)
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

            anchors { left: parent.left; leftMargin: 10; right: parent.right; rightMargin: 10; top: parent.top }
            spacing: 10

            Label {
                id: titleText

                width: parent.width
                font.pixelSize: _LARGE_FONT_SIZE
                color: _TEXT_COLOR
                elide: Text.ElideRight
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#4d4d4d"
                opacity: 0.5
            }

            Image {
                id: thumb

                x: 10
                width: 180
                height: Math.floor((width * 9) / 16)
                source: videoListModel.count == 0 ? "image://theme/meegotouch-video-placeholder" : "file:///home/user/.thumbnails/video-grid/" + Qt.md5(videoListModel.get(0).url) + ".jpeg"
                smooth: true
                onStatusChanged: if (thumb.status == Image.Error) thumb.source = "image://theme/meegotouch-video-placeholder";

                MyButton {
                    width: 150
                    anchors { left: parent.right; leftMargin: column.width - (width + parent.width) - 10; bottom: parent.bottom }
                    text: qsTr("Play all")
                    enabled: videoListModel.count > 0
                    onClicked: playPlaylist()
                }
            }

            Item {
                height: 20
                width: parent.width

                Label {
                    id: videosLabel

                    anchors { right: parent.right; top: parent.top }
                    font.pixelSize: _SMALL_FONT_SIZE
                    font.bold: true
                    color: "#4d4d4d"
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    text: videoListModel.count == 0 ? qsTr("Videos") : videoListModel.count + " " + qsTr("Videos")
                }

                Rectangle {
                    height: 1
                    anchors { left: parent.left; right: videosLabel.left; rightMargin: 10; verticalCenter: videosLabel.verticalCenter }
                    color: "#4d4d4d"
                }
            }

            Flow {
                id: videoList

                property int selectedIndex
                property real cellWidthScale: Settings.thumbnailSize == "large" ? 1.0 : 0.5
                property real cellHeightScale: Settings.thumbnailSize == "large" ? 1.0 : 0.55
                property int cellWidth: appWindow.inPortrait ? Math.floor(width * cellWidthScale) : Math.floor((width / 2) * cellWidthScale)
                property int cellHeight: appWindow.inPortrait ? Math.floor(300 * cellHeightScale) : Math.floor(280 * cellHeightScale)

                width: parent.width

                Repeater {
                    model: ListModel {
                        id: videoListModel

                        property bool loading: false

                        function reload() {
                            videoListModel.loading = true;
                            videoListModel.clear();
                            var playlistVideos = Utils.getPlaylistVideos(playlistUrl);
                            videoListModel.loading = false;
                            for (var i = 0; i < playlistVideos.length; i++) {
                                videoListModel.append(playlistVideos[i]);
                            }
                        }
                    }

                    PlaylistVideoDelegate {
                        id: delegate

                        width: videoList.cellWidth
                        height: videoList.cellHeight
                        onClicked: playVideos([ObjectCreator.cloneVideoObject(videoListModel.get(index))])
                        onPressAndHold: {
                            videoList.selectedIndex = index;
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

    Label {
        id: noResultsText

        anchors.centerIn: flicker
        font.pixelSize: _LARGE_FONT_SIZE
        font.bold: true
        color: "#4d4d4d"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: qsTr("No videos found")
        visible: (!videoListModel.loading) && (videoListModel.count == 0)
    }

    BusyIndicator {
        anchors.centerIn: flicker
        running: visible
        visible: videoListModel.loading
        platformStyle: BusyIndicatorStyle {
            inverted: theme.inverted
            size: "large"
        }
    }
}
