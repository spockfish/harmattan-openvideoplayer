import QtQuick 1.0
import com.nokia.meego 1.0

Page {
    id: page

    property alias checkList: videoList.checkList

    function selectAll() {
        var cl = videoList.checkList;
        for (var i = 0; i < videoList.count; i++) {
            cl.push(i);
        }
        videoList.checkList = cl;
    }

    function selectNone() {
        videoList.checkList = [];
    }

    function indexInCheckList(index) {
        var result = false;
        for (var i = 0; i < videoList.checkList.length; i ++) {
            if (videoList.checkList[i] == index) {
                result = true;
            }
        }
        return result;
    }

    function sortNumber(a, b) {
        /* Sort function for the checkList */

        return b - a;
    }

    function remove() {
        var toRemove;
        var stop = false;
        var pos = nowPlayingPage.playlistPosition;
        var list = videoList.checkList;
        list.sort(sortNumber);
        for (var i = 0; i < list.length; i++) {
            toRemove = list[i];
            playbackQueue.remove(toRemove);
            if (toRemove < nowPlayingPage.playlistPosition) {
                pos--;
            }
            else if (toRemove == nowPlayingPage.playlistPosition) {
                pos--;
                stop = true;
            }
        }
        nowPlayingPage.playlistPosition = pos;
        videoList.checkList = [];
        if (stop) {
            if (playbackQueue.count > 0) {
                nowPlayingPage.next();
            }
            else {
                nowPlayingPage.stopPlayback();
            }
        }
    }

    orientationLock: appWindow.pageStack.currentPage == videoPlaybackPage ? PageOrientation.Automatic
                                                                          : (Settings.screenOrientation == "landscape")
                                                                            ? PageOrientation.LockLandscape
                                                                            : (Settings.screenOrientation == "portrait")
                                                                              ? PageOrientation.LockPortrait
                                                                              : PageOrientation.Automatic

    ListView {
        id: videoList

        property variant checkList : []

        anchors { fill: parent; topMargin: appWindow.inPortrait ? 75 : 60 }
        boundsBehavior: Flickable.DragOverBounds
        highlightMoveDuration: 500
        cacheBuffer: 2500
        clip: true
        model: playbackQueue
        delegate: PlaybackQueueDelegate {
            id: delegate

            function addOrRemoveFromCheckList() {
                var cl = videoList.checkList;
                if (!delegate.checked) {
                    cl.push(index);
                }
                else {
                    for (var i = 0; i < cl.length; i++) {
                        if (cl[i] == index) {
                            cl.splice(i, 1);
                        }
                    }
                }
                videoList.checkList = cl;
            }

            checked: indexInCheckList(index)
            onClicked: {
                if (videoList.checkList.length === 0) {
                    nowPlayingPage.playlistPosition = index;
                    nowPlayingPage.getNextVideo();
                    videoPlaybackPage.displayVideo();
                }
                else {
                    addOrRemoveFromCheckList();
                }
            }
            onPressAndHold: addOrRemoveFromCheckList()
        }
    }

    ScrollDecorator {
        flickableItem: videoList
    }

    Label {
        id: noResultsText

        anchors.centerIn: videoList
        font.pixelSize: _LARGE_FONT_SIZE
        font.bold: true
        color: "#4d4d4d"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: qsTr("Playback queue empty")
        visible: videoList.count == 0
    }
}
