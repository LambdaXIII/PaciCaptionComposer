import QtQuick 2.13
import QtQuick.Controls 2.13
import Paci.CaptionComposer 1.0
import Paci.Core 1.0

import Qool.Components 1.0
import Qool.Controls 1.0
import Qool.Styles 1.0

QoolControl {
  id: root

  title: qsTr("最近使用的文件")
  showTitle: true

  FileListModel {
    id: theModel
    fileList: UIBrain.settingManager.recentFileList
  }

  contentItem: ListView {
    model: theModel
    clip: true
    orientation: Qt.Vertical
    spacing: 4
    delegate: AbstractButton {
      id: button
      width: parent.width
      hoverEnabled: true
      CutCornerHighlightCover {
        visible: button.down
        cutSize: 3
      }
      contentItem: Text {
        anchors.fill: parent
        text: model.fileName
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        color: hovered ? QoolStyle.highlightColor : QoolStyle.textColor
      }
      anchors.horizontalCenter: parent.horizontalCenter

      QoolToolTip {
        text: model.path
        closeInterval: 5000
        openInterval: 1000
      }

      onClicked: {
        UIBrain.mainDocument.openDocument(model.fileURL, model.format)
        UIBrain.wantToShowMainPage()
      }
    } //delegate
  }
}
