#ifndef FILELISTMODEL_H
#define FILELISTMODEL_H

#include "global_defs.h"
#include "paciformat/formatprofiler.h"
#include "tool_classes/filerecordlist.h"

#include <QAbstractListModel>

class FileListModel: public QAbstractListModel {
  Q_OBJECT
  Q_PROPERTY(FileRecordList fileList READ fileList WRITE setFileList
      NOTIFY fileListChanged)
public:
  explicit FileListModel(QObject* parent = nullptr);

  enum FileListRoles {
    PathRole = Qt::UserRole + 1,
    FileNameRole,
    FormatCodeRole,
    FormatRole,
    URLRole
  };
  QHash<int, QByteArray> roleNames() const override;

  // Basic functionality:
  int rowCount(
    const QModelIndex& parent = QModelIndex()) const override;

  QVariant data(const QModelIndex& index,
    int role = Qt::DisplayRole) const override;

  void setFileList(const FileRecordList& list);
  FileRecordList& fileList();
signals:
  void fileListChanged();

private:
  FileRecordList m_fileList;
  paci::FormatProfiler m_profiler;
};

#endif // FILELISTMODEL_H
