import QtQuick 2.13
import QtQuick.Controls 2.13
import Qool.Components 1.0
import Qool.Controls 1.0
import Paci.CaptionComposer 1.0
import Qool.Styles 1.0

QoolMenu {
  title: qsTr("最近的文件")
  FileListModel {
    id: listModel
    fileList: UIBrain.settingManager.recentFileList
  }
  Connections {
    target: UIBrain.mainDocument
    function onDocumentOpened() {
      listModel.fileList = UIBrain.settingManager.recentFileList
    }
  }

  Repeater {
    model: listModel
    delegate: MenuItem {
      id: menuItem
      text: model.fileName
      font.pixelSize: QoolStyle.menuTextFontPixelSize
      CutCornerHighlightCover {
        visible: down
        hasStroke: false
      }
      contentItem: Text {
        //      implicitHeight: menuItem.itemHeight
        leftPadding: menuItem.indicator.width
        rightPadding: menuItem.arrow.width
        text: menuItem.text
        font: menuItem.font
        color: menuItem.highlighted ? QoolStyle.highlightColor : QoolStyle.textColor
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
      }

      background: Rectangle {
        //      implicitHeight: 3
        //      implicitWidth: menuItem.itemWidth
        width: parent.width
        height: 3
        //      width: parent.width - backBox.width * 2
        //      y: parent.height - height
        color: menuItem.highlighted ? QoolStyle.highlightColor : "transparent"
        anchors.bottom: parent.bottom
      }
      onClicked: UIBrain.mainDocument.openDocument(model.fileURL, model.format)
    }
  }

  QoolMenuSeparator {}

  Action {
    text: qsTr("清空文件记录")
    onTriggered: UIBrain.settingManager.clearRecentFilePath()
  }
}
