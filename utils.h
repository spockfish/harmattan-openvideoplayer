#ifndef UTILS_H
#define UTILS_H

#include <QObject>

class Utils : public QObject {
    Q_OBJECT

public:
    explicit Utils(QObject *parent = 0);

public slots:
    void deleteVideo(const QString &path);

signals:
    void alert(const QString &message);
    void videoDeleted();
};

#endif // UTILS_H
