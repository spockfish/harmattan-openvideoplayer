import QtQuick 1.0
import com.nokia.meego 1.0

Button {

    property string color: Settings.activeColorString

    platformStyle: ButtonStyle {
        inverted: theme.inverted
        pressedBackground: Qt.resolvedUrl("/usr/share/themes/blanco/meegotouch/images/theme/" + color + "/" + color + "-meegotouch-button" + __invertedString + "-background-pressed" + (position ? "-" + position : "") + ".png")
        checkedBackground: Qt.resolvedUrl("/usr/share/themes/blanco/meegotouch/images/theme/" + color + "/" + color + "-meegotouch-button" + __invertedString + "-background-selected" + (position ? "-" + position : "") + ".png")
        checkedDisabledBackground: Qt.resolvedUrl("/usr/share/themes/blanco/meegotouch/images/theme/" + color + "/" + color + "-meegotouch-button" + __invertedString + "-background-disabled-selected" + (position ? "-" + position : "") + ".png")
    }
}
