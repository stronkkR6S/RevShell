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
      color: "#f7ebeb"
      // color: Theme.background
    }

        CombinedCM{}
        Workspace{}
        Powermenu{}
        Network{}
        CombinedVB{}
        Media{}
        // Systemtray{}


    
}
