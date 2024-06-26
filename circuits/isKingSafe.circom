pragma circom 2.1.6;

include "lineHits.circom";


template IsWhtKingSafe() {
    signal input board[8][8];
    signal input kingHor;
    signal input kingVer;
    signal output flag;

    signal intermedFlags[16];
    signal thrtSum;

    signal termToAdd[56];
    signal sumToCheck[8];

    var sqrCntr = 0;

    signal pieces[64];

    signal knghtHor[8] <== [2,1,-1,-2,-2,-1,1,2];
    signal knghtVer[8] <== [1,2,2,1,-1,-2,-2,-1];

    signal bshpHor[4] <== [1,-1,-1,1];
    signal bshpVer[4] <== [1,1,-1,-1];
    signal rookHor[4] <== [1,0,-1,0];
    signal rookVer[4] <== [0,1,0,-1];

    var i;
    var j;


    //checking all hits except knight's

    for (i=0; i<4; i++) {
        pieces[i] <== SqrToPiece()(board,kingHor+bshpHor[i],kingVer+bshpVer[i]);
        pieces[4+i] <== SqrToPiece()(board,kingHor+rookHor[i],kingVer+rookVer[i]);
    }
    

    termToAdd[7*sqrCntr] <== WhtKingLineHits(1,1,1,-1,1,-1,1)(pieces[sqrCntr]);
    sqrCntr++;

    termToAdd[7*sqrCntr] <== WhtKingLineHits(1,1,1,-1,1,-1,-1)(pieces[sqrCntr]);
    sqrCntr++;

    termToAdd[7*sqrCntr] <== WhtKingLineHits(1,1,1,-1,1,-1,-1)(pieces[sqrCntr]);
    sqrCntr++;

    termToAdd[7*sqrCntr] <== WhtKingLineHits(1,1,1,-1,1,-1,1)(pieces[sqrCntr]);
    sqrCntr++;

    termToAdd[7*sqrCntr] <== WhtKingLineHits(1,1,1,1,-1,-1,-1)(pieces[sqrCntr]);
    sqrCntr++;

    termToAdd[7*sqrCntr] <== WhtKingLineHits(1,1,1,1,-1,-1,-1)(pieces[sqrCntr]);
    sqrCntr++;

    termToAdd[7*sqrCntr] <== WhtKingLineHits(1,1,1,1,-1,-1,-1)(pieces[sqrCntr]);
    sqrCntr++;

    termToAdd[7*sqrCntr] <== WhtKingLineHits(1,1,1,1,-1,-1,-1)(pieces[sqrCntr]);
    sqrCntr++;


    for (i=0; i<4; i++) {
        for (j=0; j<6; j++) {
            pieces[8+6*i+j] <== SqrToPiece()(board,kingHor+bshpHor[i]*(j+2),kingVer+bshpVer[i]*(j+2));
            termToAdd[7*i+1+j] <== WhtKingLineHits(j+2,-1,1,-1,1,-1,-1)(pieces[8+6*i+j]);

            pieces[8+6*(i+4)+j] <== SqrToPiece()(board,kingHor+rookHor[i]*(j+2),kingVer+rookVer[i]*(j+2));
            termToAdd[7*(i+4)+1+j] <== WhtKingLineHits(j+2,-1,1,1,-1,-1,-1)(pieces[8+6*(i+4)+j]);
        }
    }
    
    for (i=0; i<8; i++) {
        sumToCheck[i] <== termToAdd[7*i] + termToAdd[7*i+1] + termToAdd[7*i+2] + termToAdd[7*i+3] + termToAdd[7*i+4] + termToAdd[7*i+5] + termToAdd[7*i+6];
        intermedFlags[i] <== GreaterThan(8)([sumToCheck[i],128]);
    }

    //checking knight hits

    for (i=0; i<8; i++) {
        pieces[56+i] <== SqrToPiece()(board, kingHor+knghtHor[i], kingVer+knghtVer[i]);
        intermedFlags[8+i] <== IsEqual()([pieces[56+i], 11]);
    }

    thrtSum <== intermedFlags[0] + intermedFlags[1] + intermedFlags[2] + intermedFlags[3] + intermedFlags[4] + intermedFlags[5] + intermedFlags[6] + intermedFlags[7] + intermedFlags[8] + intermedFlags[9] + intermedFlags[10] + intermedFlags[11] + intermedFlags[12] + intermedFlags[13] + intermedFlags[14] + intermedFlags[15];

    flag <== IsZero()(thrtSum);
}


template IsBlckKingSafe() {
    signal input board[8][8];
    signal input kingHor;
    signal input kingVer;
    signal output flag;

    signal intermedFlags[16];
    signal thrtSum;

    signal termToAdd[56];
    signal sumToCheck[8];

    var sqrCntr = 0;

    signal pieces[64];

    signal knghtHor[8] <== [2,1,-1,-2,-2,-1,1,2];
    signal knghtVer[8] <== [1,2,2,1,-1,-2,-2,-1];

    signal bshpHor[4] <== [1,-1,-1,1];
    signal bshpVer[4] <== [1,1,-1,-1];
    signal rookHor[4] <== [1,0,-1,0];
    signal rookVer[4] <== [0,1,0,-1];

    var i;
    var j;


    //checking all hits except knight's

    for (i=0; i<4; i++) {
        pieces[i] <== SqrToPiece()(board,kingHor+bshpHor[i],kingVer+bshpVer[i]);
        pieces[4+i] <== SqrToPiece()(board,kingHor+rookHor[i],kingVer+rookVer[i]);
    }
    

    termToAdd[7*sqrCntr] <== BlckKingLineHits(1,1,1,-1,1,-1,-1)(pieces[sqrCntr]);
    sqrCntr++;

    termToAdd[7*sqrCntr] <== BlckKingLineHits(1,1,1,-1,1,-1,1)(pieces[sqrCntr]);
    sqrCntr++;

    termToAdd[7*sqrCntr] <== BlckKingLineHits(1,1,1,-1,1,-1,1)(pieces[sqrCntr]);
    sqrCntr++;

    termToAdd[7*sqrCntr] <== BlckKingLineHits(1,1,1,-1,1,-1,-1)(pieces[sqrCntr]);
    sqrCntr++;

    termToAdd[7*sqrCntr] <== BlckKingLineHits(1,1,1,1,-1,-1,-1)(pieces[sqrCntr]);
    sqrCntr++;

    termToAdd[7*sqrCntr] <== BlckKingLineHits(1,1,1,1,-1,-1,-1)(pieces[sqrCntr]);
    sqrCntr++;

    termToAdd[7*sqrCntr] <== BlckKingLineHits(1,1,1,1,-1,-1,-1)(pieces[sqrCntr]);
    sqrCntr++;

    termToAdd[7*sqrCntr] <== BlckKingLineHits(1,1,1,1,-1,-1,-1)(pieces[sqrCntr]);
    sqrCntr++;


    for (i=0; i<4; i++) {
        for (j=0; j<6; j++) {
            pieces[8+6*i+j] <== SqrToPiece()(board,kingHor+bshpHor[i]*(j+2),kingVer+bshpVer[i]*(j+2));
            termToAdd[7*i+1+j] <== BlckKingLineHits(j+2,-1,1,-1,1,-1,-1)(pieces[8+6*i+j]);

            pieces[8+6*(i+4)+j] <== SqrToPiece()(board,kingHor+rookHor[i]*(j+2),kingVer+rookVer[i]*(j+2));
            termToAdd[7*(i+4)+1+j] <== BlckKingLineHits(j+2,-1,1,1,-1,-1,-1)(pieces[8+6*(i+4)+j]);
        }
    }
    
    for (i=0; i<8; i++) {
        sumToCheck[i] <== termToAdd[7*i] + termToAdd[7*i+1] + termToAdd[7*i+2] + termToAdd[7*i+3] + termToAdd[7*i+4] + termToAdd[7*i+5] + termToAdd[7*i+6];
        intermedFlags[i] <== GreaterThan(8)([sumToCheck[i],128]);
    }

    //checking knight hits

    for (i=0; i<8; i++) {
        pieces[56+i] <== SqrToPiece()(board, kingHor+knghtHor[i], kingVer+knghtVer[i]);
        intermedFlags[8+i] <== IsEqual()([pieces[56+i], 5]);
    }

    thrtSum <== intermedFlags[0] + intermedFlags[1] + intermedFlags[2] + intermedFlags[3] + intermedFlags[4] + intermedFlags[5] + intermedFlags[6] + intermedFlags[7] + intermedFlags[8] + intermedFlags[9] + intermedFlags[10] + intermedFlags[11] + intermedFlags[12] + intermedFlags[13] + intermedFlags[14] + intermedFlags[15];

    flag <== IsZero()(thrtSum);
}