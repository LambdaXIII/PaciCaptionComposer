import QtQuick 2.13
import QtQuick.Controls 2.13
import "components"
import Qt.labs.settings 1.1
import QtQuick.Layouts 1.13

//import Qool.Controls 1.0
ConfigPageBase {
  id: root

  Component.onCompleted: {
    infoViewer.documentPath = ":/assets/format_informations/fcp7xml.cn.html"
  }
  formatCode: "fcp7xml"

  PAConfigPane {
    id: loaderPane
    anchors.right: parent.horizontalCenter
    anchors.left: parent.left
    anchors.top: parent.verticalCenter
    anchors.bottom: parent.bottom
    anchors.rightMargin: 3
    showTitle: true
    title: qsTr("读取选项")

    contentItem: ScrollView {
      clip: true
      ColumnLayout {
        spacing: 6
        PAConfigCheckButton {
          title: qsTr("读取UUID")
          text: checked ? qsTr("尝试读取源文件中的UUID") : qsTr("忽略原始UUID")
          value: loaderSettings.value("readUUID", false)
          onValueChanged: loaderSettings.setValue("readUUID", value)
        }
        PAConfigCheckButton {
          title: qsTr("跳过空片段")
          text: checked ? qsTr("跳过空白的片段") : qsTr("空白片段也会导入")
          value: loaderSettings.value("skipEmptyClip", false)
          onValueChanged: loaderSettings.setValue("skipEmptyClip", value)
        }
        PAConfigCheckButton {
          title: qsTr("跳过时长为零的片段")
          text: checked ? qsTr("跳过时长为0的片段") : qsTr("导入时长为0的片段")
          value: loaderSettings.value("skipZeroDurationClip", false)
          onValueChanged: loaderSettings.setValue("skipZeroDurationClip", value)
        }
        PAConfigCheckButton {
          title: qsTr("跳过未激活项目")
          text: checked ? qsTr("跳过未激活的片段或轨道") : qsTr("原样导入未激活的项目")
          value: loaderSettings.value("skipDisabledStuff", false)
          onValueChanged: loaderSettings.setValue("skipDisabledStuff", value)
        }
      } //column
    }
  } //loaderpane

  PAConfigPane {
    id: saverPane
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    anchors.top: parent.verticalCenter
    anchors.bottom: parent.bottom
    anchors.leftMargin: 3
    showTitle: true
    title: qsTr("保存选项")
    contentItem: ScrollView {
      clip: true
      ColumnLayout {
        spacing: 6
        PAConfigCheckButton {
          title: qsTr("关于空片段")
          text: checked ? qsTr("跳过空白的片段") : qsTr("仍然输出空白的片段")
          value: saverSettings.value("skipEmptyClip", false)
          onValueChanged: saverSettings.setValue("skipEmptyClip", value)
        }
        PAConfigCheckButton {
          title: qsTr("跳过时长为零的片段")
          text: checked ? qsTr("跳过时长为0的片段") : qsTr("仍然输出时长为0的片段")
          value: saverSettings.value("skipZeroDurationClip", false)
          onValueChanged: saverSettings.setValue("skipZeroDurationClip", value)
        }
        PAConfigCheckButton {
          title: qsTr("跳过未激活项目")
          text: checked ? qsTr("跳过未激活的片段或轨道") : qsTr("输出未激活的片段或轨道")
          value: saverSettings.value("skipDisabledStuff", false)
          onValueChanged: saverSettings.setValue("skipDisabledStuff", value)
        }
        PAConfigCheckButton {
          title: qsTr("未激活的片段")
          text: checked ? qsTr("强行激活所有片段") : qsTr("原样输出")
          value: saverSettings.value("forceEnableClips", false)
          onValueChanged: saverSettings.setValue("forceEnableClips", value)
        }
        PAConfigCheckButton {
          title: qsTr("文字片段形式")
          text: checked ? qsTr("输出为空心字") : qsTr("输出为文本")
          value: saverSettings.value("outlineTextMode", true)
          onValueChanged: saverSettings.setValue("outlineTextMode", value)
        }
      } //Column
    }
  } //saverPane
}
