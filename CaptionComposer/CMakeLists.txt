cmake_minimum_required(VERSION 3.14)

project(CaptionComposer LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_MACOSX_BUNDLE TRUE)

set(MACOSX_BUNDLE_ICON_FILE CaptionComposer.icns)
set(MACOSX_BUNDLE_BUNDLE_NAME CaptionComposer)


# And this part tells CMake where to find and install the file itself
set(myApp_ICON ${CMAKE_CURRENT_SOURCE_DIR}/assets/CaptionComposer.icns)
set_source_files_properties(${myApp_ICON} PROPERTIES
       MACOSX_PACKAGE_LOCATION "Resources")


find_package(Qt5 COMPONENTS Core Quick Qml Svg Network REQUIRED)

aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR} SRC_FILES)
aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/logic SRC_FILES)
aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/tool_classes SRC_FILES)
aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/custom_ui SRC_FILES)

add_executable(CaptionComposer ${myApp_ICON} ${SRC_FILES}
    ${CMAKE_CURRENT_SOURCE_DIR}/tool_classes/tool_resources.qrc
    qml.qrc)

set_target_properties(CaptionComposer PROPERTIES
  MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/../PaciOneMacOSXBundleInfo.plist.in)


target_compile_definitions(CaptionComposer
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(CaptionComposer
  Qt5::Core Qt5::Quick Qt5::Qml Qt5::Svg
#  PaciOneUIKit
  QoolUI PaciFontDesigner
   PaciFormat PaciCore PaciBase PaciFortune
   warlock)

