import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: root
    property var closeSwitcher

    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    implicitHeight: 250
    implicitWidth: 1300
    visible: true
    color: "transparent"

    anchors {
        bottom: true
    }

    Rectangle {
        id: menu
        anchors.bottom: parent.bottom
        height: 0
        width: parent.width
        clip: true
        topLeftRadius: 15
        topRightRadius: 15
        color: "transparent"
        Component.onCompleted: {
            menu.height = 250;
        }
        Behavior on height {
            NumberAnimation {
                duration: 400
                easing.type: Easing.InCubic
            }
        }

        FolderListModel {
            id: wallpapers
            folder: "file://" + Quickshell.env("HOME") + "/pics/wallpapers/"
            nameFilters: ["*.png"]
            showDirs: false
            showFiles: true
            sortField: FolderListModel.Name
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            Text {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 10

                text: "Wallpapers Center"
                color: Theme.black
                font.pixelSize: 22
                font.family: "Orbitron"
                font.weight: Font.Black
                visible: false
            }

            Flickable {
                id: flick

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: 30
                Layout.rightMargin: 30

                contentWidth: wallpaperRow.width
                contentHeight: height
                //dont use clip otherwise you will not see the upper part of the image
                // clip: true

                Behavior on contentX {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutCirc
                    }
                }
                // rebound: Transition {
                //     NumberAnimation {
                //         properties: "x,y"
                //         duration: 10000
                //         easing.type: Easing.OutCirc
                //     }
                // }
                // // boundsBehavior: Flickable.DragAndOvershootBounds
                //  flickableDirection: Flickable.HorizontalFlick

                Row {
                    id: wallpaperRow
                    spacing: 0
                    y: 15

                    Repeater {
                        id: wallpaperRepeater
                        model: wallpapers
                        delegate: Column {
                            id: wallpaperItem
                            spacing: 8

                            z: activeFocus ? 1 : 0

                            width: 260

                            Rectangle {
                                id: wallpaper

                                width: 260
                                height: 135
                                radius: 15
                                color: "transparent"

                                scale: wallpaperItem.activeFocus ? 1.20 : 0.90
                                Behavior on scale {
                                    NumberAnimation {
                                        duration: 200
                                        easing.type: Easing.OutCirc
                                    }
                                }

                                Image {
                                    id: images
                                    anchors.fill: parent
                                    source: "file://" + Quickshell.env("HOME") + "/pics/wallpapers/thumbnails/" + fileName
                                    fillMode: Image.PreserveAspectCrop
                                    asynchronous: true
                                    cache: true
                                    visible: false
                                    sourceSize: Qt.size(320, 180)
                                }

                                OpacityMask {
                                    id: radiusImage
                                    anchors.fill: parent
                                    source: images
                                    maskSource: Rectangle {
                                        width: wallpaper.width
                                        height: wallpaper.height
                                        radius: 15
                                    }
                                }
                            }

                            Text {
                                width: parent.width
                                text: fileName.replace(/\.png$/i, "")
                                color: "transparent"
                                // color: "#E6E6E6"

                                font.pixelSize: 14
                                horizontalAlignment: Text.AlignHCenter
                                elide: Text.ElideRight

                                scale: wallpaperItem.activeFocus ? wallpaper.scale : 1.0

                                y: wallpaper.y + wallpaper.height + (wallpaper.height * (wallpaper.scale - 1) / 2) + 5
                            }

                            activeFocusOnTab: true

                            onActiveFocusChanged: {
                                if (activeFocus) {
                                    let target = x + width / 2 - flick.width / 2;
                                    flick.contentX = Math.max(0, Math.min(target, flick.contentWidth - flick.width));
                                }
                            }
                            Keys.onReturnPressed: {
                                Quickshell.execDetached(["sh", "-c", 'ln -sfn -- "$1" "$2" && qs ipc call wallpaper reload && qs ipc call dashboardImage reload', "sh", filePath, Quickshell.env("HOME") + "/.config/quickshell/wallpapers/wallpaper.png"]);
                            }

                            Keys.onEscapePressed: root.closeSwitcher()
                        }
                    }
                }
            }
        }
    }
}
