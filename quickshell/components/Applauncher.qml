import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets

//@ pragma IconTheme Papirus

ShellRoot {
    id: root

    property int minPanelHeight: 120
    property int maxPanelHeight: 450
    property int appHeight: 50
    property int appSpacing: 12
    property int selectedIndex: 0

    property int targetPanelHeight: Math.min(Math.max(20 + 50 + 15 + (filteredApps.values.length * appHeight) + (Math.max(filteredApps.values.length - 1, 0) * appSpacing) + 20, minPanelHeight), maxPanelHeight)

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            launcherWindow.visible = !launcherWindow.visible;

            searchBoxInput.text = "";
            root.selectedIndex = 0;

            if (launcherWindow.visible)
                searchBoxInput.forceActiveFocus();
        }
    }

    PanelWindow {
        id: launcherWindow

        implicitWidth: 450
        implicitHeight: maxPanelHeight

        // anchors.bottom: true

        color: "transparent"
        visible: false

        WlrLayershell.layer: WlrLayer.Overlay

        exclusiveZone: ExclusionMode.Ignore

        WlrLayershell.keyboardFocus: launcherWindow.visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

        mask: Region {
            item: launcherWindow.visible ? launcher : null
        }

        Rectangle {
            id: launcher

            width: parent.width

            anchors.bottom: parent.bottom

            height: launcherWindow.visible ? targetPanelHeight : 0

            color: Theme.background

            // topLeftRadius: Theme.module_radius
            // topRightRadius: Theme.module_radius
            radius: Theme.module_radius

            clip: true

            Behavior on height {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }

            ColumnLayout {
                id: mainLayout

                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }

                anchors.topMargin: 20
                anchors.leftMargin: 25
                anchors.rightMargin: 25

                spacing: 15

                Rectangle {
                    id: searchBox

                    Layout.alignment: Qt.AlignHCenter

                    Layout.preferredWidth: 400
                    Layout.preferredHeight: 50

                    radius: Theme.module_radius

                    color: "white"
                    Text {
                        anchors.fill: parent

                        anchors.leftMargin: 15
                        anchors.rightMargin: 15

                        text: "Search: "

                        font.pixelSize: 18
                        color: "black"
                        opacity: 0.78

                        verticalAlignment: Text.AlignVCenter

                        visible: searchBoxInput.text.length === 0
                    }

                    TextInput {
                        id: searchBoxInput

                        anchors.fill: parent

                        anchors.leftMargin: 15
                        anchors.rightMargin: 15

                        verticalAlignment: TextInput.AlignVCenter

                        font.pixelSize: 20
                        color: "black"

                        focus: launcherWindow.visible

                        clip: true

                        onTextChanged: {
                            root.selectedIndex = 0;
                        }

                        Keys.onDownPressed: {
                            if (filteredApps.values.length === 0)
                                return;
                            root.selectedIndex = Math.min(root.selectedIndex + 1, filteredApps.values.length - 1);

                            appList.positionViewAtIndex(root.selectedIndex, ListView.Contain);
                        }
                        Keys.onTabPressed: {
                            if (filteredApps.values.length === 0)
                                return;
                            root.selectedIndex = Math.min(root.selectedIndex + 1, filteredApps.values.length - 1);

                            appList.positionViewAtIndex(root.selectedIndex, ListView.Contain);
                        }
                        Keys.onBacktabPressed: {
                            if (filteredApps.values.length === 0)
                                return;
                            root.selectedIndex = Math.max(root.selectedIndex - 1, 0);

                            appList.positionViewAtIndex(root.selectedIndex, ListView.Contain);
                        }

                        Keys.onUpPressed: {
                            if (filteredApps.values.length === 0)
                                return;
                            root.selectedIndex = Math.max(root.selectedIndex - 1, 0);

                            appList.positionViewAtIndex(root.selectedIndex, ListView.Contain);
                        }

                        Keys.onReturnPressed: {
                            if (filteredApps.values.length === 0)
                                return;
                            filteredApps.values[root.selectedIndex].execute();

                            launcherWindow.visible = false;
                        }

                        Keys.onEscapePressed: {
                            launcherWindow.visible = false;
                        }
                    }
                }

                ScriptModel {
                    id: filteredApps

                    values: {
                        const query = searchBoxInput.text.trim().toLowerCase();

                        if (query === "")
                            return DesktopEntries.applications.values;

                        return DesktopEntries.applications.values.filter(app => app.name.toLowerCase().includes(query));
                    }
                }

                ListView {
                    id: appList

                    Layout.fillWidth: true

                    Layout.preferredHeight: Math.min(filteredApps.values.length * root.appHeight + Math.max(filteredApps.values.length - 1, 0) * root.appSpacing, 350)

                    model: filteredApps

                    clip: true

                    spacing: root.appSpacing

                    boundsBehavior: Flickable.StopAtBounds

                    delegate: Rectangle {
                        width: appList.width
                        height: root.appHeight

                        color: "transparent"

                        Rectangle {
                            anchors.fill: parent

                            anchors.margins: 2

                            radius: Theme.module_radius

                            color: index === root.selectedIndex ? Theme.blue : "transparent"

                            Behavior on color {
                                ColorAnimation {
                                    duration: 10
                                }
                            }
                        }

                        RowLayout {
                            anchors.fill: parent

                            anchors.leftMargin: 10
                            anchors.rightMargin: 10

                            spacing: 10

                            Image {
                                source: "file:///usr/share/icons/Papirus/48x48/apps/" + modelData.icon + ".svg"

                                Layout.preferredWidth: 40
                                Layout.preferredHeight: 40

                                fillMode: Image.PreserveAspectFit
                            }

                            Text {
                                Layout.fillWidth: true

                                text: modelData.name

                                font.pixelSize: 19

                                color: "black"

                                elide: Text.ElideRight

                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent

                            hoverEnabled: true

                            onEntered: {
                                root.selectedIndex = index;
                            }

                            onClicked: {
                                modelData.execute();

                                launcherWindow.visible = false;
                            }
                        }
                    }
                }
            }
        }
    }
}
