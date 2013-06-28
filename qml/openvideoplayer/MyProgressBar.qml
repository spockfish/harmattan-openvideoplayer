import QtQuick 1.0
import com.nokia.meego 1.0

ProgressBar {
    id: root

    property string color: Settings.activeColorString
    property bool inverted: theme.inverted

    platformStyle: ProgressBarStyle {
        inverted: root.inverted
        unknownTexture: Qt.resolvedUrl("/usr/share/themes/blanco/meegotouch/images/theme/" + color + "/" + color + "-meegotouch-progressindicator"+__invertedString+"-bar-unknown-texture.png")
        knownTexture: Qt.resolvedUrl("/usr/share/themes/blanco/meegotouch/images/theme/" + color + "/" + color + "-meegotouch-progressindicator"+__invertedString+"-bar-known-texture.png")
    }
}
