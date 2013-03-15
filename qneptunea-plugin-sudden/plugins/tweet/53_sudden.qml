/* Copyright (c) 2012-2013 QNeptunea Plugins Project.
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
import QNeptunea.Tweet 1.0
import QNeptunea 1.0

TweetPlugin {
    id: root
    name: qsTr('Convert text to \'sudden-death\'')
    icon: './sudden/sudden.png'

    enabled: root.text.length > 0

    function exec() {
        var ar = root.text.split(' ')
        var str = ''
        var header = ' ＿'
        var footer = '　＜\n￣'
        var byteLength = 0
        var a = ''

        for (var i = 0; i < ar.length; i++) {
            if(ar[i].charAt(0).match(/@|#/)) {
                str += '%1 '.arg(ar[i])
            } else if (i !== ar.length -1) {
                a += '%1 '.arg(ar[i])
            } else {
                a += '%1'.arg(ar[i])
            }
        }

        for(var n = 0; n < a.length; n++) {
            var c = a.charCodeAt(n)
            if ( (c >= 0x0 && c < 0x81) || (c === 0xf8f0) || (c >= 0xff61 && c < 0xffa0) || (c >= 0xf8f1 && c < 0xf8f4)) {
                byteLength += 1
            } else {
                byteLength += 2
            }
        }

        var m = 0
        while(m < byteLength / 2 + 1) {
            header += '人'
            if(m !== byteLength / 2) {
                footer += 'Y^'
            }
            m++
        }

        header += '＿\n＞　'
        footer += '￣'

        if (str.length !== 0) {
            str += '\n\n%1%2'.arg(header).arg(a)
        } else {
            str += '%1%2'.arg(header).arg(a)
        }
        str += footer
        root.text = str
    }
}
