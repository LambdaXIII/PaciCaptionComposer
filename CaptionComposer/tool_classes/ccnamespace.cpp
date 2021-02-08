#include "ccnamespace.h"

#include <QFile>
#include <QTextStream>
#include <QUrl>

paci::Color CCNamespace::paColor(
  double r, double g, double b, double a) {
  return paci::Color(r, g, b, a);
}

QString CCNamespace::readFileText(const QString& path) {
  QFile file(path);
  if (! file.open(QFile::ReadOnly | QFile::Text))
    return "";

  QTextStream s(&file);
  QString result = s.readAll();
  file.close();
  return result;
}

int CCNamespace::how_many_lines(const QString& s) {
  auto a = s.simplified();
  if (a.isEmpty())
    return 0;
  if (! a.contains("\n"))
    return 0;
  auto ls = a.split("\n");
  return ls.length();
}

paci::Timebase CCNamespace::makeTimebase(int r, bool df) {
  paci::Timebase x;
  x.rate = r;
  x.dropframe = df;
  return x;
}
