import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

Item{
    id:root
    property int radii:20
    property color color: Theme.background
    property bool direction:true
    property bool xrot:true
    property bool yrot:false

    width: radii
    height: radii
    Shape{
        id:shape
        anchors.fill: parent
        visible:true
        ShapePath{
            fillColor: root.color
            strokeWidth:0
            startX:0;startY:root.height
            PathArc {
                relativeX: root.radii
                relativeY: -root.radii
                radiusX: root.radii
                radiusY: root.radii
                direction: PathArc.Clockwise
            }
            PathLine {
                relativeX: -root.radii
                relativeY: 0
            }
        }
    }
} 
