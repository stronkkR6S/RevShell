import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

ColumnLayout {
    spacing: 8
    anchors{
        right: parent.right
        top: parent.right
        rightMargin: 330
        verticalCenter: parent.verticalCenter

    }
    

    Text {
        text: "Tray: "  
        color: "red"
    }

    Repeater {
        model: SystemTray.items

        delegate: Image {
            required property SystemTrayItem modelData

            source: modelData.icon
            fillMode: Image.PreserveAspectFit
            smooth: true

            Layout.preferredWidth: 22
            Layout.preferredHeight: 22

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    modelData.activate()
                }
            }
        }
    }
}
