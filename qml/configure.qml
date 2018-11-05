import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

Item {
    height: mainContainer.implicitHeight + 20
    width: mainContainer.implicitWidth + 20

    ColumnLayout {
        id: mainContainer
        anchors.centerIn: parent

        spacing: 5
        GridLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            columns: 3
            rowSpacing: 5
            columnSpacing: 5

            Button { id: fieldLink; text: 'Link Twitch'; Layout.fillWidth: true; Layout.columnSpan: 3; onClicked: { twitchLogin.spawn(); } }

            Label { text: qsTr('Channel:'); }
            TextField { id: fieldChannel; text: Overlay.channel; Layout.fillWidth: true; Layout.columnSpan: 2 }

            Label { text: qsTr('Backdrop:'); }
            TextField { id: bgimage; text: Overlay.bgImage; Layout.fillWidth: true }
            Button { text: qsTr('Select...'); onClicked: { bgDialogue.open(); } }

            Label { text: qsTr('Notification Sound:'); }
            TextField { id: notification; text: Overlay.notifySound; Layout.fillWidth: true }
            Button { text: qsTr('Select...'); onClicked: { notifyDialogue.open(); } }

            Label { text: qsTr('Opacity:') }
            TextSlider {
                id: opacitySlider
                Layout.columnSpan: 2
                Layout.fillWidth: true
                from: 0
                value: Overlay.opacity
                to: 100
                text: parseInt(value) + '%'
            }

            Label { text: qsTr('Scale:') }
            TextSlider {
                id: scaleSlider
                Layout.columnSpan: 2
                Layout.fillWidth: true
                from: 1
                value: Overlay.scale
                to: 400
                text: parseInt(value) + '%'
            }

            Label { text: qsTr('Fade delay:') }
            TextSlider {
                id: fadeSlider
                Layout.columnSpan: 2
                Layout.fillWidth: true
                from: 1
                value: Overlay.fadeDelay
                to: 1200
                text: parseInt(value) + 's'
                textScale: 0.8
            }

            CheckBox {
                id: cbTimestamps
                text: qsTr('Show timestamps')
                Layout.columnSpan: 2
                Layout.fillWidth: true
                checked: Overlay.showTimestamps
            }
            CheckBox {
                id: cbAvatars
                text: qsTr('Show avatars')
                Layout.fillWidth: true
                checked: Overlay.showAvatars
            }
        }

        StylePreview {
            id: preview

            bgimage: bgimage.text
            overlayopacity: opacitySlider.value * 0.01
            overlayscale: scaleSlider.value * 0.01
            fadetime: fadeSlider.value
            showtimestamps: cbTimestamps.checked
            showavatars: cbAvatars.checked
        }

        TwitchLogin {
            id: twitchLogin
        }


        FileDialog {
            id: bgDialogue
            title: qsTr("Please choose an image file")
            folder: shortcuts.home
            selectExisting: true
            selectFolder: false
            selectMultiple: false
            nameFilters: [ qsTr("Image files (*.jpg *.png)"), qsTr("All files (*)") ]
            onAccepted: {
                bgimage.text = bgDialogue.fileUrl;
                bgDialogue.close();
            }
            onRejected: {
                bgDialogue.close();
            }
        }

        FileDialog {
            id: notifyDialogue
            title: qsTr("Please choose an audio file")
            folder: shortcuts.home
            selectExisting: true
            selectFolder: false
            selectMultiple: false
            nameFilters: [ qsTr("Audio files (*.wav *.mp3)"), qsTr("All files (*)") ]
            onAccepted: {
                notification.text = notifyDialogue.fileUrl;
                notifyDialogue.close();
            }
            onRejected: {
                notifyDialogue.close();
            }
        }

        Row {
            Layout.fillWidth: true
            spacing: 5
            layoutDirection: Qt.RightToLeft

            Button
            {
                text: qsTr('&Cancel')
                onClicked: {
                    Dialogue.hide();
                }
            }

            Button
            {
                text: qsTr('&Okay')
                onClicked: {
                    Overlay.disconnect();
                    Overlay.channel = fieldChannel.text;
                    Overlay.bgImage = bgimage.text;
                    Overlay.notifySound = notification.text;
                    Overlay.scale = scaleSlider.value;
                    Overlay.opacity = opacitySlider.value;
                    Overlay.fadeDelay = fadeSlider.value;
                    Overlay.showTimestamps = cbTimestamps.checked;
                    Overlay.showAvatars = cbAvatars.checked;
                    Overlay.reconnect();

                    Dialogue.hide();
                }
            }
        }
    }
}
