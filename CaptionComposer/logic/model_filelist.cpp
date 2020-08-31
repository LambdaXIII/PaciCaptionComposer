#include "model_filelist.h"

#include <QFileInfo>

FileListModel::FileListModel(QObject* parent)
  : QAbstractListModel(parent) {
}

QHash<int, QByteArray> FileListModel::roleNames() const {
  QHash<int, QByteArray> roles;
  roles[PathRole] = "path";
  roles[FormatCodeRole] = "formatCode";
  roles[FormatRole] = "format";
  roles[FileNameRole] = "fileName";
  roles[URLRole] = "fileURL";
  return roles;
}

int FileListModel::rowCount(const QModelIndex& parent) const {
  // For list models only the root node (an invalid parent) should
  // return the list's size. For all other (valid) parents, rowCount()
  // should return 0 so that it does not become a tree model.
  if (parent.isValid())
    return 0;

  return m_fileList.length();
}

QVariant FileListModel::data(const QModelIndex& index, int role) const {
  if (! index.isValid())
    return QVariant();

  if (! m_fileList.isEmpty()) {
    int row = index.row();
    auto path = m_fileList[row].path;
    auto formatCode = m_fileList[row].formatCode;
    QFileInfo info(path);

    switch (role) {
    case PathRole:
      return path;
    case FormatCodeRole:
      return formatCode;
    case FormatRole:
      return m_profiler.formatFromCode(formatCode);
    case FileNameRole:
      return info.fileName();
    case URLRole:
      return QUrl::fromLocalFile(info.absoluteFilePath());
    }
  }

  return QVariant();
}

void FileListModel::setFileList(const FileRecordList& list) {
  if (m_fileList != list) {
    beginResetModel();
    m_fileList.clear();
    m_fileList.append(list);
    endResetModel();
    emit fileListChanged();
  }
}

FileRecordList& FileListModel::fileList() {
  return m_fileList;
}
