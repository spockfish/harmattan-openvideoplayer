/****************************************************************************
**
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components project.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
**     the names of its contributors may be used to endorse or promote
**     products derived from this software without specific prior written
**     permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 1.0
import com.nokia.meego 1.0

Item {
    id: root

    width: parent ? parent.width : 0
    height: parent ? parent.height : 0

    property alias title: titleBar.children
    property alias content: contentField.children
    property alias buttons: buttonRow.children
    property Item visualParent
    property int status: DialogStatus.Closed

    property alias acceptButtonText: acceptButton.text
    property alias rejectButtonText: rejectButton.text

    signal accepted
    signal rejected

    property QtObject platformStyle: SheetStyle { background: appStyle.background }

    //Deprecated, TODO Remove this on w13
    property alias style: root.platformStyle

    function reject() {
        close();
        rejected();
    }

    function accept() {
        close();
        accepted();
    }

    visible: status != DialogStatus.Closed;

    function open() {
        parent = visualParent || __findParent();
        sheet.state = "";
    }

    function close() {
        sheet.state = "closed";
    }

    function __findParent() {
        var next = parent;
        while (next && next.parent && next.objectName != "appWindowContent") {
            next = next.parent;
        }
        return next;
    }

    function getButton(name) {
        for (var i=0; i<buttons.length; ++i) {
            if (buttons[i].objectName == name)
                return buttons[i];
        }
        return undefined;
    }

    MouseArea {
        id: blockMouseInput
        anchors.fill: parent
    }

    Item {
        id: sheet

        width: parent.width
        height: parent.height

        clip: true

        property int transitionDurationIn: 300
        property int transitionDurationOut: 450

        state: "closed"

        function transitionStarted() {
            status = (state == "closed") ? DialogStatus.Closing : DialogStatus.Opening;
        }

        function transitionEnded() {
            status = (state == "closed") ? DialogStatus.Closed : DialogStatus.Open;
        }

        states: [
            // Closed state.
            State {
                name: "closed"
                PropertyChanges { target: sheet; y: height; }
            }
        ]

        transitions: [
            // Transition between open and closed states.
            Transition {
                from: ""; to: "closed"; reversible: false
                SequentialAnimation {
                    ScriptAction { script: if (sheet.state == "closed") { sheet.transitionStarted(); } else { sheet.transitionEnded(); } }
                    PropertyAnimation { properties: "y"; easing.type: Easing.InOutQuint; duration: sheet.transitionDurationOut }
                    ScriptAction { script: if (sheet.state == "closed") { sheet.transitionEnded(); } else { sheet.transitionStarted(); } }
                }
            },
            Transition {
                from: "closed"; to: ""; reversible: false
                SequentialAnimation {
                    ScriptAction { script: if (sheet.state == "") { sheet.transitionStarted(); } else { sheet.transitionEnded(); } }
                    PropertyAnimation { properties: "y"; easing.type: Easing.OutQuint; duration: sheet.transitionDurationIn }
                    ScriptAction { script: if (sheet.state == "") { sheet.transitionEnded(); } else { sheet.transitionStarted(); } }
                }
            }
        ]

        BorderImage {
            source: platformStyle.background
            width: parent.width
            anchors.top: header.bottom
            anchors.bottom: parent.bottom
            Item {
                id: contentField
                anchors.fill: parent
            }
        }

        Item {
            id: header
            width: parent.width
            height: headerBackground.height
            BorderImage {
                id: headerBackground
                border {
                    left: platformStyle.headerBackgroundMarginLeft
                    right: platformStyle.headerBackgroundMarginRight
                    top: platformStyle.headerBackgroundMarginTop
                    bottom: platformStyle.headerBackgroundMarginBottom
                }
                source: platformStyle.headerBackground
                width: header.width
            }
            Item {
                id: buttonRow
                anchors.fill: parent
                SheetButton {
                    id: rejectButton
                    objectName: "rejectButton"
                    anchors.left: parent.left
                    anchors.leftMargin: root.platformStyle.rejectButtonLeftMargin
                    anchors.verticalCenter: parent.verticalCenter
                    visible: text != ""
                    onClicked: close()
                }
                SheetButton {
                    id: acceptButton
                    objectName: "acceptButton"
                    anchors.right: parent.right
                    anchors.rightMargin: root.platformStyle.acceptButtonRightMargin
                    anchors.verticalCenter: parent.verticalCenter
                    platformStyle: SheetButtonAccentStyle {

                        property string color: Settings.activeColorString

                        background: Qt.resolvedUrl("/usr/share/themes/blanco/meegotouch/images/theme/" + color + "/" + color + "-meegotouch-sheet-button-accent"+__invertedString+"-background.png")
                            pressedBackground: Qt.resolvedUrl("/usr/share/themes/blanco/meegotouch/images/theme/" + color + "/" + color + "-meegotouch-sheet-button-accent"+__invertedString+"-background-pressed.png")
                            disabledBackground: Qt.resolvedUrl("/usr/share/themes/blanco/meegotouch/images/theme/" + color + "/" + color + "-meegotouch-sheet-button-accent"+__invertedString+"-background-disabled.png")
                    }
                    visible: text != ""
                    onClicked: close()
                }
                Component.onCompleted: {
                    acceptButton.clicked.connect(accepted)
                    rejectButton.clicked.connect(rejected)
                }
            }
            Item {
                id: titleBar
                anchors.fill: parent
            }
        }
    }
}
