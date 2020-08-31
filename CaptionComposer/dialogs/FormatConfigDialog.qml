import QtQuick 2.13
//import CommonQml.Controls 1.0
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
//import CommonQml.PAStyles 1.0
import Paci.CaptionComposer 1.0
import Qool.Controls 1.0
import Qool.Styles 1.0

QoolDialogWindow {
  id: root
  width: 700
  height: 800

  title: qsTr("各个格式说明及选项")

  ListModel {
    id: formatListModel
    ListElement {
      name: qsTr("普通文本文件")
      url: "qrc:/config_pages/ConfigPageTXT.qml"
    }
    ListElement {
      name: qsTr("Fcp7 XML 文件")
      url: "qrc:/config_pages/ConfigPageFCP7XML.qml"
    }
    ListElement {
      name: qsTr("iTT 字幕")
      url: "qrc:/config_pages/ConfigPageITT.qml"
    }
    ListElement {
      name: qsTr("Flame XML 文件")
      url: "qrc:/config_pages/ConfigPageFlameXML.qml"
    }
    ListElement {
      name: qsTr("CSV 表格")
      url: "qrc:/config_pages/ConfigPageCSV.qml"
    }
    ListElement {
      name: qsTr("SRT 字幕")
      url: "qrc:/config_pages/ConfigPageSRT.qml"
    }
  }

  hasCancelButton: false
  onAccepted: root.close()
  QoolDialogButton {
    parent: root.toolBarRow
    text: qsTr("重置所有选项")
    onClicked: {
      UIBrain.settingManager.clearFormatGroup()
      buttonGroup.checkedButton.checked = false
      pageLoader.source = ""
    }
  }

  Item {
    id: contentItem
    anchors.fill: hiddenBox

    QoolControl {
      id: list
      title: qsTr("格式列表")
      showTitle: true
      extraContentPadding: 6
      width: 180
      height: parent.height

      contentItem: ListView {
        model: formatListModel
        spacing: 6
        delegate: QoolButton {
          checkable: true
          width: parent.width
          height: 25
          backBox.cutSize: 5
          groupName: "config_page_format_button"
          text: model.name
          onClicked: pageLoader.source = model.url
          showTitle: false
          horizontalAlignment: Text.AlignRight
          //          backBox.backColor: QoolStyle.controlBackgroundColor2
          backBox.strokeColor: checked ? QoolStyle.infoColor : QoolStyle.backgroundStrokeColor
          backBox.strokeWidth: 1
        }
      }
    }

    Loader {
      id: pageLoader
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.right: parent.right
      anchors.left: list.right
      anchors.leftMargin: 6
    }
  } //contentItem
}
