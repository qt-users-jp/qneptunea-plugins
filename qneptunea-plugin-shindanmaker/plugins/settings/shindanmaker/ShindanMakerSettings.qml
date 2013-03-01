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
import QtQuick 1.1
import com.nokia.meego 1.0
import QNeptunea.Components 1.0

AbstractPage {
    id: root

    title: qsTr('ShindanMaker')

    property url __icon: 'shindanmaker.png'
    property string api: ''
    property string apikey: ''

    Flickable {
        id: container
        anchors.fill: parent; anchors.topMargin: root.headerHeight; anchors.bottomMargin: root.footerHeight
        contentHeight: content.height
        clip: true
        interactive: typeof root.linkMenu !== 'undefined'

        Column {
            id: content
            width: parent.width

            Text {
                text: qsTr('username:')
                font.family: constants.fontFamily
                font.pixelSize: constants.fontDefault
                color: constants.textColor
            }

            TextField {
                id: username
                width: parent.width
                enabled: !root.busy
                text: settings.readData('shindanmaker.com/username', '')
                maximumLength: 20
                platformStyle: TextFieldStyle { textFont.pixelSize: constants.fontDefault }
                platformSipAttributes: SipAttributes {
                    actionKeyLabel: 'Save'
                }
                Keys.onReturnPressed: save.save()
            }
        }
    }

    toolBarLayout: AbstractToolBarLayout {
        ToolSpacer {}
        ToolButtonRow {
            ToolButton {
                id: save

                enabled: !root.busy
                checked: enabled
                text: qsTr('Save')
                function save() {
                    settings.saveData('shindanmaker.com/username', username.text)
                    pageStack.pop()
                }
                onClicked: save.save()
            }
        }
    }
}
