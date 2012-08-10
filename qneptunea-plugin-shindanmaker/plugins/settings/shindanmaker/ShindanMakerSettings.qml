import QtQuick 1.1
import com.nokia.meego 1.0
import Twitter4QML 1.0
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
