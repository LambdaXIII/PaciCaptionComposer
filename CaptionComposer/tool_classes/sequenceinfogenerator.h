#ifndef SEQUENCEINFOGENERATOR_H
#define SEQUENCEINFOGENERATOR_H

//#include "basicmacros.h"
#include "pacicore/sequence.h"

#include <QMap>
#include <QMutex>
#include <QMutexLocker>
#include <QObject>

#define GENPROPS(name)                                                 \
protected:                                                             \
  Q_PROPERTY(QString name READ name NOTIFY infoChanged)                \
public:                                                                \
  QString name() const { return m_data[#name]; }

class SequenceInfoGenerator: public QObject {
  Q_OBJECT
  Q_PROPERTY(paci::Sequence* sequence READ sequence WRITE setSequence
      NOTIFY sequenceChanged)

  GENPROPS(sequenceName)
  GENPROPS(timebaseRate)
  GENPROPS(timebaseDropframe)
  GENPROPS(trackCount)
  GENPROPS(note)
  GENPROPS(globalFontFamily)
  GENPROPS(globalFontSize)
  GENPROPS(clipCount)
  GENPROPS(largestTrackTag)
  GENPROPS(largestTrackClipCount)
  GENPROPS(longestClipDuration)
  GENPROPS(longestClipContent)
  GENPROPS(shortestClipDuration)
  GENPROPS(shortestClipContent)
  GENPROPS(durationTimecode)

  Q_PROPERTY(
    QString sequenceReport READ sequenceReport NOTIFY sequenceChanged)

public:
  explicit SequenceInfoGenerator(QObject* parent = nullptr);
  inline paci::Sequence* sequence() const { return m_sequence; }
  void setSequence(paci::Sequence* seq);
  QString sequenceReport() const;

protected:
  paci::Sequence* m_sequence = nullptr;
  QMap<QString, QString> m_data;
  QMutex m_infoLock;

signals:
  void sequenceChanged();
  void infoChanged();

public slots:
  void updateInfos();
};

#undef GENPROPS

#endif // SEQUENCEINFOGENERATOR_H
