import QtQuick
import Quickshell
import Quickshell.Wayland

Rectangle{
    id: root

    color: "transparent"
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.leftMargin: 80
    anchors.rightMargin: 45
    anchors.topMargin: 400
        implicitHeight: 150

        Row {
            id: barsRow
            anchors.fill: parent
            anchors.margins: 10
            spacing: 3

            Repeater {
                model: Cava.barLevels

                Item {
                    width: (barsRow.width - barsRow.spacing * (Cava.barCount - 1)) / Cava.barCount

                    height: barsRow.height

                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter

                        width: parent.width
                        height: Math.max(4, parent.height * modelData)

                        radius: width / 2
                        color: Theme.blue

                        Behavior on height {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.OutQuad
                            }
                        }
                    }
                }
            }
        }
    }

