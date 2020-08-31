#ifndef UIBRAIN_H
#define UIBRAIN_H

#include "maindocument.h"
#include "networkserver.h"
#include "pacibase/property_macros.h"
#include "pacibase/uilizardbrain.h"
#include "settings_manager.h"

#include <QObject>

class UIBrain: public paci::UILizardBrain {
  Q_OBJECT
public:
  enum TimeShowingMode { Timecode, Second, Frame, Timestamp };

  Q_ENUM(TimeShowingMode)

  PA_WRITABLE_PROPERTY(
    TimeShowingMode, currentTimeShowingMode, CurrentTimeShowingMode)
  PA_WRITABLE_PROPERTY(QString, currentMessage, CurrentMessage)
  PA_CONSTANT_PROPERTY(SettingManager*, settingManager)
  PA_CONSTANT_PROPERTY(NetworkServer*, networkServer)

  Q_PROPERTY(MainDocument* mainDocument READ mainDocument CONSTANT)
  Q_PROPERTY(
    QString windowTitle READ windowTitle NOTIFY windowTitleChanged)
  Q_PROPERTY(
    paci::FormatProfiler formatProfiler READ formatProfiler CONSTANT)

public:
  explicit UIBrain(QObject* parent = nullptr);

  MainDocument* mainDocument() const { return m_document; }

  QString windowTitle() const;
  paci::FormatProfiler& formatProfiler();
  Q_INVOKABLE QString showTime(paci::TimePoint time) const;

protected:
  MainDocument* m_document;
  void setWindowTitleExtraString(const QString& s);
  QString m_windowTitleExtraString;
  QMutex m_titleLock;
  paci::FormatProfiler m_formatProfiler { 0 };

signals:
  void wantToCloseMainWindow();
  void wantToEditSequenceFont();
  void wantToEditTrackFont(paci::Track* targetTrack);
  void wantToShowMainPage();
  void windowTitleChanged(const QString& title);
  void wantToRefreshSequenceView();
  void wantToEditSequenceInfo();

public slots:
  void showMessage(const QString& message);
};

#endif // UIBRAIN_H
