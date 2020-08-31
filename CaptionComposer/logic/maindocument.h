#ifndef MAINDOCUMENT_H
#define MAINDOCUMENT_H

#include "pacibase/property_macros.h"
#include "pacicore/sequence.h"
#include "paciformat/formatprofiler.h"
#include "settings_manager.h"

#include <QMutexLocker>
#include <QObject>
#include <QThread>
#include <optional>

class MainDocument: public QObject {
  Q_OBJECT

  PA_WRITABLE_PROPERTY(
    paci::Sequence*, currentSequence, CurrentSequence)

  PA_WRITABLE_PROPERTY(QString, currentPath, CurrentPath)
  PA_WRITABLE_PROPERTY(bool, isWorking, IsWorking)
  PA_WRITABLE_PROPERTY(
    QString, currentFilterString, CurrentFilterString)
  PA_WRITABLE_PROPERTY(bool, isEdited, IsEdited)
  PA_READONLY_PROPERTY(SettingManager*, settingManager, SettingManager)

  Q_PROPERTY(paci::FormatProfiler::Format currentFormat READ
      currentFormat NOTIFY currentFilterStringChanged)
  Q_PROPERTY(QString currentFormatName READ currentFormatName NOTIFY
      currentFilterStringChanged)
  Q_PROPERTY(bool isAbleToSave READ isAbleToSave NOTIFY isEditedChanged)

public:
  explicit MainDocument(QObject* parent = nullptr);
  //  ~MainDocument() override;
  [[nodiscard]] paci::FormatProfiler::Format currentFormat() const;
  [[nodiscard]] QString currentFormatName() const;
  [[nodiscard]] bool isAbleToSave() const;

protected:
  //  QThread m_jobThread;
  paci::FormatProfiler m_formatProfiler;
  QString m_pathCache;
  QString m_filterCache;

signals:
  //  void currentSequenceChanged(paci::Sequence* sequence);
  //  void currentPathChanged(const QString& path);
  void currentProgressChanged(int i);
  void totalProgressChanged(int i);
  void progressStarted();
  void progressFinished();
  //  void isWorkingChanged(bool working);
  //  void currentFilterStringChanged(const QString& filterString);
  //  void currentFormatChanged(paci::FormatProfiler::Format);
  //  void isEditedChanged(bool edited);
  void documentSaved();
  void documentOpened();
  void messageUpdated(QString msg);
  void requestRefresh();

public slots:
  void newDocument(QString seqName, int rate = 24, bool df = false);
  void openDocument(QUrl source, QString selectedFilter);
  void openDocument(QUrl source, paci::FormatProfiler::Format format);
  void saveDocument();
  void saveDocumentAs(
    const QUrl& target, const QString& selectedFilter);
  void importDocument(QUrl source, QString selectedFilter);
  void justEdited();
  void justSaved();
  void loadExampleSequence();

  void toggleAllTracks(bool s);
  void toggleAllTracks();

protected slots:
  void getSequence(paci::Sequence* sequence);
};

#endif // MAINDOCUMENT_H
