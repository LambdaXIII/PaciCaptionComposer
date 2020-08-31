import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.13

import Qool.Controls 1.0
import Paci.CaptionComposer 1.0
import "dialogs"

QoolWindow {
  id: root
  visible: true
  width: 500
  height: 600
  title: UIBrain.windowTitle

  resizable: true

  Loader {
    id: mainWindowContent
    anchors.fill: hiddenBox
  }

  Component.onCompleted: mainWindowContent.source = "FrontPage.qml"

  CloseWindowDialog {
    id: closeWindowDialog
    onCanceled: Qt.quit()
  }

  onClosing: {
    close.accepted = !UIBrain.mainDocument.isEdited
    if (!close.accepted)
      closeWindowDialog.open()
  }

  Connections {
    target: UIBrain
    function onWantToCloseMainWindow() {
      root.close()
    }
    function onWantToEditSequenceFont() {
      fontDesigner.source = fontDesigner.defaultQML
      fontDesigner.item.editingSequenceFont = true
      fontDesigner.item.show()
    }
    function onWantToEditTrackFont() {
      fontDesigner.source = fontDesigner.defaultQML
      fontDesigner.item.editingSequenceFont = false
      fontDesigner.item.targetTrack = targetTrack
      fontDesigner.item.show()
    }
    function onWantToShowMainPage() {
      mainWindowContent.source = "MainPageContent.qml"
    }
    function onWantToEditSequenceInfo() {
      sequenceInfoDialogLoader.source = sequenceInfoDialogLoader.defaultQML
      sequenceInfoDialogLoader.item.show()
    }
  }

  Connections {
    target: UIBrain.mainDocument
    function onDocumentOpened() {
      sequenceInfoDialogLoader.source = ""
    }
  }

  Loader {
    id: fontDesigner
    property string defaultQML: "dialogs/FontDesignerDialog.qml"
  }

  Loader {
    id: sequenceInfoDialogLoader
    property string defaultQML: "dialogs/SequenceInfoDialog.qml"
    onLoaded: {
      item.currentSequence = UIBrain.mainDocument.currentSequence
      item.isEditingCurrentDocument = true
    }
  }
}
