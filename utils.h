#ifndef UTILS_H
#define UTILS_H

#include <QObject>
#include <QVariantList>
#include <QUrl>

class Utils : public QObject {
    Q_OBJECT

public:
    explicit Utils(QObject *parent = 0);

public slots:
    void deleteVideo(const QString &path);
    bool createPlaylist(QString title);
    void deletePlaylist(const QUrl &url);
    QVariantList getPlaylistVideos(const QUrl &url) const;
    void addVideoToPlaylist(const QUrl &videoUrl, const QUrl &playlistUrl);
    void deleteVideoFromPlaylist(int pos, const QString &fileName, const QUrl &playlistUrl);

signals:
    void alert(const QString &message);
    void videoDeleted();
    void playlistCreated();
    void playlistDeleted();
    void addedToPlaylist();
    void deletedFromPlaylist();
};

#endif // UTILS_H
