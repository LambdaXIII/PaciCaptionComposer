import QtQuick 2.13
import QtQuick.Controls 2.13
import Qool.Controls 1.0
import Paci.CaptionComposer 1.0
import "dialogs"
import "main_menus"

QoolMenuBar {

  PAMenuFile {
    onOpenFileDialogRequested: openFileDialog.open()
    onSaveFileDialogRequested: saveFileDialog.open()
    onImportFileDialogRequested: importFileDialog.open()
  }

  PAMenuEdit {
    onFormatConfigDialogRequested: formatConfigDialog.show()
    onFortuneDialogRequested: userFortuneDialog.show()
  }

  PAMenuView {}

  PAMenuHelp {
    onWantToShowAboutDialog: aboutDialog.show()
  }

  OpenFileDialog {
    id: openFileDialog
  }

  SaveFileDialog {
    id: saveFileDialog
  }

  ImportFileDialog {
    id: importFileDialog
  }

  FormatConfigDialog {
    id: formatConfigDialog
  }

  UserFortuneDialog {
    id: userFortuneDialog
  }
  AboutDialog {
    id: aboutDialog
  }
}
