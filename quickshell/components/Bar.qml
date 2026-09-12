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

        Clock{}
        Workspace{}
        Powermenu{}
        Network{}
        CombinedVB{}
        // Systemtray{}


    
}
