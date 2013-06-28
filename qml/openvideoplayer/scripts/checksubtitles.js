WorkerScript.onMessage = function(message) {
    var found = false;
    var i = 0;
    var sub;
    var text = "";
    while ((!found) && (i < message.subtitles.length)) {
        sub = message.subtitles[i];
        if ((message.position >= sub.start) && (message.position <= sub.end)) {
            text = sub.text;
            found = true;
        }
        i++;
    }
    WorkerScript.sendMessage(text);
}
