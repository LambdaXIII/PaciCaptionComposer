import QtQuick 2.13
import QtQuick.Controls 2.13
import "components"
import Qt.labs.settings 1.1
import QtQuick.Layouts 1.13
//import Qool.Controls 1.0
import Qool.Controls.Inputs 1.0

ConfigPageBase {
  id: root

  Component.onCompleted: {
    infoViewer.documentPath = ":/assets/format_informations/csv.cn.html"
  }
  formatCode: "csv"

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
        PAConfigCheckButton {
          title: qsTr("关于表头")
          text: checked ? qsTr("源文件第一行为表头") : qsTr("源文件没表头")
          value: loaderSettings.value("hasHeader", false)
          onValueChanged: loaderSettings.setValue("hasHeader", value)
        }
        PAConfigTextButton {
          title: qsTr("源文件分隔符")
          value: loaderSettings.value("comma", ",")
          onValueChanged: loaderSettings.setValue("comma", value)
        }
        PAConfigCheckButton {
          title: qsTr("读取额外轨道")
          text: checked ? qsTr("多余的列将读取为额外轨道") : qsTr("多余列将忽略")
          value: loaderSettings.value("loadExtraColumns", true)
          onValueChanged: loaderSettings.setValue("loadExtraColumns", value)
        }
        QoolSwitchControl {
          title: qsTr("表中时间所用单位")

          Layout.preferredHeight: 45
          Layout.preferredWidth: 200
          Layout.fillWidth: true
          Layout.leftMargin: 6
          Layout.rightMargin: 6
          currentIndex: Math.min(3, loaderSettings.value("timeMode", 0))
          tags: [qsTr("毫秒"), qsTr("秒"), qsTr("时间码"), qsTr("非法数值")]
          onCurrentIndexChanged: {
            loaderSettings.setValue("timeMode", currentIndex)
          }
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
          title: qsTr("关于表头")
          text: checked ? qsTr("第一行输出为表头") : qsTr("不输出表头")
          value: saverSettings.value("hasHeader", true)
          onValueChanged: saverSettings.setValue("hasHeader", value)
        }
        PAConfigTextButton {
          title: qsTr("表格分隔符")
          value: saverSettings.value("comma", ",")
          onValueChanged: saverSettings.setValue("comma", value)
        }
      } //Column
    }
  } //saverPane
}
