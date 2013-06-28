import QtQuick 1.1
import com.nokia.meego 1.0

MySheet {
    rejectButtonText: qsTr("Cancel")
    acceptButtonText: (titleInput.text == "") ? "" : qsTr("Save")
    onAccepted: Utils.createPlaylist(titleInput.text)
    content: Item {
        anchors.fill: parent

        Flickable {
            id: flicker

            anchors { fill: parent; margins: 10 }
            contentWidth: width
            contentHeight: col1.height + 20
            flickableDirection: Flickable.VerticalFlick
            clip: true

            Column {
                id: col1

                spacing: 20
                anchors { top: parent.top; left: parent.left; right: parent.right }

                Label {
                    width: parent.width
                    font.pixelSize: _LARGE_FONT_SIZE
                    color: _TEXT_COLOR
                    elide: Text.ElideRight
                    text: qsTr("New Playlist")
                }

                MyTextField {
                    id: titleInput

                    width: parent.width
                    placeholderText: qsTr("Title")
                    inputMethodHints: Qt.ImhNoPredictiveText
                    platformSipAttributes: SipAttributes {
                        actionKeyEnabled: titleInput.text != ""
                        actionKeyHighlighted: true
                        actionKeyLabel: qsTr("Done")
                        actionKeyIcon: ""
                    }
                    Keys.onReturnPressed: titleInput.platformCloseSoftwareInputPanel()
                    Keys.onEnterPressed: titleInput.platformCloseSoftwareInputPanel()
                }
            }
        }

        ScrollDecorator {
            flickableItem: flicker
        }
    }

    MouseArea {
        z: -1
        anchors.fill: parent
    }
}
