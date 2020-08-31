import QtQuick 2.13
import QtQuick.Controls 2.13
import Qool.Styles 1.0
import Qool.Controls 1.0
import Qool.Components 1.0
import Paci.Core 1.0
import Paci.CaptionComposer 1.0

QoolAbstractButton {
  id: root
  property PATrack track
  property real trackIndex
  property string trackTag: track.tag
  property int clipCount
  showTitle: false
  checkable: true
  checked: false

  signal requestDuplicate
  signal requestRemove

  QtObject {
    id: themeControl
    property color textColor: root.checked ? QoolStyle.highlightColor : QoolStyle.textColor
    property color dimedColor: Qt.darker(textColor, 1.2)
  }

  backBox.strokeColor: root.checked ? QoolStyle.highlightColor : QoolStyle.backgroundStrokeColor

  onClicked: checked = true

  contentItem: Item {
    Text {
      id: indexText
      text: "#" + root.trackIndex
      font.pixelSize: QoolStyle.tooltipTextFontPixelSize
      color: themeControl.dimedColor
      anchors.top: parent.top
      anchors.right: parent.right
      horizontalAlignment: Text.AlignRight
    }
    Text {
      id: clipCountText
      text: root.clipCount
      font.pixelSize: QoolStyle.tooltipTextFontPixelSize
      color: themeControl.dimedColor
      horizontalAlignment: Text.AlignLeft
      anchors.bottom: parent.bottom
      anchors.left: parent.left
    }
    Text {
      id: fontSwitchText
      text: qsTr("独立字体")
      font.pixelSize: QoolStyle.tooltipTextFontPixelSize
      color: themeControl.dimedColor
      horizontalAlignment: Text.AlignRight
      anchors.bottom: parent.bottom
      anchors.right: parent.right
      visible: track.fontSwitch
    }
    Text {
      id: tagText
      text: root.trackTag == "" ? qsTr("(无名)") : root.trackTag
      font.pixelSize: 45
      color: themeControl.textColor
      fontSizeMode: Text.Fit
      elide: Text.ElideNone
      wrapMode: Text.NoWrap
      anchors.horizontalCenter: parent.horizontalCenter
      width: parent.width
      anchors.top: indexText.bottom
      anchors.bottom: clipCountText.top
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      visible: !tagNameField.visible
      z: 20
      DisabledCover {
        z: 10
        anchors.fill: parent
        visible: !track.isActivated
        text: qsTr("未激活")
      }
    }
  } //contentItem

  QoolTextField {
    z: 80
    id: tagNameField
    width: tagText.width
    height: tagText.height
    x: tagText.x
    y: tagText.y
    visible: false
    onEditingFinished: {
      if (trackTag !== text) {
        root.track.tag = text
        UIBrain.mainDocument.justEdited()
      }
      tagNameField.visible = false
    }
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    anchors.fill: parent.contentItem
  }

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.RightButton
    onClicked: contextMenu.popup()
    z: 30
  }

  QoolMenu {
    id: contextMenu
    showTitle: true
    title: qsTr("轨道详情与设置")
    //    onAboutToShow: console.log(contextMenu
    QoolMenuBanner {
      text: root.trackTag
    }
    Action {
      checkable: true
      checked: root.track.isActivated
      text: checked ? qsTr("已激活") : qsTr("未激活")
      onTriggered: {
        if (root.track.isActivated !== checked) {
          root.track.isActivated = checked
          UIBrain.mainDocument.justEdited()
        }
      }
    }
    Action {
      text: qsTr("重命名...")
      onTriggered: {
        tagNameField.text = trackTag
        tagNameField.selectAll()
        tagNameField.visible = true
        tagNameField.forceActiveFocus()
      }
    }
    Action {
      checkable: true
      text: checked ? qsTr("独立字体已激活") : qsTr("独立字体未激活")
      Component.onCompleted: checked = track.fontSwitch
      onToggled: {
        if (track.fontSwitch !== checked) {
          track.fontSwitch = checked
          UIBrain.mainDocument.justEdited()
        }
      }
    }
    Action {
      text: qsTr("独立字体设置")
      onTriggered: UIBrain.wantToEditTrackFont(root.track)
    }
    QoolMenuSeparator {}
    Action {
      text: qsTr("复制轨道")
      onTriggered: root.requestDuplicate()
    }
    Action {
      text: qsTr("删除轨道（不可撤销）")
      onTriggered: root.requestRemove()
    }
    QoolMenuSeparator {}
    Action {
      text: qsTr("禁用全部轨道")
      onTriggered: {
        UIBrain.mainDocument.toggleAllTracks(false)
      }
    }
    Action {
      text: qsTr("反选全部轨道")
      onTriggered: {
        UIBrain.mainDocument.toggleAllTracks()
      }
    }
  }
}
