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
import QtQuick 1.1

TweetPlugin {
    id: root
    name: qsTr('Convert text to \'Shout\'')
    icon: './shout/shout.png'

    enabled: root.text.length > 0

    function exec() {

        if(root.selectionStart !== root.selectionEnd) {

            var frontText = root.text.substring(0, root.selectionStart)
            var effectedText = makeShout(root.text.substring(root.selectionStart, root.selectionEnd), false)
            var backText = root.text.substring(root.selectionEnd)
            root.text = frontText + effectedText + backText

        }
        else {
            root.text = makeShout(root.text, true)
        }
    }

    function makeShout(str, escapeId) {
        str = str.replace(/^[\s\u3000]+/,"")
        if (str.match(/^@[a-zA-Z0-9_]+[\s\u3000]/) && escapeId) {
            str = RegExp.lastMatch + makeShout(RegExp.rightContext, true)
        } else {
            str = '\uFF3C %1 \uFF0F'.arg(toHankaku(toKatakana(str)))
        }
        return str
    }

    /* Convert charcode function is modified version of libraries by kanaxs project
     *  https://code.google.com/p/kanaxs/
     *  Thanks to shogo4405-san :)
     */

    function toKatakana(str) {
        var c, i = str.length, a = []
        while(i--) {
            c = str.charCodeAt(i)
            a[i] = (0x3041 <= c && c <= 0x3096) ? c + 0x0060 : c
        }
        return String.fromCharCode.apply(null, a)
    }

    function toHankaku(str) {
        var i, f, c, m, e, a = []

        m =
                {
            0x30A1:0xFF67, 0x30A3:0xFF68, 0x30A5:0xFF69, 0x30A7:0xFF6A, 0x30A9:0xFF6B,
            0x30FC:0xFF70, 0x30A2:0xFF71, 0x30A4:0xFF72, 0x30A6:0xFF73, 0x30A8:0xFF74,
            0x30AA:0xFF75, 0x30AB:0xFF76, 0x30AD:0xFF77, 0x30AF:0xFF78, 0x30B1:0xFF79,
            0x30B3:0xFF7A, 0x30B5:0xFF7B, 0x30B7:0xFF7C, 0x30B9:0xFF7D, 0x30BB:0xFF7E,
            0x30BD:0xFF7F, 0x30BF:0xFF80, 0x30C1:0xFF81, 0x30C4:0xFF82, 0x30C6:0xFF83,
            0x30C8:0xFF84, 0x30CA:0xFF85, 0x30CB:0xFF86, 0x30CC:0xFF87, 0x30CD:0xFF88,
            0x30CE:0xFF89, 0x30CF:0xFF8A, 0x30D2:0xFF8B, 0x30D5:0xFF8C, 0x30D8:0xFF8D,
            0x30DB:0xFF8E, 0x30DE:0xFF8F, 0x30DF:0xFF90, 0x30E0:0xFF91, 0x30E1:0xFF92,
            0x30E2:0xFF93, 0x30E3:0xFF6C, 0x30E4:0xFF94, 0x30E5:0xFF6D, 0x30E6:0xFF95,
            0x30E7:0xFF6E, 0x30E8:0xFF96, 0x30E9:0xFF97, 0x30EA:0xFF98, 0x30EB:0xFF99,
            0x30EC:0xFF9A, 0x30ED:0xFF9B, 0x30EF:0xFF9C, 0x30F2:0xFF66, 0x30F3:0xFF9D,
            0x30C3:0xFF6F, 0x309B:0xFF9E, 0x309C:0xFF9F
        }

        e =
                {
            0x30F4:0xFF73, 0x30F7:0xFF9C, 0x30FA:0xFF66
        }

        for(i=0,f=str.length;i<f;)
        {
            c = str.charCodeAt(i++)
            switch(true)
            {
            case (c in m):
                a.push(m[c])
                break;
            case (c in e):
                a.push(e[c], 0xFF9E)
                break;
            case (0x30AB <= c && c <= 0x30C9):
                a.push(m[c-1], 0xFF9E)
                break;
            case (0x30CF <= c && c <= 0x30DD):
                a.push(m[c-c%3], [0xFF9E,0xFF9F][c%3-1])
                break;
            case (0xFF01 <= c && c <= 0xFF5E):
                a.push(c - 0xFEE0)
                break;
            case (c == 0x3000):
                a.push(0x0020)
                break;
            default:
                a.push(c)
                break;
            }
        }
        return String.fromCharCode.apply(null, a)
    }
}
