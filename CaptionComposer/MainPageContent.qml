import QtQuick 2.13
import QtQuick.Controls 2.13

import "main_page"

Item {
  id: root
  MainMenuBar {
    id: menuBar
    z: 99
    anchors.top: parent.top
    anchors.left: parent.left
  }
  SequenceView {
    id: sequenceView

    anchors.top: menuBar.bottom
    anchors.topMargin: 12
    anchors.left: parent.left
    anchors.bottom: parent.bottom
  }
  TrackView {
    //  PAFontOptionPanel {
    //        width: 400
    height: 500
    anchors.top: menuBar.bottom
    anchors.topMargin: 12
    anchors.left: sequenceView.right
    anchors.leftMargin: 12
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    track: sequenceView.selectedTrack
  }
}
