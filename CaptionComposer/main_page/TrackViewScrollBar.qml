import QtQuick 2.13
import Paci.CaptionComposer.UI 1.0
import Qool.Styles 1.0

Item {
  id: root
  property real yPosition: 0
  property real heightRatio: 0.1
  property alias currentTrack: minimap.currentTrack
  TrackViewMinimapImage {
    id: minimap
    width: root.width
    x: 0
    y: Math.max(
         (minimap.height - root.height + heightRatio * minimap.height) * yPosition,
         0) * -1
    z: 0
  }

  Rectangle {
    id: scope
    visible: minimap.currentTrack !== null
    color: QoolStyle.infoColor
    opacity: 0.3
    radius: 3
    width: root.width
    height: minimap.height * heightRatio
    x: 0
    y: Math.min(root.height - scope.height, minimap.height) * yPosition
    z: 10
  }
}
