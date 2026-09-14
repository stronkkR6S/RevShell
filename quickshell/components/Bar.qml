import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.components

ShellRoot{
    PanelWindow {
        WlrLayershell.layer: WlrLayer.Bottom
        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: 40
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: Theme.background
        }

        CombinedCM {}
        CombinedVM {}
        CombinedBP {}
        Workspace {}
        Network {}
        Media {}
    }
    Border{}

}
