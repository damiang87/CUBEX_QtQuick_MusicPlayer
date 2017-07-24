import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import QtMultimedia 5.9
import QtQuick.Window 2.3

Window {
    id: root
    visible: true
    flags: {
        Qt.FramelessWindowHint |
                Qt.WindowMinimizeButtonHint |
                Qt.Window
    }
    width: 350
    height: 500
    minimumHeight: 500
    maximumHeight: 500
    minimumWidth: 350
    maximumWidth: 350
    title: qsTr("CUBEX")
    color: "transparent"
    //logo
    Rectangle{
        anchors.fill: parent
        color: "#424242"
        Rectangle{
            id: tools
            width: root.width
            height: 30
            color: "#313131"
            Label{
                anchors.centerIn: parent
                height: 30
                text: "CUBEX"
                textFormat: {
                    color = "black"
                    font.pixelSize = 24
                }
            }
            MouseArea{
                anchors.fill: parent
                cursorShape: "PointingHandCursor"
                property real mX: 0
                property real mY: 0
                onPressed: {
                    mX = mouseX
                    mY = mouseY
                }
                onMouseXChanged: root.x += (mouseX - mX)
                onMouseYChanged: root.y += (mouseY - mY)
            }
        }

        Audio{
            id: media1
            autoPlay: true
            volume: volumeSlider.value
            source: myFile.fileUrl
        }

        //navigation
        Rectangle{
            id: nav
            width: root.width
            height: tools.height - 10
            y: y + tools.height
            color: "#777777"
            //exit
            Label{
                id: exitL
                width: 40
                height: parent.height
                x: parent.width - width
                text: "Exit"
                textFormat: {
                    font.pixelSize = 16
                    font.letterSpacing = 2
                }
                MouseArea{
                    anchors.fill: parent
                    cursorShape: "PointingHandCursor"
                    onClicked: {
                        media1.stop()
                        root.close()
                    }
                }
            }
            //minimize
            Rectangle{
                width: 25
                height: parent.height
                color: parent.color
                x: nav.width - exitL.width - width - 10
                Rectangle{
                    width: parent.width
                    height: 3
                    color: "black"
                    y: parent.height - height - height
                }
                MouseArea{
                    anchors.fill: parent
                    cursorShape: "PointingHandCursor"
                    onClicked: root.showMinimized()
                }
            }
            //file open
            Label{
                id: fileL
                width: 40
                height: parent.height
                x: parent.x + 5
                text: "File"
                textFormat: {
                    font.pixelSize = 16
                    font.letterSpacing = 2
                }
                FileDialog{
                    id: myFile
                    selectMultiple: true
                    onFileUrlChanged: {
                        media1.stop()
                        progresPlay.value = 0
                        statusText.text = fileUrl
                        media1.source = fileUrl
                        media1.play()
                    }
                    onFileUrlsChanged: {
                        musicModel.clear()
                        var cnt = fileUrls.length;
                        for(var i =0; i < cnt; i++)
                        {
                            musicModel.append({index: i, name: fileUrls[i]});
                        }
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    cursorShape: "PointingHandCursor"
                    onClicked: myFile.open()
                }
            }

            //play
            Label{
                id: playl
                width: 40
                height: parent.height
                x: parent.x + fileL.width + 20
                text: "Play"
                textFormat: {
                    font.pixelSize = 16
                    font.letterSpacing = 2
                }
                MouseArea{
                    anchors.fill: parent
                    cursorShape: "PointingHandCursor"
                    onClicked: media1.play()
                }
            }
            //stop
            Label{
                id: stopl
                width: 40
                height: parent.height
                x: parent.x + fileL.width + playl.width + 40
                text: "Stop"
                textFormat: {
                    font.pixelSize = 16
                    font.letterSpacing = 2
                }
                MouseArea{
                    anchors.fill: parent
                    cursorShape: "PointingHandCursor"
                    onClicked: media1.stop()
                }
            }
            //pause
            Label{
                id: pauseLabel
                width: 40
                height: parent.height
                x: parent.x + fileL.width + playl.width + stopl.width + 65
                text: "Pause"
                textFormat: {
                    font.pixelSize = 16
                    font.letterSpacing = 2
                }
                MouseArea{
                    anchors.fill: parent
                    cursorShape: "PointingHandCursor"
                    onClicked: media1.pause()
                }
            }
        }

        //music components
        //volume slider
        Label{
            id: volumeL
            width: 40
            height: 20
            y: y + nav.height + tools.height + 10
            x: (parent.width / 2) - width/2 - 20
            text: "VOLUME"
            color: "grey"
            textFormat: {
                font.pixelSize = 16
                font.letterSpacing = 2
            }
        }

        Slider{
            id: volumeSlider
            width: parent.width - 30
            height: 50
            y: y + nav.height + tools.height + volumeL.height
            x: x + 15
            value: 0.5
        }

        //progress bar
        Label{
            id: progresL
            width: 40
            height: 20
            y: y + nav.height + tools.height + 15 + volumeSlider.height
            x: (parent.width / 2) - width/2 - 10
            text: "SEEK"
            color: "grey"
            textFormat: {
                font.pixelSize = 16
                font.letterSpacing = 2
            }
        }

        Slider{
            id: progresPlay
            width: parent.width - 30
            height: 20
            x: x + 15
            y: y + nav.height + tools.height + volumeL.height + progresL.height + volumeSlider.height + 5
            minimumValue: 0
            maximumValue: media1.duration
            function seek(){
                var pos = progresPlay.value
                if(media1.seekable == false)    return;
                if(pos == 0)    return;
                media1.seek(Math.round(pos));
            }
            onValueChanged: {
                seek()
            }
        }

        //progress StatusBar
        ProgressBar{
            id: progressStatus
            width: parent.width - 30
            height: 5
            x: x + 15
            y: y + nav.height + tools.height + volumeL.height + progresL.height + volumeSlider.height + 15 + progresPlay.height
            minimumValue: 0
            maximumValue: media1.duration
            value: media1.position
        }

        //Playlist
        Rectangle{
            id: listRec
            width: parent.width - 10
            height: parent.height / 2 + 30
            color: "grey"
            y: root.height - height - stat.height
            x: parent.x + 5
            //addlist
            MusicListModel{id: musicModel}
            MusicDelegate{id: musicDel}
            ListView{
                anchors.fill: parent
                model: musicModel
                delegate: musicDel
                spacing: 5
            }
        }

        //status bar
        Rectangle{
            id: stat
            height: nav.height
            width: parent.width
            anchors.bottom: parent.bottom
            color: "#424242"
            Label{
                id: statusLabel
                width: parent.width - 10
                height: parent.height - 5
                y: y + 2
                x: parent.x + 5
                color: "grey"
                Text{
                    id: statusText
                    text: "source..."
                    elide: Text.ElideRight
                    font.pixelSize: 11
                    color: "grey"
                }
            }
        }
    }
}
