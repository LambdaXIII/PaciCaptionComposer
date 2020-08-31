import QtQuick 2.13
//import QtQuick.Dialogs 1.3
import Qool.Controls 1.0
import Qool.Styles 1.0

QoolDialogWindow {
  title: qsTr("当前文档没保存，确定不存了？")
  width: 400
  height: 200
  Text {
    id: mainText
    text: qsTr("你好像忘了保存了，是否确定不保存了 ？")
    anchors.centerIn: hiddenBox
    color: QoolStyle.textColor
  }

  okButton.text: qsTr("我在想一想…")
  cancelButton.text: qsTr("真的不存了!")
}
