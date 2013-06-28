import QtQuick 1.0
import com.nokia.meego 1.0

CheckBox {

    property string color: Settings.activeColorString

    platformStyle: CheckBoxStyle {
        backgroundPressed: Qt.resolvedUrl("/usr/share/themes/blanco/meegotouch/images/theme/" + color + "/" + color + "-meegotouch-button-checkbox" + __invertedString + "-background-pressed" + ".png")
        backgroundSelected: Qt.resolvedUrl("/usr/share/themes/blanco/meegotouch/images/theme/" + color + "/" + color + "-meegotouch-button-checkbox" + __invertedString + "-background-selected" + ".png")
    }
}
