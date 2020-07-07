const fs = require('fs');
// @ts-ignore
const zkSnark = require("snarkjs");

const hash = require("circomlib/src/mimc7.js").hash;


const circuitDef = fs.readFileSync("circuitSender/circuit.r1cs", "utf8");
const circuit = new zkSnark.Circuit(circuitDef);
const setup = zkSnark.groth.setup(circuit);
Console.log(circuit.nOutputs) ;          // number of public outputs

