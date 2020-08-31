import QtQuick 2.13

import Paci.CaptionComposer 1.0
import Qool.Controls 1.0
import Qool.Styles 1.0

QoolDialogWindow {
  id: root
  title: qsTr("语录设置")
  width: 300
  height: 400
  resizable: false

  hasCancelButton: false
  QoolDialogButton {
    text: qsTr("清空全部收藏")
    onClicked: {
      UIBrain.settingManager.setUserFortunes("")
      root.close()
    }
    parent: toolBarRow
  }

  ListView {
    id: contentItem
    anchors.fill: hiddenBox
    delegate: Text {
      text: modelData
      width: parent.width
      horizontalAlignment: Text.AlignHCenter
      color: QoolStyle.foregroundColor
    }
  }

  onVisibleChanged: if (visible == true) {
                      contentItem.model = UIBrain.settingManager.userFortunes()
                    }
}
