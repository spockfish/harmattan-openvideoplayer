#include "settings.h"
#include <QDebug>
#include <QDir>

Settings::Settings(QSettings *parent) :
    QSettings(QString("OVP"), QString("OVP"), parent) {
}

void Settings::restoreSettings() {
    beginGroup("Media");
    setPlayPosition(value("playPosition", "start").toString());
    setPauseWhenMinimized(value("pauseWhenMinimized", false).toBool());
    setPlayInBackground(value("playInBackground", true).toBool());
    setVideoSkipLength(value("videoSkipLength", 30000).toInt());
    setEnableSubtitles(value("enableSubtitles", false).toBool());
    setSubtitlesSize(value("subtitlesSize", 32).toInt());
    setSubtitlesColor(value("subtitlesColor", "#ffffff").toString());
    setBoldSubtitles(value("boldSubtitles", false).toBool());
    endGroup();

    beginGroup("Appearance");
    setTheme(value("theme", "dark").toString());
    setActiveColor(value("activeColor", "#cd0fbc").toString());
    setActiveColorString(value("activeColorString", "color12").toString());
    setLanguage(value("language", "en").toString());
    setThumbnailSize(value("thumbnailSize", "large").toString());
    endGroup();

    beginGroup("System");
    setOrientation(value("screenOrientation", "auto").toString());
    endGroup();
}

void Settings::saveSettings() {
    beginGroup("Media");
    setValue("playPosition", playPosition);
    setValue("pauseWhenMinimized", pauseWhenMinimized);
    setValue("playInBackground", playInBackground);
    setValue("videoSkipLength", videoSkipLength);
    setValue("enableSubtitles", enableSubtitles);
    setValue("subtitlesSize", subtitlesSize);
    setValue("subtitlesColor", subtitlesColor);
    setValue("boldSubtitles", boldSubtitles);
    endGroup();

    beginGroup("Appearance");
    setValue("theme", theme);
    setValue("activeColor", activeColor);
    setValue("activeColorString", activeColorString);
    setValue("language", language);
    setValue("thumbnailSize", thumbnailSize);
    endGroup();

    beginGroup("System");
    setValue("screenOrientation", screenOrientation);
    endGroup();
}

void Settings::setPlayPosition(const QString &position) {
    playPosition = position;
    emit playPositionChanged();
}

void Settings::setPauseWhenMinimized(bool pause) {
    pauseWhenMinimized = pause;
    emit pauseWhenMinimizedChanged();
}

void Settings::setPlayInBackground(bool play) {
    playInBackground = play;
    emit playInBackgroundChanged();
}

void Settings::setVideoSkipLength(int length) {
    videoSkipLength = length;
    emit videoSkipLengthChanged();
}

void Settings::setThumbnailSize(const QString &size) {
    thumbnailSize = size;
    emit thumbnailSizeChanged();
}

void Settings::setTheme(const QString &aTheme) {
    theme = aTheme;
    emit themeChanged();
}

void Settings::setActiveColor(const QString &color) {
    activeColor = color;
    emit activeColorChanged();
}

void Settings::setActiveColorString(const QString &colorString) {
    activeColorString = colorString;
    emit activeColorStringChanged();
}

void Settings::setLanguage(const QString &lang) {
    language = lang;
    emit languageChanged();
}

void Settings::setOrientation(const QString &orientation) {
    screenOrientation = orientation;
    emit orientationChanged();
}

void Settings::setEnableSubtitles(bool enable) {
    enableSubtitles = enable;
    emit enableSubtitlesChanged();
}

void Settings::setSubtitlesSize(int size) {
    subtitlesSize = size;
    emit subtitlesSizeChanged();
}

void Settings::setSubtitlesColor(const QString &color) {
    subtitlesColor = color;
    emit subtitlesColorChanged();
}

void Settings::setBoldSubtitles(bool bold) {
    boldSubtitles = bold;
    emit boldSubtitlesChanged();
}
