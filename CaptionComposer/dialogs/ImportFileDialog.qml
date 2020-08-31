import QtQuick 2.13
import QtQuick.Dialogs 1.3
//import Paci.Core 1.0
import Paci.CaptionComposer 1.0

//import Qt.labs.platform 1.3
FileDialog {
  id: root
  title: qsTr("清选择需要导入的文件")
  folder: shortcuts.documents
  //  folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
  nameFilters: UIBrain.formatProfiler.allLoaderFiltersList
  selectExisting: true
  //  modality: Qt.
  //  fileMode: FileDialog.OpenFile
  onAccepted: {
    UIBrain.mainDocument.importDocument(fileUrl, selectedNameFilter)
    visible = false
  }
}
