function createObject(sourceFile, parentObject) {
    var component = Qt.createComponent(sourceFile);
    var guiObject = component.createObject(parentObject);

    if (guiObject == null) {
        console.log("Error creating object");
    }
    else {
        return guiObject
    }
}

function cloneObject(objectToClone) {
    var clone = {};
    for (var attribute in objectToClone) {
        clone[attribute] = objectToClone[attribute];
    }
    return clone;
}

function cloneVideoObject(video, itemId) {
    var archiveItem = {};
    if (itemId) {
        archiveItem["itemId"] = itemId;
    }
    else {
        archiveItem["itemId"] = video.itemId;
    }
    archiveItem["title"] = video.title;
    archiveItem["name"] = video.title;
    archiveItem["url"] = video.url;
    archiveItem["duration"] = video.duration;
    return archiveItem;
}

