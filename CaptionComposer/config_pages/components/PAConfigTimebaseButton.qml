import QtQuick 2.13
//import CommonQml.Controls 1.0
//import CommonQml.PAStyles 1.0
import QtQuick.Controls 2.13
//import CommonQml.Components 1.0
import QtQuick.Layouts 1.13

import Qool.Controls.Inputs 1.0
import Qool.Styles 1.0

BasicInputControl {
  id: control
  height: 45
  width: 200
  Layout.preferredHeight: 45
  Layout.fillWidth: true
  Layout.leftMargin: 6
  Layout.rightMargin: 6
  property string unit
  property int rate: 24
  property bool df: false

  contentItem: TextInput {
    id: textEdit
    enabled: control.enabled
    color: QoolStyle.textColor
    selectionColor: QoolStyle.infoColor
    readOnly: false
    font: control.font
    selectByMouse: true

    text: value_to_text()
    onEditingFinished: {
      text_to_value(textEdit.text)
      focus = false
    }
    horizontalAlignment: Text.AlignRight
    verticalAlignment: Text.AlignVCenter
  }

  onRateChanged: textEdit.text = value_to_text()
  onDfChanged: textEdit.text = value_to_text()

  function value_to_text() {
    if (df) {
      switch (rate) {
      case 24:
        return "23.98"
      case 30:
        return "29.97"
      case 60:
        return "59.94"
      default:
        return "%1 DF".arg(rate)
      }
    }
    return rate.toString()
  }

  function text_to_value(text) {
    let t = text.toUpperCase()
    if (t.indexOf(".") >= 0 || t.indexOf("DF") >= 0)
      df = true
    let ns = t.replace("DF")
    rate = Math.round(parseFloat(ns))
  }

  function force_refresh_value() {
    text_to_value(textEdit.text)
  }
}
