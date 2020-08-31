import QtQuick 2.13
//import CommonQml.Components 1.0
import CommonQml.PAStyles 1.0
import CommonQml.Controls 1.0
import Paci.CaptionComposer 1.0

Item {
  id: root

  Rectangle {
    color: PAStyle.darkBackgroundColor
    anchors.fill: parent
  }

  PABigProgressBar {
    id: progressBar
    width: Math.max(parent.width / 2, 300)
    anchors.centerIn: parent
  }

  Connections {
    target: UIBrain.mainDocument
    onProgressStarted: root.visible = true
    onProgressFinished: root.visible = false
  }

  Connections {
    enabled: root.visible
    target: UIBrain.mainDocument
    onCurrentProgressChanged: progressBar.currentWork = i
    onTotalProgressChanged: progressBar.totalWork = i
  }
}
