import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

ShellRoot {
    Timer {
        id: closeTimer

        interval: 200

        onTriggered: {
            if (!area_opener.containsMouse && !dashboardHover.hovered) {
                dashboard.visible = false;
            }
        }
    }
    // EDGE TRIGGER
    PanelWindow {
        id: dashboard_opener

        WlrLayershell.layer: WlrLayer.Overlay
        exclusiveZone: ExclusionMode.Ignore

        implicitWidth: 10
        implicitHeight: 300

        color: "transparent"

        anchors.left: true
        anchors.top: true
        margins.top: 400
        MouseArea {
            id: area_opener

            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                closeTimer.stop();
                dashboard.visible = true;
            }

            onExited: {
                closeTimer.restart();
            }
        }
    }

    // DASHBOARD
    PanelWindow {
        id: dashboard

        visible: false

        WlrLayershell.layer: WlrLayer.Overlay
        exclusiveZone: ExclusionMode.Ignore

        implicitWidth: Theme.dashboard_width
        implicitHeight: Theme.dashboard_height

        color: "transparent"

        anchors.left: true
        anchors.top: true
        margins.top: 300

        onVisibleChanged: {
            if (visible)
                appearAnim.restart();
        }

        //used rectangle because of radius
        Rectangle {
            id: contentRect

            width: Theme.dashboard_width
            height: Theme.dashboard_height

            color: Theme.background

            topRightRadius: Theme.dashboard_radius
            bottomRightRadius: Theme.dashboard_radius

            clip: true

            HoverHandler {
                id: dashboardHover

                onHoveredChanged: {
                    if (hovered)
                        closeTimer.stop();
                    else
                        closeTimer.restart();
                }
            }

            Item {
                id: page1
                anchors.fill: parent
                visible: columnn.selected === 1

                DashboardUser {}
                DashboardBrightness {}
                DashboardVolume {}
                Dashboardmedia {}
                DashboardVisu{}
            }

            Item {
                id: page2
                anchors.fill: parent
                visible: columnn.selected === 2
                DashboardNetwork{}
                DashboardPowerprofile{}
                DashboardBluetooth{}
                DashboardNight{}
                DashboardBattery{}
                // DashboardRecorder{}
                DashboardTools{}
            }

            Item {
                id: page3
                anchors.fill: parent
                visible: columnn.selected === 3

                DashboardCpu{}
                DashboardMemory{}
                DashboardDisk{}
                DashboardImageEnv{}
            }

            Column {
                id: columnn
                property int selected: 1
                anchors {
                    left: parent.left
                    leftMargin: 25
                    top: parent.top
                    topMargin: 100
                }

                spacing: 40

                Rectangle {
                    width: 9
                    height: parent.selected === 1 ? 110 : 70
                    color: parent.selected === 1 ? Theme.blue : Theme.black
                    radius: 10
                    MouseArea {
                        id: changewidth
                        anchors.fill: parent
                        onClicked: parent.parent.selected = 1
                    }
                    Behavior on height {
                        NumberAnimation {
                            duration: 500
                            easing.type: Easing.InOutQuad
                        }
                    }
                }

                Rectangle {
                    width: 9
                    radius: 10
                    height: parent.selected === 2 ? 110 : 70
                    color: parent.selected === 2 ? Theme.blue : Theme.black
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: parent.parent.selected = 2
                    }
                    Behavior on height {
                        NumberAnimation {
                            duration: 500
                            easing.type: Easing.InOutQuad
                        }
                    }
                }

                Rectangle {
                    width: 9
                    radius: 10
                    height: parent.selected === 3 ? 110 : 70
                    color: parent.selected === 3 ? Theme.blue : Theme.black
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: parent.parent.selected = 3
                    }
                    Behavior on height {
                        NumberAnimation {
                            duration: 500
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }

            NumberAnimation {
                id: appearAnim

                target: contentRect
                property: "width"

                from: 0
                to: Theme.dashboard_width

                duration: 500
                easing.type: Easing.InOutQuad
            }
        }
    }
}
