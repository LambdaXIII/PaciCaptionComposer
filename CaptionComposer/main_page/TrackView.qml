import QtQuick 2.13
import QtQuick.Controls 2.13
import Paci.CaptionComposer 1.0
import Paci.Core 1.0
import Qool.Styles 1.0
import Qool.Components 1.0
import Qool.Controls 1.0

QoolControl {
  id: rootPane
  property PATrack track

  backBox.title: track && track.tag ? track.tag : qsTr("没东西呀")
  backBox.imagePath: ":/assets/images/cinema_seats.jpg"
  backBox.imageOpacity: 0.35

  extraContentPadding: 6

  contentItem: Item {
    clip: true
    ListView {
      id: root
      spacing: 6
      orientation: Qt.Vertical

      cacheBuffer: 2000

      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.right: parent.right
      anchors.left: scrollBar.right
      anchors.leftMargin: rootPane.extraContentPadding

      populate: Transition {
        id: popTransition
        SequentialAnimation {
          PropertyAction {
            properties: "x"
            value: root.width
          }
          PauseAnimation {
            duration: popTransition.ViewTransition.index * 50
          }
          NumberAnimation {
            properties: "x"
            duration: 200
            easing.type: Easing.OutQuad
          }
        }
      }

      TrackModel {
        id: trackModel
        track: rootPane.track
      }
      model: trackModel

      Image {
        source: "qrc:/assets/images/没东西.svg"
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
        visible: rootPane.track == null
        Component.onCompleted: {
          let a = root.width / 4
          sourceSize.width = a
          sourceSize.height = a
        }
        opacity: 0.7
      }

      footer: Item {
        height: 25
        width: parent.width
        visible: rootPane.track != null
        SmallIndicator {
          id: footerIndicator
          text: "BOTTOM"
          backColor: QoolStyle.commentColor
          anchors.right: parent.right
          anchors.bottom: parent.bottom
        }
      } //footer

      header: Item {
        height: 25
        width: parent.width
        visible: rootPane.track != null
        SmallIndicator {
          id: headerIndicator
          text: "TOP"
          backColor: QoolStyle.tooltipColor
          anchors.right: parent.right
        }
      } //header

      delegate: ClipInfoButton {
        x: root.width - width
        currentClip: model.clip
        currentClipIndex: model.clipIndex
      }
    } //ListView

    TrackViewScrollBar {
      id: scrollBar
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      width: 25
      currentTrack: rootPane.track
      yPosition: root.visibleArea.yPosition
      heightRatio: root.visibleArea.heightRatio
      MouseArea {
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        anchors.fill: parent
        onClicked: {
          if (mouse.button === Qt.LeftButton) {
            let ratio = mouse.y / (scrollBar.height * (1 - root.visibleArea.heightRatio))
            let offset = Math.floor(trackModel.rowCount() * ratio)
            root.positionViewAtIndex(offset, ListView.Visible)
          } else {
            minimapMenu.popup()
          }
        }
      }

      QoolMenu {
        id: minimapMenu
        showTitle: true
        title: qsTr("跳转")
        Action {
          text: qsTr("跳到头")
          onTriggered: root.positionViewAtBeginning()
        }
        Action {
          text: qsTr("跳到尾")
          onTriggered: root.positionViewAtEnd()
        }
      }
    } //ScrollBar
  } //contentItem
}
