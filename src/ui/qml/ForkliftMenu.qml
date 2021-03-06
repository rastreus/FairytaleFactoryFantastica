import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtMultimedia 5.0
import QtGraphicalEffects 1.0

Rectangle {
    id: forkliftMenu
    width: parent.width
    height: parent.height
    anchors.fill: parent
    color: "black"

    state: "INVISIBLE"

    states: [
        State {
            name: "VISIBLE"
            PropertyChanges { target: menuFade; opacity: 0; visible: true; }
            PropertyChanges { target: startMenu; visible: true }
            StateChangeScript{ name: "moveForklift"; script: moveForklift.start(); }
            StateChangeScript{ name: "playTankSound"; script: if(_SOUND_CHECK_FLAG) tankSound.play(); }
        },
        State{
            name: "INVISIBLE"
            PropertyChanges { target: menuFade; opacity: 0; visible: false; }
            PropertyChanges { target: startMenu; visible: false }

        }

    ]

    transitions:[
        Transition{
            to: "VISIBLE"

            ScriptAction{
                scriptName: "moveForklift"
            }
        }
    ]

    SoundEffect {
        id: tankSound
        source: "tank.wav"
    }

    SoundEffect {
        id: slidingSound
        source: "sliding-sound.wav"
    }

    SoundEffect {
            id: pressButtonSound
            source: "ButtonClick2.wav"
    }

    property int _FORKLIFT_MENU_DOORS_TOP_MARGIN: 100

    Doors{
        id: doors
        z: brickWall + 5
        width: 700;
        height: 800;
        color: "black"
        anchors.top: forkliftMenu.top
        anchors.topMargin: _FORKLIFT_MENU_DOORS_TOP_MARGIN
        anchors.right: forkliftMenu.right
        anchors.rightMargin: 51

        //source: "loading-bay-door.png"
        //width: 1260; //height: loadingBayDoor.width;
        //fillMode: Image.PreserveAspectFit
    }

    Image {
        id: fx3_logo
        width: 600; height: 200
        source: "fx3-50opacity.png"
        z: brickWall.z + 1
        rotation: -15
        scale: 0.75
        anchors.left: forkliftMenu.left
        anchors.leftMargin: -75
        anchors.top: forkliftMenu.top
    }

    Image{
        anchors.fill: parent
        id: brickWall
        source: "LoadingDockWithDoor.png"
        z: 5
    }

    NumberAnimation{
        id: fadeForkliftMenu; target: menuFade; properties: "opacity"; to: 1; duration: 1800;
        onStopped: {
            //THIS IS IT!
        }
    }

    Image{
        id: brickWall_rightSide
        width: 134; height: parent.height
        source: "LoadingDockRightSide.png"
        fillMode: Image.PreserveAspectFit
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 14
        z: forklift.z + 1
    }

    Image{
        id: sound_Text
        width: 85; height: 85
        source: "sound-stencil.png"
        z: brickWall_rightSide.z + 1

        anchors.right: forkliftMenu.right
        anchors.rightMargin: 12
        anchors.top: forkliftMenu.top
        anchors.topMargin: 235
    }

    Item {
        id: nosound_forkliftMenu
        width: nosound_forkliftMenu_rec.width
        height: nosound_forkliftMenu_rec.height
        z: nosound_forkliftMenu_rec.z

        anchors.top: forkliftMenu.top
        anchors.topMargin: 303
        anchors.right: forkliftMenu.right
        anchors.rightMargin: 30

        RectangularGlow {
           id: nosound_forkliftMenu_glowEffect
           anchors.fill: nosound_forkliftMenu_rec
           cornerRadius: 50
           glowRadius: 20
           spread: 0.0
           color: "red"
           visible: false
           cached: true
        }

        Rectangle{
            id: nosound_forkliftMenu_rec
            color: "transparent"
            width: 50; height: 50
            visible: true
            radius: 25
            z: brickWall_rightSide.z + 1

            anchors.centerIn: nosound_forkliftMenu

            Image{
                id: nosound_forklifeMenu_img
                width: nosound_forkliftMenu_rec.width
                height: nosound_forkliftMenu_rec.height
                z: nosound_forkliftMenu_rec.z + 1
                scale: 0.7
                visible: !_SOUND_CHECK_FLAG
                source: "nosound-forkliftMenu.png"

                anchors.centerIn: nosound_forkliftMenu_rec
            }

            MouseArea {
                id: nosound_forkliftMenu_mouseArea
                anchors.fill: nosound_forkliftMenu_rec
                hoverEnabled: true

                onEntered: {
                    if(!nosound_forkliftMenu_glowEffect.visible  && nosound_forkliftMenu_mouseArea.containsMouse){
                        nosound_forkliftMenu_glowEffect.visible = true;
                    }
                }
                onExited: {
                    if(nosound_forkliftMenu_glowEffect.visible){
                        nosound_forkliftMenu_glowEffect.visible = false;
                    }
                }
                onPressed: { if( !forkliftMenuButtonsAreLocked ) pressButtonSound.play() }
                onClicked: {
                    if( !forkliftMenuButtonsAreLocked ){
                        changeSoundState();
                        changeSoundCheckFlag();
                    }
                }
            }
        }
    }

    Item {
        id: sound_forkliftMenu
        width: sound_forkliftMenu_rec.width
        height: sound_forkliftMenu_rec.height
        z: sound_forkliftMenu_rec.z

        anchors.top: forkliftMenu.top
        anchors.topMargin: 371
        anchors.right: forkliftMenu.right
        anchors.rightMargin: 30

        RectangularGlow {
           id: sound_forkliftMenu_glowEffect
           anchors.fill: sound_forkliftMenu_rec
           cornerRadius: 50
           glowRadius: 20
           spread: 0.0
           color: "green"
           visible: false
           cached: true
        }

        Rectangle{
            id: sound_forkliftMenu_rec
            color: "transparent"
            width: 50; height: 50
            visible: true
            radius: 25
            z: brickWall_rightSide.z + 1//brickWall.z + 1

            anchors.centerIn: sound_forkliftMenu

            Image{
                id: sound_forklifeMenu_img
                width: sound_forkliftMenu_rec.width
                height: sound_forkliftMenu_rec.height
                z: sound_forkliftMenu_rec.z + 1
                scale: 0.7
                visible: _SOUND_CHECK_FLAG
                source: "sound-forkliftMenu.png"

                anchors.centerIn: sound_forkliftMenu_rec
            }

            MouseArea {
                id: sound_forkliftMenu_mouseArea
                anchors.fill: sound_forkliftMenu_rec
                hoverEnabled: true

                onEntered: {
                    if( !sound_forkliftMenu_glowEffect.visible && sound_forkliftMenu_mouseArea.containsMouse && !forkliftMenuButtonsAreLocked){
                        sound_forkliftMenu_glowEffect.visible = true;
                    }
                }
                onExited: {
                    if( sound_forkliftMenu_glowEffect.visible ){
                        sound_forkliftMenu_glowEffect.visible = false;
                    }
                }
                onPressed: { if( !forkliftMenuButtonsAreLocked ) pressButtonSound.play() }
                onClicked: {
                    if( !forkliftMenuButtonsAreLocked ){
                        changeSoundState();
                        changeSoundCheckFlag();
                    }
                }
            }
        }
    }

    Item{
        id: helpBox
        width: helpBox_img.width
        height: helpBox_img.height
        z: forklift.z + 1
        anchors.bottom: forkliftMenu.bottom
        anchors.bottomMargin: -5
        anchors.horizontalCenter: forkliftMenu.horizontalCenter
        anchors.horizontalCenterOffset: -20

        Rectangle{
            id:dummy_helpBox_rec
            width: 75; height: 75
            color: "transparent"
            z: helpBox.z - 1
            anchors.centerIn: helpBox
        }

        RectangularGlow {
           id: helpBox_glowEffect
           anchors.fill: dummy_helpBox_rec
           cornerRadius: 5
           glowRadius: 0
           spread: 0.2
           color: "#f9f2a6"
           visible: false
           cached: true
        }

        SequentialAnimation{
            id: pulse_helpBox_glowEffect
            running: false
            loops: Animation.Infinite

            ParallelAnimation {
                NumberAnimation { target: helpBox_glowEffect; property: "glowRadius"; to: 80; duration: 2000; easing.type: Easing.InOutQuad }
                NumberAnimation { target: helpBox_glowEffect; property: "spread"; to: 0.0; duration: 2000; easing.type: Easing.InOutQuad }
            }
            ParallelAnimation {
                NumberAnimation { target: helpBox_glowEffect; property: "glowRadius"; to:  0; duration: 2000; easing.type: Easing.InOutQuad }
                NumberAnimation { target: helpBox_glowEffect; property: "spread"; to: 0.0; duration: 2000; easing.type: Easing.InOutQuad }
            }

        }

        Image {
            id: helpBox_img
            width: 150; height: 150
            z: helpBox.z + 1
            anchors.centerIn: helpBox

            source: "smaller-cardboard-box.png"

            Image {
                id: helpbox_text
                source: help_source_string

                anchors.left: helpBox_img.left
                anchors.leftMargin: -15
                anchors.top: helpBox_img.top
                anchors.topMargin: 8

                width: helpBox_img.width
                height: helpBox_img.height
                z: helpBox_img.z + 1

                property string help_source_string: "how-to-play-stencil.png"

                MouseArea {
                    id: helpBox_mouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        if( helpBox_mouseArea.containsMouse && helpbox_text.help_source_string === "how-to-play-stencil.png"){
                            helpbox_text.help_source_string = "how-to-play-stencil-selected.png";
                        }
                    }
                    onExited: {
                        if( helpbox_text.help_source_string === "how-to-play-stencil-selected.png"){
                            helpbox_text.help_source_string = "how-to-play-stencil.png";
                        }
                    }
                    onPressed: {
                        if(_SOUND_CHECK_FLAG && !forkliftMenuButtonsAreLocked ) pressButtonSound.play();
                        resolveEscFocus();
                    }
                    onClicked: { if( !forkliftMenuButtonsAreLocked )help.state = "SHOW_HELP"; }
                }
            }
        }
    }

    Item{
        id: creditsBox
        width: creditsBox_img.width
        height: creditsBox_img.height
        z: forklift.z + 1
        anchors.bottom: helpBox.bottom
        anchors.right: helpBox.left
        anchors.rightMargin: 15

        FontLoader{ id: stencilFont; source: "STENCIL.TTF" }

        Rectangle{
            id:dummy_creditsBox_rec
            width: 75; height: 75
            color: "transparent"
            z: creditsBox.z - 1
            anchors.centerIn: creditsBox
        }

        Image {
            id: creditsBox_img
            width: 150; height: 150
            z: creditsBox.z + 1
            anchors.centerIn: creditsBox
            source: "smaller-cardboard-box.png"
            Text {
                id: creditsBox_text
                font.family: stencilFont.name
                text: "credits"
                color: "#371D07"
                font.pointSize: 18
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.left: creditsBox_img.left
                anchors.top: creditsBox_img.top

                width: creditsBox_img.width - 22
                height: creditsBox_img.height
                z: creditsBox_img.z + 1

                MouseArea {
                    id: creditsBox_mouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        creditsBox_text.color = "#653306"
                    }
                    onExited: {
                        creditsBox_text.color = "#371D07"
                    }
                    onPressed: { if(_SOUND_CHECK_FLAG && !forkliftMenuButtonsAreLocked ) pressButtonSound.play(); }
                    onClicked: { if( !forkliftMenuButtonsAreLocked )credits.state = "SHOW_CREDITS" }
                }
            }
        }
    }

    ParallelAnimation{
        id: moveForklift

        onStarted: forklift.visible = true

        NumberAnimation{
            id: moveForkliftFromLeft
            target: forklift.anchors
            properties: "leftMargin"
            duration: 1500
            from: -700
            to: -175
        }
        RotationAnimation{
            id: rotateFrontTire
            target: frontTire
            duration: 1500
            direction: RotationAnimation.Clockwise
            from: 0
            to: 200
        }
        RotationAnimation{
            id: rotateRearTire
            target: rearTire
            duration: 1500
            direction: RotationAnimation.Clockwise
            from: 0
            to: 200
        }

        onStopped:{
            if(tankSound.playing) {
                tankSound.stop();
            }

            forklift.anchors.leftMargin = -175
            frontTire.rotation = 200
            rearTire.rotation = 200

            helpBox_glowEffect.visible = true;
            pulse_helpBox_glowEffect.start();
            exitFlickerLongTimer.start();
        }
    }

    Timer{
        id: fadeForkliftMenu_timer
        interval: 1200
        onTriggered: {
            fadeForkliftMenu.start()
        }
    }

    ParallelAnimation{
        id: moveForklift_IntoGameScreen

        onStarted: {
            //TODO: lockDownForkliftMenu()
            fadeForkliftMenu_timer.start()
        }

        NumberAnimation{
            id: moveForkliftFromLeft_IntoGameScreen
            target: forklift.anchors
            properties: "leftMargin"
            duration: 3000
            from: -175
            to: 1200
        }
        RotationAnimation{
            id: rotateFrontTire_IntoGameScreen
            target: frontTire
            duration: 3000
            direction: RotationAnimation.Clockwise
            from: 200
            to: 600
        }
        RotationAnimation{
            id: rotateRearTire_IntoGameScreen
            target: rearTire
            duration: 3000
            direction: RotationAnimation.Clockwise
            from: 200
            to: 600
        }

        onStopped:{
            if(tankSound.playing) {
                tankSound.stop();
            }

            forklift.visible = false
            forklift.anchors.leftMargin = -700
            frontTire.rotation = 0
            rearTire.rotation = 0

            //Turn Off Fade
            menuFade.opacity =  0;
            menuFade.visible = false;
        }
    }

    Rectangle {
        id: forklift
        y: 248
        color: "transparent"
        anchors.bottomMargin: -48
        anchors.leftMargin: 8
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: 700
        height: 700
        scale: 0.75
        z: 10

        Image{
            id: forkTruck
            x: 26
            y: 198
            width: 700
            height: 700
            source: "ForkTruck.png"
            anchors.centerIn: parent
        }
        Image{
            id: frontTire
            x: 366
            y: 378
           // x: 378
            //y: 594
            width: 300
            height: 288
            anchors.verticalCenterOffset: 172
            anchors.horizontalCenterOffset: 166
            source: "Tires_Grey.png"
            anchors.centerIn: parent
            z: 13
        }
        Image{
            id: rearTire
            x: -8
            y: 434
            //x: 0
            //y: 640
            width: 224
            height: 224
            anchors.verticalCenterOffset: 196
            anchors.horizontalCenterOffset: -246
            source: "Tires_Grey.png"
            anchors.centerIn: parent
            z: 13
        }

        Item {
            id: forkWitch
            x: 192
            y: 60
            width: forkWitch_img.width
            height: forkWitch_img.height

            Glow {
               id: forkWitch_glowEffect
               anchors.fill: forkWitch_img
               radius: 24
               samples: 12
               spread: 0.4
               color: "#880E8200"
               source: forkWitch_img
               visible: false
               fast: true
               cached: true
            }

            Image {
                id: forkWitch_img
                anchors.centerIn: forkWitch
                source: "WitchOnForks.png"

                SoundEffect {
                    id: witchSound
                    source: "witch-laugh.wav"
                }

                MouseArea {
                    id: witch_mouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        if(forkWitch_glowEffect.visible == false && witch_mouseArea.containsMouse && !forkliftMenuButtonsAreLocked ){
                            forkWitch_glowEffect.visible = true;
                        }
                    }
                    onExited: {
                        if(forkWitch_glowEffect.visible == true ){
                            forkWitch_glowEffect.visible = false;
                        }
                    }
                    onPressed: if(_SOUND_CHECK_FLAG && !forkliftMenuButtonsAreLocked ) witchSound.play()
                }
            }
        }

        Image {
            id: fork
            x: 513
            y: 26
            rotation: -3
            source: "Fork.png"
        }

        Image {
            id: box1
            x: 668
            y: -350
            z: 3
            source: "WideCardboardBox.png"

            Image {
                id: startMenu_startOnePlayer
                source: source_string

                anchors.left: box1.left
                anchors.leftMargin: 15
                anchors.top: box1.top
                anchors.topMargin: 85

                width: 375; height: 375; scale: 1
                z: box1.z + 1

                property string source_string: "single-player-stencil.png"

                MouseArea {
                    id: singlePlayer_mouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        if( singlePlayer_mouseArea.containsMouse && startMenu_startOnePlayer.source_string === "single-player-stencil.png" && !forkliftMenuButtonsAreLocked ){
                            startMenu_startOnePlayer.source_string = "single-player-stencil-selected.png";
                        }
                    }
                    onExited: {
                        if( startMenu_startOnePlayer.source_string === "single-player-stencil-selected.png" && !forkliftMenuButtonsAreLocked ){
                            if(startOnePlayer_currently_selected == false){
                                startMenu_startOnePlayer.source_string = "single-player-stencil.png";
                            }
                        }
                    }
                    onPressed: {
                        if( !forkliftMenuButtonsAreLocked ){
                            startOnePlayer_currently_selected = true;
                            if(net_currently_selected == true) {
                                net_currently_selected = false;
                                startMenu_startNetwork.net_source_string = "network-game-stencil.png";
                            }
                            if(pvp_currently_selected == true) {
                                pvp_currently_selected = false;
                                startMenu_startPlayerVsPlayer.pvp_source_string = "player-vs-player-stencil.png";
                            }
                            if(_SOUND_CHECK_FLAG) slidingSound.play();
                        }
                    }
                    onClicked: {
                        if( !forkliftMenuButtonsAreLocked ){
                            doors.state = "SINGLE_PLAYER";
                        }
                    }
                }
            }

        }

        Image {
            id: box2
            x: 642
            y: -74
            source: "WideCardboardBox.png"
            z: box1.z - 1

            Image {
                id: startMenu_startPlayerVsPlayer
                source: pvp_source_string
                anchors.left: box2.left
                anchors.leftMargin: 15
                anchors.top: box2.top
                anchors.topMargin: 85
                width: 375; height: 375; scale: 1
                z: box2.z + 1


                property string pvp_source_string: "player-vs-player-stencil.png"

                MouseArea {
                    id: pvp_mouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        if( pvp_mouseArea.containsMouse && startMenu_startPlayerVsPlayer.pvp_source_string === "player-vs-player-stencil.png" && !forkliftMenuButtonsAreLocked  ){
                            startMenu_startPlayerVsPlayer.pvp_source_string = "player-vs-player-stencil-selected.png";
                        }
                    }

                    onExited: {
                        if( startMenu_startPlayerVsPlayer.pvp_source_string === "player-vs-player-stencil-selected.png"  ){
                            if(pvp_currently_selected == false){
                                startMenu_startPlayerVsPlayer.pvp_source_string = "player-vs-player-stencil.png";
                            }
                        }
                    }
                    onPressed: {
                        if ( !forkliftMenuButtonsAreLocked ){
                            pvp_currently_selected = true;
                            if(net_currently_selected == true) {
                                net_currently_selected = false;
                                startMenu_startNetwork.net_source_string = "network-game-stencil.png";
                            }
                            if(startOnePlayer_currently_selected == true) {
                                startOnePlayer_currently_selected = false;
                                startMenu_startOnePlayer.source_string = "single-player-stencil.png";
                            }
                            if(_SOUND_CHECK_FLAG) slidingSound.play();
                        }
                    }
                    onClicked: {
                        if ( !forkliftMenuButtonsAreLocked ){
                            doors.state = "VERSUS"
                        }
                    }
                }
            }
        }

        Image {
            id: box3
            x: 616
            y: 186
            source: "WideCardboardBox.png"
            z: box2.z - 1

            Image {
                id: startMenu_startNetwork
                source: net_source_string
                anchors.left: box3.left
                anchors.leftMargin: 15
                anchors.top: box3.top
                anchors.topMargin: 85
                width: 375; height: 375; scale: 1
                z: box3.z + 1

                property string net_source_string: "network-game-stencil.png"

                MouseArea {
                    id: network_mouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        if( !forkliftMenuButtonsAreLocked && network_mouseArea.containsMouse && startMenu_startNetwork.net_source_string === "network-game-stencil.png"){
                            startMenu_startNetwork.net_source_string = "network-game-stencil-selected.png";
                        }
                    }

                    onExited: {
                        if( startMenu_startNetwork.net_source_string === "network-game-stencil-selected.png"){
                            if( net_currently_selected == false) {
                                startMenu_startNetwork.net_source_string = "network-game-stencil.png";
                            }
                        }
                    }
                    onPressed: {
                        if (!forkliftMenuButtonsAreLocked ){
                            net_currently_selected = true;
                            if(pvp_currently_selected == true) {
                                pvp_currently_selected = false;
                                startMenu_startPlayerVsPlayer.pvp_source_string = "player-vs-player-stencil.png";
                            }
                            if(startOnePlayer_currently_selected == true) {
                                startOnePlayer_currently_selected = false;
                                startMenu_startOnePlayer.source_string = "single-player-stencil.png";
                            }
                            if(_SOUND_CHECK_FLAG) slidingSound.play()
                        }
                    }
                    onClicked: {

                        if (!forkliftMenuButtonsAreLocked ){
                            doors.state = "NETWORK";
                        }
                    }
                }
            }
        }
    }

    Image{
        id: exitSignUnder
        width: 1056 / 9
        height: 587 / 9
        source: "exitSignLit.png"
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 15
        z: brickWall_rightSide.z + 1

    }

    Image {
        id: exitSign
        width: 1056 / 9
        height: 587 / 9
        source: "exitSignDim.png"
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 15
        z: brickWall_rightSide.z + 2

        property bool isHovered:false

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered:{
                if ( !forkliftMenuButtonsAreLocked ){
                    exitSign.isHovered = true;
                    exitSign.source = "exitSignHover.png"
                }
            }

            onExited:{
                if ( !forkliftMenuButtonsAreLocked ){
                    exitSign.isHovered = false;
                    exitSign.source = "exitSignDim.png"
                }
            }

            onClicked: {
                if (!forkliftMenuButtonsAreLocked ){
                    readyToExitGame()
                }
            }
        }

    }

    Connections{
        target: page
        onBackToMainMenu:{
            forkliftMenuButtonsAreLocked = false;
            exitFlickerLongTimer.start();
        }
        onLeaveForkliftMenuToGameScreen:{
            forkliftMenuButtonsAreLocked = true;
            exitFlickerLongTimer.stop();
            exitFlickerShortTimer.stop();
            pulse_helpBox_glowEffect.stop();
        }
    }

    Timer{
        id: exitFlickerLongTimer
        interval: 3000
        running: false
        repeat: true

        onTriggered:{
            exitFlickerShortTimer.start()
        }
    }

    Timer{
        id: exitFlickerShortTimer
        interval: 20
        running: false
        repeat: false
        property bool isLit: false
        property int flickerCount: 0
        property int totalCount: 0
        onTriggered:{
            if( flickerCount <= 26 ){
                ++flickerCount;
                totalCount+= flickerCount/2 + 1;
                interval = (totalCount % 100 + 30 ) / (totalCount%2 + 1);

                if( !exitSign.isHovered ){
                    if( isLit ){
                        exitSign.opacity = 0;
                    }
                    else{
                        exitSign.opacity = 1;
                    }

                    isLit = !isLit;
                }
                exitFlickerShortTimer.start();
            }
            else{
                flickerCount = 0;
                exitFlickerLongTimer.start();
            }
        }
    }
}
