**INSTRUCTIONS**

1. First, you need to install rust and circom:

```
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
git clone https://github.com/iden3/circom.git
cd circom
cargo build --release
cargo install --path circom
```

2. Secondly, you need to add circomlib to use those circuits as templates:

```
npm init
npm i circomlib
```

3. Now, you are ready to check your chess game's correctness. First, you need to fill in `input.txt` file with chess game notation in SAN (Short Algebraic Notation) or PGN (Portable Game Notation) format.

4. At this point, you need to edit main circuit `playAGame.circom` to work it properly.

```
cd circuits
```

5. Edit last line of `playAGame.circom` file: `component main = PlayAGame(%HALFMOVESNUMBER);`, where you put your chess game's number of halfmoves instead of given number.

6. Now, you can compile circuit and generate an input for that. Don't be confused with generation script's name: it will work both for SAN and PGN notation.

```
circom playAGame.circom --r1cs --wasm
../python3 generateInputJSONFromSAN.py
mv ../playAGame_input.json ./playAGame_js/
```

7. Now, you can generate a witness.

```
node generate_witness.js playAGame.wasm playAGame_input.json witness.wtns
```

8. Finally, you get a witness. That's a sign that everything was performed correctly. At this point, proof generation is complicated and will be implented later
