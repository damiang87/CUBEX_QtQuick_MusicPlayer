import QtQuick 2.0
import QtQuick.Window 2.0

Component {
    Rectangle{
        id: baseRec
        height: 20
        width: listRec.width
        color: "grey"
        Text {
            id: texSrc
            elide: Text.ElideRight
            color: "black"
            anchors.fill: parent
            text: index + " " + name
            verticalAlignment: Text.AlignVCenter
        }
        MouseArea{
            anchors.fill: parent
            cursorShape: "PointingHandCursor"
            hoverEnabled: true
            onClicked: {
                media1.stop()
                progresPlay.value = 0
                media1.source = myFile.fileUrls[index]
                media1.play()
                statusText.text = myFile.fileUrls[index]
            }
            onEntered: {
                baseRec.color = "#19605e"
            }
            onExited: {
                baseRec.color = "grey"
            }
        }
    }
}



