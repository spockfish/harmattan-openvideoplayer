#include "utils.h"
#include <QFile>
#include <QStringList>
#include <QDebug>

Utils::Utils(QObject *parent) :
    QObject(parent) {
}

void Utils::deleteVideo(const QString &path) {
    QString message;
    if (QFile::remove(path)) {
        message = tr("Video deleted successfully");
        emit videoDeleted();
    }
    else {
        message = tr("Video could not be deleted");
    }
    emit alert(message);
}

QVariantList Utils::getSubtitles(const QString &filePath) {
    QVariantList subtitles;
    QFile aFile(filePath.left(filePath.lastIndexOf(".")) + ".srt");
    if (aFile.open(QIODevice::ReadOnly)) {
        QString contents(aFile.readAll().replace("\r", ""));
        aFile.close();
        QStringList lines(contents.split("\n", QString::SkipEmptyParts));
        while (!lines.isEmpty()) {
            lines.takeFirst();
            QVariantMap sub;
            QStringList times(lines.takeFirst().split("-->"));
            if (times.size() == 2) {
                sub.insert("start", getSubTime(times.takeFirst().trimmed()));
                sub.insert("end", getSubTime(times.takeFirst().trimmed()));
                sub.insert("text", lines.takeFirst());
                subtitles.prepend(sub);
            }
        }
    }
    return subtitles;
}

int Utils::getSubTime(const QString &aTime) {
    QStringList hms(aTime.split(":"));
    int subTime = 0;
    int hours = 0;
    int mins = 0;
    int secs = 0;
    int msecs = 0;
    if (hms.size() == 3) {
        hours = hms.takeFirst().toInt() * 3600000;
        mins = hms.takeFirst().toInt() * 60000;
        QStringList sms(hms.takeFirst().split(","));
        if (sms.size() == 2) {
            secs = sms.takeFirst().toInt() * 1000;
            msecs = sms.takeFirst().toInt();
        }
        subTime = hours + mins + secs + msecs;
    }
    return subTime;
}
