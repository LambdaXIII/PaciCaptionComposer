import QtQuick 2.13
//import CommonQml.Components 1.0
//import CommonQml.PAStyles 1.0
import QtQuick.Controls 2.13
//import QtQuick.Dialogs 1.2
//import CommonQml.Controls 1.0
import Paci.CaptionComposer 1.0

import Qool.Controls 1.0
import Qool.Components 1.0
import Qool.Styles 1.0
import Qool.Controls.Inputs 1.0

QoolDialogWindow {
  id: root
  title: qsTr("新建空序列")
  width: 250
  height: 300
  Item {
    id: mainPanel
    anchors.fill: hiddenBox
    Column {
      anchors.fill: parent
      spacing: 6
      QoolTextInputControl {
        id: sequenceNameField
        title: qsTr("序列名称（必填）")
        width: parent.width
      }

      QoolSwitchControl {
        id: rateField
        title: qsTr("帧速率")
        tags: ['24', '25', '30', '50', '60']
        width: parent.width
      }
      QoolRadioButton {
        id: dropframeField
        title: qsTr("帧数计算模式")
        showTitle: false
        text: checked ? qsTr("不丢帧") : qsTr("不帧")
        width: parent.width
        checked: true
      }
    }
  }

  onAccepted: {
    sequenceNameField.force_refresh_value()
    UIBrain.mainDocument.newDocument(sequenceNameField.value,
                                     parseInt(rateField.value),
                                     !dropframeField.checked)
  }
  hasOKButton: sequenceNameField.value != ""
}
