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
        contentHeight: col1.height + 20
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
                    Component.onCompleted: checked = Settings.playInBackground
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
                    Component.onCompleted: checked = Settings.pauseWhenMinimized
                    onCheckedChanged: Settings.pauseWhenMinimized = checked
                }
            }

            Row {
                x: 10
                spacing: 10

                Label {
                    width: col1.width - 30 - lockVideosSwitch.width
                    height: lockVideosSwitch.height
                    color: _TEXT_COLOR
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    text: qsTr("Lock screen to landscape when viewing videos")
                }

                MySwitch {
                    id: lockVideosSwitch

                    Component.onCompleted: checked = Settings.lockVideosToLandscape
                    onCheckedChanged: Settings.lockVideosToLandscape = checked
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
                    text: qsTr("Enable subtitles")
                }

                MySwitch {
                    Component.onCompleted: checked = Settings.enableSubtitles
                    onCheckedChanged: Settings.enableSubtitles = checked
                }
            }

            Column {
                id: subsColumn

                width: parent.width
                spacing: 20
                visible: Settings.enableSubtitles
                opacity: visible ? 1 : 0

                Behavior on opacity { PropertyAnimation { duration: 300 } }

                Row {
                    x: 10
                    spacing: parent.width - (children[0].width + children[1].width + 20)

                    Label {
                        height: 30
                        color: _TEXT_COLOR
                        verticalAlignment: Text.AlignBottom
                        font.bold: true
                        text: qsTr("Subtitles font size")
                    }

                    MyTextField {
                        id: subsizeText

                        width: 66
                        onTextChanged: Settings.subtitlesSize = parseInt(text)
                        inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhDigitsOnly
                        platformSipAttributes: SipAttributes {
                            actionKeyEnabled: subsizeText.text != ""
                            actionKeyHighlighted: true
                            actionKeyLabel: qsTr("Done")
                            actionKeyIcon: ""
                        }
                        Keys.onEnterPressed: platformCloseSoftwareInputPanel()
                        Keys.onReturnPressed: platformCloseSoftwareInputPanel()

                        Component.onCompleted: subsizeText.text = Settings.subtitlesSize
                    }
                }

                Label {
                    x: 10
                    font.bold: true
                    color: _TEXT_COLOR
                    text: qsTr("Subtitles color")
                }

                Flow {
                    x: 10
                    width: parent.width - 20
                    spacing: 10

                    Repeater {
                        model: ["#ffffff", "#000000", "#66b907", "#418b11", "#37790c",
                            "#346905", "#0fa9cd","#0881cb", "#066bbe", "#2054b1",
                            "#6705bd", "#8a12bc","#cd0fbc", "#e805a3", "#ef5906",
                            "#ea6910", "#f7751e", "#ff8806", "#ed970c", "#f2b317"]

                        Rectangle {
                            width: 50
                            height: 50
                            color: modelData
                            border.color: (Settings.subtitlesColor == "#ffffff") || (!theme.inverted) ? "#4d4d4d" : "#ffffff"
                            border.width: color == Settings.subtitlesColor ? 2 : 0

                            MouseArea {
                                anchors.fill: parent
                                onClicked: Settings.subtitlesColor = parent.color
                            }
                        }
                    }
                }

                MyCheckBox {
                    x: 10
                    text: qsTr("Use bold font for subtitles?")
                    Component.onCompleted: checked = Settings.boldSubtitles
                    onClicked: Settings.boldSubtitles = checked
                }
            }
        }
    }

    ScrollDecorator {
        flickableItem: flicker
    }
}
