#ifndef UTILS_H
#define UTILS_H

#include <QObject>
#include <QVariantList>

class Utils : public QObject {
    Q_OBJECT

public:
    explicit Utils(QObject *parent = 0);

public slots:
    void deleteVideo(const QString &path);
    QVariantList getSubtitles(const QString &filePath);

private:
    int getSubTime(const QString &aTime);

signals:
    void alert(const QString &message);
    void videoDeleted();
};

#endif // UTILS_H
