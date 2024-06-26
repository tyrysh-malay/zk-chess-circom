import json

filename = "inputMakeAMove.txt"

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
        if s[j] == 'K':
            board[7-i].append(1)
        elif s[j] == 'Q':
            board[7-i].append(2)
        elif s[j] == 'R':
            board[7-i].append(3)
        elif s[j] == 'B':
            board[7-i].append(4)
        elif s[j] == 'N':
            board[7-i].append(5)
        elif s[j] == 'P':
            board[7-i].append(6)
        elif s[j] == 'k':
            board[7-i].append(7)
        elif s[j] == 'q':
            board[7-i].append(8)
        elif s[j] == 'r':
            board[7-i].append(9)
        elif s[j] == 'b':
            board[7-i].append(10)
        elif s[j] == 'n':
            board[7-i].append(11)
        elif s[j] == 'p':
            board[7-i].append(12)
        else:
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
        if ch == 'K':
            kingCstlFlag[0] = 1
        elif ch == 'Q':
            qnCstlFlag[0] = 1
        elif ch == 'k':
            kingCstlFlag[1] = 1
        elif ch == 'q':
            qnCstlFlag[1] = 1


def sqrStrToJSON(sqr):
    ver = ord(sqr[0]) - 97
    hor = int(sqr[1]) - 1
    return hor,ver

def pieceStrToJSON(pieceStr):
    pieceJSON = 1
    if pieceStr == 'K':
        pieceJSON = 1
    elif pieceStr == 'Q':
        pieceJSON = 2
    elif pieceStr == 'R':
        pieceJSON = 3
    elif pieceStr == 'B':
        pieceJSON = 4
    elif pieceStr == 'N':
        pieceJSON = 5
    return pieceJSON

enPassHor = 50
enPassVer = 50

if enPassSqrStr!='-':
    enPassHor, enPassVer = sqrStrToJSON(enPassSqrStr)

halfMvCntr = int(halfMvCntrStr)

captFlag = 0
prmtPiece = 0

if moveStr == '0-0':
    origHor = 7*stm
    origVer = 4
    origPiece = 1 + 6*stm
    destHor = 7*stm
    destVer = 6
    captFlag = 0
    prmtPiece = 0
elif moveStr == '0-0-0':
    origHor = 7*stm
    origVer = 4
    origPiece = 1 + 6*stm
    destHor = 7*stm
    destVer = 2
    captFlag = 0
    prmtPiece = 0
else:
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
    if n>=7:
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

out_file = open("playAGame_input.json", "w")
json.dump(dict1, out_file, indent = 4, sort_keys = False)
out_file.close()
