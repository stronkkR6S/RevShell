import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Shapes

Item {
    id: root

    width: 170
    height: 170
    property real cpuUsage: 0
    property real cpuTemp: 0

property real totalSweep: cpuUsage * 3

Behavior on totalSweep {
    NumberAnimation {
        duration: 800
        easing.type: Easing.OutCubic
    }
}

property real firstAngle: Math.min(totalSweep, 100)
property real secondAngle: Math.min(Math.max(totalSweep - 100, 0), 100)
property real thirdAngle: Math.min(Math.max(totalSweep - 200, 0), 100)

    anchors {
        top: parent.top
        topMargin: 200
        left: parent.left
        leftMargin: 100
    }

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeColor: Theme.customGray
            strokeWidth: 10
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: 85
                centerY: 85
                radiusX: 80
                radiusY: 80
                startAngle: -90
                sweepAngle: 100
            }

            PathAngleArc {
                centerX: 85
                centerY: 85
                radiusX: 80
                radiusY: 80
                startAngle: 30
                sweepAngle: 100
            }

            PathAngleArc {
                centerX: 85
                centerY: 85
                radiusX: 80
                radiusY: 80
                startAngle: 150
                sweepAngle: 100
            }
        }
    }

    Text {
        anchors.centerIn: parent
        text: root.cpuUsage + " "
        font.pixelSize: 30
    }
    Text {
        anchors {
            top: parent.top
            topMargin: 105
            left: parent.left
            leftMargin: 50
        }
        text: "CPUT: " + root.cpuTemp + "°"
        font.pixelSize: 15
    }

    Item {

        width: 170
        height: 170

        anchors {
            centerIn: parent
        }

        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                strokeColor: Theme.blue
                strokeWidth: 10
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    centerX: 85
                    centerY: 85
                    radiusX: 80
                    radiusY: 80
                    startAngle: -90
                    sweepAngle: root.firstAngle
                }

                PathAngleArc {
                    centerX: 85
                    centerY: 85
                    radiusX: 80
                    radiusY: 80
                    startAngle: 30
                    sweepAngle: root.secondAngle
                }

                PathAngleArc {
                    centerX: 85
                    centerY: 85
                    radiusX: 80
                    radiusY: 80
                    startAngle: 150
                    sweepAngle: root.thirdAngle
                }
            }
        }
    }

    Process {
        id: cpuUse

        command: ["sh", "-c", "~/.config/quickshell/scripts/cpusage.sh"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                root.cpuUsage = Number(data.trim());
            }
        }
    }

    Process {
        id: cpuTemp

        command: ["sh", "-c", "~/.config/quickshell/scripts/cputemp.sh"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                root.cpuTemp= Number(data.trim());
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: cpuTemp.running = true
    }
}
