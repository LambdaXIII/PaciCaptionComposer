import QtQuick 2.13
import QtQuick.Controls 2.13
import Paci.CaptionComposer 1.0
import Paci.Core 1.0
import Qool.Controls 1.0

ListView {
  id: root
  width: 100
  property PATrack selectedTrack

  spacing: 6
  clip: true

  Connections {
    target: UIBrain
    function onWantToRefreshSequenceView(){ sequenceModel.totalRefresh()}
  }

  Connections {
    target: UIBrain.mainDocument
    function onRequestRefresh(){ sequenceModel.totalRefresh()}
  }

  SequenceModel {
    id: sequenceModel
    sequence: UIBrain.mainDocument.currentSequence
  }
  model: sequenceModel
  orientation: Qt.Vertical

  delegate: TrackButton {
    id: wrapper
    track: model.track
    trackIndex: model.trackIndex
    clipCount: model.clipCount
    groupName: "trackButtons"
    width: 100
    height: 50
    onClicked: root.selectedTrack = wrapper.track
    onRequestDuplicate: {
      sequenceModel.duplicateTrack(model.trackIndex - 1)
      UIBrain.mainDocument.justEdited()
    }
    onRequestRemove: {
      sequenceModel.removeTrack(model.trackIndex - 1)
      UIBrain.mainDocument.justEdited()
    }
  }

  header: Item {
    SequenceInfoButton {
      sequence: sequenceModel.sequence
      visible: sequenceModel.sequence !== null
      width: 100
      height: 100
    }
    height: 125
  }
}
