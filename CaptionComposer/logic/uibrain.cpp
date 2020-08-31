#include "uibrain.h"

#include "pacifortune/pacifortune.h"

#include <QCoreApplication>
#include <QMutexLocker>

UIBrain::UIBrain(QObject* parent)
  : paci::UILizardBrain(parent) {
  m_settingManager = new SettingManager(this);
  m_networkServer = new NetworkServer(this);

  auto* fortune = new PaciFortune(this);
  fortune->fortunes().append(m_settingManager->userFortunes());
  m_windowTitleExtraString = fortune->pickOne();
  fortune->deleteLater();

  m_document = new MainDocument(this);
  m_document->updateSettingManager(m_settingManager);
  connect(m_document, &MainDocument::messageUpdated, this,
    &UIBrain::setCurrentMessage);
  connect(m_document, &MainDocument::currentPathChanged, [=] {
    this->setWindowTitleExtraString(m_document->currentPath());
  });
}

// paci::Sequence* UIBrain::currentSequence() const{
//  return m_document->currentSequence();
//}

void UIBrain::showMessage(const QString& message) {
  setCurrentMessage(message);
}

void UIBrain::setWindowTitleExtraString(const QString& s) {
  QMutexLocker locker(&m_titleLock);
  auto d = s.simplified();
  if (m_windowTitleExtraString != d) {
    m_windowTitleExtraString = d;
    emit windowTitleChanged(windowTitle());
  }
}

QString UIBrain::windowTitle() const {
  if (m_windowTitleExtraString.isEmpty())
    return QCoreApplication::applicationName();
  QString result = QString("%1 - %2")
                     .arg(QCoreApplication::applicationName())
                     .arg(m_windowTitleExtraString);
  return result;
}

paci::FormatProfiler& UIBrain::formatProfiler() {
  return m_formatProfiler;
}

QString UIBrain::showTime(paci::TimePoint time) const {
  switch (m_currentTimeShowingMode) {
  case Timecode:
    return time.toTimecode(
      mainDocument()->currentSequence()->timebase());
  case Second:
    return QString::number(time.toSeconds());
  case Frame:
    return QString::number(
      time.toFrames(mainDocument()->currentSequence()->timebase()));
  case Timestamp:
    return time.toTimestamp();
  default:
    return QString::number(time.toMillseconds());
  }
}
