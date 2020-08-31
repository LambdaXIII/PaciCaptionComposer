import QtQuick 2.13

FrontPageBigButton {
  id: root

  width: 250
  height: 300

  text: qsTr("打开序列文件")
  desciption: qsTr("打开现有的字幕文件，\n支持多种格式。")

  upperBackgroundColor: "#3F214D"

  centerImage: root.hovered ? "qrc:/assets/icons/folder.orange.fill.png" : "qrc:/assets/icons/folder.orange.png"
}
