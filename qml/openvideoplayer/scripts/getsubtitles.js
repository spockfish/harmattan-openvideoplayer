WorkerScript.onMessage = function(url) {
    var subtitles = [];
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            try {
                var contents = doc.responseText.replace(/\r/g, "").slice(1);
                var lines = contents.split(/\n+\d+\n|,\d{3}\n|\s-->\s/);
                var i = 0;
                while (i < (lines.length - 3)) {
                    var sub = {};
                    sub["start"] = getSubTime(lines[i]);
                    i++;
                    sub["end"] = getSubTime(lines[i] + ",500");
                    i++;
                    sub["text"] = lines[i];
                    i++;
                    subtitles.push(sub);
                }
                WorkerScript.sendMessage(subtitles);
            }
            catch(err) {
                console.log("Cannot retrieve subtitles");
                WorkerScript.sendMessage([]);
            }
        }
    }
    doc.open("GET", url.slice(0, url.lastIndexOf(".")) + ".srt");
    doc.send();
}

function getSubTime(time) {
    var hms = time.split(":");
    var hours = hms[0] * 3600000;
    var mins = hms[1] * 60000;
    var sms = hms[2].split(",");
    var secs = sms[0] * 1000;
    var msecs = parseInt(sms[1]);
    return hours + mins + secs + msecs;
}
