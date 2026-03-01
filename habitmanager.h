#ifndef HABITMANAGER_H
#define HABITMANAGER_H

#include <QObject>
#include <QString>

using namespace std;

class HabitManager : public QObject {
    Q_OBJECT
public:
    explicit HabitManager (QObject *parent = nullptr);
    Q_INVOKABLE void saveHistory(const QString &jsonData);
    Q_INVOKABLE QString loadHistory();

    // The Q_INVOKABLE macro is the magic word that lets QML call these C++ functions
    Q_INVOKABLE void saveHabits(const QString &jsonData);
    Q_INVOKABLE QString loadHabits();

};
#endif // HABITMANAGER_H
