import QtQuick 2.13
import Paci.CaptionComposer 1.0
import Qool.Controls 1.0
import Qool.Styles 1.0

QoolDialogWindow {
  width: 640
  height: 400
  resizable: false
  Image {
    id: image
    x: 25
    y: 25
    width: 256
    height: 256
    source: "qrc:/assets/CaptionComposer_bigicon.png"
    fillMode: Image.PreserveAspectFit
  }

  Column {
    x: 287
    y: 25
    Text {
      id: element
      text: UIBrain.appName
      font.pixelSize: 28
      color: QoolStyle.textColor
    }

    Text {
      id: versionLabel
      text: UIBrain.appVersion
      font.pixelSize: 12
      color: QoolStyle.textColor
    }

    Text {
      id: previewLable
      text: qsTr("试用版")
      color: QoolStyle.negativeColor
      font.pixelSize: 12
      visible: UIBrain.isPreviewVersion
    }
  }

  hasCancelButton: false
  okButton.text: qsTr("看完了")
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

