#ifndef SETTINGS_MANAGER_H
#define SETTINGS_MANAGER_H

#include "global_defs.h"
#include "pacicore/configmanager.h"
#include "tool_classes/filerecordlist.h"

#include <QObject>
#include <QSettings>

class SettingManager: public QObject {
  Q_OBJECT
  Q_PROPERTY(
    FileRecordList recentFileList READ recentFilePaths CONSTANT)
  Q_PROPERTY(QString formatGroup MEMBER m_formatGroup CONSTANT)

public:
  explicit SettingManager(QObject* parent = nullptr);

  FileRecordList recentFilePaths() const;

  Q_INVOKABLE QStringList userFortunes() const;

  paci::ConfigManager readLoaderConfigs(
    const QString& formatCode) const;

  paci::ConfigManager readSaverConfigs(const QString& formatCode) const;

  const static QString m_formatGroup;

public slots:
  void addRecentFilePath(const QString& path, const QString& format);
  void clearRecentFilePath();
  void addUserFortune(const QString& s);
  void setUserFortunes(const QStringList& list);
  void setUserFortunes(const QString& s);
  void clearFormatGroup();
};

#endif // SETTINGS_MANAGER_H
