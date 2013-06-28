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
    Q_PROPERTY(bool lockVideosToLandscape
               READ getLockVideosToLandscape
               WRITE setLockVideosToLandscape
               NOTIFY lockVideosToLandscapeChanged)
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
    Q_PROPERTY(bool enableMarqueeText
               READ getEnableMarqueeText
               WRITE setEnableMarqueeText
               NOTIFY enableMarqueeTextChanged)
    Q_PROPERTY(bool enableSubtitles
               READ getEnableSubtitles
               WRITE setEnableSubtitles
               NOTIFY enableSubtitlesChanged)
    Q_PROPERTY(int subtitlesSize
               READ getSubtitlesSize
               WRITE setSubtitlesSize
               NOTIFY subtitlesSizeChanged)
    Q_PROPERTY(QString subtitlesColor
               READ getSubtitlesColor
               WRITE setSubtitlesColor
               NOTIFY subtitlesColorChanged)
    Q_PROPERTY(bool boldSubtitles
               READ getBoldSubtitles
               WRITE setBoldSubtitles
               NOTIFY boldSubtitlesChanged)

public:
    explicit Settings(QSettings *parent = 0);
    QString getPlayPosition() const { return playPosition; }
    bool getPauseWhenMinimized() { return pauseWhenMinimized; }
    bool getPlayInBackground() { return playInBackground; }
    int getVideoSkipLength() { return videoSkipLength; }
    bool getLockVideosToLandscape() { return lockVideosToLandscape; }
    QString getThumbnailSize() const { return thumbnailSize; }
    QString getTheme() const { return theme; }
    QString getLanguage() const { return language; }
    QString getOrientation() const { return screenOrientation; }
    QString getActiveColor() const { return activeColor; }
    QString getActiveColorString() const { return activeColorString; }
    bool getEnableSubtitles() { return enableSubtitles; }
    int getSubtitlesSize() { return subtitlesSize; }
    QString getSubtitlesColor() const { return subtitlesColor; }
    bool getBoldSubtitles() { return boldSubtitles; }
    bool getEnableMarqueeText() { return enableMarqueeText; }

signals:
    void playPositionChanged();
    void pauseWhenMinimizedChanged();
    void playInBackgroundChanged();
    void videoSkipLengthChanged();
    void lockVideosToLandscapeChanged();
    void thumbnailSizeChanged();
    void themeChanged();
    void languageChanged();
    void orientationChanged();
    void alert(const QString &message);
    void activeColorChanged();
    void activeColorStringChanged();
    void enableSubtitlesChanged();
    void subtitlesSizeChanged();
    void subtitlesColorChanged();
    void boldSubtitlesChanged();
    void enableMarqueeTextChanged();

public slots:
    void saveSettings();
    void restoreSettings();
    void setPlayPosition(const QString &position);
    void setPauseWhenMinimized(bool pause);
    void setPlayInBackground(bool play);
    void setVideoSkipLength(int length);
    void setLockVideosToLandscape(bool lock);
    void setThumbnailSize(const QString &size);
    void setTheme(const QString &aTheme);
    void setActiveColor(const QString &color);
    void setActiveColorString(const QString &colorString);
    void setLanguage(const QString &lang);
    void setOrientation(const QString &orientation);
    void setEnableSubtitles(bool enable);
    void setSubtitlesSize(int size);
    void setSubtitlesColor(const QString &color);
    void setBoldSubtitles(bool bold);
    void setEnableMarqueeText(bool enable);

private:
    QString playPosition;
    bool pauseWhenMinimized;
    bool playInBackground;
    int videoSkipLength;
    bool lockVideosToLandscape;
    QString thumbnailSize;
    QString theme;
    QString activeColor;
    QString activeColorString;
    QString language;
    QString screenOrientation;
    bool enableSubtitles;
    int subtitlesSize;
    QString subtitlesColor;
    bool boldSubtitles;
    bool enableMarqueeText;
};

#endif // SETTINGS_H
