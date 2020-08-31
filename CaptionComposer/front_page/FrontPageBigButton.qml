import QtQuick 2.13
import Qool.Controls 1.0
import Qool.Components 1.0
import Qool.Styles 1.0

QoolButton {
  id: control

  showTitle: false

  property string desciption
  property string centerImage
  property alias upperBackgroundColor: upperBackground.backColor

  animationEnabled: true
  topPadding: backBox.strokeWidth
  backBox.cutSize: QoolStyle.controlCutSize

  contentItem: Item {
    Rectangle {
      id: bottomTextRect
      color: "lightgrey"
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      height: 60
      Text {
        id: bottomText
        text: control.text
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignTop
        font.pixelSize: 24
      }
      Text {
        id: descriptionText
        anchors.top: bottomText.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: control.desciption
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignBottom
        font.pixelSize: 12
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        fontSizeMode: Text.Fit
      }
    }
    CutCornerBox {
      id: upperBackground
      cutSize: backBox.cutSize
      anchors.fill: parent
      anchors.bottomMargin: bottomTextRect.height
      hasStroke: false
      Image {
        source: control.centerImage
        fillMode: Image.PreserveAspectFit
        width: 64
        height: 64
        anchors.centerIn: parent
      }
    }
  }
}
