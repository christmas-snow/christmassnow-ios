#include <QDeclarativeContext>

#include "csapplication.h"
#include "qmlapplicationviewer.h"

int main(int argc, char *argv[])
{
    CSApplication app(argc, argv);
    QmlApplicationViewer viewer;

    viewer.rootContext()->setContextProperty("CSApplication", &app);

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
#ifdef MEEGO_TARGET
    viewer.setMainQmlFile(QLatin1String("qml/christmassnow/Meego/main.qml"));
#else
    viewer.setMainQmlFile(QLatin1String("qml/christmassnow/Symbian/main.qml"));
#endif
    viewer.showFullScreen();

    return app.exec();
}
