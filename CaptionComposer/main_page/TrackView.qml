import QtQuick 2.13
import QtQuick.Controls 2.13
import Paci.CaptionComposer 1.0
import Paci.Core 1.0
import Qool.Styles 1.0
import Qool.Components 1.0
import Qool.Controls 1.0

Pane {
  id: rootPane
  property PATrack track

  background: CutCornerBox {
    imagePath: ":/assets/images/cinema_seats.jpg"
    imageOpacity: 0.35
    anchors.fill: parent
  }
  padding: 6
  contentItem: ListView {
    id: root

    width: 300

    clip: true
    spacing: 6
    orientation: Qt.Vertical

    property real implicitContentWidth: Math.min(300,
                                                 root.width - scrollBar.width)

    cacheBuffer: 800

    populate: Transition {
      id: popTransition
      SequentialAnimation {
        PropertyAction {
          properties: "y"
          value: popTransition.ViewTransition.destination.y + root.height
        }

        PauseAnimation {
          duration: popTransition.ViewTransition.index * 100
        }

        NumberAnimation {
          properties: "y"
          duration: 500
          easing.type: Easing.Bezier
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
      height: 50
      width: root.implicitContentWidth
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.horizontalCenterOffset: 0 - scrollBar.width / 2
      CutCornerBox {
        anchors.bottom: parent.bottom
        cutSize: 5
        width: parent.width
        height: 15
        backColor: QoolStyle.highlightColor
        hasStroke: false
      }
      visible: rootPane.track != null
    }

    header: Item {
      height: 50
      width: root.implicitContentWidth
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.horizontalCenterOffset: 0 - scrollBar.width / 2
      CutCornerBox {
        //        anchors.bottom: parent.bottom
        cutSize: 5
        width: parent.width
        height: 15
        backColor: QoolStyle.infoColor
        hasStroke: false
        Text {
          text: rootPane.track && rootPane.track.tag ? rootPane.track.tag : ""
          anchors.centerIn: parent
          color: QoolStyle.backgroundColor
        }
      }
      visible: rootPane.track != null
    }

    delegate: ClipInfoButton {
      currentClip: model.clip
      currentClipIndex: model.clipIndex
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.horizontalCenterOffset: 0 - scrollBar.width / 2
      width: root.implicitContentWidth
      height: 65
    }

    TrackViewScrollBar {
      id: scrollBar
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.right: parent.right
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
  }
}
