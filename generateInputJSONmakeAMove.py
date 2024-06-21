import json

filename = "inputMakeAMove.txt"


# filename = "test1.txt"
# filename = "test2.txt"
# filename = "test3.txt"
# filename = "test4.txt"
# filename = "test5.txt"

dict1 = {}

with open(filename) as f:
    first_line = f.readline()
    boardStr, stmStr, cstFlagsStr, enPassSqrStr, halfMvCntrStr, fullMvCntrStr, moveStr = first_line.strip().split()

boardLines = boardStr.split("/")

board = []
for i in range(8):
    board.append([])

for i,s in enumerate(boardLines):
    n = len(s)
    for j in range(n):
        match s[j]:
            case 'K':
                board[7-i].append(1)
            case 'Q':
                board[7-i].append(2)
            case 'R':
                board[7-i].append(3)
            case 'B':
                board[7-i].append(4)
            case 'N':
                board[7-i].append(5)
            case 'P':
                board[7-i].append(6)
            case 'k':
                board[7-i].append(7)
            case 'q':
                board[7-i].append(8)
            case 'r':
                board[7-i].append(9)
            case 'b':
                board[7-i].append(10)
            case 'n':
                board[7-i].append(11)
            case 'p':
                board[7-i].append(12)
            case _:
                m = int(s[j])
                for k in range(m):
                    board[7-i].append(0)


kingHor = [50,50]
kingVer = [50,50]

for i in range(8):
    for j in range(8):
        if board[i][j]==1:
            kingHor[0] = i
            kingVer[0] = j
        elif board[i][j]==7:
            kingHor[1] = i
            kingVer[1] = j

if stmStr=='w':
    stm = 0
else:
    stm = 1

kingCstlFlag = [0,0]
qnCstlFlag = [0,0]

if cstFlagsStr!='-':
    for ch in cstFlagsStr:
        match ch:
            case 'K':
                kingCstlFlag[0] = 1
            case 'Q':
                qnCstlFlag[0] = 1
            case 'k':
                kingCstlFlag[1] = 1
            case 'q':
                qnCstlFlag[1] = 1


def sqrStrToJSON(sqr):
    match sqr[0]:
        case 'a':
            ver = 0
        case 'b':
            ver = 1
        case 'c':
            ver = 2
        case 'd':
            ver = 3
        case 'e':
            ver = 4
        case 'f':
            ver = 5
        case 'g':
            ver = 6
        case 'h':
            ver = 7
    hor = int(sqr[1])-1
    return hor,ver

def pieceStrToJSON(pieceStr):
    match pieceStr:
        case 'K':
            pieceJSON = 1
        case 'Q':
            pieceJSON = 2
        case 'R':
            pieceJSON = 3
        case 'B':
            pieceJSON = 4
        case 'N':
            pieceJSON = 5
        # case _:
        #     pieceJSON = 6
    return pieceJSON

enPassHor = 50
enPassVer = 50

if enPassSqrStr!='-':
    enPassHor, enPassVer = sqrStrToJSON(enPassSqrStr)

halfMvCntr = int(halfMvCntrStr)

n = len(moveStr)

captFlag = 0
prmtPiece = 0

if moveStr[0].isupper():
    origPiece = pieceStrToJSON(moveStr[0]) + 6*stm
    moveStr = moveStr[1:]
else:
    origPiece = 6 + 6*stm

n = len(moveStr)

origHor, origVer = sqrStrToJSON(moveStr[:2])
destHor, destVer = sqrStrToJSON(moveStr[3:5])
if moveStr[2]=='x':
    captFlag = 1
if n==7:
    prmtPiece = pieceStrToJSON(moveStr[6]) + 6*stm


dict1['board'] = board
dict1['stm'] = stm
dict1['kingCstlFlag'] = kingCstlFlag
dict1['qnCstlFlag'] = qnCstlFlag
dict1['enPassHor'] = enPassHor
dict1['enPassVer'] = enPassVer
dict1['halfMvCntr'] = halfMvCntr
dict1['kingHor'] = kingHor
dict1['kingVer'] = kingVer
dict1['origHor'] = origHor
dict1['origVer'] = origVer
dict1['origPiece'] = origPiece
dict1['destHor'] = destHor
dict1['destVer'] = destVer
dict1['captFlag'] = captFlag
dict1['prmtPiece'] = prmtPiece

out_file = open("input.json", "w")
json.dump(dict1, out_file, indent = 4, sort_keys = False)
out_file.close()