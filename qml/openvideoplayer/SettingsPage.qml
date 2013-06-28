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
                text: qsTr("Settings")
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

                    model: ListModel {
                        id: settingsModel

                        ListElement { name: QT_TR_NOOP("Media"); fileName: "MediaSettingsPage.qml" }
                        ListElement { name: QT_TR_NOOP("Appearance"); fileName: "AppearanceSettingsPage.qml" }
                        ListElement { name: QT_TR_NOOP("Other"); fileName: "SystemSettingsPage.qml" }
                    }

                    DrillDownDelegate {
                        id: delegate

                        width: column.width
                        title: name
                        onClicked: appWindow.pageStack.push(Qt.resolvedUrl(fileName))
                    }
                }

            }
        }
    }

    ScrollDecorator {
        flickableItem: flicker
    }
}
