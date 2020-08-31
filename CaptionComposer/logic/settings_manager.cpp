#include "settings_manager.h"

#include <QDebug>
#include <QFileInfo>

SettingManager::SettingManager(QObject* parent)
  : QObject(parent) {
}

const QString SettingManager::m_formatGroup = { "formats" };

FileRecordList SettingManager::recentFilePaths() const {
  FileRecordList result;
  QSettings settings;
  auto code = settings.value("recent_paths").toString();
  if (code.isEmpty())
    return FileRecordList();

  FileRecordList list = FileRecordList::fromStringCode(code);
  for (const auto& record : list) {
    auto p = record.path;
    QFileInfo info(p);
    if (info.exists())
      result << record;
  }
  return result;
}

void SettingManager::addRecentFilePath(
  const QString& path, const QString& format) {
  QSettings settings;
  FileRecord data { path, format };

  auto list = recentFilePaths();
  if (! list.contains(data)) {
    list.append(data);
    while (list.length() > 15)
      list.removeFirst();
    settings.setValue("recent_paths", list.encodeToString());
  }
}

void SettingManager::clearRecentFilePath() {
  QSettings sets;
  sets.remove("recent_paths");
}

void SettingManager::addUserFortune(const QString& s) {
  auto list = userFortunes();
  if (! list.contains(s)) {
    list << s;
    while (list.length() > 100)
      list.removeFirst();
    QSettings sets;
    sets.setValue("user_fortunes", list);
  }
}

void SettingManager::setUserFortunes(const QStringList& list) {
  QSettings sets;
  sets.setValue("user_fortunes", list);
}

void SettingManager::setUserFortunes(const QString& s) {
  QStringList l = s.split("\n");
  setUserFortunes(l);
}

void SettingManager::clearFormatGroup() {
  QSettings sets;
  sets.remove(m_formatGroup);
}

QStringList SettingManager::userFortunes() const {
  QSettings sets;
  return sets.value("user_fortunes").value<QStringList>();
}

paci::ConfigManager SettingManager::readLoaderConfigs(
  const QString& formatCode) const {
  paci::ConfigManager configs;

  QSettings sets;
  QString groupName = m_formatGroup + "/" + formatCode + "_loader";
  sets.beginGroup(groupName);
  auto keys = sets.childKeys();
  for (const auto& k : keys) {
    auto v = sets.value(k);
    if (v.canConvert<bool>()) {
      configs.set<bool>(k, v.value<bool>());
    } else if (v.canConvert<int>()) {
      configs.set<int>(k, v.value<int>());
    } else if (v.canConvert<QString>()) {
      configs.set<QString>(k, v.value<QString>());
    }
  }
  return configs;
}

paci::ConfigManager SettingManager::readSaverConfigs(
  const QString& formatCode) const {
  paci::ConfigManager configs;

  QSettings sets;
  QString groupName = m_formatGroup + "/" + formatCode + "_saver";
  sets.beginGroup(groupName);
  auto keys = sets.childKeys();
  for (const auto& k : keys) {
    auto v = sets.value(k);
    configs.set(k, v);
  }
  sets.endGroup();
  return configs;
}
