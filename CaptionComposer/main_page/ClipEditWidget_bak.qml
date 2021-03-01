import QtQuick 2.13
import QtQuick.Controls 2.13
import Qool.Components 1.0
import Qool.Controls 1.0
import Qool.Styles 1.0

Item {
  id: control
  property alias editArea: editArea
  property alias text: editArea.text
  signal accepted
  signal rejected
  Item {
    id: toolbar
    width: 120
    height: 15
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    AbstractButton {
      id: okButton
      //        showControlTitle: false
      //        controlBack.cutSize: 5
      contentItem: Text {
        text: qsTr("改好了")
        color: okButton.hovered ? QoolStyle.highlightColor : QoolStyle.textColor
        fontSizeMode: Text.Fit
      }
      hoverEnabled: true
      height: parent.height
      width: parent.width / 2
      onClicked: control.accepted()
    }
    AbstractButton {
      id: cancelButton
      //        showControlTitle: false
      //        controlBack.cutSize: 0
      contentItem: Text {
        text: qsTr("拉倒吧")
        color: cancelButton.hovered ? QoolStyle.highlightColor : QoolStyle.textColor
        fontSizeMode: Text.Fit
      }
      hoverEnabled: true
      height: parent.height
      width: parent.width / 2
      x: width
      onClicked: control.rejected()
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
    }
  }
}
