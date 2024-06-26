pragma circom 2.1.6;

include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/gates.circom";

template IsNonEqual(){
    signal input in[2];
    signal output out;

    signal iszOut <== IsZero()(in[1]-in[0]);

    1 - iszOut ==> out;
}

template IsNonZero() {
    signal input in;
    signal output out;

    signal inv;

    inv <-- in!=0 ? 1/in : 0;

    out <== in*inv;
    in*(1-out) === 0;
}

template IsOnBoard() {
    signal input sqrHor;
    signal input sqrVer;
    signal output flag;

    signal intermedFlags[4];
    signal intermediate;

    intermedFlags[0] <== LessEqThan(8)([sqrHor,7]);
    intermedFlags[1] <== LessEqThan(8)([sqrVer,7]);
    intermedFlags[2] <== GreaterEqThan(8)([sqrHor,0]);
    intermedFlags[3] <== GreaterEqThan(8)([sqrVer,0]);

    intermediate <== intermedFlags[0] + intermedFlags[1] + intermedFlags[2] + intermedFlags[3];

    flag <== IsEqual()([intermediate,4]);
}


template Sum(N) {
    signal input in[N];
    signal output out;

    signal intermediate[N+1];
    intermediate[0] <== 0;

    for (var i=0; i<N; i++) {
        intermediate[i+1] <== intermediate[i] + in[i];
    }

    out <== intermediate[N];
}

template ChckPieceLoc() {
    signal input trgtSqrHor;
    signal input trgtSqrVer;
    signal input pieceHor;
    signal input pieceVer;
    signal output flag;

    signal intermedFlags[2];

    intermedFlags[0] <== IsEqual()([trgtSqrHor,pieceHor]);
    intermedFlags[1] <== IsEqual()([trgtSqrVer,pieceVer]);

    flag <== intermedFlags[0]*intermedFlags[1];
}


template SqrToPiece() {
    signal input board[8][8];
    signal input sqrHor;
    signal input sqrVer;
    signal output piece;

    signal isOnBoard;
    signal intermedFlags[64];
    signal pieces[64];

    var i;
    var j;

    for (i=0; i<8; i++) {
        for (j=0; j<8; j++) {
            intermedFlags[8*i+j] <== IsEqual()([8*sqrHor+sqrVer,8*i+j]);
            pieces[8*i+j] <== intermedFlags[8*i+j] * board[i][j];
        }
    }

    isOnBoard <== intermedFlags[0] + intermedFlags[1] + intermedFlags[2] + intermedFlags[3] + intermedFlags[4] + intermedFlags[5] + intermedFlags[6] + intermedFlags[7] + intermedFlags[8] + intermedFlags[9] + intermedFlags[10] + intermedFlags[11] + intermedFlags[12] + intermedFlags[13] + intermedFlags[14] + intermedFlags[15] + intermedFlags[16] + intermedFlags[17] + intermedFlags[18] + intermedFlags[19] + intermedFlags[20] + intermedFlags[21] + intermedFlags[22] + intermedFlags[23] + intermedFlags[24] + intermedFlags[25] + intermedFlags[26] + intermedFlags[27] + intermedFlags[28] + intermedFlags[29] + intermedFlags[30] + intermedFlags[31] + intermedFlags[32] + intermedFlags[33] + intermedFlags[34] + intermedFlags[35] + intermedFlags[36] + intermedFlags[37] + intermedFlags[38] + intermedFlags[39] + intermedFlags[40] + intermedFlags[41] + intermedFlags[42] + intermedFlags[43] + intermedFlags[44] + intermedFlags[45] + intermedFlags[46] + intermedFlags[47] + intermedFlags[48] + intermedFlags[49] + intermedFlags[50] + intermedFlags[51] + intermedFlags[52] + intermedFlags[53] + intermedFlags[54] + intermedFlags[55] + intermedFlags[56] + intermedFlags[57] + intermedFlags[58] + intermedFlags[59] + intermedFlags[60] + intermedFlags[61] + intermedFlags[62] + intermedFlags[63];


    piece <== isOnBoard * (pieces[0] + pieces[1] + pieces[2] + pieces[3] + pieces[4] + pieces[5] + pieces[6] + pieces[7] + pieces[8] + pieces[9] + pieces[10] + pieces[11] + pieces[12] + pieces[13] + pieces[14] + pieces[15] + pieces[16] + pieces[17] + pieces[18] + pieces[19] + pieces[20] + pieces[21] + pieces[22] + pieces[23] + pieces[24] + pieces[25] + pieces[26] + pieces[27] + pieces[28] + pieces[29] + pieces[30] + pieces[31] + pieces[32] + pieces[33] + pieces[34] + pieces[35] + pieces[36] + pieces[37] + pieces[38] + pieces[39] + pieces[40] + pieces[41] + pieces[42] + pieces[43] + pieces[44] + pieces[45] + pieces[46] + pieces[47] + pieces[48] + pieces[49] + pieces[50] + pieces[51] + pieces[52] + pieces[53] + pieces[54] + pieces[55] + pieces[56] + pieces[57] + pieces[58] + pieces[59] + pieces[60] + pieces[61] + pieces[62] + pieces[63] - 50) + 50; //the same as piece <== isOnBoard*(intermedFlags[0]+...) + (1-isOnBoard)*50

}

// template UpdPieceSqr() {
//     signal input boardToPieceInd[8][8];
//     signal input pieceHor[33];
//     signal input pieceVer[33];
//     signal input pieceInd;
//     signal input newSqrHor;
//     signal input newSqrVer;
//     signal output newPieceHor[33];
//     signal output newPieceVer[33];

//     signal intermedFlags[32];

//     for (var i=0; i<32; i++) {
//         intermedFlags[i] <== IsEqual()([pieceInd,i]);
//         newPieceHor[i] <== pieceHor[i] + intermedFlags[i]*(newSqrHor - pieceHor[i]);
//         newPieceVer[i] <== pieceVer[i] + intermedFlags[i]*(newSqrVer - pieceVer[i]);    
//     }

// }




template HowManyWhtPieces() {
    signal input pieceHor[33];
    signal output out;

    signal intermedFlags[16];

    for (var i=0; i<8; i++) {
        intermedFlags[i] <== IsNonEqual()([pieceHor[i],50]);
        intermedFlags[8+i] <== IsNonEqual()([pieceHor[16+i],50]);
    }

    out <== Sum(16)(intermedFlags);

}


template HowManyBlckPieces() {
    signal input pieceHor[33];
    signal output out;

    signal intermedFlags[16];

    for (var i=0; i<8; i++) {
        intermedFlags[i] <== IsNonEqual()([pieceHor[8+i],50]);
        intermedFlags[8+i] <== IsNonEqual()([pieceHor[24+i],50]);
    }

    out <== Sum(16)(intermedFlags);

}