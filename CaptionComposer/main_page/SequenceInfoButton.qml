import QtQuick 2.13
import QtQuick.Controls 2.13
import Qool.Styles 1.0
import Qool.Controls 1.0
import Paci.Core 1.0
import Paci.CaptionComposer 1.0

QoolButton {
  id: root
  property PASequence sequence
  showTitle: false

  implicitWidth: 150
  implicitHeight: 150
  extraContentPadding: 2

  backBox.strokeColor: QoolStyle.infoColor
  highlightColor: QoolStyle.infoColor

  onClicked: UIBrain.wantToEditSequenceInfo()

  SequenceInfoGenerator {
    id: info
    sequence: root.sequence
  }

  contentItem: Item {
    Text {
      id: formatNameText
      text: UIBrain.mainDocument.currentFormatName
      horizontalAlignment: Text.AlignRight
      font.pixelSize: QoolStyle.controlTitleFontPixelSize
      color: QoolStyle.infoColor
      anchors.top: parent.top
      anchors.right: parent.right
    }
    Text {
      id: sequenceNameText
      text: info.sequenceName
      color: QoolStyle.textColor
      font.pixelSize: QoolStyle.controlMainTextFontPixelSize
      anchors.left: parent.left
      anchors.top: formatNameText.bottom
      elide: Text.ElideNone
      fontSizeMode: Text.Fit
    }

    Text {
      id: rateText
      text: info.timebaseRate
      color: QoolStyle.textColor
      font.pixelSize: QoolStyle.controlImportantTextSize
      anchors.left: parent.left
      anchors.top: sequenceNameText.bottom
      //      anchors.bottom: clipCountText.top
    }
    Text {
      text: info.timebaseDropframe
      font.pixelSize: QoolStyle.tooltipTextFontPixelSize
      color: QoolStyle.warningColor
      anchors.top: rateText.top
      anchors.topMargin: 6
      anchors.left: rateText.right
    }
    Text {
      text: "FPS"
      color: QoolStyle.textColor
      font.pixelSize: QoolStyle.tipSize + 4
      anchors.bottom: rateText.bottom
      anchors.bottomMargin: 6
      anchors.left: rateText.right
    }
    Text {
      text: info.durationTimecode
      color: QoolStyle.infoColor
      font.pixelSize: QoolStyle.tooltipTextFontPixelSize
      anchors.right: parent.right
      anchors.bottom: parent.bottom
    }
  } //contentItem

  QoolMenu {
    id: contextMenu
    title: qsTr("序列信息与设置")
    showTitle: true
    QoolMenuBanner {
      text: info.note == "" ? qsTr("[空]") : info.note
      contentText.horizontalAlignment: Text.AlignLeft
      contentText.wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    }
    Action {
      text: qsTr("设置序列字体")
      onTriggered: UIBrain.wantToEditSequenceFont()
    }

    Action {
      text: qsTr("序列详情")
      onTriggered: UIBrain.wantToEditSequenceInfo()
    }
  } //contextMenu

  MouseArea {
    anchors.fill: parent
    z: 50
    acceptedButtons: Qt.RightButton
    onClicked: contextMenu.popup()
  }
}
