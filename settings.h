#ifndef SETTINGS_H
#define SETTINGS_H

#include <QSettings>
#include <QStringList>

class Settings : public QSettings
{
    Q_OBJECT
    Q_PROPERTY(QString playPosition
               READ getPlayPosition
               WRITE setPlayPosition
               NOTIFY playPositionChanged)
    Q_PROPERTY(bool pauseWhenMinimized
               READ getPauseWhenMinimized
               WRITE setPauseWhenMinimized
               NOTIFY pauseWhenMinimizedChanged)
    Q_PROPERTY(bool playInBackground
               READ getPlayInBackground
               WRITE setPlayInBackground
               NOTIFY playInBackgroundChanged)
    Q_PROPERTY(int videoSkipLength
               READ getVideoSkipLength
               WRITE setVideoSkipLength
               NOTIFY videoSkipLengthChanged)
    Q_PROPERTY(QString thumbnailSize
               READ getThumbnailSize
               WRITE setThumbnailSize
               NOTIFY thumbnailSizeChanged)
    Q_PROPERTY(QString appTheme
               READ getTheme
               WRITE setTheme
               NOTIFY themeChanged)
    Q_PROPERTY(QString language
               READ getLanguage
               WRITE setLanguage
               NOTIFY languageChanged)
    Q_PROPERTY(QString screenOrientation
               READ getOrientation
               WRITE setOrientation
               NOTIFY orientationChanged)
    Q_PROPERTY(QString activeColor
               READ getActiveColor
               WRITE setActiveColor
               NOTIFY activeColorChanged)
    Q_PROPERTY(QString activeColorString
               READ getActiveColorString
               WRITE setActiveColorString
               NOTIFY activeColorStringChanged)

public:
    explicit Settings(QSettings *parent = 0);
    QString getPlayPosition() const { return playPosition; }
    bool getPauseWhenMinimized() { return pauseWhenMinimized; }
    bool getPlayInBackground() { return playInBackground; }
    int getVideoSkipLength() { return videoSkipLength; }
    QString getThumbnailSize() const { return thumbnailSize; }
    QString getTheme() const { return theme; }
    QString getLanguage() const { return language; }
    QString getOrientation() const { return screenOrientation; }
    QString getActiveColor() const { return activeColor; }
    QString getActiveColorString() const { return activeColorString; }

signals:
    void playPositionChanged();
    void pauseWhenMinimizedChanged();
    void playInBackgroundChanged();
    void videoSkipLengthChanged();
    void thumbnailSizeChanged();
    void themeChanged();
    void languageChanged();
    void orientationChanged();
    void alert(const QString &message);
    void activeColorChanged();
    void activeColorStringChanged();

public slots:
    void saveSettings();
    void restoreSettings();
    void setPlayPosition(const QString &position);
    void setPauseWhenMinimized(bool pause);
    void setPlayInBackground(bool play);
    void setVideoSkipLength(int length);
    void setThumbnailSize(const QString &size);
    void setTheme(const QString &aTheme);
    void setActiveColor(const QString &color);
    void setActiveColorString(const QString &colorString);
    void setLanguage(const QString &lang);
    void setOrientation(const QString &orientation);

private:
    QString playPosition;
    bool pauseWhenMinimized;
    bool playInBackground;
    int videoSkipLength;
    QString thumbnailSize;
    QString theme;
    QString activeColor;
    QString activeColorString;
    QString language;
    QString screenOrientation;
};

#endif // SETTINGS_H
