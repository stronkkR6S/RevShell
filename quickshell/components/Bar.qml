import Quickshell
import QtQuick

 PanelWindow {
    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 40
    color: "transparent"



    Rectangle {
      anchors.fill: parent
      // color: Theme.background
      color: "#CEDEDE"
    }

        CombinedCM{}
        CombinedVM{}
        CombinedBP{}
        Workspace{}
        Network{}
        Media{}
        // Systemtray{}


    
}
