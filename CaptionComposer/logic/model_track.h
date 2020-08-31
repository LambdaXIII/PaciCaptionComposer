#ifndef TRACKMODEL_H
#define TRACKMODEL_H

//#include "property_macros.h"
#include "pacicore/track.h"

#include <QAbstractListModel>

class TrackModel: public QAbstractListModel {
  Q_OBJECT
  //  PA_READONLY_PROPERTY(paci::Track*, track,Track)
  Q_PROPERTY(
    paci::Track* track READ track WRITE setTrack NOTIFY trackChanged)

public:
  enum ClipRoles {
    ClipRole = Qt::UserRole + 1,
    StartTimeRole,
    DurationTimeRole,
    EndTimeRole,
    ContentRole,
    ClipIndexRole,
  };
  QHash<int, QByteArray> roleNames() const override;

  explicit TrackModel(
    paci::Track* t = nullptr, QObject* parent = nullptr);

  paci::Track* track() const { return m_track; }

  // Header:
  QVariant headerData(int section, Qt::Orientation orientation,
    int role = Qt::DisplayRole) const override;

  // Basic functionality:
  int rowCount(
    const QModelIndex& parent = QModelIndex()) const override;

  QVariant data(const QModelIndex& index,
    int role = Qt::DisplayRole) const override;

  // Editable:
  bool setData(const QModelIndex& index, const QVariant& value,
    int role = Qt::EditRole) override;

  Qt::ItemFlags flags(const QModelIndex& index) const override;

  // Remove data:
  bool removeRows(int row, int count,
    const QModelIndex& parent = QModelIndex()) override;

signals:
  void trackChanged(paci::Track* track);

protected:
  paci::Track* m_track;

public slots:
  void setTrack(paci::Track* track);
};

#endif // TRACKMODEL_H
