#include "global_defs.h"
//#include "paciuikit/paci_ui_kit_global_register.h"
#include "qoolui_cpp/qool_register_classes.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char* argv[]) {
  QCoreApplication::setApplicationName("CaptionComposer");
  QCoreApplication::setApplicationVersion("beta-1.0");
  QCoreApplication::setOrganizationName("PaciProject");
  //  QCoreApplication::setOrganizationDomain("org.paci");
  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

  QGuiApplication app(argc, argv);

  QQmlApplicationEngine engine;

  //  paci_ui_kit_reg();
  qool_register_classes();
  register_classes();

  engine.addImportPath("qrc:/");
  const QUrl url(QStringLiteral("qrc:/main.qml"));
  QObject::connect(
    &engine, &QQmlApplicationEngine::objectCreated, &app,
    [url](QObject* obj, const QUrl& objUrl) {
      if (! obj && url == objUrl)
        QCoreApplication::exit(-1);
    },
    Qt::QueuedConnection);

  engine.load(url);

  return app.exec();
}
