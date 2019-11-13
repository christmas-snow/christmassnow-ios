#include <QtCore/QString>
#include <QtCore/QLocale>
#include <QtCore/QTranslator>
#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>
#include <QtQuickControls2/QQuickStyle>

#include "gifcreator.h"
#include "sharehelper.h"
#include "sparkcreator.h"
#include "storehelper.h"

int main(int argc, char *argv[])
{
    QTranslator     translator;
    QGuiApplication app(argc, argv);

    if (translator.load(QStringLiteral(":/tr/christmassnow_%1").arg(QLocale::system().name()))) {
        QGuiApplication::installTranslator(&translator);
    }

    qmlRegisterType<SparkCreator>("SparkCreator", 1, 0, "SparkCreator");

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty(QStringLiteral("GIFCreator"), &GIFCreator::GetInstance());
    engine.rootContext()->setContextProperty(QStringLiteral("ShareHelper"), &ShareHelper::GetInstance());
    engine.rootContext()->setContextProperty(QStringLiteral("StoreHelper"), &StoreHelper::GetInstance());

    QQuickStyle::setStyle(QStringLiteral("Default"));

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    if (engine.rootObjects().isEmpty()) {
        return -1;
    } else {
        return QGuiApplication::exec();
    }
}
