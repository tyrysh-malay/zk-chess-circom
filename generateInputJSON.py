import json

# filename = "input.txt"

filename = "test1.txt"

with open(filename) as f:
    first_line = f.readline()
    moves = first_line.strip().split()

for ind,s in enumerate(moves):
    if ind%2==0:
        moves[ind] = s[(s.find('.')+1):]

N = len(moves)

dict1 = {}


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

def parseMove(ind,moveStr):
    captFlag = 0
    prmtPiece = 0

    if moveStr[0].isupper():
        origPiece = pieceStrToJSON(moveStr[0]) + 6*(ind%2)
        moveStr = moveStr[1:]
    else:
        origPiece = 6 + 6*(ind%2)

    n = len(moveStr)

    origHor, origVer = sqrStrToJSON(moveStr[:2])
    destHor, destVer = sqrStrToJSON(moveStr[3:5])
    if moveStr[2]=='x':
        captFlag = 1
    if n==7:
        prmtPiece = pieceStrToJSON(moveStr[6]) + 6*stm

    return (origHor,origVer,origPiece,destHor,destVer,captFlag,prmtPiece)

origHor = []
origVer = []
origPiece = []
destHor = []
destVer = []
captFlag = []
prmtPiece = []

for i in range(N):
    origHor.append(0)
    origVer.append(0)
    origPiece.append(0)
    destHor.append(0)
    destVer.append(0)
    captFlag.append(0)
    prmtPiece.append(0)

    origHor[i],origVer[i],origPiece[i],destHor[i],destVer[i],captFlag[i],prmtPiece[i] = parseMove(i,moves[i])

dict1['origHor'] = origHor
dict1['origVer'] = origVer
dict1['origPiece'] = origPiece
dict1['destHor'] = destHor
dict1['destVer'] = destVer
dict1['captFlag'] = captFlag
dict1['prmPiece'] = prmtPiece

out_file = open("input.json", "w")
json.dump(dict1, out_file, indent = 4, sort_keys = False)
out_file.close()