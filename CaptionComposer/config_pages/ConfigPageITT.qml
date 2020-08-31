import QtQuick 2.13
import QtQuick.Controls 2.13
import "components"
import Qt.labs.settings 1.1
import QtQuick.Layouts 1.13

//import CommonQml.Controls 1.0
//import CommonQml.PAStyles 1.0
ConfigPageBase {
  id: root

  Component.onCompleted: {
    infoViewer.documentPath = ":/assets/format_informations/iTT.cn.html"
  }
  formatCode: "iTT"
  PAConfigPane {
    id: loaderPane
    anchors.right: parent.horizontalCenter
    anchors.left: parent.left
    anchors.top: parent.verticalCenter
    anchors.bottom: parent.bottom
    anchors.rightMargin: 3
    showTitle: true
    title: qsTr("读取选项")

    contentItem: Item {
      PAConfigTimebaseButton {
        width: 200
        height: 45
        anchors.centerIn: parent
        title: qsTr("读取时使用的时基")
        rate: loaderSettings.value("defaultRate", 24)
        df: loaderSettings.value("defaultDropframe", false)
        onRateChanged: loaderSettings.setValue("defaultRate", rate)
        onDfChanged: loaderSettings.setValue("defaultDropframe", df)
      }
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
          title: qsTr("导出时基与当前序列一致")
          enabled: false
          text: qsTr("是的")
          checked: true
          Layout.preferredWidth: 200
          Layout.preferredHeight: 45
          disableInfo: qsTr("不让改")
        }
      } //Column
    }
  } //saverPane
}
