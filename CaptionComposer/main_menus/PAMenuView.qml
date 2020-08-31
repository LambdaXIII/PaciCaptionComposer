import QtQuick 2.13
import QtQuick.Controls 2.13
import Qool.Controls 1.0
import Paci.CaptionComposer 1.0

QoolMenu {
  title: qsTr("查看")
  QoolMenu {
    title: qsTr("时间显示方式")
    ActionGroup {
      id: timecodeModeGroup
    }
    Action {
      text: qsTr("时间码")
      checkable: true
      checked: true
      ActionGroup.group: timecodeModeGroup
      onCheckedChanged: if (checked)
                          UIBrain.currentTimeShowingMode = UIBrain.Timecode
    }
    Action {
      text: qsTr("秒")
      checkable: true
      ActionGroup.group: timecodeModeGroup
      onCheckedChanged: if (checked)
                          UIBrain.currentTimeShowingMode = UIBrain.Second
    }
    Action {
      text: qsTr("帧数")
      checkable: true
      ActionGroup.group: timecodeModeGroup
      onCheckedChanged: if (checked)
                          UIBrain.currentTimeShowingMode = UIBrain.Frame
    }
    Action {
      text: qsTr("时间戳")
      checkable: true
      ActionGroup.group: timecodeModeGroup
      onCheckedChanged: if (checked)
                          UIBrain.currentTimeShowingMode = UIBrain.Timestamp
    }
  }
}
