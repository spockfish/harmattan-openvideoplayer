#include <QtGui/QApplication>
#include <QDeclarativeContext>
#include <QtDeclarative>
#include <QtOpenGL/QGLWidget>
#include "qmlapplicationviewer.h"
#include "utils.h"
#include "settings.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QmlApplicationViewer viewer;

    Utils utils;
    Settings settings;
    QObject::connect(&app, SIGNAL(aboutToQuit()), &settings, SLOT(saveSettings()));

    QDeclarativeContext *context = viewer.rootContext();
    context->setContextProperty("Utils", &utils);
    context->setContextProperty("Settings", &settings);
    settings.restoreSettings();

    viewer.setViewport(new QGLWidget());
    viewer.setMainQmlFile(QLatin1String("qml/openvideoplayer/main.qml"));
    viewer.showFullScreen();

    return app.exec();
}
