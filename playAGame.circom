pragma circom  2.1.6;

include "isKingSafe.circom";
include "isMoveLegal.circom";
include "Stalemate.circom";

template PlayAGame(N) {
    signal input origHor[N];
    signal input origVer[N];
    signal input origPiece[N];
    signal input destHor[N];
    signal input destVer[N];
    signal input captFlag[N];
    signal input prmtPiece[N];
    signal output finalResult;

    signal board[N][8][8];
    signal boardToPieceInd[N][8][8];
    signal pieceType[N][16];
    signal pieceHor[N][32];
    signal pieceVer[N][32];
    signal stm[N];
    signal kingCstlFlag[N][2];
    signal qnCstlFlag[N][2];
    signal enPassHor[N];
    signal enPassVer[N];
    signal halfMvCntr[N];
    signal kingHor[N][2];
    signal kingVer[N][2];
    signal result[N];

    var i;
    var j;

    board[0][0] <== [3,5,4,2,1,4,5,3];
    board[0][1] <== [6,6,6,6,6,6,6,6];
    board[0][2] <== [0,0,0,0,0,0,0,0];
    board[0][3] <== [0,0,0,0,0,0,0,0];
    board[0][4] <== [0,0,0,0,0,0,0,0];
    board[0][5] <== [0,0,0,0,0,0,0,0];
    board[0][6] <== [12,12,12,12,12,12,12,12];
    board[0][7] <== [9,11,10,8,9,10,11,9];

    for (i=0; i<8; i++) {
        boardToPieceInd[0][0][i] <== 16+i+1;
        boardToPieceInd[0][1][i] <== i+1;
        boardToPieceInd[0][2][i] <== 0;
        boardToPieceInd[0][3][i] <== 0;
        boardToPieceInd[0][4][i] <== 0;
        boardToPieceInd[0][5][i] <== 0;
        boardToPieceInd[0][6][i] <== 8+i+1;
        boardToPieceInd[0][7][i] <== 24+i+1;
    }

    for (i=0; i<8; i++) {
        pieceType[0][i] <== 6;
        pieceType[0][8+i] <== 12;
    }

    for (i=0; i<8; i++) {
        pieceHor[0][i] <== 1;
        pieceHor[0][8+i] <== 6;
        pieceHor[0][16+i] <== 0;
        pieceHor[0][24+i] <== 7;

        pieceVer[0][i] <== i;
        pieceVer[0][8+i] <== i;
        pieceVer[0][16+i] <== i;
        pieceVer[0][24+i] <== i;
    }

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




    for (i=1; i<N; i++) {
        (board[i],boardToPieceInd[i],pieceType[i],pieceHor[i],pieceVer[i],stm[i],kingCstlFlag[i],qnCstlFlag[i],enPassHor[i],enPassVer[i],halfMvCntr[i],kingHor[i],kingVer[i],result[i]) <== MakeAMove()(board[i-1],boardToPieceInd[i-1],pieceType[i-1],pieceHor[i-1],pieceVer[i-1],stm[i-1],kingCstlFlag[i-1],qnCstlFlag[i-1],enPassHor[i-1],enPassVer[i-1],halfMvCntr[i-1],kingHor[i-1],kingVer[i-1],origHor[i-1],origVer[i-1],origPiece[i-1],destHor[i-1],destVer[i-1],captFlag[i-1],prmtPiece[i-1]);

    }


}


template UpdCoordByMv() {
    signal input boardToPieceInd[8][8];
    signal input pieceType[16];
    signal input pieceHor[32];
    signal input pieceVer[32];
    signal input origHor;
    signal input origVer;
    signal input origPieceInd;
    signal input destHor;
    signal input destVer;
    signal input destPieceInd;
    signal input prmtPiece;
    signal output newPieceType[16];
    signal output newPieceHor[32];
    signal output newPieceVer[32];

    signal intermedFlags[80];
    signal intermediate[64];
    signal isPrmtd <== IsNonZero()(prmtPiece);

    for (var i=0; i<16; i++) {
        intermedFlags[3*i] <== IsEqual()([origPieceInd,i+1]);
        intermedFlags[3*i+1] <== IsEqual()([destPieceInd,i+1]);
        intermediate[2*i] <== pieceHor[i]*(1-intermedFlags[2*i]-intermedFlags[2*i+1]);
        intermediate[2*i+1] <== pieceVer[i]*(1-intermedFlags[2*i]-intermedFlags[2*i+1]);

        intermedFlags[3*i+2] <== intermedFlags[3*i]*isPrmtd;
        newPieceType[i] <== pieceType[i] + intermedFlags[3*i+2]*(prmtPiece - pieceType[i]);

        newPieceHor[i] <== intermediate[2*i] + intermedFlags[2*i]*destHor + intermedFlags[2*i+1]*50;
        newPieceVer[i] <== intermediate[2*i+1] + intermedFlags[2*i]*destVer + intermedFlags[2*i+1]*50;
    }
    for (var i=16; i<32; i++) {
        intermedFlags[16+2*i] <== IsEqual()([origPieceInd,i+1]);
        intermedFlags[16+2*i+1] <== IsEqual()([destPieceInd,i+1]);
        intermediate[2*i] <== pieceHor[i]*(1-intermedFlags[16+2*i]-intermedFlags[16+2*i+1]);
        intermediate[2*i+1] <== pieceVer[i]*(1-intermedFlags[16+2*i]-intermedFlags[16+2*i+1]);

        newPieceHor[i] <== intermediate[2*i] + intermedFlags[16+2*i]*destHor + intermedFlags[16+2*i+1]*50;
        newPieceVer[i] <== intermediate[2*i+1] + intermedFlags[16+2*i]*destVer + intermedFlags[16+2*i+1]*50;
    }
}

template MakeAMove() {
    signal input board[8][8];
    signal input boardToPieceInd[8][8];
    signal input pieceType[16];
    signal input pieceHor[32];
    signal input pieceVer[32];
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
    signal output newBoardToPieceInd[8][8];
    signal output newPieceType[16];
    signal output newPieceHor[32];
    signal output newPieceVer[32];
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
    signal isOrigSqr[64];
    signal isDestSqr[64];
    signal cstlFlags[10];

    signal isKingMv[2];

    // signal origPiece <== SqrToPiece()(board,origHor,origVer);
    signal destPiece <== SqrToPiece()(board,destHor,destVer);

    signal origPieceInd <== SqrToPiece()(boardToPieceInd,origHor,origVer);
    signal destPieceInd <== SqrToPiece()(boardToPieceInd,destHor,destVer);

    var i;
    var j;

    //checking if move is correct
    
    component wMvCrr = IsWhtMvLgl();
    component bMvCrr = IsBlckMvLgl();

    for (i=0; i<8; i++) {
        for (j=0; j<8; j++) {
            wMvCrr.board[i][j] <== board[i][j];
            bMvCrr.board[i][j] <== board[i][j];
        }
    }
    wMvCrr.kingCstlFlag <== kingCstlFlag[0];
    wMvCrr.qnCstlFlag <== qnCstlFlag[0];
    wMvCrr.enPassHor <== enPassHor;
    wMvCrr.enPassVer <== enPassVer;
    wMvCrr.origHor <== origHor;
    wMvCrr.origVer <== origVer;
    wMvCrr.origPiece <== origPiece;
    wMvCrr.destHor <== destHor;
    wMvCrr.destVer <== destVer;
    wMvCrr.destPiece <== destPiece;
    wMvCrr.captFlag <== captFlag;
    wMvCrr.prmtPiece <== prmtPiece;

    bMvCrr.kingCstlFlag <== kingCstlFlag[1];
    bMvCrr.qnCstlFlag <== qnCstlFlag[1];
    bMvCrr.enPassHor <== enPassHor;
    bMvCrr.enPassVer <== enPassVer;
    bMvCrr.origHor <== origHor;
    bMvCrr.origVer <== origVer;
    bMvCrr.origPiece <== origPiece;
    bMvCrr.destHor <== destHor;
    bMvCrr.destVer <== destVer;
    bMvCrr.destPiece <== destPiece;
    bMvCrr.captFlag <== captFlag;
    bMvCrr.prmtPiece <== prmtPiece;

    wMvCrr.flag + bMvCrr.flag === 1;

    //updating board and coordinates
    
    for (i=0; i<8; i++) {
        for (j=0; j<8; j++) {
            intermedFlags[4*(8*i+j)] <== IsEqual()([i,origHor]);
            intermedFlags[4*(8*i+j)+1] <== IsEqual()([j,origVer]);
            isOrigSqr[8*i+j] <== intermedFlags[4*(8*i+j)]*intermedFlags[4*(8*i+j)+1];

            intermedFlags[4*(8*i+j)+2] <== IsEqual()([i,destHor]);
            intermedFlags[4*(8*i+j)+3] <== IsEqual()([j,destVer]);
            isDestSqr[8*i+j] <== intermedFlags[4*(8*i+j)+2]*intermedFlags[4*(8*i+j)+3];

            intermediate[8*i+j] <== origPiece*isDestSqr[8*i+j];

            newBoard[i][j] <== board[i][j] - board[i][j]*(isOrigSqr[8*i+j]+isDestSqr[8*i+j]) + intermediate[8*i+j];
            newBoardToPieceInd[i][j] <== boardToPieceInd[i][j] - boardToPieceInd[i][j]*(isOrigSqr[8*i+j]+isDestSqr[8*i+j]) + intermediate[8*i+j];
        }
    }

    (newPieceType,newPieceHor,newPieceVer) <== UpdCoordByMv()(boardToPieceInd,pieceType,pieceHor,pieceVer,origHor,origVer,origPieceInd,destHor,destVer,destPieceInd,prmtPiece);


    //checking if king is safe

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

    //updating promotion piece



    //updating half move counter

    intermedFlags[261] <== IsEqual()([origPiece,6+6*stm]);
    intermedFlags[262] <== IsZero()(captFlag+intermedFlags[261]);
    newHalfMvCntr <== (halfMvCntr+1)*intermedFlags[262];

    component geqt = GreaterEqThan(8);
    geqt.in[0] <== newHalfMvCntr;
    geqt.in[1] <== 100;
    // geqt.out*3 ==> result;

    //checking stalemate

    component whtStlmt = AreWhtStlmtd();
    component blckStlmt = AreBlckStlmtd();

    for (i=0; i<8; i++) {
        for (j=0; j<8; j++) {
            whtStlmt.board[i][j] <== newBoard[i][j];
            blckStlmt.board[i][j] <== newBoard[i][j];
        }
    }

    for (i=0; i<16; i++) {
        whtStlmt.pieceType[i] <== newPieceType[i];
        blckStlmt.pieceType[i] <== newPieceType[i];
    }

    for (i=0; i<32; i++) {
        whtStlmt.pieceHor[i] <== newPieceHor[i];
        whtStlmt.pieceVer[i] <== newPieceVer[i];
        blckStlmt.pieceHor[i] <== newPieceHor[i];
        blckStlmt.pieceVer[i] <== newPieceVer[i];
    }

    whtStlmt.kingHor <== newKingHor[0];
    whtStlmt.kingVer <== newKingVer[0];
    blckStlmt.kingHor <== newKingHor[1];
    blckStlmt.kingVer <== newKingVer[1];

    intermedFlags[263] <== whtStlmt.flag + newSTM*(blckStlmt.flag - whtStlmt.flag);
    intermedFlags[264] <== OR()(geqt.out, intermedFlags[263]);

    result <== 3*intermedFlags[264];

}

component main = PlayAGame(3);