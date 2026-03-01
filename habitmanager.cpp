#include "habitmanager.h"
#include <QFile>
#include <QTextStream>
#include <QStandardPaths>
#include <QDir>

using namespace std;

HabitManager::HabitManager(QObject *parent) : QObject(parent) {}

// Helper function to get the save file path
QString getFilePath() {
    QString path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(path);
    if (!dir.exists()) dir.mkpath(".");
    return path + "/habits.json";
}

void HabitManager::saveHabits(const QString &jsonData) {
    QFile file(getFilePath());
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&file);
        out << jsonData;
        file.close();
    }
}

QString HabitManager::loadHabits() {
    QFile file(getFilePath());
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&file);
        QString data = in.readAll();
        file.close();
        return data;
    }
    return "[]"; // Returns an empty JSON list if it's the first time running
}

QString getHistoryFilePath() {
    QString path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(path);
    if (!dir.exists()) dir.mkpath(".");
    return path + "/history.json";
}

void HabitManager::saveHistory(const QString &jsonData) {
    QFile file(getHistoryFilePath());
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream out(&file);
        out << jsonData;
        file.close();
    }
}

QString HabitManager::loadHistory() {
    QFile file(getHistoryFilePath());
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&file);
        QString data = in.readAll();
        file.close();
        return data;
    }
    return "{}"; // Returns an empty JSON object for the first run
}
