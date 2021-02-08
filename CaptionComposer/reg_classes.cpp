//#include "CommonQuickItemRegisters.h"
#include "custom_ui/trackviewminimapimage.h"
#include "global_defs.h"
#include "logic/maindocument.h"
#include "logic/model_filelist.h"
#include "logic/model_sequence.h"
#include "logic/model_track.h"
#include "logic/networkserver.h"
#include "logic/uibrain.h"
#include "pacicore/sequence.h"
#include "tool_classes/baidutransapihandler.h"
#include "tool_classes/ccnamespace.h"
#include "tool_classes/filerecordlist.h"
#include "tool_classes/sequenceinfogenerator.h"

#include <QQmlEngine>

#include "pacicore/TimePoint.h"
#include <QJSValue>

template<>
paci::TimePoint::TimePoint(QJSValue x){
  auto s = warlock::positiveGate(x.toNumber());
  m_data = TimeNumber(std::round(s));
}

void register_classes() {
  //#define REG3(cls)                                                      \
//  qmlRegisterType<paci::cls>("Paci.Core", 1, 0, "PA" #cls);

#define REG(cls)                                                       \
  qmlRegisterUncreatableType<paci::cls>(                               \
    "Paci.Core", 1, 0, "PA" #cls, "Can not create" #cls);

#define REG_DATA(cls)                                                       \
  qmlRegisterUncreatableType<paci::cls>(                               \
    "Paci.Core", 1, 0, "pa" #cls, "Can not create" #cls);

#define REG2(cls)                                                      \
  qmlRegisterType<paci::cls>("Paci.Core", 1, 0, "PA" #cls);

  REG(Clip)
  REG_DATA(Color)
  REG(Track)
  REG(FontInfo)
  REG_DATA(Timebase)
  REG_DATA(TimePoint)
  REG(Sequence)
  REG(TrackManager)
  REG_DATA(FormatProfiler)

#undef REG
#undef REG2

#define CC_ERI "Paci.CaptionComposer", 1, 0

  qmlRegisterSingletonType<UIBrain>(CC_ERI, "UIBrain",
    [](QQmlEngine* engine, QJSEngine* scriptEngine) -> QObject* {
      Q_UNUSED(engine)
      Q_UNUSED(scriptEngine)
      auto* brain = new UIBrain();
      return brain;
    });

  qmlRegisterUncreatableType<MainDocument>(
    CC_ERI, "MainDocument", "Can not create.");
//  qmlRegisterUncreatableType<paci::FormatProfiler>(
//    CC_ERI, "FormatProfiler", "Thsi can not create.");
  qmlRegisterType<TrackModel>(CC_ERI, "TrackModel");
  qmlRegisterType<SequenceModel>(CC_ERI, "SequenceModel");
  qmlRegisterType<FileListModel>(CC_ERI, "FileListModel");
  qmlRegisterType<SequenceInfoGenerator>(
    CC_ERI, "SequenceInfoGenerator");

  qmlRegisterUncreatableType<FileRecord>(CC_ERI, "fileRecord", "");
  qmlRegisterUncreatableType<FileRecordList>(
    CC_ERI, "fileRecordList", "");
  qmlRegisterUncreatableType<NetworkServer>(
    CC_ERI, "NetworkServer", "");
  qmlRegisterType<BaiduTransAPIHandler>(CC_ERI, "BaiduTransAPIHandler");

  qmlRegisterSingletonType<CCNamespace>(CC_ERI, "CC",
    [](QQmlEngine* engine, QJSEngine* scriptEngine) -> QObject* {
      Q_UNUSED(engine)
      Q_UNUSED(scriptEngine)
      auto* brain = new CCNamespace();
      return brain;
    });

#undef CC_ERI

#define CCUI_ERI "Paci.CaptionComposer.UI", 1, 0

  qmlRegisterType<TrackViewMinimapImage>(
    CCUI_ERI, "TrackViewMinimapImage");

#undef CCUI_ERI
}
