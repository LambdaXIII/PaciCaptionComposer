#ifndef SEQUENCEMODEL_H
#define SEQUENCEMODEL_H

//#include "basicmacros.h"
#include "pacicore/sequence.h"
//#include "property_macros.h"
#include <QAbstractListModel>

class SequenceModel: public QAbstractListModel {
  Q_OBJECT
  //  PA_WRITABLE_PROPERTY(paci::Sequence*, sequence)
  Q_PROPERTY(paci::Sequence* sequence READ sequence WRITE setSequence
      NOTIFY sequenceChanged)

protected:
  paci::Sequence* m_sequence;

public:
  enum TrackRoles {
    TrackRole = Qt::UserRole + 1,
    TrackIndexRole,
    TimebaseRole,
    ClipCountRole,
    FontInfoRole,
    FontSwitchRole,
    TagRole
  };
  QHash<int, QByteArray> roleNames() const override;

  explicit SequenceModel(
    paci::Sequence* seq = nullptr, QObject* parent = nullptr);

  [[nodiscard]] paci::Sequence* sequence() const { return m_sequence; }

  // Header:
  QVariant headerData(int section, Qt::Orientation orientation,
    int role = Qt::DisplayRole) const override;

  // Basic functionality:
  int rowCount(
    const QModelIndex& parent = QModelIndex()) const override;

  QVariant data(const QModelIndex& index,
    int role = Qt::DisplayRole) const override;
  bool setData(
    const QModelIndex& index, const QVariant& value, int role) override;

signals:
  void sequenceChanged(paci::Sequence* seq);

public slots:
  void setSequence(paci::Sequence* sequence);
  void duplicateTrack(int index);
  void removeTrack(int index);
  void totalRefresh();
};

#endif // SEQUENCEMODEL_H
