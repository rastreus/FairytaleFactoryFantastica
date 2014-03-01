import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Rectangle {

    id: startMenu
    width: parent.width
    height: parent.height
    z: 100
    color: "#00FFFF"

    Image {
        id: main_background
        width: 1440; height: 900; z: 0
        anchors.centerIn: parent
        source: "main-menu-background.png"
        fillMode: Image.PreserveAspectFit
    }

    /* HAMMERS CPU!
    Smoke {
        x: 1210
        y: 210
    }

    Smoke {
        x: 1340
        y: 210
    }
    */

    states: [
        State{
            name: "VISIBLE"
            PropertyChanges {
                target: startMenu
                visible: true
            }

        },
        State{
            name: "INVISIBLE"
            PropertyChanges {
                target: startMenu
                visible: false
            }
        }

    ]

    TextArea{
        id: playerNameBox
        width: 100
        height: 25
        text: "enter a name"
        anchors.left: parent.left
        anchors.leftMargin: 400
        anchors.top: parent.top
        anchors.topMargin: 5
    }

    Button {
        id: startOnePlayer
        width: 100
        height: 50
        anchors.centerIn: parent
        text: "One Player"
        onClicked: {
            sendPlayerName( playerNameBox.text );
            startMenu.state = "INVISIBLE"
            pentagoBoard.state = "UNLOCKED";
            clearBoard();
            readyToStartOnePersonPlay();
        }
    }

    Button {
        id: startNetworkPlay
        width: 100
        height: 50
        anchors.top: parent.top
        anchors.topMargin: parent.height/2+30
        anchors.left: parent.left
        anchors.leftMargin: parent.width/2
       text: "Network Play"
        onClicked: {
            sendPlayerName( playerNameBox.text );
            networkLobby.state ="VISIBLE"
            startMenu.state = "INVISIBLE"
           // pentagoBoard.state = "UNLOCKED";
            clearBoard();
            console.log("network play button clicked!");
            enterNetworkLobby();
        }
    }

    GUIButton {

        property int buttonColor

        id: colorSelection
        source_string: "purp-button.png"
        anchors.top: parent.top
        anchors.topMargin: (parent.height/2) - 30
        anchors.left: parent.left
        anchors.leftMargin: 30
        z: 3

        state: "BLACK"
        buttonColor: 1

        states: [
            State{
                name: "WHITE"
                PropertyChanges{ target: colorSelection; buttonColor: 0 }
            },
            State{
                name: "BLACK"
                PropertyChanges{ target: colorSelection; buttonColor: 1 }
            }
        ]

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(colorSelection.state == "BLACK")
                {
                    colorSelection.source_string = "teal-button.png"
                    colorSelection.state = "WHITE"
                    page.guiPlayerIsWhite = true;
                    changeGuiPlayerColor(colorSelection.buttonColor);
                }
                else
                {
                    colorSelection.source_string = "purp-button.png"
                    colorSelection.state = "BLACK"
                    page.guiPlayerIsWhite = false;
                    changeGuiPlayerColor(colorSelection.buttonColor);
                }
            }
        }
    }

    GUIButton {
        id: startMenu_soundButton
        source_string: "sound-button.png"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: ((parent.height - 30)/4) - 30
        anchors.left: parent.left
        anchors.leftMargin: 30
        z: 3

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (startMenu_soundButton.source_string === "sound-button.png") {
                    startMenu_soundButton.source_string = "nosound-button.png"
                } else {
                    startMenu_soundButton.source_string = "sound-button.png"
                }
                changeSoundState();
            }
        }
    }

    GUIButton {
        id: startMenu_leaveGame
        source_string: "leave-button.png"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: 15
        anchors.leftMargin: 30
        z: 3

        MouseArea {
            anchors.fill: parent

            onClicked: {
                readyToExitGame()
            }
        }
    }

}
