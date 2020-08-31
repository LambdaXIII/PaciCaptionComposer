#ifndef BAIDUTRANSAPIHANDLER_H
#define BAIDUTRANSAPIHANDLER_H

#include <QMutex>
#include <QMutexLocker>
#include <QObject>

class BaiduTransAPIHandler: public QObject {
  Q_OBJECT
  Q_PROPERTY(QStringList languages READ langNames CONSTANT)
public:
  explicit BaiduTransAPIHandler(QObject* parent = nullptr);

  Q_INVOKABLE QString forgeQuestFromCode(
    const QString& code, const QString& string);

  Q_INVOKABLE QString forgeQuestFromName(
    const QString& lang_name, const QString& string);

protected:
  static const QString m_language_names_file;
  static const QString m_appID;
  static const QString m_appKey;
  static const QString m_apiAddr;
  QStringList m_langNames, m_langCodes;
  QMutex m_listLock;
  void loadLangNames();
  QStringList langNames();
  QStringList langCodes();
  QString signCode(const QString& q, const QString& salt) const;

signals:

public slots:
};

#endif // BAIDUTRANSAPIHANDLER_H
