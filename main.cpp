#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "habitmanager.h"

using namespace std;


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setOrganizationName("MyPortfolio");
    app.setApplicationName("HabitTracker");

    qmlRegisterType<HabitManager>("Backend", 1, 0, "HabitManager");

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("HabitTracker", "Main");

    return app.exec();
}
