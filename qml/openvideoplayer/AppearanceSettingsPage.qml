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
                text: qsTr("Settings - Appearance")
            }

            Rectangle {
                x: 10
                width: parent.width - 20
                height: 1
                color: "#4d4d4d"
                opacity: 0.5
            }

            SelectionItem {
                id: themeSelector

                title: qsTr("Theme")
                model: ListModel {
                    ListElement { name: QT_TR_NOOP("Light"); value: "light" }
                    ListElement { name: QT_TR_NOOP("Dark"); value: "dark" }
                }
                initialValue: Settings.appTheme
                onValueChosen: Settings.appTheme = value
            }

            Label {
                x: 10
                font.bold: true
                color: _TEXT_COLOR
                text: qsTr("Active color")
            }

            Flow {
                x: 10
                width: parent.width - 20
                spacing: 10

                Repeater {
                    model: ["#66b907", "#418b11", "#37790c", "#346905", "#0fa9cd",
                        "#0881cb", "#066bbe", "#2054b1", "#6705bd", "#8a12bc",
                        "#cd0fbc", "#e805a3", "#ef5906", "#ea6910", "#f7751e",
                        "#ff8806", "#ed970c", "#f2b317"]

                    Rectangle {
                        width: 50
                        height: 50
                        color: modelData
                        border.color: Settings.appTheme == "light" ? "#4d4d4d" : "white"
                        border.width: color == Settings.activeColor ? 2 : 0

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                Settings.activeColor = parent.color;
                                Settings.activeColorString = "color" + (index + 2).toString();
                            }
                        }
                    }
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
                    text: qsTr("Enable marquee text")
                }

                MySwitch {
                    Component.onCompleted: checked = Settings.enableMarqueeText
                    onCheckedChanged: Settings.enableMarqueeText = checked
                }
            }
        }
    }

    ScrollDecorator {
        flickableItem: flicker
    }
}
