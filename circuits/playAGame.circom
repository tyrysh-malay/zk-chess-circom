pragma circom  2.1.6;

include "isKingSafe.circom";
include "isMoveLegal.circom";

template PlayAGame(N) {
    signal input origHor[N];
    signal input origVer[N];
    signal input origPiece[N];
    signal input destHor[N];
    signal input destVer[N];
    signal input captFlag[N];
    signal input prmtPiece[N];
    signal output finalResult;

    signal board[N+1][8][8];
    signal stm[N+1];
    signal kingCstlFlag[N+1][2];
    signal qnCstlFlag[N+1][2];
    signal enPassHor[N+1];
    signal enPassVer[N+1];
    signal halfMvCntr[N+1];
    signal kingHor[N+1][2];
    signal kingVer[N+1][2];
    signal result[N+1];

    var i;
    var j;

    board[0][0] <== [3,5,4,2,1,4,5,3];
    board[0][1] <== [6,6,6,6,6,6,6,6];
    board[0][2] <== [0,0,0,0,0,0,0,0];
    board[0][3] <== [0,0,0,0,0,0,0,0];
    board[0][4] <== [0,0,0,0,0,0,0,0];
    board[0][5] <== [0,0,0,0,0,0,0,0];
    board[0][6] <== [12,12,12,12,12,12,12,12];
    board[0][7] <== [9,11,10,8,7,10,11,9];

    stm[0] <== 0;

    kingCstlFlag[0][0] <== 1;
    kingCstlFlag[0][1] <== 1;
    qnCstlFlag[0][0] <== 1;
    qnCstlFlag[0][1] <== 1;

    enPassHor[0] <== 50;
    enPassVer[0] <== 50;

    halfMvCntr[0] <== 0;

    kingHor[0][0] <== 0;
    kingHor[0][1] <== 7;
    kingVer[0][0] <== 4;
    kingVer[0][1] <== 4;

    for (i=1; i<(N+1); i++) {
        (board[i],stm[i],kingCstlFlag[i],qnCstlFlag[i],enPassHor[i],enPassVer[i],halfMvCntr[i],kingHor[i],kingVer[i],result[i]) <== MakeAMove()(board[i-1],stm[i-1],kingCstlFlag[i-1],qnCstlFlag[i-1],enPassHor[i-1],enPassVer[i-1],halfMvCntr[i-1],kingHor[i-1],kingVer[i-1],origHor[i-1],origVer[i-1],origPiece[i-1],destHor[i-1],destVer[i-1],captFlag[i-1],prmtPiece[i-1]);
    }

    finalResult <== result[N];

}



template UpdBoards() {
    signal input board[8][8];
    signal input origHor;
    signal input origVer;
    signal input origPiece;
    signal input destHor;
    signal input destVer;
    signal input enPassFlag;
    signal input isPawnTakenByEnPass[2][8];
    signal input prmtPiece;
    signal input prmtFlag;
    signal input isWhtQnCstl;
    signal input isWhtKingCstl;
    signal input isBlckQnCstl;
    signal input isBlckKingCstl;
    signal input isWhtCstl;
    signal input isBlckCstl;
    signal input isOrigHor[8];
    signal input isOrigVer[8];
    signal input isDestHor[8];
    signal input isDestVer[8];
    
    signal output newBoard[8][8];

    var i;
    var j;

    signal isOrigSqr[8][8];
    signal isDestSqr[8][8];

    signal pieceForDestSqr[8][8];

    signal ordinarMvPart[8][8];

    for (i=0; i<8; i++) {
        for (j=0; j<8; j++) {
            isOrigSqr[i][j] <== isOrigHor[i] * isOrigVer[j];
            isDestSqr[i][j] <== isDestHor[i] * isDestVer[j];

            pieceForDestSqr[i][j] <== origPiece * isDestSqr[i][j];

            ordinarMvPart[i][j] <== board[i][j] * (-isOrigSqr[i][j] - isDestSqr[i][j]) + pieceForDestSqr[i][j];
        }
    }


    // first rank

    signal prmtDestFlag[2][8];
    signal prmtPart[2][8];

    for (i=0; i<2; i++) {
        for (j=0; j<8; j++) {
            prmtDestFlag[i][j] <== prmtFlag*isDestSqr[7*i][j];
        }
    }

    for (i=0; i<2; i++) {
        for (j=0; j<8; j++) {
            prmtPart[i][j] <== prmtDestFlag[i][j] * (prmtPiece - board[7*i][j]);
        }
    }

    signal firstRankOrdMvFlag <== (1-isWhtCstl) * (1-prmtFlag);

    newBoard[0][0] <== board[0][0] + ordinarMvPart[0][0] * firstRankOrdMvFlag + prmtPart[0][0] - isWhtQnCstl*3;
    newBoard[0][1] <== board[0][1] + ordinarMvPart[0][1] * (1-prmtFlag)       + prmtPart[0][1];
    newBoard[0][2] <== board[0][2] + ordinarMvPart[0][2] * (1-prmtFlag)       + prmtPart[0][2];
    newBoard[0][3] <== board[0][3] + ordinarMvPart[0][3] * firstRankOrdMvFlag + prmtPart[0][3] + isWhtQnCstl*3;
    newBoard[0][4] <== board[0][4] + ordinarMvPart[0][4] * (1-prmtFlag)       + prmtPart[0][4];
    newBoard[0][5] <== board[0][5] + ordinarMvPart[0][5] * firstRankOrdMvFlag + prmtPart[0][5] + isWhtKingCstl*3;
    newBoard[0][6] <== board[0][6] + ordinarMvPart[0][6] * (1-prmtFlag)       + prmtPart[0][6];
    newBoard[0][7] <== board[0][7] + ordinarMvPart[0][7] * firstRankOrdMvFlag + prmtPart[0][7] - isWhtKingCstl*3;

    // second and third rank

    for (i=1; i<3; i++) {
        for (j=0; j<8; j++) {
            newBoard[i][j] <== board[i][j] + ordinarMvPart[i][j];
        }
    }

    // fourth and fifth rank

    for (i=3; i<5; i++) {
        for (j=0; j<8; j++) {
            newBoard[i][j] <== board[i][j] - isPawnTakenByEnPass[i-3][j] * (board[i][j] + ordinarMvPart[i][j]) + ordinarMvPart[i][j];
        }
    }

    // sixth and seventh rank

    for (i=5; i<7; i++) {
        for (j=0; j<8; j++) {
            newBoard[i][j] <== board[i][j] + ordinarMvPart[i][j];
        }
    }
    
    // eighth (last) rank

    signal lastRankOrdMvFlag <== (1-isBlckCstl) * (1-prmtFlag);

    newBoard[7][0] <== board[7][0] + ordinarMvPart[7][0] * lastRankOrdMvFlag + prmtPart[1][0] - isBlckQnCstl*9;
    newBoard[7][1] <== board[7][1] + ordinarMvPart[7][1] * (1-prmtFlag)      + prmtPart[1][1];
    newBoard[7][2] <== board[7][2] + ordinarMvPart[7][2] * (1-prmtFlag)      + prmtPart[1][2];
    newBoard[7][3] <== board[7][3] + ordinarMvPart[7][3] * lastRankOrdMvFlag + prmtPart[1][3] + isBlckQnCstl*9;
    newBoard[7][4] <== board[7][4] + ordinarMvPart[7][4] * (1-prmtFlag)      + prmtPart[1][4];
    newBoard[7][5] <== board[7][5] + ordinarMvPart[7][5] * lastRankOrdMvFlag + prmtPart[1][5] + isBlckKingCstl*9;
    newBoard[7][6] <== board[7][6] + ordinarMvPart[7][6] * (1-prmtFlag)      + prmtPart[1][6];
    newBoard[7][7] <== board[7][7] + ordinarMvPart[7][7] * lastRankOrdMvFlag + prmtPart[1][7] - isBlckKingCstl*9;
}

template MakeAMove() {
    signal input board[8][8];
    signal input stm;
    signal input kingCstlFlag[2];
    signal input qnCstlFlag[2];
    signal input enPassHor;
    signal input enPassVer;
    signal input halfMvCntr;
    signal input kingHor[2];
    signal input kingVer[2];
    signal input origHor;
    signal input origVer;
    signal input origPiece;
    signal input destHor;
    signal input destVer;
    signal input captFlag;
    signal input prmtPiece;

    signal output newBoard[8][8];
    signal output newSTM <== 1 - stm;
    signal output newKingCstlFlag[2];
    signal output newQnCstlFlag[2];
    signal output newEnPassHor;
    signal output newEnPassVer;
    signal output newHalfMvCntr;
    signal output newKingHor[2];
    signal output newKingVer[2];
    signal output result;

    signal intermedFlags[265];
    signal intermediate[65];





    // signal origPiece <== SqrToPiece()(board,origHor,origVer);
    signal destPiece <== SqrToPiece()(board,destHor,destVer);
  

    var i;
    var j;

    //checking if move is legal
    
    component wMvLgl = IsWhtMvLgl();
    component bMvLgl = IsBlckMvLgl();

    for (i=0; i<8; i++) {
        for (j=0; j<8; j++) {
            wMvLgl.board[i][j] <== board[i][j];
            bMvLgl.board[i][j] <== board[i][j];
        }
    }
    wMvLgl.kingCstlFlag <== kingCstlFlag[0];
    wMvLgl.qnCstlFlag <== qnCstlFlag[0];
    wMvLgl.enPassHor <== enPassHor;
    wMvLgl.enPassVer <== enPassVer;
    wMvLgl.origHor <== origHor;
    wMvLgl.origVer <== origVer;
    wMvLgl.origPiece <== origPiece;
    wMvLgl.destHor <== destHor;
    wMvLgl.destVer <== destVer;
    wMvLgl.destPiece <== destPiece;
    wMvLgl.captFlag <== captFlag;
    wMvLgl.prmtPiece <== prmtPiece;

    bMvLgl.kingCstlFlag <== kingCstlFlag[1];
    bMvLgl.qnCstlFlag <== qnCstlFlag[1];
    bMvLgl.enPassHor <== enPassHor;
    bMvLgl.enPassVer <== enPassVer;
    bMvLgl.origHor <== origHor;
    bMvLgl.origVer <== origVer;
    bMvLgl.origPiece <== origPiece;
    bMvLgl.destHor <== destHor;
    bMvLgl.destVer <== destVer;
    bMvLgl.destPiece <== destPiece;
    bMvLgl.captFlag <== captFlag;
    bMvLgl.prmtPiece <== prmtPiece;

    wMvLgl.flag + bMvLgl.flag === 1;


    // castle flags

    signal isWhtQnCstlSqr[4];
    signal isWhtKingCstlSqr[4];
    signal isBlckQnCstlSqr[4];
    signal isBlckKingCstlSqr[4];
    signal isWhtQnCstl;
    signal isWhtKingCstl;
    signal isBlckQnCstl;
    signal isBlckKingCstl;
    signal isWhtCstl;
    signal isBlckCstl;

    isWhtQnCstlSqr[0] <== ChckPieceLoc()(origHor,origVer,0,4);
    isWhtQnCstlSqr[1] <== ChckPieceLoc()(destHor,destVer,0,2);
    isWhtQnCstlSqr[2] <== IsEqual()([origPiece,1]);
    isWhtQnCstlSqr[3] <== isWhtQnCstlSqr[0] * isWhtQnCstlSqr[1];
    isWhtQnCstl <== isWhtQnCstlSqr[2] * isWhtQnCstlSqr[3];

    isWhtKingCstlSqr[0] <== ChckPieceLoc()(origHor,origVer,0,4);
    isWhtKingCstlSqr[1] <== ChckPieceLoc()(destHor,destVer,0,6);
    isWhtKingCstlSqr[2] <== IsEqual()([origPiece,1]);
    isWhtKingCstlSqr[3] <== isWhtKingCstlSqr[0] * isWhtKingCstlSqr[1];
    isWhtKingCstl <== isWhtKingCstlSqr[2] * isWhtKingCstlSqr[3];
    
    isBlckQnCstlSqr[0] <== ChckPieceLoc()(origHor,origVer,7,4);
    isBlckQnCstlSqr[1] <== ChckPieceLoc()(destHor,destVer,7,2);
    isBlckQnCstlSqr[2] <== IsEqual()([origPiece,7]);
    isBlckQnCstlSqr[3] <== isBlckQnCstlSqr[0] * isBlckQnCstlSqr[1];
    isBlckQnCstl <== isBlckQnCstlSqr[2] * isBlckQnCstlSqr[3];
    
    isBlckKingCstlSqr[0] <== ChckPieceLoc()(origHor,origVer,7,4);
    isBlckKingCstlSqr[1] <== ChckPieceLoc()(destHor,destVer,7,6);
    isBlckKingCstlSqr[2] <== IsEqual()([origPiece,7]);
    isBlckKingCstlSqr[3] <== isBlckKingCstlSqr[0] * isBlckKingCstlSqr[1];
    isBlckKingCstl <== isBlckKingCstlSqr[2] * isBlckKingCstlSqr[3];
    
    isWhtCstl <== isWhtQnCstl + isWhtKingCstl;
    isBlckCstl <== isBlckQnCstl + isBlckKingCstl;

    // signals for UpdBoards component

    signal isOrigHor[8];
    signal isOrigVer[8];
    signal isDestHor[8];
    signal isDestVer[8];

    for (i=0; i<8; i++) {
        isOrigHor[i] <== IsEqual()([i,origHor]);
        isOrigVer[i] <== IsEqual()([i,origVer]);
        isDestHor[i] <== IsEqual()([i,destHor]);
        isDestVer[i] <== IsEqual()([i,destVer]);
    }

    // en Passant and promotion flags

    signal enPassSqrFlag;
    signal enPassFlag;

    enPassSqrFlag <== ChckPieceLoc()(destHor,destVer,enPassHor,enPassVer);
    enPassFlag <== enPassSqrFlag*captFlag;

    signal isPawnAtEnPassSqr[2][8];
    signal isPawnTakenByEnPass[2][8];

    for (i=3; i<5; i++) {
        for (j=0; j<8; j++) {
            isPawnAtEnPassSqr[i-3][j] <== isOrigHor[i]*isDestVer[j];
            isPawnTakenByEnPass[i-3][j] <== isPawnAtEnPassSqr[i-3][j] * enPassFlag;
        }
    }

    signal prmtFlag <== IsNonZero()(prmtPiece);

    // updating boards and coordinates

    newBoard <== UpdBoards()(board,origHor,origVer,origPiece,destHor,destVer,enPassFlag,isPawnTakenByEnPass,prmtPiece,prmtFlag,isWhtQnCstl,isWhtKingCstl,isBlckQnCstl,isBlckKingCstl,isWhtCstl,isBlckCstl,isOrigHor,isOrigVer,isDestHor,isDestVer);




    //checking if king is safe

    signal isKingMv[2];

    isKingMv[0] <== IsEqual()([origPiece,1]);
    isKingMv[1] <== IsEqual()([origPiece,7]);

    newKingHor[0] <== kingHor[0] + isKingMv[0]*(destHor-kingHor[0]);
    newKingVer[0] <== kingVer[0] + isKingMv[0]*(destVer-kingVer[0]);
    newKingHor[1] <== kingHor[1] + isKingMv[1]*(destHor-kingHor[1]);
    newKingVer[1] <== kingVer[1] + isKingMv[1]*(destVer-kingVer[1]);

    component wKingSf = IsWhtKingSafe();
    component bKingSf = IsBlckKingSafe();

    for (i=0; i<8; i++) {
        for (j=0; j<8; j++) {
            wKingSf.board[i][j] <== newBoard[i][j];
            bKingSf.board[i][j] <== newBoard[i][j];
        }
    }

    wKingSf.kingHor <== newKingHor[0];
    wKingSf.kingVer <== newKingVer[0];
    bKingSf.kingHor <== newKingHor[1];
    bKingSf.kingVer <== newKingVer[1];

    wKingSf.flag + stm*(bKingSf.flag - wKingSf.flag) === 1;

    //putting new castling flags

    signal cstlFlags[10];

    cstlFlags[0] <== IsEqual()([newBoard[0][4],1]);
    cstlFlags[1] <== IsEqual()([newBoard[0][0],3]);
    cstlFlags[2] <== IsEqual()([newBoard[0][7],3]);
    cstlFlags[3] <== cstlFlags[0]*cstlFlags[1];
    cstlFlags[4] <== cstlFlags[0]*cstlFlags[2];
    cstlFlags[5] <== IsEqual()([newBoard[7][4],7]);
    cstlFlags[6] <== IsEqual()([newBoard[7][0],9]);
    cstlFlags[7] <== IsEqual()([newBoard[7][7],9]);
    cstlFlags[8] <== cstlFlags[5]*cstlFlags[6];
    cstlFlags[9] <== cstlFlags[5]*cstlFlags[7];

    newQnCstlFlag[0] <== qnCstlFlag[0]*cstlFlags[3];
    newKingCstlFlag[0] <== kingCstlFlag[0]*cstlFlags[4];
    newQnCstlFlag[1] <== qnCstlFlag[1]*cstlFlags[8];
    newKingCstlFlag[1] <== kingCstlFlag[1]*cstlFlags[9];

    //putting new en passant square

    intermedFlags[256] <== IsEqual()([origPiece,6+6*stm]);
    intermedFlags[257] <== IsEqual()([origHor,1+5*stm]);
    intermedFlags[258] <== IsEqual()([destHor,3+stm]);
    intermedFlags[259] <== intermedFlags[256]*intermedFlags[257];
    intermedFlags[260] <== intermedFlags[258]*intermedFlags[259];

    intermediate[64] <== intermedFlags[260]*(2+3*stm)-50;
    newEnPassHor <== 50 + intermedFlags[260]*intermediate[64];
    newEnPassVer <== 50 + intermedFlags[260]*(destVer-50);

    //updating half move counter

    intermedFlags[261] <== IsEqual()([origPiece,6+6*stm]);
    intermedFlags[262] <== IsZero()(captFlag+intermedFlags[261]);
    newHalfMvCntr <== (halfMvCntr+1)*intermedFlags[262];

    component geqt = GreaterEqThan(8);
    geqt.in[0] <== newHalfMvCntr;
    geqt.in[1] <== 100;
    // geqt.out*3 ==> result;



}

component main = PlayAGame(97);
