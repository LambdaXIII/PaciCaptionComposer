import QtQuick 2.13
import QtQuick.Controls 2.13
//import CommonQml.Controls 1.0
import Paci.Core 1.0
//import CommonQml.Components 1.0
//import CommonQml.PAStyles 1.0
//import QtQuick.Layouts 1.12
import Paci.CaptionComposer 1.0
//import QtGraphicalEffects 1.13
import Qool.Controls 1.0
import Qool.Components 1.0
import Qool.Styles 1.0

import "../config_pages/components" as ConfigControls

QoolDialogWindow {
  id: root

  width: 500
  height: 450

  title: qsTr("序列信息")
  resizable: false

  property PASequence currentSequence

  property alias editingSequenceName: nameButton.value
  property alias editingRate: timebaseButton.rate
  property alias editingDropframe: timebaseButton.df
  property alias editingNote: noteEdit.text

  property bool isEditingCurrentDocument: false

  signal somethingChanged

  onAccepted: {
    nameButton.force_refresh_value()
    timebaseButton.force_refresh_value()
    let changed = false
    if (currentSequence.sequenceName !== editingSequenceName) {
      currentSequence.sequenceName = editingSequenceName
      changed = true
    }

    let tb = CC.makeTimebase(editingRate, editingDropframe)

    if (currentSequence.timebase !== tb) {
      currentSequence.timebase = tb
      changed = true
    }

    if (currentSequence.note !== editingNote) {
      currentSequence.note = editingNote
      changed = true
    }

    if (changed) {
      somethingChanged()
      currentSequence.fullRefreshTriggered()
      if (isEditingCurrentDocument)
        UIBrain.mainDocument.justEdited()
    }
    root.close()
  }

  Item {
    id: contentItem
    anchors.fill: hiddenBox

    CutCornerBox {
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.bottom: parent.bottom
      anchors.right: nameButton.left
      anchors.rightMargin: 6
      cutSize: 15
      imagePath: ":/assets/images/premiere.jpg"
    }

    ConfigControls.PAConfigTextButton {
      id: nameButton
      title: qsTr("序列名称")
      value: currentSequence.sequenceName
      onValueChanged: {
        if (value === "")
          value = qsTr("(还是起个名字吧)")
      }
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.rightMargin: 6
      width: 250
      height: 45
    }

    ConfigControls.PAConfigTimebaseButton {
      id: timebaseButton
      title: qsTr("序列时基")
      rate: currentSequence.timebase.rate
      df: currentSequence.timebase.dropframe
      anchors.right: parent.right
      anchors.top: nameButton.bottom
      anchors.topMargin: 6
      anchors.rightMargin: 6
      width: 250
      height: 45
    }

    QoolControl {
      id: noteArea
      anchors.right: parent.right
      anchors.top: timebaseButton.bottom
      anchors.topMargin: 6
      anchors.rightMargin: 6
      width: 250
      anchors.bottom: parent.bottom
      title: qsTr("序列备注")
      showTitle: true
      contentItem: ScrollView {
        TextArea {
          id: noteEdit
          text: currentSequence.note
          color: QoolStyle.textColor
          selectionColor: QoolStyle.infoColor
          wrapMode: Text.WrapAnywhere
          background: Item {}
        }
      }
    } //notearea
  } //contentItem
}
