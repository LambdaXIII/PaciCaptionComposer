import QtQuick 2.14
import Qool.Components 1.0
import Qool.Styles 1.0

Item {
  property alias text: mainText.text

  Text {
    id: mainText
    color: QoolStyle.controlBackgroundColor2
    font.pixelSize: QoolStyle.controlTitleFontPixelSize
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignBottom
    anchors.fill: parent
    z: 10
  }
  Rectangle {
    anchors.fill: parent
    border.width: 0
    color: QoolStyle.negativeColor
    opacity: 0.7
    z: 1
  }
}
