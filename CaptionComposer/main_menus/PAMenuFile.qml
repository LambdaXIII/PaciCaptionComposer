import QtQuick 2.13
import QtQuick.Controls 2.13
import Qool.Controls 1.0
import Paci.CaptionComposer 1.0
import ".."

QoolMenu {
  title: qsTr("文件")

  signal openFileDialogRequested
  signal saveFileDialogRequested
  signal importFileDialogRequested

  Action {
    text: qsTr("打开…")
    onTriggered: openFileDialogRequested()
  }
  Action {
    text: qsTr("保存")
    onTriggered: UIBrain.mainDocument.saveDocument()
    enabled: UIBrain.mainDocument.isAbleToSave
  }
  Action {
    text: qsTr("另存为…")
    onTriggered: saveFileDialogRequested()
    enabled: UIBrain.mainDocument.currentSequence !== null
  }
  QoolMenuSeparator {}

  PARecentFileMenu {}

  Action {
    text: qsTr("导入其它文件…")
    onTriggered: importFileDialogRequested()
  }

  QoolMenuSeparator {}
  Action {
    text: qsTr("退出")
    onTriggered: UIBrain.wantToCloseMainWindow()
  }
}
