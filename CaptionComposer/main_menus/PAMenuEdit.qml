import QtQuick 2.13
import QtQuick.Controls 2.13
import Qool.Controls 1.0
import Paci.CaptionComposer 1.0

QoolMenu {
  title: qsTr("编辑")
  signal formatConfigDialogRequested
  signal fortuneDialogRequested
  Action {
    text: qsTr("高级查找替换...")
  }
  QoolMenuSeparator {}
  Action {
    text: qsTr("格式说明/选项…")
    onTriggered: formatConfigDialogRequested()
  }
  Action {
    text: qsTr("语录…")
    onTriggered: fortuneDialogRequested()
  }
}
