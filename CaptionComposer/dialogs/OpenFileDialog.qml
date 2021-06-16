import QtQuick 2.14
import Qt.labs.platform 1.1
import Paci.CaptionComposer 1.0

FileDialog {
  id: root
  title: qsTr("清选择需要打开的文件")
  //  folder: shortcuts.documents
  folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
  nameFilters: UIBrain.formatProfiler.allLoaderFiltersList
  //  selectExisting: true
  //  modality: Qt.
  //  fileMode: FileDialog.OpenFile
  onAccepted: {
    console.log(currentFile, selectedNameFilter.index, nameFilters)
    UIBrain.mainDocument.openDocument(currentFile, selectedNameFilter.name)
    visible = false
  }
}
