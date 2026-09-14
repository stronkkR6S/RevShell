import QtQuick
import Quickshell
import Quickshell.I3

// Workspace background
Rectangle {
    anchors.left: parent.left
    anchors.leftMargin: 10
    anchors.verticalCenter: parent.verticalCenter

    width: workspaces.width + 20
    height: 10
    radius: 20
    color: "transparent"

    Row {
        id: workspaces
        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: I3.workspaces

            delegate: Rectangle {
                anchors.verticalCenter: parent.verticalCenter

                width: modelData.active ? 43 : 25
                height: 22
                radius: 15

                // border.width: 0.5
                // border.color: "black"

                // inactive background
                color: Theme.vibrantOrange

                // Active gradient
                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius

                    visible: modelData.active

                    gradient: Gradient {
                        GradientStop {
                            position: 0.0
                            color: Theme.cyan
                        }

                        GradientStop {
                            position: 1.0
                            color: Theme.blue
                        }
                    }
                }

                Behavior on width {
                    NumberAnimation {
                        duration: 400
                        easing.type: Easing.InOutQuad
                    }
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        modelData.activate()
                    }
                }
            }
        }
    }
}
