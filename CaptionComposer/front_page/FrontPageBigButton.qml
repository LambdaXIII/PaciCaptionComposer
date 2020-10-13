import QtQuick 2.13
import Qool.Controls 1.0
import Qool.Components 1.0
import Qool.Styles 1.0

QoolButton {
  id: control

  showTitle: false

  property string description
  property string centerImage
  property color textColor: QoolStyle.textColor

  //  property alias upperBackgroundColor: upperBackground.backColor
  animationEnabled: true
  topPadding: backBox.strokeWidth
  backBox.cutSize: QoolStyle.controlCutSize
  backBox.imagePath: centerImage

  rightPadding: 10
  bottomPadding: 20

  contentItem: Item {
    Text {
      id: buttonName
      text: control.text
      font.pixelSize: 24
      anchors.right: parent.right
      anchors.bottom: descText.top
      color: control.textColor
      font.bold: true
    }

    Text {
      id: descText
      text: control.description
      horizontalAlignment: Qt.AlignRight
      anchors.right: parent.right
      anchors.left: parent.left
      anchors.bottom: parent.bottom
      color: control.textColor
    }
  } //contentItem
}
