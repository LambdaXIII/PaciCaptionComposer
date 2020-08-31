import QtQuick 2.13
import QtQuick.Controls 2.13
import Qool.Controls 1.0
import Paci.CaptionComposer 1.0
import Qool.FontDesigner 1.0

QoolMenu {
  title: qsTr("帮助")
  signal wantToShowAboutDialog
  Action {
    text: qsTr("帮助主题...")
  }
  Action {
    text: qsTr("关于...")
    onTriggered: wantToShowAboutDialog()
  }
  QoolMenuSeparator {}
  Action {
    text: qsTr("导入范例序列")
    onTriggered: UIBrain.mainDocument.loadExampleSequence()
  }
  Action {
    text: qsTr("Font dialog")
    onTriggered: fdialog.show()
  }

  QoolFontDesignerDialog {
    id: fdialog
  }
}
