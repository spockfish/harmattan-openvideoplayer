#include "utils.h"
#include <QFile>
#include <QDir>
#include <QStringList>
#include <QDebug>
#include <QByteArray>
#include <QRegExp>

#define PLAYLIST_PATH "/home/user/MyDocs/OVP/Playlists/"
#define ILLEGAL_CHARS "[\"@&~=\\/:?#!|<>*^]"
#define EXCLUDED_CHARS ",/:()'"

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

QVariantList Utils::getPlaylistVideos(const QUrl &url) const {
    QString filePath(url.toString());
    QByteArray path(filePath.left(filePath.lastIndexOf("/") + 1).right(filePath.size() - 7).toAscii());
    QVariantList videos;
    QFile aFile(url.toLocalFile());
    if (aFile.open(QIODevice::ReadOnly)) {
        QByteArray contents(aFile.readAll().replace("\r", ""));
        QList<QByteArray> lines(contents.split('\n'));
        aFile.close();
        foreach (QByteArray line, lines) {
            if (!((line.startsWith("#")) || (line.isEmpty()))) {
                QVariantMap video;
                if (!line.startsWith("file:///")) {
                    video.insert("url", QString("file:///" + path + line.toPercentEncoding(QByteArray(EXCLUDED_CHARS), QByteArray(" "))));
                    video.insert("filePath", path + line);
                }
                else {
                    video.insert("url", QString(line.toPercentEncoding(QByteArray(EXCLUDED_CHARS), QByteArray(" "))));
                    video.insert("filePath", QString(line.right(line.size() - 7)));
                }
                QString fileName(line.split('/').last());
                QString title(fileName.left(fileName.lastIndexOf(".")));
                video.insert("fileName", fileName);
                video.insert("title", title);
                video.insert("name", title);
                video.insert("duration", 0);
                videos.append(video);
            }
        }
    }
    return videos;
}

bool Utils::createPlaylist(QString title) {
    QDir path(PLAYLIST_PATH);
    if (!path.exists()) {
        path.mkpath(PLAYLIST_PATH);
    }
    bool created = false;
    QString message;
    QFile aFile(PLAYLIST_PATH + title.replace(QRegExp(ILLEGAL_CHARS), "_") + ".m3u");
    if (aFile.exists()) {
        message = tr("Playlist already exists");
    }
    else {
        created = aFile.open(QIODevice::WriteOnly);
        if (created) {
            aFile.write("");
            aFile.close();
            message = tr("New playlist created");
            emit playlistCreated();
        }
        else {
            message = tr("Playlist could not be created");
        }
    }
    emit alert(message);
    return created;
}

void Utils::deletePlaylist(const QUrl &url) {
    QString message;
    if (QFile::remove(url.toLocalFile())) {
        message = tr("Playlist deleted successfully");
        emit playlistDeleted();
    }
    else {
        message = tr("Playlist could not be deleted");
    }
    emit alert(message);
}

void Utils::addVideoToPlaylist(const QUrl &videoUrl, const QUrl &playlistUrl) {
    QString message;
    QFile aFile(playlistUrl.toLocalFile());
    if (aFile.open(QIODevice::Append)) {
        aFile.write("\n" + videoUrl.toString().toAscii());
        aFile.close();
        message = tr("Video added to playlist");
        emit addedToPlaylist();
    }
    else {
        message = tr("Video could not be added to playlist");
    }
    emit alert(message);
}

void Utils::deleteVideoFromPlaylist(int pos, const QString &fileName, const QUrl &playlistUrl) {
    QString message;
    QFile aFile(playlistUrl.toLocalFile());
    if (aFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QString contents(aFile.readAll().replace("\r", ""));
        aFile.close();
        QStringList lines(contents.split("\n", QString::SkipEmptyParts));
        QString line;
        int lineNumber = 0;
        int videoNumber = 0;
        bool found = false;
        while ((!found) && (lineNumber < lines.size())) {
            line = lines.at(lineNumber);
            if (!line.startsWith("#")) {
                if ((videoNumber == pos) && (line.endsWith(fileName))) {
                    lines.removeAt(lineNumber);
                    found = true;
                }
                videoNumber++;
            }
            lineNumber++;
        }
        QByteArray data(lines.join("\n").toAscii());
        if ((aFile.open(QIODevice::WriteOnly | QIODevice::Text)) && (aFile.write(data) > 0)) {
            aFile.close();
            message = tr("Video deleted from playlist");
            emit deletedFromPlaylist();
        }
        else {
            message = tr("Video could not be added to playlist");
        }
    }
    else {
        message = tr("Video could not be added to playlist");
    }
    emit alert(message);
}
