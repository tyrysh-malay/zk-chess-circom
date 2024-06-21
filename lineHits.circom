pragma circom 2.1.6;

include "generalChessRules.circom";

template WhtKingLineHits(N,K,Q,R,B,Kn,P) {
    signal input piece;
    signal output finalAdd;

    assert(N>0);
    assert(N<8);
    assert(K*K==1);
    assert(Q*Q==1);
    assert(R*R==1);
    assert(B*B==1);
    assert(Kn*Kn==1);
    assert(P*P==1);

    signal outs[9];
    signal sign;

    var i;

    outs[0] <== GreaterEqThan(8)([piece,1]);
    outs[1] <== LessEqThan(8)([piece,6]);
    outs[2] <== outs[0]*outs[1];

    for (i=0; i<6; i++) {
        outs[3+i] <== IsEqual()([piece,7+i]);
    }

    sign <== -outs[2] + K*outs[3] + Q*outs[4] + R*outs[5] + B*outs[6] + Kn*outs[7] + P*outs[8];

    finalAdd <== FinalAdd(8-N)(sign);
}

template BlckKingLineHits(N,K,Q,R,B,Kn,P) {
    signal input piece;
    signal output finalAdd;

    assert(N>0);
    assert(N<8);
    assert(K*K==1);
    assert(Q*Q==1);
    assert(R*R==1);
    assert(B*B==1);
    assert(Kn*Kn==1);
    assert(P*P==1);

    signal outs[9];
    signal sign;

    var i;

    outs[0] <== GreaterEqThan(8)([piece,7]);
    outs[1] <== LessEqThan(8)([piece,12]);
    outs[2] <== outs[0]*outs[1];

    for (i=0; i<6; i++) {
        outs[3+i] <== IsEqual()([piece,1+i]);
    }

    sign <== -outs[2] + K*outs[3] + Q*outs[4] + R*outs[5] + B*outs[6] + Kn*outs[7] + P*outs[8];

    finalAdd <== FinalAdd(8-N)(sign);
}

template FinalAdd(M) {
    signal input sign;
    signal output finalAdd;

    assert(M>0);
    assert(M<8);

    signal powers[M];
    signal termToAdd;

    var i;

    powers[0] <== 1;
    for (i=1; i<M; i++) {
        powers[i] <== 2*powers[i-1];
    }

    termToAdd <== powers[M-1];

    finalAdd <== sign*termToAdd;
}