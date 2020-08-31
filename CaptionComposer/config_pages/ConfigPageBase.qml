import QtQuick 2.13
import QtQuick.Controls 2.13
import "components"
import Qt.labs.settings 1.1
import Paci.CaptionComposer 1.0

Item {

  id: root

  property string formatCode: "unknown"
  property alias infoViewer: viewer
  property alias loaderSettings: loaderSettings
  property alias saverSettings: saverSettings

  PAConfigInfoViewer {
    id: viewer
    anchors.top: parent.top
    width: parent.width
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: root.verticalCenter
    anchors.bottomMargin: 6
  }

  Settings {
    id: saverSettings
    category: UIBrain.settingManager.formatGroup + "/" + formatCode + "_saver"
  }

  Settings {
    id: loaderSettings
    category: UIBrain.settingManager.formatGroup + "/" + formatCode + "_loader"
  }
}
