#include "model_sequence.h"

SequenceModel::SequenceModel(paci::Sequence* seq, QObject* parent)
  : QAbstractListModel(parent)
  , m_sequence(seq) {
}

QVariant SequenceModel::headerData(
  int section, Qt::Orientation orientation, int role) const {
  Q_UNUSED(section)
  if (role == Qt::DisplayRole) {
    if (orientation == Qt::Horizontal)
      return tr("轨道");
  }
  return QVariant();
}

QHash<int, QByteArray> SequenceModel::roleNames() const {
  QHash<int, QByteArray> roles;
  roles[TrackRole] = "track";
  roles[TimebaseRole] = "timebase";
  roles[ClipCountRole] = "clipCount";
  roles[TrackIndexRole] = "trackIndex";
  roles[FontInfoRole] = "fontInfo";
  roles[FontSwitchRole] = "fontSwitch";
  roles[TagRole] = "tag";
  return roles;
}

int SequenceModel::rowCount(const QModelIndex& parent) const {
  // For list models only the root node (an invalid parent) should
  // return the list's size. For all other (valid) parents, rowCount()
  // should return 0 so that it does not become a tree model.
  if (parent.isValid())
    return 0;

  if (m_sequence == nullptr)
    return 0;

  return m_sequence->trackManager()->length();
}

QVariant SequenceModel::data(const QModelIndex& index, int role) const {
  if (! index.isValid() || m_sequence == nullptr)
    return QVariant();

  int row = index.row();
  auto* mng = m_sequence->trackManager();
  paci::Track* track = mng->at(row);

  switch (role) {
  case TagRole:
  case Qt::DisplayRole:
    return track->tag();
  case TrackRole:
    return QVariant::fromValue<paci::Track*>(track);
  case TimebaseRole:
    return QVariant::fromValue<paci::Timebase>(m_sequence->timebase());
  case ClipCountRole:
    return track->length();
  case FontInfoRole:
    return QVariant::fromValue<paci::FontInfo*>(track->fontInfo());
  case FontSwitchRole:
    return track->fontSwitch();
  case TrackIndexRole:
    return row + 1;
  default:
    return QVariant();
  }
}

bool SequenceModel::setData(
  const QModelIndex& index, const QVariant& value, int role) {
  if ((! index.isValid()) || m_sequence == nullptr)
    return false;

  int row = index.row();
  auto* track = m_sequence->trackManager()->at(row);
  auto result = true;

  switch (role) {
  case Qt::DisplayRole:
  case TagRole:
    track->setTag(value.toString());
  default:
    result = false;
  }

  if (result)
    emit dataChanged(index, index, { role });
  return result;
}

void SequenceModel::setSequence(paci::Sequence* seq) {
  if (m_sequence != seq) {
    beginResetModel();
    m_sequence = seq;
    emit sequenceChanged(m_sequence);
    endResetModel();
  }
}

void SequenceModel::duplicateTrack(int index) {
  auto row_count = rowCount();
  beginInsertRows(QModelIndex(), row_count, row_count);
  auto track = m_sequence->trackManager()->at(index);
  auto track2 = new paci::Track(track);
  track2->setTag(tr("%1_副本").arg(track->tag()));
  m_sequence->trackManager()->appendTrack(track2);
  endInsertRows();
}

void SequenceModel::removeTrack(int index) {
  beginRemoveRows(QModelIndex(), index, index);
  m_sequence->trackManager()->removeTrackAt(index);
  endRemoveRows();
}

void SequenceModel::totalRefresh() {
  beginResetModel();
  endResetModel();
}
