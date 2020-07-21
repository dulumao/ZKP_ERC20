#!/bin/bash
snarkjs zkey new circuit.r1cs ../PTAU/pot12_final.ptau circuit_0000.zkey
snarkjs zkey contribute circuit_0000.zkey circuit_0001.zkey --name="1st Contributor Name" -e="bonjour" -v
snarkjs zkey contribute circuit_0001.zkey circuit_0002.zkey --name="Second contribution Name" -v -e="Another random entropy"
snarkjs zkey contribute circuit_0002.zkey circuit_0003.zkey --name="Third contribution Name" -v -e="Another random entropy"
snarkjs zkey verify circuit.r1cs ../PTAU/pot12_final.ptau circuit_0003.zkey
snarkjs zkey beacon circuit_0003.zkey circuit_final.zkey 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2"
snarkjs zkey verify circuit.r1cs ../PTAU/pot12_final.ptau circuit_final.zkey
snarkjs zkey export verificationkey circuit_final.zkey verification_key.json
snarkjs wtns calculate circuit.wasm input.json witness.wtns
snarkjs wtns debug circuit.wasm input.json witness.wtns circuit.sym --trigger --get --set
snarkjs groth16 prove circuit_final.zkey witness.wtns proof.json public.json




