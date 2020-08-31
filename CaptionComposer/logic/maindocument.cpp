#include "maindocument.h"

#include "warlock/logicpool.h"

#include <QDebug>

MainDocument::MainDocument(QObject* parent)
  : QObject(parent)
  , m_currentSequence(nullptr)
  , m_isWorking(false)
  , m_isEdited(false)
  , m_settingManager(nullptr) {
  connect(this, &MainDocument::progressStarted,
    [this] { this->setIsWorking(true); });
  connect(this, &MainDocument::progressFinished,
    [this] { this->setIsWorking(false); });
  connect(this, &MainDocument::documentOpened, [this] {
    if (this->m_settingManager != nullptr) {
      m_settingManager->addRecentFilePath(currentPath(),
        this->m_formatProfiler.codeOf(this->currentFormat()));
    }
  });
}
/*
MainDocument::~MainDocument() {
    m_jobThread.quit();
    m_jobThread.wait();
}
*/

paci::FormatProfiler::Format MainDocument::currentFormat() const {
  return m_formatProfiler.formatFromFilter(currentFilterString());
}

QString MainDocument::currentFormatName() const {
  return m_formatProfiler.nameOf(
    m_formatProfiler.formatFromFilter(currentFilterString()));
}

bool MainDocument::isAbleToSave() const {
  warlock::LogicPool judge { currentPath().isEmpty(),
    currentFilterString().isEmpty(),
    (! m_formatProfiler.hasSaver(currentFormat())), (! isEdited()) };
  return judge.allWrong();
}

void MainDocument::getSequence(paci::Sequence* sequence) {
  //  qDebug() << "Got the sequence";
  sequence->setParent(this);
  setCurrentSequence(sequence);
  if (m_formatProfiler.hasSaver(
        m_formatProfiler.formatFromFilter(m_filterCache))) {
    setCurrentPath(m_pathCache);
    setCurrentFilterString(m_filterCache);
  }
  emit documentOpened();
  emit progressFinished();
}

void MainDocument::newDocument(QString seqName, int rate, bool df) {
  auto* new_sequence = new paci::Sequence(seqName, this);
  new_sequence->setTimebase(paci::Timebase(rate, df));
  setCurrentSequence(new_sequence);
  setCurrentPath("");
  setCurrentFilterString("");
  m_isEdited = false;
  emit documentOpened();
}

void MainDocument::openDocument(QUrl source, QString selectedFilter) {
  m_pathCache = source.toLocalFile();
  m_filterCache = selectedFilter;
  auto* loader = m_formatProfiler.forgeLoader(source, selectedFilter);

  auto code = m_formatProfiler.codeOf(
    m_formatProfiler.formatFromFilter(m_filterCache));
  paci::ConfigManager confs = m_settingManager->readLoaderConfigs(code);
  loader->config().addOptions(confs);

  connect(loader, &paci::BaseLoader::currentMessageChanged, this,
    &MainDocument::messageUpdated);
  connect(loader, &paci::BaseLoader::currentProgressChanged, this,
    &MainDocument::currentProgressChanged);
  connect(loader, &paci::BaseLoader::totalProgressChanged, this,
    &MainDocument::totalProgressChanged);
  connect(loader, &paci::BaseLoader::started, this,
    &MainDocument::progressStarted);
  connect(loader, &paci::BaseLoader::resultReady, this,
    &MainDocument::getSequence);
  connect(this, &MainDocument::progressFinished, loader,
    &paci::BaseLoader::deleteLater);
  //  m_jobThread.start();
  loader->doWork();
}

void MainDocument::openDocument(
  QUrl source, paci::FormatProfiler::Format format) {
  auto fake_filter = m_formatProfiler.filterOf(format);
  openDocument(source, fake_filter);
}

void MainDocument::saveDocument() {
  if (isAbleToSave()) {
    saveDocumentAs(
      QUrl::fromLocalFile(currentPath()), currentFilterString());
    setIsEdited(false);
  }
}

void MainDocument::saveDocumentAs(
  const QUrl& target, const QString& selectedFilter) {
  auto* saver = m_formatProfiler.forgeSaver(
    currentSequence(), target, selectedFilter);

  auto code = m_formatProfiler.codeOf(
    m_formatProfiler.formatFromFilter(selectedFilter));
  paci::ConfigManager confs = m_settingManager->readSaverConfigs(code);
  saver->config().addOptions(confs);

  connect(saver, &paci::BaseSaver::currentMessageChanged, this,
    &MainDocument::messageUpdated);
  connect(saver, &paci::BaseSaver::currentProgressChanged, this,
    &MainDocument::currentProgressChanged);
  connect(saver, &paci::BaseSaver::totalProgressChanged, this,
    &MainDocument::totalProgressChanged);
  connect(saver, &paci::BaseSaver::started, this,
    &MainDocument::progressStarted);
  //  connect(saver, &paci::BaseSaver::finished, this,
  //          &MainDocument::progressFinished);
  //  connect(&m_jobThread, &QThread::finished, saver,
  //          &paci::BaseSaver::deleteLater);
  connect(saver, &paci::BaseSaver::finished,
    [this, &target, &selectedFilter] {
      emit this->documentSaved();
      this->justSaved();
      if (m_formatProfiler.hasLoader(
            m_formatProfiler.formatFromFilter(selectedFilter))) {
        if (target.toLocalFile() != this->currentPath())
          emit this->documentOpened();
        this->setCurrentPath(target.toLocalFile());
        this->setCurrentFilterString(selectedFilter);
      }
      emit this->progressFinished();
    });
  connect(this, &MainDocument::progressFinished, saver,
    &paci::BaseSaver::deleteLater);

  saver->doWork();
}

void MainDocument::importDocument(QUrl source, QString selectedFilter) {
  emit progressStarted();
  auto* loader = m_formatProfiler.forgeLoader(source, selectedFilter);
  auto code = m_formatProfiler.codeOf(
    m_formatProfiler.formatFromFilter(selectedFilter));
  paci::ConfigManager confs = m_settingManager->readLoaderConfigs(code);
  loader->config().addOptions(confs);
  auto* seq = loader->doWork();
  for (auto* track : *seq->trackManager()) {
    m_currentSequence->trackManager()->appendTrack(track);
  }
  justEdited();
  emit requestRefresh();
  emit progressFinished();
  seq->deleteLater();
}

void MainDocument::justEdited() {
  setIsEdited(true);
}

void MainDocument::justSaved() {
  setIsEdited(false);
}

void MainDocument::loadExampleSequence() {
  emit progressStarted();
  auto* loader = m_formatProfiler.forgeExampleSequenceLoader();
  auto* seq = loader->doWork();
  seq->setParent(this);
  setCurrentPath("");
  setCurrentSequence(seq);
  setCurrentFilterString(
    m_formatProfiler.filterOf(paci::FormatProfiler::PaciProject));
  emit documentOpened();
  emit progressFinished();
}

void MainDocument::toggleAllTracks(bool s) {
  if (m_currentSequence != nullptr)
    for (auto* t : *m_currentSequence->trackManager()) {
      bool old = t->isActivated();
      t->setIsActivated(s);
      if (old != s)
        justEdited();
    }
}

void MainDocument::toggleAllTracks() {
  if (m_currentSequence != nullptr) {
    for (auto* t : *m_currentSequence->trackManager()) {
      bool old = t->isActivated();
      t->setIsActivated(! old);
    }
    justEdited();
  }
}
