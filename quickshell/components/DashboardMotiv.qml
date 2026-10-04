import QtQuick
import Quickshell
import Qt5Compat.GraphicalEffects
Rectangle {
    height: 220
    width: 150
    color: Theme.modulefg
    radius: 15

    anchors {
        right: parent.right
        rightMargin: 5
        top: parent.top
        topMargin: 5
    }

    Image {
        anchors.fill: parent
        source: "../icons/motiv.png"

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: 150
                height: 220
                radius: 15
            }
        }
    }
}
