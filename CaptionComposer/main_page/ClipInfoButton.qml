import QtQuick 2.14
import Qool.Styles 1.0
import Qool.Controls 1.0
import QtQuick.Controls 2.14
import Paci.Core 1.0
import Paci.CaptionComposer 1.0
import Qool.Components 1.0
import QtQuick.Layouts 1.13

QoolAbstractButton {
  id: element
  width: 450
  height: defaultHeight
  implicitHeight: 65
  implicitWidth: 450

  //  alterBackgroundColor: false
  property PAClip currentClip
  property int currentClipIndex
  property real defaultHeight

  QtObject {
    id: themeControl
    property int timecodeSize: QoolStyle.controlTitleFontPixelSize
  }

  showTitle: true
  title: "#" + currentClipIndex

  QtObject {
    id: timeFormatter
    property string start: UIBrain.showTime(currentClip.startTime)
    property string duration: UIBrain.showTime(currentClip.durationTime)
    property string end: UIBrain.showTime(currentClip.endTime)
    function refreshTimes() {
      start = UIBrain.showTime(currentClip.startTime)
      duration = UIBrain.showTime(currentClip.durationTime)
      end = UIBrain.showTime(currentClip.endTime)
    }
  }
  Connections {
    target: UIBrain
    function onCurrentTimeShowingModeChanged() {
      timeFormatter.refreshTimes()
    }
  }
  Connections {
    target: currentClip
    function onStartTimeChanged() {
      timeFormatter.refreshTimes()
    }
    function onDurationTimeChanged() {
      timeFormatter.refreshTimes()
    }
  }

  contentItem: Item {
    implicitHeight: startTimeText.implicitHeight + contentText.implicitHeight
    Text {
      id: startTimeText
      text: timeFormatter.start
      verticalAlignment: Text.AlignBottom
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      font.pixelSize: themeControl.timecodeSize
      color: QoolStyle.backgroundStrokeColor
    }

    Text {
      id: endTimeText
      text: timeFormatter.end
      horizontalAlignment: Text.AlignRight
      verticalAlignment: Text.AlignBottom
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      font.pixelSize: themeControl.timecodeSize
      color: QoolStyle.backgroundStrokeColor
    }

    Text {
      id: durationTimeText
      text: timeFormatter.duration
      verticalAlignment: Text.AlignBottom
      horizontalAlignment: Text.AlignHCenter
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.bottom: parent.bottom
      font.pixelSize: themeControl.timecodeSize
      color: QoolStyle.backgroundStrokeColor
    }

    Text {
      id: contentText
      text: currentClip.content
      fontSizeMode: Text.Fit
      wrapMode: Text.WrapAtWordBoundaryOrAnywhere
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.bottom: startTimeText.top
      anchors.left: parent.left
      color: QoolStyle.textColor
      font.pixelSize: 24
      DisabledCover {
        z: 10
        visible: !currentClip.isActivated
        text: qsTr("本条字幕未激活")
        anchors.fill: parent
      }
    }
  } //contentItem

  ClipEditWidget {
    id: editWidget
    z: 50
    visible: false
    anchors.fill: parent
    onAccepted: {
      if (currentClip.content !== editWidget.text) {
        currentClip.content = editWidget.text
        UIBrain.mainDocument.justEdited()
      }
      closeEdit()
    }
    onRejected: closeEdit()
  }

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.RightButton
    onClicked: cmenu.popup()
    z: 30
  }

  QoolMenu {
    id: cmenu
    title: qsTr("字幕信息")
    showTitle: true
    QoolMenuBanner {
      text: qsTr("左键单击可以打开字幕内容编辑器")
    }

    Action {
      checkable: true
      checked: currentClip.isActivated
      text: checked ? qsTr("已激活") : qsTr("未激活")
      onToggled: {
        if (currentClip.isActivated !== checked) {
          currentClip.isActivated = checked
          UIBrain.mainDocument.justEdited()
        }
      }
    }
    Action {
      text: qsTr("编辑...")
      onTriggered: openEdit()
    }
    QoolMenuSeparator {}
    Action {
      text: qsTr("加入我的语录")
      onTriggered: UIBrain.settingManager.addUserFortune(currentClip.content)
    }
    QoolMenu {
      title: qsTr("百度翻译")
      enabled: UIBrain.networkServer.networkAccessible
      BaiduTransAPIHandler {
        id: hdl
      }
      GridLayout {
        Repeater {
          model: hdl.languages
          delegate: AbstractButton {
            Layout.fillWidth: true
            CutCornerHighlightCover {
              anchors.fill: parent
              visible: down
              cutSize: 2
            }
            contentItem: Text {
              text: modelData
              color: hovered ? QoolStyle.highlightColor : QoolStyle.textColor
            }
            onClicked: {
              UIBrain.networkServer.wantBaiduToTranslate(modelData, currentClip)
              UIBrain.mainDocument.justEdited()
              cmenu.close()
            }
          } //delegate
        }
        columns: 2
        columnSpacing: 2
      }
    }
  } //menu

  function openEdit() {
    defaultHeight = element.height
    element.height = 250
    editWidget.text = currentClip.content
    editWidget.visible = true
  }

  function closeEdit() {
    editWidget.visible = false
    element.height = defaultHeight
  }

  onClicked: openEdit()
}
