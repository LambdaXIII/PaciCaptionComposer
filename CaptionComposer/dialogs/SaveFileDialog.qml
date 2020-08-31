import QtQuick 2.13
import QtQuick.Dialogs 1.3
import Paci.CaptionComposer 1.0

FileDialog {
  id: root
  title: qsTr("清选择要保存到哪")
  folder: shortcuts.documents
  nameFilters: UIBrain.formatProfiler.allSaverFiltersList
  selectExisting: false

  onAccepted: {
    UIBrain.mainDocument.saveDocumentAs(fileUrl, selectedNameFilter)
    visible = false
  }
}
