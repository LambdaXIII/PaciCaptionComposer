import QtQuick 2.13
//import CommonQml.Controls 1.0
//import CommonQml.PAStyles 1.0
//import CommonQml.Components 1.0
import QtQuick.Layouts 1.13
import Qool.Styles 1.0
import Qool.Controls.Inputs 1.0
import Qool.Components 1.0

QoolCheckableControl {
  id: control
  height: 45
  width: 200

  property alias value: control.checked
 disableInfo: qsTr("选项不受支持")

  Layout.preferredHeight: 45
  Layout.preferredWidth: 200
  Layout.fillWidth: true
  Layout.leftMargin: 6
  Layout.rightMargin: 6
  horizontalAlignment: Text.AlignRight

  showTitle: true
}
