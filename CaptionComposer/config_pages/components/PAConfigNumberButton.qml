import QtQuick 2.13
//import CommonQml.Controls 1.0
//import CommonQml.PAStyles 1.0
import QtQuick.Controls 2.13
//import CommonQml.Components 1.0
import QtQuick.Layouts 1.13

import Qool.Controls.Inputs 1.0


QoolDragNumberControl {
  id: control
  height: 45
  width: 200
  //  checkable: true
  property string unit

  Layout.preferredHeight: 45
  Layout.fillWidth: true
  Layout.leftMargin: 6
  Layout.rightMargin: 6
}
