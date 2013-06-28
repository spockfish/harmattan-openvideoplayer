import QtQuick 1.0
import com.nokia.meego 1.0

Switch {

    property string color: Settings.activeColorString

    platformStyle: SwitchStyle {
        switchOn: Qt.resolvedUrl("/usr/share/themes/blanco/meegotouch/images/theme/" + color + "/" + color + "-meegotouch-switch-on"+__invertedString+".png")
    }
}
