import QtQuick 1.0
import com.nokia.meego 1.0

QueryDialog {
    id: dialog

    property variant playlist: []

    titleText: qsTr("Delete?")
    message: !playlist.title ? "" : qsTr("Do you want to delete the playlist") + " '" + playlist.title + "' " + qsTr("from your device? (Videos will not be deleted)")
    acceptButtonText: qsTr("Yes")
    rejectButtonText: qsTr("No")
    onAccepted: Utils.deletePlaylist(playlist.url)
}
