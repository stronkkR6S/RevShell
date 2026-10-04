import QtQuick
import Quickshell

Rectangle {
    color: Theme.customGray
    width: 215
    height: 275
    radius: 20
    anchors {
        bottom: parent.bottom
        right: parent.right
        bottomMargin: 5
        rightMargin: 10
    }

    DashboardRecorder {}
    DashboardScreenshot{}
    DashboardMotiv{}
}
