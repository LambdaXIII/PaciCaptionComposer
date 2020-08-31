import QtQuick 2.13
import QtQuick.Controls 2.13
//import CommonQml.Controls 1.0
import Paci.CaptionComposer 1.0
//import CommonQml.PAStyles 1.0
import Qool.Controls 1.0
import Qool.Styles 1.0

QoolControl {
  id: control
  property string documentPath

  showTitle: false

  extraContentPadding: 5
  contentItem: ScrollView {
    clip: true
    TextArea {
      id: coreText
      readOnly: true
      textFormat: Text.RichText
      wrapMode: Text.WrapAtWordBoundaryOrAnywhere
      color: QoolStyle.textColor
    }
  }

  onDocumentPathChanged: refresh()

  Component.onCompleted: {
    if (documentPath != undefined)
      refresh()
  }

  function refresh() {
    coreText.text = CC.readFileText(documentPath)
  }
}
