# Add more folders to ship with the application, here
#folder_01.source = qml
#folder_01.target = qml
#DEPLOYMENTFOLDERS = folder_01

QT += multimedia core network concurrent quick

CONFIG += c++11 release #static release link_prl
#CONFIG -= qt

#CONFIG(release, debug|release): LIBS += -L$$PWD/../../QtSDK-x86_64 - static/lib/ -lQt5Core -lQt5Gui -lQt5Quick -lQt5Multimedia -lQt5Network -lQt5Qml
#else:CONFIG(debug, debug|release): LIBS += -L$$PWD/../../QtSDK-x86_64 - static/lib/ -lQt5Cored -lQt5Guid -lQt5Quickd -lQt5Multimediad -lQt5Networkd -lQt5Qmld

QMAKE_CXXFLAGS -= -O1 -O2 -O3


LIBS += -fopenmp
QMAKE_CXXFLAGS += -fopenmp -Ofast

RESOURCES += \
    ui/resources/qmlResources.qrc \
    ui/resources/imageResources.qrc \
    ui/resources/guiButtonsResources.qrc \
    ui/resources/menuResources.qrc \
    ui/resources/audioResources.qrc \
    ui/resources/MonkeysSpinningMonkeys.qrc

INCLUDEPATH += \
    backend \
    backend/ai \
    backend/core \
    backend/networking

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += \ 
    backend/core/fourInARowArray.cpp \
    backend/core/fourToFiveInARowArray.cpp \
    backend/core/GameCore.cpp \
    backend/core/GuiGameController.cpp \
    backend/core/threeInARowArray.cpp \
    backend/core/threeToFourInARowArray.cpp \
    backend/core/threeToFourInARowIndexesArray.cpp \
    backend/core/twoInARowArray.cpp \
    backend/core/Wins.cpp \
    backend/main.cpp \
    backend/core/rotationArray.cpp

# Installation path
# target.path =

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    ui/qml/Arrow.qml \
    ui/qml/Board.qml \
    ui/qml/BoardHoleButton.qml \
    ui/qml/ChallengePopup.qml \
    ui/qml/GameOverMenu.qml \
    ui/qml/LobbyRow.qml \
    ui/qml/main.qml \
    ui/qml/NetworkLobby.qml \
    ui/qml/QmlTimer.qml \
    ui/qml/Quadrant.qml \
    ui/qml/SentChallengePopup.qml \
    ui/qml/StartMenu.qml \
    ui/qml/ClawPiece.qml \
    ui/qml/GUIButton.qml \
    ui/qml/RedRotateButton.qml \
    ui/qml/Smoke.qml \
    ui/qml/SplashScreen.qml \
    ui/qml/Tbar.qml \
    ui/qml/Witch.qml \
    ui/qml/Cogs.qml

HEADERS += \
    backend/networking/Barrager.h \
    backend/networking/NetworkInterface.h \
    backend/networking/PentagoNetworkUtil.h \
    backend/networking/Transaction.h \
    backend/core/BitBoard.h \
    backend/core/BitboardUtil.h \
    backend/core/BoardLocation.h \
    backend/core/Direction.h \
    backend/core/GameCore.h \
    backend/core/GameData.h \
    backend/core/GuiGameController.h \
    backend/core/MainBoard.h \
    backend/core/MusicPlayer.h \
    backend/core/PentagoExceptions.h \
    backend/core/Player.h \
    backend/core/PlayerColor.h \
    backend/core/Quadrant.h \
    backend/core/Turn.h \
    backend/core/WinningAlignment.h \
    backend/ai/lessdumbplayer2.h \
    backend/ai/lessdumbplayer3.h \
    backend/ai/MonteCarloAI.h \
    backend/ai/randomplayer.h \
    backend/ai/SmarterPlayer.h \
    backend/ai/MonteCarloAI2.h \
    backend/ai/MonteCarloAI3.h \
    backend/ai/MonteCarloAI4.h \
    backend/ai/MonteCarloParallelAI.h \
    backend/ai/AlphaBetaAI.h



