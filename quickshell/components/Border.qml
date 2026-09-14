import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland

Item {
    id: border

    property int thickness: 14

    // left
    PanelWindow {
        WlrLayershell.layer: WlrLayer.Bottom

        anchors {
            top: true
            bottom: true
            left: true
        }

        implicitWidth: border.thickness
        exclusiveZone: border.thickness
        color: "transparent"

        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                fillColor: Theme.background
                strokeColor: "transparent"

                startX: 0
                startY: 0

                PathLine {
                    x: 0
                    y: 25
                }

                PathLine {
                    x: border.thickness
                    y: 0
                }
            }
        }
    }

    // right
    PanelWindow {
        WlrLayershell.layer: WlrLayer.Bottom

        anchors {
            top: true
            bottom: true
            right: true
        }

        implicitWidth: border.thickness
        exclusiveZone: border.thickness
        color: "transparent"
        Shape {
            anchors.fill: parent

            ShapePath {
                fillColor: Theme.background
                strokeColor: "transparent"

                startX: border.thickness
                startY: 0

                PathLine {
                    x: border.thickness
                    y: 25
                }

                PathLine {
                    x: 0
                    y: 0
                }
            }
        }
    }
}
