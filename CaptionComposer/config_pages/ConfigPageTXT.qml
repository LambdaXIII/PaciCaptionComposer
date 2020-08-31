import QtQuick 2.13
import QtQuick.Controls 2.13
import "components"
import Qt.labs.settings 1.1
import QtQuick.Layouts 1.13

ConfigPageBase {
  id: root

  Component.onCompleted: {
    infoViewer.documentPath = ":/assets/format_informations/plaintext.cn.html"
  }
  formatCode: "plaintext"
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
        PAConfigNumberButton {
          Layout.fillWidth: true
          title: qsTr("最短片段长度")
          value: loaderSettings.value("minimumClipDuration", 48)
          unit: qsTr("帧")
          onValueChanged: loaderSettings.setValue("minimumClipDuration", value)
          decimals: 0
        }

        PAConfigNumberButton {
          Layout.fillWidth: true
          title: qsTr("每个字的时长")
          value: loaderSettings.value("durationPerChar", 3)
          unit: qsTr("帧")
          onValueChanged: loaderSettings.setValue("durationPerChar", value)
          decimals: 0
        }

        PAConfigNumberButton {
          Layout.fillWidth: true
          title: qsTr("片段间隔")
          value: loaderSettings.value("spaceBetweenClips", 0)
          unit: qsTr("帧")
          onValueChanged: loaderSettings.setValue("spaceBetweenClips", value)
          decimals: 0
        }

        PAConfigTimebaseButton {
          Layout.fillWidth: true
          title: qsTr("读取时基")
          rate: loaderSettings.value('defaultTBRate', 24)
          df: loaderSettings.value("defaultDropframe", false)
          onRateChanged: loaderSettings.setValue("defaultTBRate", rate)
          onDfChanged: loaderSettings.setValue("defaultDropframe", df)
        }
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
          title: qsTr("跳过空片段")
          text: checked ? qsTr("跳过空白的片段") : qsTr("空白片段将输出为空行")
          value: saverSettings.value("skipEmptyClip", false)
          onValueChanged: saverSettings.setValue("skipEmptyClip", value)
        }
        PAConfigCheckButton {
          //          Layout.fillWidth: true
          title: qsTr("跳过时长为零的片段")
          text: checked ? qsTr("跳过时长为0的片段") : qsTr("输出时长为0的片段")
          value: saverSettings.value("skipZeroDurationClip", false)
          onValueChanged: saverSettings.setValue("skipZeroDurationClip", value)
        }
        PAConfigCheckButton {
          //          Layout.fillWidth: true
          title: qsTr("跳过未激活项目")
          text: checked ? qsTr("跳过未激活的片段或轨道") : qsTr("仍然输出未激活的项目")
          value: saverSettings.value("skipDisabledStuff", false)
          onValueChanged: saverSettings.setValue("skipDisabledStuff", value)
        }
      }
    }
  } //saverPane
}
