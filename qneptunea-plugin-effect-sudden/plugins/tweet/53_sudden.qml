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

        if(root.selectionStart !== root.selectionEnd) {

            var frontText = root.text.substring(0, root.selectionStart) + '\n\n'
            var effectedText = makeSudden(root.text.substring(root.selectionStart, root.selectionEnd))
            var backText = root.text.substring(root.selectionEnd)
            root.text = frontText + effectedText + backText

        } else {
            var ar = root.text.split(' ')
            var str = ''
            var a = ''
            var escape = [ '@', '#' ]

            for (var i = 0; i < ar.length; i++) {
                if(escape.indexOf(ar[i].charAt(0)) > -1) {
                    str += '%1 '.arg(ar[i])
                } else if (i !== ar.length -1) {
                    a += '%1 '.arg(ar[i])
                } else {
                    a += '%1'.arg(ar[i])
                }
            }

            if(str !== '') {
                str += '\n\n%1'.arg(makeSudden(a))
            } else {
                str += makeSudden(a)
            }
            root.text = str
        }
    }

    function makeSudden(str) {

        var header = ' \uFF3F'
        var footer = '\u3000\uFF1C\n\uFFE3'
        var byteLength = 0

        for(var n = 0; n < str.length; n++) {
            var c = str.charCodeAt(n)
            if ( (c >= 0x0 && c < 0x81) || (c === 0xf8f0) || (c >= 0xff61 && c < 0xffa0) || (c >= 0xf8f1 && c < 0xf8f4)) {
                byteLength += 1
            } else {
                byteLength += 2
            }
        }

        for (var m = 0; m < byteLength /2; m++) {
            header += '\u4EBA'
            footer += 'Y^'
        }

        header += '\u4EBA\uFF3F\n\uFF1E\u3000'
        footer += 'Y\uFFE3'

        return header + str + footer
    }
}
