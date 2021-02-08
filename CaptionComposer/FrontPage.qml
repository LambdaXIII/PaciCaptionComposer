import QtQuick 2.14
import "front_page"
import "dialogs"
import Paci.CaptionComposer 1.0

Item {
  id: root

  FrontPageRecentFilesPane {
    id: recentFilesPane

    width: 250
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.bottom: parent.bottom
  }

  FrontPageOpenButton {
    id: openButton
    onClicked: {
      openFileDialog.open()
    }
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.right: recentFilesPane.left
    anchors.rightMargin: 6
    anchors.bottom: parent.verticalCenter
    anchors.bottomMargin: 6
  }

  FrontPageNewButton {
    anchors.left: parent.left
    onClicked: newSequenceDialog.open()
    anchors.bottom: parent.bottom
    anchors.right: recentFilesPane.left
    anchors.rightMargin: 6
    anchors.top: parent.verticalCenter
    anchors.topMargin: 6
  }

  OpenFileDialog {
    id: openFileDialog
    onAccepted: {
      UIBrain.wantToShowMainPage()
    }
  }

  NewSequenceDialog {
    id: newSequenceDialog
    onAccepted: UIBrain.wantToShowMainPage()
  }
}
