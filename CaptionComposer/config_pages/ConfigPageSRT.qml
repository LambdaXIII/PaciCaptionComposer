import QtQuick 2.13
import QtQuick.Controls 2.13
import "components"
import Qt.labs.settings 1.1
import QtQuick.Layouts 1.13


ConfigPageBase {
  id: root

  Component.onCompleted: {
    infoViewer.documentPath = ":/assets/format_informations/srt.cn.html"
  }
  formatCode: "srt"

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
          title: qsTr("Premiere 兼容模式")
          text: checked ? qsTr("尝试兼容旧版PR") : qsTr("输出正常的SRT")
          value: saverSettings.value("premiereCompatible", false)
          onValueChanged: saverSettings.setValue("premiereCompatible", value)
        }
        PAConfigCheckButton {
          title: qsTr("单文件模式")
          text: checked ? qsTr("输出为单独文件") : qsTr("每个轨道分别输出")
          value: saverSettings.value("singleFile", false)
          onValueChanged: saverSettings.setValue("singleFile", value)
        }
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
      } //Column
    }
  } //saverPane
}
