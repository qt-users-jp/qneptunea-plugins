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
    name: qsTr('Insert space')
    icon: './space/space.png'

    enabled: root.text.length > 0

    function exec() {

        if(root.selectionStart !== root.selectionEnd) {
            var frontText = root.text.substring(0, root.selectionStart)
            var effectedText = insertSpace(root.text.substring(root.selectionStart, root.selectionEnd))
            var backText = root.text.substring(root.selectionEnd)
            root.text = frontText + effectedText + backText

        } else {
            root.text = insertSpace(root.text)
        }
    }

    function insertSpace(text) {
        var ret = ''
        var lines = text.split('\n')
        var escape = ['@', '#']

        for (var i = 0; i < lines.length; i++) {
            var array = lines[i].split(' ')
            for (var j = 0; j < array.length; j++) {
                if(escape.indexOf(array[j].charAt(0)) > -1 || array[j].match(/.*:\/\//)) {
                    ret += '%1 '.arg(array[j])
                } else {
                    ret += array[j].split('').join(' ')
                }
            }

            if(lines.length > 1 && i < lines.length -1) {
                ret += '\n'
            }
        }
        return ret
    }
}
