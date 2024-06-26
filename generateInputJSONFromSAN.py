import chess
import chess.pgn
import io
import json

filename = "input.txt"

with open(filename) as f:
    san_string = f.read()

# print(san_string)

# Initialize a game object from the SAN string
pgn = io.StringIO(san_string)
game = chess.pgn.read_game(pgn)

# Initialize a board to track the position
board = game.board()

# Iterate through the lan_moves and convert SAN to LAN
lan_moves = []
for move in game.mainline_moves():
    lan_moves.append(board.lan(move))
    board.push(move)

print(lan_moves)

N = len(lan_moves)

dict1 = {}


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

def parseMove(ind,moveStr):
    captFlag = 0
    prmtPiece = 0

    stm = ind%2

    if moveStr == 'O-O':
        origHor = 7*stm
        origVer = 4
        origPiece = 1 + 6*stm
        destHor = 7*stm
        destVer = 6
        captFlag = 0
        prmtPiece = 0
    elif moveStr == 'O-O-O':
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

    origHor[i],origVer[i],origPiece[i],destHor[i],destVer[i],captFlag[i],prmtPiece[i] = parseMove(i,lan_moves[i])

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