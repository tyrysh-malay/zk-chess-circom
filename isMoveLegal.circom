pragma circom  2.1.6;

include "lineHits.circom";

template IsWhtMvLgl() {
    signal input board[8][8];
    signal input kingCstlFlag;
    signal input qnCstlFlag;
    signal input enPassHor;
    signal input enPassVer;
    signal input origHor;
    signal input origVer;
    signal input origPiece;
    signal input destHor;
    signal input destVer;
    signal input destPiece;
    signal input captFlag;
    signal input prmtPiece;
    signal output flag;

    var intFlagsN = 36;

    signal output intermedFlags[intFlagsN];

    signal isOrigWht;
    signal isNonSelfCapt;
    signal nonPawnFlag;

    intermedFlags[0] <== IsOnBoard()(origHor,origVer);
    intermedFlags[1] <== IsOnBoard()(destHor,destVer);

    intermedFlags[2] <== GreaterEqThan(8)([origPiece,1]);
    intermedFlags[3] <== LessEqThan(8)([origPiece,6]);
    isOrigWht <== intermedFlags[2]*intermedFlags[3];

    intermedFlags[4] <== IsEqual()([destPiece,0]);
    intermedFlags[5] <== GreaterEqThan(8)([destPiece,7]);
    intermedFlags[6] <== LessEqThan(8)([destPiece,12]);
    intermedFlags[7] <== intermedFlags[5]*intermedFlags[6];
    isNonSelfCapt <== intermedFlags[4] + intermedFlags[7];

    nonPawnFlag <== IsZero()(prmtPiece);

    intermedFlags[8] <== IsEqual()([origPiece,1]);
    intermedFlags[9] <== IsEqual()([origPiece,2]);
    intermedFlags[10] <== IsEqual()([origPiece,3]);
    intermedFlags[11] <== IsEqual()([origPiece,4]);
    intermedFlags[12] <== IsEqual()([origPiece,5]);
    intermedFlags[13] <== IsEqual()([origPiece,6]);

    intermedFlags[14] <== ChckPieceLoc()(origHor,origVer,0,4);
    intermedFlags[15] <== ChckPieceLoc()(destHor,destVer,0,2);
    intermedFlags[16] <== ChckPieceLoc()(destHor,destVer,0,6);
    intermedFlags[17] <== intermedFlags[14]*(intermedFlags[15]+intermedFlags[16]);

    intermedFlags[18] <== IsKingMvLgl()(origHor,origVer,destHor,destVer);
    intermedFlags[19] <== IsQnMvLgl()(board,origHor,origVer,destHor,destVer);
    intermedFlags[20] <== IsRookMvLgl()(board,origHor,origVer,destHor,destVer);
    intermedFlags[21] <== IsBshpMVLgl()(board,origHor,origVer,destHor,destVer);
    intermedFlags[22] <== IsKnghtMvLgl()(origHor,origVer,destHor,destVer);
    intermedFlags[23] <== IsWhtPawnMvLgl()(board,origHor,origVer,destHor,destVer,destPiece,captFlag,prmtPiece,enPassHor,enPassVer);
    intermedFlags[24] <== IsWhtCstlLgl()(board,destHor,kingCstlFlag,qnCstlFlag);

    intermedFlags[25] <== intermedFlags[8]*intermedFlags[18];
    intermedFlags[26] <== intermedFlags[9]*intermedFlags[19];
    intermedFlags[27] <== intermedFlags[10]*intermedFlags[20];
    intermedFlags[28] <== intermedFlags[11]*intermedFlags[21];
    intermedFlags[29] <== intermedFlags[12]*intermedFlags[22];
    intermedFlags[30] <== intermedFlags[13]*intermedFlags[23];
    intermedFlags[31] <== intermedFlags[17]*intermedFlags[24];

    intermedFlags[32] <== nonPawnFlag*(intermedFlags[25] + intermedFlags[26] + intermedFlags[27] + intermedFlags[28] + intermedFlags[29] + intermedFlags[31]) + intermedFlags[30];
    intermedFlags[33] <== intermedFlags[0]*intermedFlags[1];
    intermedFlags[34] <== isOrigWht*isNonSelfCapt;
    intermedFlags[35] <== intermedFlags[33]*intermedFlags[34];

    flag <== intermedFlags[32]*intermedFlags[35];
}

template IsBlckMvLgl() {
    signal input board[8][8];
    signal input kingCstlFlag;
    signal input qnCstlFlag;
    signal input enPassHor;
    signal input enPassVer;
    signal input origHor;
    signal input origVer;
    signal input origPiece;
    signal input destHor;
    signal input destVer;
    signal input destPiece;
    signal input captFlag;
    signal input prmtPiece;
    signal output flag;

    var intFlagsN = 36;

    signal intermedFlags[intFlagsN];

    signal isOrigBlck;
    signal isNonSelfCapt;
    signal nonPawnFlag;

    intermedFlags[0] <== IsOnBoard()(origHor,origVer);
    intermedFlags[1] <== IsOnBoard()(destHor,destVer);

    intermedFlags[2] <== GreaterEqThan(8)([origPiece,7]);
    intermedFlags[3] <== LessEqThan(8)([origPiece,12]);
    isOrigBlck <== intermedFlags[2]*intermedFlags[3];

    intermedFlags[4] <== IsEqual()([destPiece,0]);
    intermedFlags[5] <== GreaterEqThan(8)([destPiece,1]);
    intermedFlags[6] <== LessEqThan(8)([destPiece,6]);
    intermedFlags[7] <== intermedFlags[5]*intermedFlags[6];
    isNonSelfCapt <== intermedFlags[4] + intermedFlags[7];

    nonPawnFlag <== IsZero()(prmtPiece);

    intermedFlags[8] <== IsEqual()([origPiece,7]);
    intermedFlags[9] <== IsEqual()([origPiece,8]);
    intermedFlags[10] <== IsEqual()([origPiece,9]);
    intermedFlags[11] <== IsEqual()([origPiece,10]);
    intermedFlags[12] <== IsEqual()([origPiece,11]);
    intermedFlags[13] <== IsEqual()([origPiece,12]);

    intermedFlags[14] <== ChckPieceLoc()(origHor,origVer,7,4);
    intermedFlags[15] <== ChckPieceLoc()(destHor,destVer,7,2);
    intermedFlags[16] <== ChckPieceLoc()(destHor,destVer,7,6);
    intermedFlags[17] <== intermedFlags[14]*(intermedFlags[15]+intermedFlags[16]);

    intermedFlags[18] <== IsKingMvLgl()(origHor,origVer,destHor,destVer);
    intermedFlags[19] <== IsQnMvLgl()(board,origHor,origVer,destHor,destVer);
    intermedFlags[20] <== IsRookMvLgl()(board,origHor,origVer,destHor,destVer);
    intermedFlags[21] <== IsBshpMVLgl()(board,origHor,origVer,destHor,destVer);
    intermedFlags[22] <== IsKnghtMvLgl()(origHor,origVer,destHor,destVer);
    intermedFlags[23] <== IsBlckPawnMvLgl()(board,origHor,origVer,destHor,destVer,destPiece,captFlag,prmtPiece,enPassHor,enPassVer);
    intermedFlags[24] <== IsBlckCstlLgl()(board,destHor,kingCstlFlag,qnCstlFlag);

    intermedFlags[25] <== intermedFlags[8]*intermedFlags[18];
    intermedFlags[26] <== intermedFlags[9]*intermedFlags[19];
    intermedFlags[27] <== intermedFlags[10]*intermedFlags[20];
    intermedFlags[28] <== intermedFlags[11]*intermedFlags[21];
    intermedFlags[29] <== intermedFlags[12]*intermedFlags[22];
    intermedFlags[30] <== intermedFlags[13]*intermedFlags[23];
    intermedFlags[31] <== intermedFlags[17]*intermedFlags[24];

    intermedFlags[32] <== nonPawnFlag*(intermedFlags[25] + intermedFlags[26] + intermedFlags[27] + intermedFlags[28] + intermedFlags[29] + intermedFlags[31]) + intermedFlags[30];
    intermedFlags[33] <== intermedFlags[0]*intermedFlags[1];
    intermedFlags[34] <== isOrigBlck*isNonSelfCapt;
    intermedFlags[35] <== intermedFlags[33]*intermedFlags[34];

    flag <== intermedFlags[32]*intermedFlags[35];
}

template IsKnghtMvLgl() {
    signal input origHor;
    signal input origVer;
    signal input destHor;
    signal input destVer;
    signal output flag;

    signal knghtHor[8] <== [2,1,-1,-2,-2,-1,1,2];
    signal knghtVer[8] <== [1,2,2,1,-1,-2,-2,-1];

    signal intermedFlags[8];

    var i;

    for (i=0; i<8; i++) {
        intermedFlags[i] <== ChckPieceLoc()(origHor+knghtHor[i],origVer+knghtVer[i],destHor,destVer);
    }

    flag <== intermedFlags[0] + intermedFlags[1] + intermedFlags[2] + intermedFlags[3] + intermedFlags[4] + intermedFlags[5] + intermedFlags[6] + intermedFlags[7];
    
}

template IsWhtPawnMvLgl() {
    signal input board[8][8];
    signal input origHor;
    signal input origVer;
    signal input destHor;
    signal input destVer;
    signal input destPiece;
    signal input captFlag;
    signal input prmtPiece;
    signal input enPassHor;
    signal input enPassVer;
    signal output flag;

    signal enPassFlag;
    signal isDestEmpty;
    signal isEnPassLgl;
    signal isRightCapt;
    signal isLeftCapt;
    signal isCaptLgl;
    signal oneSqrMvFlag;
    signal twoSqrMvFlag[3];
    signal isStartPlace;
    signal blockPiece;    
    signal isBlockEmpty;
    signal isReadyToPrmt;
    signal isPrmt;
    signal isPrmtLgl;
    signal isPawnMvLgl[3];

    enPassFlag <== ChckPieceLoc()(destHor,destVer,enPassHor,enPassVer);
    isDestEmpty <== IsZero()(destPiece);
    isEnPassLgl <== IsEqual()([isDestEmpty*captFlag,enPassFlag]);

    isRightCapt <== ChckPieceLoc()(origHor+1, origVer+1, destHor, destVer);
    isLeftCapt <== ChckPieceLoc()(origHor+1, origVer-1, destHor, destVer);
    isCaptLgl <== IsEqual()([captFlag,isRightCapt + isLeftCapt]);

    oneSqrMvFlag <== ChckPieceLoc()(origHor+1, origVer, destHor, destVer);

    twoSqrMvFlag[0] <== ChckPieceLoc()(origHor+2, origVer, destHor, destVer);
    isStartPlace <== IsEqual()([origHor,1]);
    twoSqrMvFlag[1] <== twoSqrMvFlag[0]*isStartPlace;
    blockPiece <== SqrToPiece()(board, origHor+1, origVer);
    isBlockEmpty <== IsZero()(blockPiece);
    twoSqrMvFlag[2] <== twoSqrMvFlag[1]*isBlockEmpty;

    isReadyToPrmt <== IsEqual()([origHor,6]);
    isPrmt <== IsNonZero()(prmtPiece);
    isPrmtLgl <== IsEqual()([isReadyToPrmt,isPrmt]);

    isPawnMvLgl[0] <== captFlag + isDestEmpty*(oneSqrMvFlag + twoSqrMvFlag[2]);
    isPawnMvLgl[1] <== isEnPassLgl*isCaptLgl;
    isPawnMvLgl[2] <== isPrmtLgl*isPawnMvLgl[0];

    flag <== isPawnMvLgl[1]*isPawnMvLgl[2];

}

template IsBlckPawnMvLgl() {
    signal input board[8][8];
    signal input origHor;
    signal input origVer;
    signal input destHor;
    signal input destVer;
    signal input destPiece;
    signal input captFlag;
    signal input prmtPiece;
    signal input enPassHor;
    signal input enPassVer;
    signal output flag;

    signal enPassFlag;
    signal isDestEmpty;
    signal isEnPassLgl;
    signal isRightCapt;
    signal isLeftCapt;
    signal isCaptLgl;
    signal oneSqrMvFlag;
    signal twoSqrMvFlag[3];
    signal isStartPlace;
    signal blockPiece;    
    signal isBlockEmpty;
    signal isReadyToPrmt;
    signal isPrmt;
    signal isPrmtLgl;
    signal isPawnMvLgl[3];

    enPassFlag <== ChckPieceLoc()(destHor,destVer,enPassHor,enPassVer);
    isDestEmpty <== IsZero()(destPiece);
    isEnPassLgl <== IsEqual()([isDestEmpty*captFlag,enPassFlag]);

    isRightCapt <== ChckPieceLoc()(origHor-1, origVer+1, destHor, destVer);
    isLeftCapt <== ChckPieceLoc()(origHor-1, origVer-1, destHor, destVer);
    isCaptLgl <== IsEqual()([captFlag,isRightCapt + isLeftCapt]);

    oneSqrMvFlag <== ChckPieceLoc()(origHor-1, origVer, destHor, destVer);

    twoSqrMvFlag[0] <== ChckPieceLoc()(origHor-2, origVer, destHor, destVer);
    isStartPlace <== IsEqual()([origHor,6]);
    twoSqrMvFlag[1] <== twoSqrMvFlag[0]*isStartPlace;
    blockPiece <== SqrToPiece()(board, origHor-1, origVer);
    isBlockEmpty <== IsZero()(blockPiece);
    twoSqrMvFlag[2] <== twoSqrMvFlag[1]*isBlockEmpty;

    isReadyToPrmt <== IsEqual()([origHor,1]);
    isPrmt <== IsNonZero()(prmtPiece);
    isPrmtLgl <== IsEqual()([isReadyToPrmt,isPrmt]);

    isPawnMvLgl[0] <== captFlag + isDestEmpty*(oneSqrMvFlag + twoSqrMvFlag[2]);
    isPawnMvLgl[1] <== isEnPassLgl*isCaptLgl;
    isPawnMvLgl[2] <== isPrmtLgl*isPawnMvLgl[0];

    flag <== isPawnMvLgl[1]*isPawnMvLgl[2];
}


template IsWhtCstlLgl() {
    signal input board[8][8];
    signal input destVer;
    signal input kingCstlFlag;
    signal input qnCstlFlag;
    signal output flag;

    signal isKingCstlPssbl;
    signal isQnCstlPssbl;

    var thrtSqrs = 55;
    var sqrFlagsN = thrtSqrs*9;

    signal intermedFlags[sqrFlagsN+6];
    signal thrtFlags[22];
    signal isSqrEmpty[5];
    signal intermediate[7];

    signal signs[70];
    signal sumToCheck[17];
    signal pieces[thrtSqrs];

    signal termToAdd[77];

    var i;
    var j;

    signal thrtSqrHor[thrtSqrs] <== [1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7];
    signal thrtSqrVer[thrtSqrs] <== [0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6];

    for (i=0; i<thrtSqrs; i++) {
        pieces[i] <== SqrToPiece()(board,thrtSqrHor[i],thrtSqrVer[i]);
        intermedFlags[9*i] <== GreaterEqThan(8)([pieces[i],1]);
        intermedFlags[9*i+1] <== LessEqThan(8)([pieces[i],6]);
        intermedFlags[9*i+2] <== intermedFlags[9*i]*intermedFlags[9*i+1];

        for (j=0; j<6; j++) {
            intermedFlags[9*i+3+j] <== IsEqual()([pieces[i],7+j]);
        }
    }

    //checking file (vertical rook) threats

    var start = 9*2 + 2; //C2 sqruare

    for (i=0; i<5; i++) {
        signs[7*i] <== -intermedFlags[start+9*i] + intermedFlags[start+9*i+1] + intermedFlags[start+9*i+2] + intermedFlags[start+9*i+3] - intermedFlags[start+9*i+4] - intermedFlags[start+9*i+5] - intermedFlags[start+9*i+6];
        termToAdd[7*i] <== FinalAdd(7)(signs[7*i]);

        for (j=1; j<7; j++) {
            signs[7*i+j] <== -intermedFlags[start+9*(i+8*j)] - intermedFlags[start+9*(i+8*j)+1] + intermedFlags[start+9*(i+8*j)+2] + intermedFlags[start+9*(i+8*j)+3] - intermedFlags[start+9*(i+8*j)+4] - intermedFlags[start+9*(i+8*j)+5] - intermedFlags[start+9*(i+8*j)+6];
            termToAdd[7*i+j] <== FinalAdd(8-(j+1))(signs[7*i+j]);
        }

        sumToCheck[i] <== termToAdd[7*i] + termToAdd[7*i+1] + termToAdd[7*i+2] + termToAdd[7*i+3] + termToAdd[7*i+4] + termToAdd[7*i+5] + termToAdd[7*i+6];

        thrtFlags[i] <== GreaterThan(8)([sumToCheck[i],128]);
    }

    // checking diagonal threats

    var leftStart = 9*1 + 2; //B2 sqruare
    var rightStart = 9*3 + 2; //D2 sqruare


    for (i=0; i<5; i++) {
        signs[35+7*i] <== -intermedFlags[leftStart+9*i] + intermedFlags[leftStart+9*i+1] + intermedFlags[leftStart+9*i+2] - intermedFlags[leftStart+9*i+3] + intermedFlags[leftStart+9*i+4] - intermedFlags[leftStart+9*i+5] + intermedFlags[leftStart+9*i+6];
        termToAdd[35+7*i] <== FinalAdd(7)(signs[35+7*i]);

        signs[35+7*i+2+i] <== -intermedFlags[rightStart+9*i] + intermedFlags[rightStart+9*i+1] + intermedFlags[rightStart+9*i+2] - intermedFlags[rightStart+9*i+3] + intermedFlags[rightStart+9*i+4] - intermedFlags[rightStart+9*i+5] + intermedFlags[rightStart+9*i+6];
        termToAdd[35+7*i+2+i] <== FinalAdd(7)(signs[35+7*i+2+i]);

        for (j=1; j<(2+i); j++) {
            signs[35+7*i+j] <== -intermedFlags[start+9*(i+7*j)] - intermedFlags[start+9*(i+7*j)+1] + intermedFlags[start+9*(i+7*j)+2] + intermedFlags[start+9*(i+7*j)+3] - intermedFlags[start+9*(i+7*j)+4] - intermedFlags[start+9*(i+7*j)+5] - intermedFlags[start+9*(i+7*j)+6];
            termToAdd[35+7*i+j] <== FinalAdd(8-(j+1))(signs[35+7*i+j]);
        }
        for (j=1; j<(7-(2+i)); j++) {
            signs[35+7*i+2+i+j] <== -intermedFlags[start+9*(i+9*j)] - intermedFlags[start+9*(i+9*j)+1] + intermedFlags[start+9*(i+9*j)+2] - intermedFlags[start+9*(i+9*j)+3] + intermedFlags[start+9*(i+9*j)+4] - intermedFlags[start+9*(i+9*j)+5] - intermedFlags[start+9*(i+9*j)+6];
            termToAdd[35+7*i+2+i+j] <== FinalAdd(8-(j+1))(signs[35+7*i+2+i+j]);
        }        
    }

    sumToCheck[5] <== termToAdd[35] + termToAdd[36];
    sumToCheck[6] <== termToAdd[37] + termToAdd[38] + termToAdd[39] + termToAdd[40] + termToAdd[41];
    sumToCheck[7] <== termToAdd[42] + termToAdd[43] + termToAdd[44];
    sumToCheck[8] <== termToAdd[45] + termToAdd[46] + termToAdd[47] + termToAdd[48];
    sumToCheck[9] <== termToAdd[49] + termToAdd[50] + termToAdd[51] + termToAdd[52];
    sumToCheck[10] <== termToAdd[53] + termToAdd[54] + termToAdd[55];
    sumToCheck[11] <== termToAdd[56] + termToAdd[57] + termToAdd[58] + termToAdd[59] + termToAdd[60];
    sumToCheck[12] <== termToAdd[61] + termToAdd[62];
    sumToCheck[13] <== termToAdd[63] + termToAdd[64] + termToAdd[65] + termToAdd[66] + termToAdd[67] + termToAdd[68];
    sumToCheck[14] <== termToAdd[69];

    for (i=0; i<5; i++) {
        thrtFlags[5+2*i] <== GreaterThan(8)([sumToCheck[5+2*i],128]);
        thrtFlags[5+2*i+1] <== GreaterThan(8)([sumToCheck[5+2*i+1],128]);
    }

    //checking knight threats

    for (i=0; i<4; i++) {
        intermediate[i] <== intermedFlags[9*(i+7)+7] + intermedFlags[9*(i+11)+7] + intermedFlags[9*(i+16)+7] + intermedFlags[9*(i+18)+7];
    }

    intermediate[4] <== intermedFlags[9*11+7] + intermedFlags[9*20+7] + intermedFlags[9*22+7];

    for (i=0; i<5; i++) {
        thrtFlags[15+i] <== IsNonZero()(intermediate[i]);
    }

    //checking first rank (horizontal rook) threats

    for (i=0; i<4; i++) {
        termToAdd[70+i] <== WhtKingLineHits(i+1,-1,1,1,-1,-1,-1)(board[0][3-i]);
    }

    for (i=0; i<3; i++) {
        termToAdd[74+i] <== WhtKingLineHits(i+1,-1,1,1,-1,-1,-1)(board[0][5+i]);
    }

    sumToCheck[15] <== termToAdd[70] + termToAdd[71] + termToAdd[72] + termToAdd[73];
    sumToCheck[16] <== termToAdd[74] + termToAdd[75] + termToAdd[76];

    thrtFlags[20] <== GreaterThan(8)([sumToCheck[15],128]);
    thrtFlags[21] <== GreaterThan(8)([sumToCheck[16],128]);

    isSqrEmpty[0] <== IsZero()(board[0][1]);
    isSqrEmpty[1] <== IsZero()(board[0][2]);
    isSqrEmpty[2] <== IsZero()(board[0][3]);
    isSqrEmpty[3] <== IsZero()(board[0][5]);
    isSqrEmpty[4] <== IsZero()(board[0][6]);

    intermediate[5] <== thrtFlags[0] + thrtFlags[1] + thrtFlags[2] + thrtFlags[5] + thrtFlags[6] + thrtFlags[7] + thrtFlags[8] + thrtFlags[9] + thrtFlags[10] + thrtFlags[15] + thrtFlags[16] + thrtFlags[17] + thrtFlags[20] + (1-isSqrEmpty[0]) + (1-isSqrEmpty[1]) + (1-isSqrEmpty[2]);

    intermediate[6] <== thrtFlags[2] + thrtFlags[3] + thrtFlags[4] + thrtFlags[9] + thrtFlags[10] + thrtFlags[11] + thrtFlags[12] + thrtFlags[13] + thrtFlags[14] + thrtFlags[17] + thrtFlags[18] + thrtFlags[19] + thrtFlags[21] + (1-isSqrEmpty[3]) + (1-isSqrEmpty[4]);

    isQnCstlPssbl <== IsZero()(intermediate[5]);
    isKingCstlPssbl <== IsZero()(intermediate[6]);


    intermedFlags[sqrFlagsN] <== IsEqual()([destVer,2]);
    intermedFlags[sqrFlagsN+1] <== IsEqual()([destVer,6]);

    intermedFlags[sqrFlagsN+2] <== intermedFlags[sqrFlagsN]*isQnCstlPssbl;
    intermedFlags[sqrFlagsN+3] <== intermedFlags[sqrFlagsN+1]*isKingCstlPssbl;

    intermedFlags[sqrFlagsN+4] <== intermedFlags[sqrFlagsN+2]*qnCstlFlag;
    intermedFlags[sqrFlagsN+5] <== intermedFlags[sqrFlagsN+3]*kingCstlFlag;

    flag <== intermedFlags[sqrFlagsN+4] + intermedFlags[sqrFlagsN+5];
}

template IsBlckCstlLgl() {
    signal input board[8][8];
    signal input destVer;
    signal input kingCstlFlag;
    signal input qnCstlFlag;
    signal output flag;

    signal isKingCstlPssbl;
    signal isQnCstlPssbl;

    var thrtSqrs = 55;
    var sqrFlagsN = thrtSqrs*9;

    signal intermedFlags[sqrFlagsN+6];
    signal thrtFlags[22];
    signal isSqrEmpty[5];
    signal intermediate[7];

    signal signs[70];
    signal sumToCheck[17];
    signal pieces[thrtSqrs];

    signal termToAdd[77];

    var i;
    var j;
    
    signal thrtSqrHor[thrtSqrs] <== [6,6,6,6,6,6,6,6,5,5,5,5,5,5,5,5,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0];
    signal thrtSqrVer[thrtSqrs] <== [0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,0,1,2,3,4,5,6];


    for (i=0; i<thrtSqrs; i++) {
        pieces[i] <== SqrToPiece()(board,thrtSqrHor[i],thrtSqrVer[i]);
        intermedFlags[9*i] <== GreaterEqThan(8)([pieces[i],7]);
        intermedFlags[9*i+1] <== LessEqThan(8)([pieces[i],12]);
        intermedFlags[9*i+2] <== intermedFlags[9*i]*intermedFlags[9*i+1];

        for (j=0; j<6; j++) {
            intermedFlags[9*i+3+j] <== IsEqual()([pieces[i],1+j]);
        }
    }
    
    //checking file (vertical rook) threats

    var start = 9*2 + 2; //C7 sqruare

    for (i=0; i<5; i++) {
        signs[7*i] <== -intermedFlags[start+9*i] + intermedFlags[start+9*i+1] + intermedFlags[start+9*i+2] + intermedFlags[start+9*i+3] - intermedFlags[start+9*i+4] - intermedFlags[start+9*i+5] - intermedFlags[start+9*i+6];
        termToAdd[7*i] <== FinalAdd(7)(signs[7*i]);

        for (j=1; j<7; j++) {
            signs[7*i+j] <== -intermedFlags[start+9*(i+8*j)] - intermedFlags[start+9*(i+8*j)+1] + intermedFlags[start+9*(i+8*j)+2] + intermedFlags[start+9*(i+8*j)+3] - intermedFlags[start+9*(i+8*j)+4] - intermedFlags[start+9*(i+8*j)+5] - intermedFlags[start+9*(i+8*j)+6];
            termToAdd[7*i+j] <== FinalAdd(8-(j+1))(signs[7*i+j]);
        }

        sumToCheck[i] <== termToAdd[7*i] + termToAdd[7*i+1] + termToAdd[7*i+2] + termToAdd[7*i+3] + termToAdd[7*i+4] + termToAdd[7*i+5] + termToAdd[7*i+6];

        thrtFlags[i] <== GreaterThan(8)([sumToCheck[i],128]);
    }

    // checking diagonal threats

    var leftStart = 9*1 + 2; //B7 sqruare
    var rightStart = 9*3 + 2; //D7 sqruare


    for (i=0; i<5; i++) {
        signs[35+7*i] <== -intermedFlags[leftStart+9*i] + intermedFlags[leftStart+9*i+1] + intermedFlags[leftStart+9*i+2] - intermedFlags[leftStart+9*i+3] + intermedFlags[leftStart+9*i+4] - intermedFlags[leftStart+9*i+5] + intermedFlags[leftStart+9*i+6];
        termToAdd[35+7*i] <== FinalAdd(7)(signs[35+7*i]);

        signs[35+7*i+2+i] <== -intermedFlags[rightStart+9*i] + intermedFlags[rightStart+9*i+1] + intermedFlags[rightStart+9*i+2] - intermedFlags[rightStart+9*i+3] + intermedFlags[rightStart+9*i+4] - intermedFlags[rightStart+9*i+5] + intermedFlags[rightStart+9*i+6];
        termToAdd[35+7*i+2+i] <== FinalAdd(7)(signs[35+7*i+2+i]);

        for (j=1; j<(2+i); j++) {
            signs[35+7*i+j] <== -intermedFlags[start+9*(i+7*j)] - intermedFlags[start+9*(i+7*j)+1] + intermedFlags[start+9*(i+7*j)+2] + intermedFlags[start+9*(i+7*j)+3] - intermedFlags[start+9*(i+7*j)+4] - intermedFlags[start+9*(i+7*j)+5] - intermedFlags[start+9*(i+7*j)+6];
            termToAdd[35+7*i+j] <== FinalAdd(8-(j+1))(signs[35+7*i+j]);
        }
        for (j=1; j<(7-(2+i)); j++) {
            signs[35+7*i+2+i+j] <== -intermedFlags[start+9*(i+9*j)] - intermedFlags[start+9*(i+9*j)+1] + intermedFlags[start+9*(i+9*j)+2] - intermedFlags[start+9*(i+9*j)+3] + intermedFlags[start+9*(i+9*j)+4] - intermedFlags[start+9*(i+9*j)+5] - intermedFlags[start+9*(i+9*j)+6];
            termToAdd[35+7*i+2+i+j] <== FinalAdd(8-(j+1))(signs[35+7*i+2+i+j]);
        }        
    }

    sumToCheck[5] <== termToAdd[35] + termToAdd[36];
    sumToCheck[6] <== termToAdd[37] + termToAdd[38] + termToAdd[39] + termToAdd[40] + termToAdd[41];
    sumToCheck[7] <== termToAdd[42] + termToAdd[43] + termToAdd[44];
    sumToCheck[8] <== termToAdd[45] + termToAdd[46] + termToAdd[47] + termToAdd[48];
    sumToCheck[9] <== termToAdd[49] + termToAdd[50] + termToAdd[51] + termToAdd[52];
    sumToCheck[10] <== termToAdd[53] + termToAdd[54] + termToAdd[55];
    sumToCheck[11] <== termToAdd[56] + termToAdd[57] + termToAdd[58] + termToAdd[59] + termToAdd[60];
    sumToCheck[12] <== termToAdd[61] + termToAdd[62];
    sumToCheck[13] <== termToAdd[63] + termToAdd[64] + termToAdd[65] + termToAdd[66] + termToAdd[67] + termToAdd[68];
    sumToCheck[14] <== termToAdd[69];

    for (i=0; i<5; i++) {
        thrtFlags[5+2*i] <== GreaterThan(8)([sumToCheck[5+2*i],128]);
        thrtFlags[5+2*i+1] <== GreaterThan(8)([sumToCheck[5+2*i+1],128]);
    }

    //checking knight threats

    for (i=0; i<4; i++) {
        intermediate[i] <== intermedFlags[9*(i+7)+7] + intermedFlags[9*(i+11)+7] + intermedFlags[9*(i+16)+7] + intermedFlags[9*(i+18)+7];
    }

    intermediate[4] <== intermedFlags[9*11+7] + intermedFlags[9*20+7] + intermedFlags[9*22+7];

    for (i=0; i<5; i++) {
        thrtFlags[15+i] <== IsNonZero()(intermediate[i]);
    }

    //checking last rank (horizontal rook) threats

    for (i=0; i<4; i++) {
        termToAdd[70+i] <== BlckKingLineHits(i+1,-1,1,1,-1,-1,-1)(board[7][3-i]);
    }

    for (i=0; i<3; i++) {
        termToAdd[74+i] <== BlckKingLineHits(i+1,-1,1,1,-1,-1,-1)(board[7][5+i]);
    }

    sumToCheck[15] <== termToAdd[70] + termToAdd[71] + termToAdd[72] + termToAdd[73];
    sumToCheck[16] <== termToAdd[74] + termToAdd[75] + termToAdd[76];

    thrtFlags[20] <== GreaterThan(8)([sumToCheck[15],128]);
    thrtFlags[21] <== GreaterThan(8)([sumToCheck[16],128]);

    isSqrEmpty[0] <== IsZero()(board[7][1]);
    isSqrEmpty[1] <== IsZero()(board[7][2]);
    isSqrEmpty[2] <== IsZero()(board[7][3]);
    isSqrEmpty[3] <== IsZero()(board[7][5]);
    isSqrEmpty[4] <== IsZero()(board[7][6]);

    intermediate[5] <== thrtFlags[0] + thrtFlags[1] + thrtFlags[2] + thrtFlags[5] + thrtFlags[6] + thrtFlags[7] + thrtFlags[8] + thrtFlags[9] + thrtFlags[10] + thrtFlags[15] + thrtFlags[16] + thrtFlags[17] + thrtFlags[20] + (1-isSqrEmpty[0]) + (1-isSqrEmpty[1]) + (1-isSqrEmpty[2]);

    intermediate[6] <== thrtFlags[2] + thrtFlags[3] + thrtFlags[4] + thrtFlags[9] + thrtFlags[10] + thrtFlags[11] + thrtFlags[12] + thrtFlags[13] + thrtFlags[14] + thrtFlags[17] + thrtFlags[18] + thrtFlags[19] + thrtFlags[21] + (1-isSqrEmpty[3]) + (1-isSqrEmpty[4]);

    isQnCstlPssbl <== IsZero()(intermediate[5]);
    isKingCstlPssbl <== IsZero()(intermediate[6]);

    intermedFlags[sqrFlagsN] <== IsEqual()([destVer,2]);
    intermedFlags[sqrFlagsN+1] <== IsEqual()([destVer,6]);

    intermedFlags[sqrFlagsN+2] <== intermedFlags[sqrFlagsN]*isQnCstlPssbl;
    intermedFlags[sqrFlagsN+3] <== intermedFlags[sqrFlagsN+1]*isKingCstlPssbl;

    intermedFlags[sqrFlagsN+4] <== intermedFlags[sqrFlagsN+2]*qnCstlFlag;
    intermedFlags[sqrFlagsN+5] <== intermedFlags[sqrFlagsN+3]*kingCstlFlag;

    flag <== intermedFlags[sqrFlagsN+4] + intermedFlags[sqrFlagsN+5];
}

template IsKingMvLgl() {
    signal input origHor;
    signal input origVer;
    signal input destHor;
    signal input destVer;
    signal output flag;

    signal intermedFlags[4];

    signal horDiff <== destHor - origHor;
    signal verDiff <== destVer - origVer;

    intermedFlags[0] <== GreaterEqThan(8)([horDiff,-1]);
    intermedFlags[1] <== GreaterEqThan(8)([verDiff,-1]);
    intermedFlags[2] <== LessEqThan(8)([horDiff,1]);
    intermedFlags[3] <== LessEqThan(8)([verDiff,1]);

    component iseq = IsEqual();
    iseq.in[0] <== intermedFlags[0] + intermedFlags[1] + intermedFlags[2] + intermedFlags[3];
    iseq.in[1] <== 4;
    iseq.out ==> flag;
}

template IsBshpMVLgl() {
    signal input board[8][8];
    signal input origHor;
    signal input origVer;
    signal input destHor;
    signal input destVer;
    signal output flag;

    signal mvLglFlags[28];
    signal isDiagEmpty[24];
    signal isDestLgl[24];
    signal isSqrEmpty[20];
    signal pieces[24];

    signal bshpHor[4] <== [1,-1,-1,1];
    signal bshpVer[4] <== [1,1,-1,-1];

    var i;
    var j;

    for (i=0; i<4; i++) {
        mvLglFlags[7*i] <== ChckPieceLoc()(origHor+bshpHor[i],origVer+bshpVer[i],destHor,destVer);  

        pieces[6*i] <== SqrToPiece()(board,origHor+bshpHor[i],origVer+bshpVer[i]);
        isDiagEmpty[6*i] <== IsZero()(pieces[6*i]);
        isDestLgl[6*i] <== ChckPieceLoc()(origHor+bshpHor[i]*2,origVer+bshpVer[i]*2,destHor,destVer);
        mvLglFlags[7*i+1] <== isDiagEmpty[6*i]*isDestLgl[6*i];     

        for (j=1; j<6; j++) {
            pieces[6*i+j] <== SqrToPiece()(board,origHor+bshpHor[i]*(j+1),origVer+bshpVer[i]*(j+1));
            isSqrEmpty[5*i+j-1] <== IsZero()(pieces[6*i+j]);
            isDiagEmpty[6*i+j] <== isDiagEmpty[6*i+j-1]*isSqrEmpty[5*i+j-1];
            isDestLgl[6*i+j] <== ChckPieceLoc()(origHor+bshpHor[i]*(j+2),origVer+bshpVer[i]*(j+2),destHor,destVer);
            mvLglFlags[7*i+j+1] <== isDiagEmpty[6*i+j]*isDestLgl[6*i+j];
        }
    }

    flag <== mvLglFlags[0] + mvLglFlags[1] + mvLglFlags[2] + mvLglFlags[3] + mvLglFlags[4] + mvLglFlags[5] + mvLglFlags[6] + mvLglFlags[7] + mvLglFlags[8] + mvLglFlags[9] + mvLglFlags[10] + mvLglFlags[11] + mvLglFlags[12] + mvLglFlags[13] + mvLglFlags[14] + mvLglFlags[15] + mvLglFlags[16] + mvLglFlags[17] + mvLglFlags[18] + mvLglFlags[19] + mvLglFlags[20] + mvLglFlags[21] + mvLglFlags[22] + mvLglFlags[23] + mvLglFlags[24] + mvLglFlags[25] + mvLglFlags[26] + mvLglFlags[27];

}


template IsRookMvLgl() {
    signal input board[8][8];
    signal input origHor;
    signal input origVer;
    signal input destHor;
    signal input destVer;
    signal output flag;

    signal mvLglFlags[28];
    signal isLineEmpty[24];
    signal isDestLgl[24];
    signal isSqrEmpty[20];
    signal pieces[24];

    signal rookHor[4] <== [1,0,-1,0];
    signal rookVer[4] <== [0,1,0,-1];

    var i;
    var j;

    for (i=0; i<4; i++) {
        mvLglFlags[7*i] <== ChckPieceLoc()(origHor+rookHor[i],origVer+rookVer[i],destHor,destVer);  

        pieces[6*i] <== SqrToPiece()(board,origHor+rookHor[i],origVer+rookVer[i]);
        isLineEmpty[6*i] <== IsZero()(pieces[6*i]);
        isDestLgl[6*i] <== ChckPieceLoc()(origHor+rookHor[i]*2,origVer+rookVer[i]*2,destHor,destVer);
        mvLglFlags[7*i+1] <== isLineEmpty[6*i]*isDestLgl[6*i];     

        for (j=1; j<6; j++) {
            pieces[6*i+j] <== SqrToPiece()(board,origHor+rookHor[i]*(j+1),origVer+rookVer[i]*(j+1));
            isSqrEmpty[5*i+j-1] <== IsZero()(pieces[6*i+j]);
            isLineEmpty[6*i+j] <== isLineEmpty[6*i+j-1]*isSqrEmpty[5*i+j-1];
            isDestLgl[6*i+j] <== ChckPieceLoc()(origHor+rookHor[i]*(j+2),origVer+rookVer[i]*(j+2),destHor,destVer);
            mvLglFlags[7*i+j+1] <== isLineEmpty[6*i+j]*isDestLgl[6*i+j];
        }
    }

    flag <== mvLglFlags[0] + mvLglFlags[1] + mvLglFlags[2] + mvLglFlags[3] + mvLglFlags[4] + mvLglFlags[5] + mvLglFlags[6] + mvLglFlags[7] + mvLglFlags[8] + mvLglFlags[9] + mvLglFlags[10] + mvLglFlags[11] + mvLglFlags[12] + mvLglFlags[13] + mvLglFlags[14] + mvLglFlags[15] + mvLglFlags[16] + mvLglFlags[17] + mvLglFlags[18] + mvLglFlags[19] + mvLglFlags[20] + mvLglFlags[21] + mvLglFlags[22] + mvLglFlags[23] + mvLglFlags[24] + mvLglFlags[25] + mvLglFlags[26] + mvLglFlags[27];

}

template IsQnMvLgl() {
    signal input board[8][8];
    signal input origHor;
    signal input origVer;
    signal input destHor;
    signal input destVer;
    signal output flag;

    signal bshpMvFlag;
    signal rookMvFlag;

    bshpMvFlag <== IsBshpMVLgl()(board,origHor,origVer,destHor,destVer);
    rookMvFlag <== IsRookMvLgl()(board,origHor,origVer,destHor,destVer);

    flag <== bshpMvFlag + rookMvFlag;

}
