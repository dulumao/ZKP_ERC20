const fs = require('fs');
const zkSnark = require("snarkjs");


const circuitDef = fs.readFileSync("circuitSender/circuit.circom", "utf8");
const circuit = snarkjs.Circuit(circuitDef);

Console.log(circuit.nOutputs) ;          // number of public outputs
