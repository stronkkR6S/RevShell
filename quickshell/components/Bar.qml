//@ pragma UseQApplication
import QtQuick
import Quickshell
import Quickshell.Wayland
import "../components"

ShellRoot {
    PanelWindow {
        id: bar
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
        Dashboard {}
        Systemtray {
            dashboard_window: bar
        }
    }
    Border {}
}
