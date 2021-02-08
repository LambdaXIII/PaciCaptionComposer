#ifndef FILERECORDLIST_H
#define FILERECORDLIST_H

#include <QObject>

struct FileRecord {
  QString path, formatCode;
  bool operator==(const FileRecord& other) const {
    return path == other.path && formatCode == other.formatCode;
  }

private:
  Q_GADGET
};

Q_DECLARE_METATYPE(FileRecord)

class FileRecordList: public QList<FileRecord> {
private:
  Q_GADGET
  const static QString BIG_SEP;
  const static QString SMALL_SEP;

public:
  FileRecordList() = default;
  FileRecordList(const FileRecordList& other);

  QString encodeToString() const;
  static FileRecordList fromStringCode(const QString& code);
};

Q_DECLARE_METATYPE(FileRecordList)

#endif // FILERECORDLIST_H
