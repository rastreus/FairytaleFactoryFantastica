#ifndef GUIGAMECONTROLLER_H
#define GUIGAMECONTROLLER_H

#include "GameCore.h"
#include "Player.h"

#include <QGuiApplication>
#include <QObject>
#include <QQuickView>
#include <QQuickItem>
#include <QMediaPlayer>
#include <QThread>

//#include "MonteCarloParallelAI.h"
#include "NetworkInterface.h"
#include "SmartestPlayer.h"
#include "MonteCarloParallelAI.h"
#include "AlphaBetaAI.h"
#include "FinalPlayer.h"


class Proxy : public QObject {

Q_OBJECT

public:

    virtual ~Proxy(){}


signals:

    //qml proxy
    void challengeTimedOutAsIfDeclined();
    void readyToStartOnePersonPlay( int aiLevel, int menuSelectedColor );
    void readyToStartTwoPersonPlay();
    void changeSoundState();
    void changeGuiPlayerColor(int color);
    void readyToExitGame();
    void leaveLobby();
    void sendPlayerName(QVariant playerName );
    void readyToOpenClaw(int qIndex, int pIndex, QVariant whichClaw );
    void enterNetworkLobby();
    void sendThisChallenge( QVariant stringAddressOfPlayerToChallenge );
    void challengeReceivedFromNetwork( QVariant challengerName, QVariant stringAddressOfPlayerWhoChallenged );
    void challengeWasAccepted();
    void challengeWasDeclined();
    void sendThisChallengeResponse( bool acceptChallenge );
    void sendThisNetworkMove( int quadrantIndex, int pieceIndex, int quadrantToRotate, int rotationDirection, PlayerColor );
    void playerEnteredLobby( QVariant arrivingPlayerName, QVariant addressOfArrivingPlayer, int playerId, bool isBusy );
    void networkPlayerNoLongerBusy(QVariant);
    void networkPlayerBecameBusy(QVariant);
    void playerLeftLobby( int playerId );
    void opponentDisconnected();
    void opponentReconnected();

    //GuiGameController proxy
    void readyForGuiMove();
    void readyForVersusMove();
    void gameIsOver();
    void registerGuiTurnWithBoard();
    void setGuiTurnRotation( int quadrantToRotate, int rotationDirection );
    void setGuiTurnHole( int qIndex, int pIndex );

};

class GuiGameController : public QObject, public GameCore {

    Q_OBJECT
    Q_PROPERTY( QList<int> opponentsTurn READ getOpponentsTurn )
    Q_PROPERTY( int winner READ getWinner )

protected:

    typedef SmartestPlayer<0, true>       EasyAIPlayer;
    typedef SmartestPlayer<1>       MediumAIPlayer;
    typedef FinalPlayer<1>       HardAIPlayer;

    QGuiApplication* app;
    Proxy* gui;
    Player* player2; //AI
    NetworkInterface* net;
    EasyAIPlayer easyAi;
    MediumAIPlayer mediumAi;
    HardAIPlayer hardAi;
    PlayerColor guiPlayerColor;
    QString guiPlayerName;
    PlayerColor firstMover;
    bool isGuiPlayersTurn;
    bool isNetworkGame;
    bool isVersusGame;
    QList<int> qOpponentsLastTurn;
    Turn qGuiTurn;

    void startNetworkGame( PlayerColor myColor );

public:

    //called from main
    GuiGameController( QGuiApplication* mainApp );
    void setWindow(Proxy* window);
    void setQApplication( QGuiApplication* qapp );

    //called from QML
    Q_INVOKABLE QList<int> getOpponentsTurn() const {
        return qOpponentsLastTurn;
    }

    Q_INVOKABLE int getWinner();
    Q_INVOKABLE int getLastMoverColor();
signals:

    void badMoveFromGui();
    void gameIsOver();
    void readyForGuiMove();
    void readyForVersusMove();
    void challengeReceived();
    void challengeAccepted();
    void challengeDeclined();

public slots:

    //connected to Gui buttons
    void setPlayer2( Player* );
    void startOnePersonPlay( int aiLevel, int menuSelectedColor );
    void startTwoPersonPlay();
    void enterNetworkLobby();
    void exitGame();
    void setPlayerName(QVariant name);

    void registerOpponentsTurnWithBoard( Turn );
    void registerGuiTurnWithBoard();
    void setGuiTurnHole( int qIndex, int pIndex );
    void setGuiTurnRotation( int quadrantToRotate, int rotationDirection );

    //network slots
    void forwardChallengeResponse(bool accepted);
    void challengeResponseReceivedFromNetwork(bool);
    void networkTurnReceivedFromNetwork( int, int, int, int );
    void initialize();
    void setNetworkInterface();
    void leaveLobby();
};


class GuiProxy : public Proxy {

    Q_OBJECT

    GuiGameController* core;

public:

    //called from QML
    Q_INVOKABLE QList<int> getOpponentsTurn() const {
        return core->getOpponentsTurn();
    }

    Q_INVOKABLE int getWinner(){
        return core->getWinner();
    }
    Q_INVOKABLE int getLastMoverColor(){
        return core->getLastMoverColor();
    }

    ~GuiProxy(){}

    GuiProxy( GuiGameController* c, QQuickItem* gui){
        core = c;

        qDebug() << "connecting gui proxy signals";
        connect( gui,   SIGNAL( readyToStartOnePersonPlay( int,int ) ),             this,   SIGNAL( readyToStartOnePersonPlay( int,int ) ));
        connect( gui,   SIGNAL( readyToStartTwoPersonPlay() ),                      this,   SIGNAL( readyToStartTwoPersonPlay() ));
        connect( gui,   SIGNAL( sendPlayerName( QVariant ) ) ,                      this,   SIGNAL( sendPlayerName( QVariant )  ));
        connect( gui,   SIGNAL( enterNetworkLobby() ),                              this,   SIGNAL( enterNetworkLobby() ));
        connect( gui,   SIGNAL( changeSoundState() ),                               this,   SIGNAL( changeSoundState() ));
        connect( gui,   SIGNAL( changeGuiPlayerColor( int )),                       this,   SIGNAL( changeGuiPlayerColor( int ) ));
        connect( gui,   SIGNAL( readyToExitGame() ),                                this,   SIGNAL( readyToExitGame() ));
        connect( gui,   SIGNAL( leaveLobby() ),                                     this,   SIGNAL( leaveLobby() ));
        connect( gui,   SIGNAL(sendThisChallenge(QVariant)),                        this,   SIGNAL(sendThisChallenge(QVariant)));
        connect( gui,   SIGNAL(sendThisChallengeResponse(bool)),                    this,   SIGNAL(sendThisChallengeResponse(bool)));
        connect( this,  SIGNAL(challengeReceivedFromNetwork(QVariant, QVariant)),   gui,    SIGNAL(challengeReceivedFromNetwork(QVariant, QVariant)));
        connect( this,  SIGNAL( challengeWasAccepted()),                            gui,    SIGNAL(challengeWasAccepted() ));
        connect( this,  SIGNAL( challengeWasDeclined()),                            gui,    SIGNAL(challengeWasDeclined()));
        connect( gui,   SIGNAL( challengeTimedOutAsIfDeclined()),                   this,   SIGNAL(challengeTimedOutAsIfDeclined()));
        connect( this,  SIGNAL( playerEnteredLobby(QVariant, QVariant, int, bool )),gui,    SIGNAL(playerEnteredLobby(QVariant, QVariant, int, bool )));
        connect( this,  SIGNAL( playerLeftLobby(int)),                              gui,    SIGNAL(playerLeftLobby(int)));
        connect( this,  SIGNAL(opponentReconnected()),                              gui,    SIGNAL(opponentReconnected()));
        connect( this,  SIGNAL(opponentDisconnected()),                             gui,    SIGNAL(opponentDisconnected()));
        connect( this,  SIGNAL(networkPlayerBecameBusy(QVariant)),                  gui,    SIGNAL(networkPlayerBecameBusy(QVariant)) );
        connect( this,  SIGNAL(networkPlayerNoLongerBusy(QVariant)),                  gui,  SIGNAL(networkPlayerNoLongerBusy(QVariant)) );

        qDebug() << "connecting core proxy signals";
        connect( core,  SIGNAL( readyForGuiMove() ),                                this,   SIGNAL(readyForGuiMove()),          Qt::QueuedConnection );
        connect( core,  SIGNAL( readyForVersusMove() ),                             this,   SIGNAL(readyForVersusMove()),    Qt::QueuedConnection );
        connect( core,  SIGNAL( gameIsOver() ),                                     this,   SIGNAL(gameIsOver()),               Qt::QueuedConnection );
        connect( this,  SIGNAL( registerGuiTurnWithBoard()),                        core,   SLOT( registerGuiTurnWithBoard()),  Qt::QueuedConnection );
        connect( this,  SIGNAL(setGuiTurnRotation(int, int)),                       core,   SLOT(setGuiTurnRotation(int,int)),  Qt::QueuedConnection );
        connect( this,  SIGNAL(setGuiTurnHole(int,int)),                            core,   SLOT(setGuiTurnHole(int,int)),      Qt::QueuedConnection );

    }


};

#endif // GUIGAMECONTROLLER_H
