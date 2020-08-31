#ifndef NETWORKSERVER_H
#define NETWORKSERVER_H

#include "pacibase/property_macros.h"
#include "pacicore/clip.h"
#include "tool_classes/baidutransapihandler.h"

#include <QNetworkAccessManager>
#include <QObject>

class NetworkServer: public QObject {
  Q_OBJECT
  PA_CONSTANT_PROPERTY(QNetworkAccessManager*, networkManager)
  Q_PROPERTY(bool networkAccessible READ networkAccessible NOTIFY
      networkAccessibleChanged)

public:
  explicit NetworkServer(QObject* parent = nullptr);
  bool networkAccessible() const;

signals:
  void networkAccessibleChanged(bool accessable);

public slots:
  void wantBaiduToTranslate(const QString& langName, paci::Clip* clip);
};

#endif // NETWORKSERVER_H
