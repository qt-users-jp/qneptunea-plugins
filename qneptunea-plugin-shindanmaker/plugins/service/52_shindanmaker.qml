/* Copyright (c) 2012 QNeptunea Plugins Project.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the QNeptunea Plugins nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL QNEPTUNEA PLUGINS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
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
                    case XMLHttpRequest.DONE: {
                        if (request.status == 200 && request.responseText.match(/<textarea .+?>([^]*)<\/textarea>/)) {
                            pageStack.push(tweetPage, { 'statusText': RegExp.$1 } )
                            root.result = true
                        } else {
                            root.message = request.responseText
                            root.result = false
                        }
                        root.loading = false
                        break 
                    }
                    case XMLHttpRequest.ERROR: {
                        root.result = false
                        root.message = request.responseText
                        root.loading = false
                        break }
                    default:
                        break
                    }
                }
        request.send(postdata);
    }
}
