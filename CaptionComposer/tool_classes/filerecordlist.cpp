#include "filerecordlist.h"

FileRecordList::FileRecordList(const FileRecordList& other) {
  for (const auto& x : other)
    this->append(x);
}

const QString FileRecordList::BIG_SEP = { "!!!BIG_SEPARATOR!!!" };
const QString FileRecordList::SMALL_SEP = { "???SMALL_SEPARATOR???" };

QString FileRecordList::encodeToString() const {
  QStringList results;
  for (const auto& x : *this) {
    auto small =
      QString("%1%2%3").arg(x.path).arg(SMALL_SEP).arg(x.formatCode);
    results << small;
  }
  return results.join(BIG_SEP);
}

FileRecordList FileRecordList::fromStringCode(const QString& code) {
  FileRecordList newList;
  QStringList list = code.split(BIG_SEP);
  for (const auto& x : list) {
    auto a = x.split(SMALL_SEP);
    newList.append(FileRecord { a.first(), a.last() });
  }
  return newList;
}
