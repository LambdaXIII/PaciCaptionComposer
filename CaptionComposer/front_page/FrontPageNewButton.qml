import QtQuick 2.13
import Qool.Styles 1.0

FrontPageBigButton {
  id: root

  width: 250
  height: 300

  text: qsTr("新建序列文件")
  description: qsTr("新建一个空的序列文件\n然而并没有什么卵用")

  //  upperBackgroundColor: "#135A87"
  centerImage: ":/assets/images/papers.jpg"
  textColor: QoolStyle.backgroundColor
}
