#include "model_track.h"

TrackModel::TrackModel(paci::Track* t, QObject* parent)
  : QAbstractListModel(parent)
  , m_track(t) {
}

 void TrackModel::setTrack(paci::Track *track) {
  if (m_track != track) {
    beginResetModel();
    m_track = track;
    emit trackChanged(m_track);
    endResetModel();
  }
}

QHash<int, QByteArray> TrackModel::roleNames() const {
  QHash<int, QByteArray> roles;
  roles[ClipRole] = "clip";
  roles[StartTimeRole] = "startTime";
  roles[DurationTimeRole] = "durationTime";
  roles[EndTimeRole] = "endTime";
  roles[ContentRole] = "content";
  roles[ClipIndexRole] = "clipIndex";
  return roles;
}

QVariant TrackModel::headerData(
  int section, Qt::Orientation orientation, int role) const {
  if (role == Qt::DisplayRole) {
    if (orientation == Qt::Horizontal)
      return tr("片段");
    else
      return QString::number(section + 1);
  }
  return QVariant();
}

int TrackModel::rowCount(const QModelIndex& parent) const {
  // For list models only the root node (an invalid parent) should
  // return the list's size. For all other (valid) parents, rowCount()
  // should return 0 so that it does not become a tree model.
  if (parent.isValid() || m_track == nullptr)
    return 0;

  return m_track->length();
}

QVariant TrackModel::data(const QModelIndex& index, int role) const {
  if ((! index.isValid()) || m_track == nullptr)
    return QVariant();

  int row = index.row();
  auto* clip = m_track->at(row);

  switch (role) {
  case Qt::DisplayRole:
  case ContentRole:
    return clip->content();
  case ClipRole:
    return QVariant::fromValue(clip);
  case StartTimeRole:
    return QVariant::fromValue(clip->startTime());
  case DurationTimeRole:
    return QVariant::fromValue(clip->durationTime());
  case EndTimeRole:
    return QVariant::fromValue(clip->endTime());
  case ClipIndexRole:
    return row + 1;
  }

  return QVariant();
}

bool TrackModel::setData(
  const QModelIndex& index, const QVariant& value, int role) {
  if (data(index, role) != value) {
    auto* clip = m_track->at(index.row());
    switch (role) {
    case StartTimeRole:
      clip->setStartTime(value.value<paci::TimePoint>());
    case DurationTimeRole:
      clip->setDurationTime(value.value<paci::TimePoint>());
    case EndTimeRole:
      clip->setEndTime(value.value<paci::TimePoint>());
    case ContentRole:
      clip->setContent(value.toString());
    default:
      return false;
    }
    emit dataChanged(index, index, QVector<int>() << role);
    return true;
  }
  return false;
}

Qt::ItemFlags TrackModel::flags(const QModelIndex& index) const {
  if (! index.isValid() || m_track == nullptr)
    return Qt::NoItemFlags;

  return Qt::ItemIsEditable;
}

bool TrackModel::removeRows(
  int row, int count, const QModelIndex& parent) {
  beginRemoveRows(parent, row, row + count - 1);
  for (int i = 0; i < count; ++i)
    m_track->removeAt(row);
  endRemoveRows();
  return true;
}
