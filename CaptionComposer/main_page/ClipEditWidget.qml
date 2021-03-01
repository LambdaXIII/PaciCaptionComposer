import QtQuick 2.13
import QtQuick.Controls 2.13
import Qool.Components 1.0
import Qool.Controls 1.0
import Qool.Styles 1.0
import Qool.Controls.Inputs 1.0 as QInputs

Item {
  id: control
  property alias editArea: editArea
  property alias text: editArea.text
  property color buttonColor: QoolStyle.backgroundStrokeColor
  signal accepted
  signal rejected
  Row {
    id: toolbar
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    QInputs.BasicInputSmallButton {
      id: okButton
      text: qsTr("改好了")
      onClicked: control.accepted()
      textColor: control.buttonColor
    }

    QInputs.BasicInputSmallButton {
      id: cancelButton
      text: qsTr("拉倒吧")
      onClicked: control.rejected()
      textColor: control.buttonColor
    }
  }

  ScrollView {
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: toolbar.top
    TextArea {
      id: editArea
      color: QoolStyle.textColor
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      background: Item {}
    }
  }
}
