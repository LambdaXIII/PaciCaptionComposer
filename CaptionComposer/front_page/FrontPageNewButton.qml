import QtQuick 2.13

FrontPageBigButton {
  id: root

  width: 250
  height: 300

  text: qsTr("新建序列文件")
  desciption: qsTr("新建一个空的序列文件；\n然而并没有什么卵用。")

  upperBackgroundColor: "#135A87"

  centerImage: root.hovered ? "qrc:/assets/icons/plus.fill.png" : "qrc:/assets/icons/plus.png"
}
