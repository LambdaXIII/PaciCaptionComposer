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
    property color backgroundColor: element.editingMode ? QoolStyle.controlBackgroundColor2 : QoolStyle.controlBackgroundColor

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

  ClipEditWidget {
    id: editingField
    anchors.fill: parent
    anchors.topMargin: element.topPadding
    anchors.leftMargin: element.leftPadding
    anchors.rightMargin: element.rightPadding
    anchors.bottomMargin: element.bottomPadding
    buttonColor: themeControl.uiColor
    z: 55
    visible: element.editingMode
    onVisibleChanged: {
      if (visible) {
        text = contentText.text
      }
    }
    onAccepted: {
      if (currentClip.content !== editingField.text) {
        currentClip.content = editingField.text
        UIBrain.mainDocument.justEdited()
      }
      close_edit()
    }
    onRejected: close_edit()
  } //editingField

  MouseArea {
    id: mainMouseArea
    property bool hovered: false
    enabled: !editingField.visible
    anchors.fill: parent
    containmentMask: parent.backBox
    hoverEnabled: true
    onClicked: {
      open_edit()
    }
    onEntered: mainMouseArea.hovered = true
    onExited: mainMouseArea.hovered = false
    z: 80
  }

  function open_edit() {
    element.height = 200
    if (parent)
      element.width = parent.width
    editingMode = true
  }

  function close_edit() {
    element.height = defaultHeight
    element.width = defaultWidth
    editingMode = false
  }
}
