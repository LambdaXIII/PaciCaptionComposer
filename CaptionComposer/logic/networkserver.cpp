#include "networkserver.h"

#include <QDebug>
#include <QJsonDocument>
#include <QNetworkReply>

NetworkServer::NetworkServer(QObject* parent)
  : QObject(parent)
  , m_networkManager(new QNetworkAccessManager(this)) {
  connect(m_networkManager,
    &QNetworkAccessManager::networkAccessibleChanged, [this] {
      emit this->networkAccessibleChanged(this->networkAccessible());
    });
}

bool NetworkServer::networkAccessible() const {
  return m_networkManager->networkAccessible()
         == QNetworkAccessManager::Accessible;
}

void NetworkServer::wantBaiduToTranslate(
  const QString& langName, paci::Clip* clip) {
  auto* handler = new BaiduTransAPIHandler(this);
  QString ori_line = clip->content();
  ori_line.replace("\n", " ");
  QUrl url(handler->forgeQuestFromName(langName, ori_line));
  QUrl encoded_url(url.toEncoded());
  handler->deleteLater();

  auto* reply = m_networkManager->get(QNetworkRequest(encoded_url));
  connect(reply, &QNetworkReply::finished, [reply, clip]() {
    QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
    qDebug() << doc;
    auto p = doc["trans_result"][0]["dst"].toString().simplified();
    if (! p.isEmpty()) {
      clip->setExtraProperty("translate_history", clip->content());
      clip->setContent(p);
    }
    reply->deleteLater();
  });
}
