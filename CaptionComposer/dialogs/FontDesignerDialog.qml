import QtQuick 2.13
//import CommonQml.FontDesigner 1.0
import Qool.FontDesigner 1.0
import Paci.CaptionComposer 1.0
import Paci.Core 1.0

QoolFontDesignerDialog {
  id: root
  title: editingSequenceFont ? qsTr("序列字体设计器") : qsTr("轨道字体设计器")

  property bool editingSequenceFont: true
  property PATrack targetTrack

  QtObject {
    id: inter_functions
    function pa_to_q_color(ftc) {
      return Qt.rgba(ftc.r, ftc.g, ftc.b, ftc.a)
    }
    function q_to_pa_color(c) {
      return CC.paColor(c.r, c.g, c.b, c.a)
    }

    function read_font(ft, pn) {
      pn.family = ft.family
      pn.size = ft.size


      /*
      pn.isBold = ft.bold
      pn.isItalic = ft.italic
      */
      pn.setBoldItalic(ft.bold, ft.italic)
      switch (ft.alignment) {
      case PAFontInfo.Left:
        pn.alignment = 0
        break
      case PAFontInfo.Right:
        pn.alignment = 2
        break
      default:
        pn.alignment = 1
      }

      pn.textColor = pa_to_q_color(ft.color)
      pn.lead = ft.lead
      pn.track = ft.track
      pn.outlineWidth = ft.outlineWidth
      pn.outlineSoft = ft.outlineSoft
      pn.outlineColor = pa_to_q_color(ft.outlineColor)
      pn.aspect = ft.aspect
      pn.textOpacity = ft.opacity
    }

    function save_font(pn, ft) {
      ft.family = pn.family
      ft.size = pn.size
      ft.bold = pn.isBold
      ft.italic = pn.isItalic
      switch (pn.alignment) {
      case "left":
        ft.alignment = PAFontInfo.Left
        break
      case "right":
        ft.alignment = PAFontInfo.Right
        break
      default:
        ft.alignment = PAFontInfo.Center
      }

      ft.color = q_to_pa_color(pn.textColor)
      ft.lead = pn.lead
      ft.track = pn.track
      ft.outlineWidth = pn.outlineWidth
      ft.outlineSoft = pn.outlineSoft
      ft.outlineColor = q_to_pa_color(pn.outlineColor)
      ft.aspect = pn.aspect
      ft.opacity = pn.textOpacity
    }
  }

  onVisibleChanged: {
    if (visible) {
      let sequence = UIBrain.mainDocument.currentSequence
      let pn = root.optionPanel
      let ft = editingSequenceFont ? sequence.fontInfo : root.targetTrack.fontInfo
      inter_functions.read_font(ft, pn)
    }
  }

  onAccepted: {
    let sequence = UIBrain.mainDocument.currentSequence
    let pn = root.optionPanel
    let ft = editingSequenceFont ? sequence.fontInfo : root.targetTrack.fontInfo
    inter_functions.save_font(pn, ft)
    UIBrain.mainDocument.justEdited()
  }
}
