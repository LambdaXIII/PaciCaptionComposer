import QtQuick 2.14
import Qool.Styles 1.0
import Qool.Controls 1.0
import QtQuick.Controls 2.14
import Paci.Core 1.0
import Paci.CaptionComposer 1.0
import Qool.Components 1.0
import QtQuick.Layouts 1.13

QoolControl {
  id: element

  implicitWidth: Math.max(
                   contentText.implicitWidth,
                   titleText.width + backBox.cutSize) + leftPadding + rightPadding

  width: parent ? Math.min(parent.width, implicitWidth) : implicitWidth
  extraContentPadding: 2

  backBox.strokeColor: themeControl.uiColor
  backBox.strokeWidth: 1
  titleText.color: themeControl.uiColor
  titleText.anchors.leftMargin: backBox.cutSize
  titleText.font.pixelSize: themeControl.timecodeSize
  backBox.backColor: themeControl.backgroundColor
  backBox.cutSize: 5
  showTitle: true
  title: editingMode ? timeFormatter.full : timeFormatter.start

  property PAClip currentClip
  property int currentClipIndex
  property real defaultHeight
  property real defaultWidth
  property bool editingMode: false

  Component.onCompleted: {
    defaultHeight = height
    defaultWidth = width
  }

  Behavior on height {
    NumberAnimation {}
  }

  Behavior on width {
    NumberAnimation {}
  }

  QtObject {
    id: themeControl
    property int timecodeSize: QoolStyle.controlTitleFontPixelSize
    property color uiColor: element.editingMode ? QoolStyle.infoColor : mainMouseArea.hovered ? QoolStyle.highlightColor : QoolStyle.backgroundStrokeColor
    property color backgroundColor: element.editingMode ? QoolStyle.controlBackgroundColor2 : trans_color(
                                                            QoolStyle.controlBackgroundColor)

    Behavior on uiColor {
      ColorAnimation {
        duration: 200
      }
    }

    Behavior on backgroundColor {
      ColorAnimation {
        duration: 200
      }
    }

    //半透明化颜色
    function trans_color(c) {
      let a = 0.6
      return Qt.rgba(c.r, c.g, c.b, a)
    }
  } //themeControl

  QtObject {
    id: timeFormatter
    property string start: UIBrain.showTime(currentClip.startTime)
    property string duration: UIBrain.showTime(currentClip.durationTime)
    property string end: UIBrain.showTime(currentClip.endTime)
    property string full: timeFormatter.start + " -> " + timeFormatter.end
    function refreshTimes() {
      start = UIBrain.showTime(currentClip.startTime)
      duration = UIBrain.showTime(currentClip.durationTime)
      end = UIBrain.showTime(currentClip.endTime)
    }
  } //timeFormatter
  Connections {
    target: UIBrain
    function onCurrentTimeShowingModeChanged() {
      timeFormatter.refreshTimes()
    }
  }
  Connections {
    target: currentClip
    function onAnyTimeChanged() {
      timeFormatter.refreshTimes()
    }
  }

  contentItem: Text {
    id: contentText
    text: currentClip.content
    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignBottom
    color: QoolStyle.textColor
    width: parent.width
    font.pixelSize: 14
    leftPadding: 10
    topPadding: 0
    DisabledCover {
      z: 10
      visible: !currentClip.isActivated
      text: qsTr("本条字幕未激活")
      anchors.fill: parent
    }
    visible: !editingMode
  } //contentItem

  Loader {
    id: editingLoader
    active: false
    anchors.fill: parent
    anchors.topMargin: element.topPadding
    anchors.leftMargin: element.leftPadding
    anchors.rightMargin: element.rightPadding
    anchors.bottomMargin: element.bottomPadding
    z: 55
    visible: element.editingMode
    onVisibleChanged: {
      if (visible) {
        item.text = contentText.text
      }
    }
    sourceComponent: ClipEditWidget {
      buttonColor: themeControl.uiColor
    }
    Connections {
      target: editingLoader.item
      function onAccepted() {
        if (currentClip.content !== editingLoader.item.text) {
          currentClip.content = editingLoader.item.text
          UIBrain.mainDocument.justEdited()
        }
        close_edit()
      }
      function onRejected() {
        close_edit()
      }
    }
    onLoaded: editingLoader.item.text = contentText.text
  } //editingLoader

  MouseArea {
    id: mainMouseArea
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    property bool hovered: false
    enabled: !editingMode
    anchors.fill: parent
    containmentMask: parent.backBox
    hoverEnabled: true
    onClicked: {
      if (mouse.button === Qt.LeftButton)
        open_edit()
      else {
        cmenu.popup()
      }
    }
    onEntered: mainMouseArea.hovered = true
    onExited: mainMouseArea.hovered = false
    z: 80
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
      onTriggered: open_edit()
    }
    QoolMenuSeparator {}
    Action {
      text: qsTr("加入我的语录")
      onTriggered: UIBrain.settingManager.addUserFortune(currentClip.content)
    }
    QoolMenu {
      title: qsTr("百度翻译")
      //      enabled: UIBrain.networkServer.networkAccessible
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

  function open_edit() {
    element.height = 200
    if (parent)
      element.width = parent.width
    editingLoader.active = true
    editingMode = true
  }

  function close_edit() {
    element.height = defaultHeight
    element.width = defaultWidth
    editingMode = false
  }
}
