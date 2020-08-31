#ifndef CCNAMESPACE_H
#define CCNAMESPACE_H

#include "pacicore/basicstructs.h"

#include <QObject>

class CCNamespace: public QObject {
  Q_OBJECT
public:
  Q_INVOKABLE static paci::Color paColor(
    double r, double g, double b, double a);

  Q_INVOKABLE static QString readFileText(const QString& path);

  Q_INVOKABLE static int how_many_lines(const QString& s);

  Q_INVOKABLE static paci::Timebase makeTimebase(
    int r, bool df = false);
};

#endif // CCNAMESPACE_H
