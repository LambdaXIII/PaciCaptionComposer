#include "baidutransapihandler.h"

#include <QCryptographicHash>
#include <QFile>
#include <QTextStream>

BaiduTransAPIHandler::BaiduTransAPIHandler(QObject* parent)
  : QObject(parent) {
}

QString BaiduTransAPIHandler::forgeQuestFromCode(
  const QString& code, const QString& string) {
  auto q = string;
  //  auto from = "auto";
  auto to = code;
  auto salt = "1234567";
  auto md5code = signCode(q, salt);
  QString result = m_apiAddr + "?" + "q=" + string
                   + "&from=auto&to=" + code + "&appid=" + m_appID
                   + "&salt=" + salt + "&sign=" + md5code;
  return result;
}

QString BaiduTransAPIHandler::forgeQuestFromName(
  const QString& lang_name, const QString& string) {
  auto n = langNames().indexOf(lang_name);
  auto code = langCodes().at(n);
  return forgeQuestFromCode(code, string);
}

void BaiduTransAPIHandler::loadLangNames() {
  QMutexLocker locker(&m_listLock);
  if (! m_langCodes.isEmpty())
    m_langCodes.clear();
  if (! m_langNames.isEmpty())
    m_langNames.clear();
  QString langFile(m_language_names_file); // TODO: 多语言化
  QFile f(langFile);
  if (! f.open(QFile::ReadOnly | QFile::Text)) {
    throw tr("百度语言文件读取错误");
  }

  QTextStream s(&f);
  while (! s.atEnd()) {
    auto line = s.readLine();
    auto ps = line.split(" ");
    auto code = ps.first().simplified();
    auto name = ps.last().simplified();
    if (code != "auto") {
      m_langNames << name;
      m_langCodes << code;
    }
  }
  f.close();
}

QStringList BaiduTransAPIHandler::langNames() {
  if (m_langNames.isEmpty())
    loadLangNames();
  return m_langNames;
}

QStringList BaiduTransAPIHandler::langCodes() {
  if (m_langCodes.isEmpty())
    loadLangNames();
  return m_langCodes;
}

QString BaiduTransAPIHandler::signCode(
  const QString& q, const QString& salt) const {
  QCryptographicHash hasher(QCryptographicHash::Md5);
  QString code = m_appID + q + salt + m_appKey;
  hasher.addData(code.toStdString().c_str());
  return hasher.result().toHex();
}

const QString BaiduTransAPIHandler::m_language_names_file = {
  ":/baidu_translate_languages.cn.txt"
};

const QString BaiduTransAPIHandler::m_appID = "20160326000016623";
const QString BaiduTransAPIHandler::m_appKey = "re8Y2BP51G8HhGbBM5wl";
const QString BaiduTransAPIHandler::m_apiAddr =
  "http://api.fanyi.baidu.com/api/trans/vip/translate";
