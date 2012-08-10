import QNeptunea.Service 1.0

ServicePlugin {
    id: root
    service: 'ShindanMaker'
    icon: 'shindanmaker.png'

    property string api: 'http://shindanmaker.com'

    function matches(url) {
        var re = new RegExp("shindanmaker.com")
        return re.test(url);
    }

    function open(link, parameters) {
        var username = settings.readData('shindanmaker.com/username', '')
        if (username.length == 0 ) {
            pageStack.push(settingsPage, {'state': 'plugins'})
            return
        }

        root.loading = true
        // Fixme: URL shorten services is not supported.
        var url = link;
        console.debug(url);

        var Boundary = "xxfwqogfiajiodsaij32099fsa"
        var postdata = "--" + Boundary + "\r\n" + "Content-Disposition: form-data; name=\"u\"" + "\r\n\r\n" + username + "\r\n" + "--"
                + Boundary + "Content-Disposition: form-data; name=\"from\"" + "\r\n\r\n" + "--" + Boundary;

        var request = new XMLHttpRequest();
        request.open('POST', url);
        request.setRequestHeader("Content-Type", "multipart/form-data; boundary=" + Boundary);
        request.setRequestHeader("Cache-Control", "max-age=0");
        request.setRequestHeader("Origin", "http://shindanmaker.com")
        request.onreadystatechange = function() {
                    switch (request.readyState) {
                    case XMLHttpRequest.HEADERS_RECEIVED:
                        break
                    case XMLHttpRequest.LOADING:
                        break
                    case XMLHttpRequest.DONE: {
                        root.result = (request.status == 200)
                        if (root.result) {
                            var b = request.responseText
                            var re = new RegExp("<div style=\"padding: 10px; font-size: 2em;\">[^<div]*");
                            var c = b.match(re).shift();
                            var d = c.split('\t');
                            d.shift();
                            var e = d.shift();
                            pageStack.push(tweetPage, { 'statusText': e.concat(" ").concat(url) } );
                        } else {
                            root.message = request.responseText
                        }
                        root.loading = false
                        break 
                    }
                    case XMLHttpRequest.ERROR: {
                        root.result = false
                        root.message = request.responseText
                        root.loading = false
                        break }
                    }
                }
        request.send(postdata);
    }
}
