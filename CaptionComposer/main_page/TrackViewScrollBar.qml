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

  Canvas {
    id: scope2
    width: root.width
    height: minimap.height * heightRatio
    visible: minimap.currentTrack !== null
    renderStrategy: Canvas.Threaded
    opacity: 0.6
    onPaint: {
      let c = getContext('2d')
      c.clearRect(0, 0, width, height)
      let cut_size = 4
      c.strokeStyle = QoolStyle.infoColor
      c.lineWidth = 2
      c.beginPath()
      c.moveTo(width - cut_size, 0)
      c.lineTo(width, cut_size)
      c.lineTo(width, height - cut_size)
      c.lineTo(width - cut_size, height)
      c.stroke()
      c.closePath()
    }
    x: 0
    y: Math.min(root.height - scope2.height, minimap.height) * yPosition
    z: 10
    onVisibleChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()
  } //scope2

  Connections {
    target: minimap
    function onCurrentTrackChanged() {
      scope2.requestPaint()
    }
  }
}
