import QtQuick 1.0
import com.nokia.meego 1.0

Page {

    orientationLock: appWindow.pageStack.currentPage == videoPlaybackPage ? PageOrientation.Automatic
                     : (Settings.screenOrientation == "landscape")
                     ? PageOrientation.LockLandscape
                     : (Settings.screenOrientation == "portrait")
                       ? PageOrientation.LockPortrait
                       : PageOrientation.Automatic

    tools: ToolBarLayout {
        id: toolBar

        ToolIcon {
            anchors.left: parent.left
            platformIconId: "toolbar-back"
            onClicked: appWindow.pageStack.pop()
        }
    }

    Flickable {
        id: flicker

        anchors { fill: parent; topMargin: 10 }
        contentWidth: width
        contentHeight: col1.height
        flickableDirection: Flickable.VerticalFlick
        clip: true

        Column {
            id: col1

            anchors { top: parent.top; left: parent.left; right: parent.right }
            spacing: 20

            Label {
                id: heading

                x: 10
                width: parent.width - 20
                elide: Text.ElideRight
                font.pixelSize: _LARGE_FONT_SIZE
                color: _TEXT_COLOR
                text: qsTr("Settings - Other")
            }

            Rectangle {
                x: 10
                width: parent.width - 20
                height: 1
                color: "#4d4d4d"
                opacity: 0.5
            }

            SelectionItem {
                id: orientationSelector

                title: qsTr("Screen orientation")
                model: ListModel {
                    ListElement { name: QT_TR_NOOP("Auto"); value: "auto" }
                    ListElement { name: QT_TR_NOOP("Landscape"); value: "landscape" }
                    ListElement { name: QT_TR_NOOP("Portrait"); value: "portrait" }
                }
                initialValue: Settings.screenOrientation
                onValueChosen: Settings.screenOrientation = value
            }
        }
    }

    ScrollDecorator {
        flickableItem: flicker
    }
}
