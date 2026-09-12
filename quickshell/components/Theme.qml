pragma Singleton

import QtQuick

QtObject {
    //colors
    readonly property color background: "#020202"
    readonly property color powermenubackground: "#f7ebeb"
    // readonly property color powermenubackground: "#020202"
    readonly property color foreground: "#bfbdb6"

    readonly property color black: "#0D0D0D"
    readonly property color darkGray: "#2d3640"
    readonly property color gray: "#5c6773"
    readonly property color lightGray: "#dedede"
    readonly property color white: "#ffffff"

    readonly property color blue: "#59c2ff"
    readonly property color cyan: "#73b8ff"
    readonly property color green: "#aad94c"
    readonly property color magenta: "#d2a6ff"
    readonly property color orange: "#ff8f40"
    readonly property color red: "#f07178"
    readonly property color yellow: "#e6b450"

    readonly property color vibrantYellow: "#CFCA0D"
    readonly property color vibrantOrange: "#FF8732"

    //other values
    readonly property int barSideMargin: 0
    // readonly property int barRounding: 20
    readonly property int powermenuRounding: 20
    readonly property int barWidth: 45
    readonly property int barRotation: -90
    readonly property int fontSize: 17

}
