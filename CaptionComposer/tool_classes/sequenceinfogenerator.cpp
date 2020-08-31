#include "sequenceinfogenerator.h"

SequenceInfoGenerator::SequenceInfoGenerator(QObject* parent)
  : QObject(parent) {
}

/*!
 * \brief SequenceInfoGenerator::updateInfos
 * 单独的更新数据的函数
 * 带锁
 */
void SequenceInfoGenerator::updateInfos() {
  if (m_sequence == nullptr)
    return;

  QMutexLocker locke(&m_infoLock);

  m_data["sequenceName"] = m_sequence->sequenceName();

  m_data["timebaseRate"] = QString::number(m_sequence->timebase().rate);
  m_data["timebaseDropframe"] = m_sequence->timebase().dropframe ?
                                  tr("DF", "drop frame") :
                                  tr("", "No dropframe");

  m_data["trackCount"] =
    QString::number(m_sequence->trackManager()->length());
  m_data["note"] = m_sequence->note();

  m_data["globalFontFamily"] = m_sequence->fontInfo()->family();
  m_data["globalFontSize"] =
    QString::number(m_sequence->fontInfo()->size());

  m_data["clipCount"] =
    QString::number(m_sequence->trackManager()->clipCount());

  paci::Track* largestTrack = nullptr;
  for (auto* t : *(m_sequence->trackManager())) {
    if (largestTrack == nullptr)
      largestTrack = t;
    else if (largestTrack->length() < t->length())
      largestTrack = t;
  }

  m_data["largestTrackTag"] =
    largestTrack ? largestTrack->tag() : tr("无");
  m_data["largestTrackClipCount"] =
    largestTrack ? QString::number(largestTrack->length()) : tr("无");

  paci::Clip* longest_clip = nullptr;
  paci::Clip* shortest_clip = nullptr;
  for (auto* t : *(m_sequence->trackManager()))
    for (auto* c : *t) {
      if (longest_clip == nullptr
          || c->durationTime() >= longest_clip->durationTime())
        longest_clip = c;
      if (shortest_clip == nullptr
          || c->durationTime() < shortest_clip->durationTime())
        shortest_clip = c;
    }
  m_data["longestClipDuration"] =
    longest_clip ?
      QString::number(longest_clip->durationTime().toSeconds()) :
      tr("无");
  m_data["longestClipContent"] =
    longest_clip ? longest_clip->content() : tr("无");
  m_data["shortestClipDuration"] =
    shortest_clip ?
      QString::number(shortest_clip->durationTime().toSeconds()) :
      tr("无");
  m_data["shortestClipContent"] =
    shortest_clip ? shortest_clip->content() : tr("无");

  m_data["durationTimecode"] =
    m_sequence->durationTime().toTimecode(m_sequence->timebase());

  emit infoChanged();
}

void SequenceInfoGenerator::setSequence(paci::Sequence* seq) {
  if (seq != nullptr && seq != m_sequence) {
    m_sequence = seq;
    connect(m_sequence, &paci::Sequence::fullRefreshTriggered, this,
      &SequenceInfoGenerator::updateInfos);

    emit sequenceChanged();
    updateInfos();
  }
}

QString SequenceInfoGenerator::sequenceReport() const {
  QStringList reports;
  reports << tr("序列报告") << tr("序列名称：%1").arg(sequenceName())
          << tr("序列时基：%1").arg(timebaseRate());
  // TODO:Maybe I don't need this.
  return reports.join("\n");
}
