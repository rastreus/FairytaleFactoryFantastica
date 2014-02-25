#ifndef SMARTERPLAYER_H
#define SMARTERPLAYER_H

#include <iostream>
#include <fstream>
#include <cstring>
#include <cstdlib>
#include <string>
#include <cassert>
#include <time.h>

#include "Player.h"

#define MAX_PIECES_ON_BOARD 36
#define MAX_PIECES_ON_QUADRANT 9
#define NUMBER_OF_POSSIBLE_ROTATIONS 8
#define NUMBER_OF_QUADRANTS 4

struct RotationConfig{
    Direction direction;
    short quadrantIndex;


    inline RotationConfig& operator++(){
        if( direction == Direction::LEFT ){
            direction = Direction::RIGHT;
        }
        else{
            direction = Direction::LEFT;
            if(quadrantIndex == 3){
                quadrantIndex = 0;
            }
            else{
                ++quadrantIndex;
            }
        }

        return *this;
    }

    inline void randomize(){
        direction = (Direction)(rand()%2);
        quadrantIndex = rand()%4;
    }
};

class SmarterPlayer : public Player {

    //GameCore* const gameCore;

    int moveCount;
    bool isFirstMove;
    Turn lastMove;


    BitBoard opponentsBoard;
    BitBoard myOriginalBoard;

    static const int WIN_WEIGHT = 10000000;
    static const int FOUR_WEIGHT = 1000000;
    static const int THREE_WEIGHT = 1000;
    static const int TWO_WEIGHT = 2;
    static const int DEFAULT_WEIGHT = 1;
public:

    SmarterPlayer():moveCount(0),isFirstMove(true){
    }

    inline int evaluateBitBoard( const BitBoard& boardToCheck ){

        int resultWeight = DEFAULT_WEIGHT;

        for(BitBoard winningBoard : WINS){
            if( boardToCheck.hasPattern(winningBoard) && !winningBoard.overlapsPattern( opponentsBoard ) ){
                return WIN_WEIGHT;
            }
        }

        for( unsigned char fourInARowIndex = 0; fourInARowIndex < NUMBER_OF_SIGNIFICANT_FOUR_IN_A_ROW_PATTERNS; ++fourInARowIndex ){

            BoardInt fourInARowBoard = FOUR_IN_A_ROW[fourInARowIndex];

            //if( boardToCheck has a four-in-a-row pattern we didn't already have
            if( !myOriginalBoard.hasPattern( fourInARowBoard ) && boardToCheck.hasPattern( fourInARowBoard ) ){

                assert(!opponentsBoard.overlapsPattern(fourInARowBoard));

                BoardInt futureWinPattern1 = FOUR_TO_FIVE_IN_A_ROW[fourInARowIndex][0];
                BoardInt futureWinPattern2 = FOUR_TO_FIVE_IN_A_ROW[fourInARowIndex][1];

                // make sure the four-in-a-row patterns aren't blocked on at least one end
                if( !opponentsBoard.overlapsPattern(futureWinPattern1) ){
                    resultWeight += FOUR_WEIGHT;
                }

                if( futureWinPattern2 != 0 && !opponentsBoard.overlapsPattern(futureWinPattern2) ){
                    resultWeight += FOUR_WEIGHT;
                }
            }
        }

        if( resultWeight > DEFAULT_WEIGHT )
            return resultWeight;

        for( unsigned char threeInARowIndex = 0; threeInARowIndex < NUMBER_OF_SIGNIFICANT_THREE_IN_A_ROW_PATTERNS; ++threeInARowIndex ){
            BoardInt threeInARowBoard = THREE_IN_A_ROW[threeInARowIndex];

            if( boardToCheck.hasPattern( threeInARowBoard ) && !myOriginalBoard.hasPattern( threeInARowBoard )  ){

                assert(!opponentsBoard.overlapsPattern(threeInARowBoard));

                BoardInt future4Pattern1 = THREE_TO_FOUR_IN_A_ROW[threeInARowIndex][0];
                BoardInt future4Pattern2 = THREE_TO_FOUR_IN_A_ROW[threeInARowIndex][1];
                int future4Pattern1Index = THREE_TO_FOUR_IN_A_ROW_INDEXES[threeInARowIndex][0];
                int future4Pattern2Index = THREE_TO_FOUR_IN_A_ROW_INDEXES[threeInARowIndex][1];

                if( !opponentsBoard.overlapsPattern(future4Pattern1) ){

                    BoardInt futureWinPattern1 = FOUR_TO_FIVE_IN_A_ROW[future4Pattern1Index][0];
                    BoardInt futureWinPattern2 = FOUR_TO_FIVE_IN_A_ROW[future4Pattern1Index][1];

                    if( !opponentsBoard.overlapsPattern(futureWinPattern1) ){
                        resultWeight += THREE_WEIGHT;
                    }
                    if( futureWinPattern2 != 0 && !opponentsBoard.overlapsPattern(futureWinPattern2) ){
                        resultWeight += THREE_WEIGHT;
                    }
                }

                if( future4Pattern2Index != -1 && !opponentsBoard.overlapsPattern(future4Pattern2) ){

                    BoardInt futureWinPattern1 = FOUR_TO_FIVE_IN_A_ROW[future4Pattern2Index][0];
                    BoardInt futureWinPattern2 = FOUR_TO_FIVE_IN_A_ROW[future4Pattern2Index][1];

                    if( !opponentsBoard.overlapsPattern(futureWinPattern1) ){
                        resultWeight += THREE_WEIGHT;
                    }
                    if( futureWinPattern2 != 0 && !opponentsBoard.overlapsPattern(futureWinPattern2) ){
                           resultWeight += THREE_WEIGHT;
                    }
                }
            }
        }

        if( resultWeight > DEFAULT_WEIGHT )
            return resultWeight;


        for( BitBoard twoInARowBoard : TWO_IN_A_ROW ){
            if( boardToCheck.hasPattern(twoInARowBoard) && !opponentsBoard.overlapsPattern(twoInARowBoard) ){
                resultWeight += TWO_WEIGHT;
            }
        }

        return resultWeight;
    }

    //obviously this wouldn't work right now -- the MainBoard would need to accept a
    //move as a BitBoard and & it with itself. The GuiGameController would also have to be
    //slightly changed.
    Turn getMove(const Board& mainBoard) override{


        myOriginalBoard = mainBoard.getBoardOfPlayer(myColor);

        int bestMoveWeight = 0;
        Turn bestMove;

        //make every possible move for mover
        //make every possible piece placement

        for( int quadrantIndex = rand()% 4, quadrantCount = 0;  quadrantCount < NUMBER_OF_QUADRANTS;    quadrantIndex = ((quadrantIndex == 3)? 0 : quadrantIndex + 1), ++quadrantCount ){
            for( int pieceIndex = rand()%9, pieceCount = 0;     pieceCount    < MAX_PIECES_ON_QUADRANT;   pieceIndex  = ((pieceIndex    == 8)? 0 : pieceIndex    + 1), ++pieceCount    ){

                if( mainBoard.holeIsEmpty( quadrantIndex, pieceIndex )){

                    //place the piece
                    BitBoard tryPieceHere = myOriginalBoard;
                    tryPieceHere.placePiece(quadrantIndex, pieceIndex);


                    //loop through all 8 possible rotations
                    int rotationCount = 0;
                    RotationConfig rotationConfig;
                    for( rotationConfig.randomize(); rotationCount < NUMBER_OF_POSSIBLE_ROTATIONS; ++rotationCount, ++rotationConfig ){

                        BitBoard boardToRotate = tryPieceHere;
                        boardToRotate.rotate( rotationConfig.quadrantIndex, rotationConfig.direction );
                        opponentsBoard = mainBoard.getBoardOfPlayer(opponentColor);
                        opponentsBoard.rotate( rotationConfig.quadrantIndex, rotationConfig.direction );

                        int checkWeight = evaluateBitBoard( boardToRotate );

                        //if it's the best move we've found this far, keep it
                        if( checkWeight > bestMoveWeight ){
                            bestMove = Turn(quadrantIndex, pieceIndex, rotationConfig.quadrantIndex, rotationConfig.direction, myColor);
                            bestMoveWeight = checkWeight;
                        }
                    }
                }
            }
        }

        return bestMove;

    }

};


#endif // SMARTERPLAYER_H
