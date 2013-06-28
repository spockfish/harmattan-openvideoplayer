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
                text: qsTr("Settings - Media")
            }

            Rectangle {
                x: 10
                width: parent.width - 20
                height: 1
                color: "#4d4d4d"
                opacity: 0.5
            }

            SelectionItem {
                title: qsTr("Video skip length")
                model: ListModel {
                    ListElement { name: QT_TR_NOOP("15 secs"); value: 15000 }
                    ListElement { name: QT_TR_NOOP("30 secs"); value: 30000 }
                    ListElement { name: QT_TR_NOOP("1 min"); value: 60000 }
                    ListElement { name: QT_TR_NOOP("2 mins"); value: 120000 }
                    ListElement { name: QT_TR_NOOP("5 mins"); value: 300000 }
                    ListElement { name: QT_TR_NOOP("10 mins"); value: 600000 }
                }
                initialValue: Settings.videoSkipLength
                onValueChosen: Settings.videoSkipLength = value
            }

            Row {
                x: 10
                spacing: parent.width - (children[0].width + children[1].width + 20)

                Label {
                    height: 30
                    color: _TEXT_COLOR
                    verticalAlignment: Text.AlignBottom
                    font.bold: true
                    text: qsTr("Play in background")
                }

                MySwitch {
                    id: backgroundSwitch

                    Component.onCompleted: {
                        checked = Settings.playInBackground
                    }
                    onCheckedChanged: Settings.playInBackground = checked
                }
            }

            Row {
                x: 10
                spacing: parent.width - (children[0].width + children[1].width + 20)

                Label {
                    height: 30
                    color: _TEXT_COLOR
                    verticalAlignment: Text.AlignBottom
                    font.bold: true
                    text: qsTr("Pause when minimized")
                }

                MySwitch {
                    id: pauseSwitch

                    Component.onCompleted: {
                        checked = Settings.pauseWhenMinimized
                    }
                    onCheckedChanged: Settings.pauseWhenMinimized = checked
                }
            }
        }
    }

    ScrollDecorator {
        flickableItem: flicker
    }
}
