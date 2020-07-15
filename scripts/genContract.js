const ethers = require("ethers");
const snarkjs = require("snarkjs");
const {stringifyBigInts, unstringifyBigInts} = require("ffjavascript").utils;
const fs = require("fs");
const { createCode } = require("../circomlib/src/mimc_gencontract");
const { abi } = require("../circomlib/src/mimc_gencontract");
const mimc7 = require("./mimc7.js");

let provider = ethers.providers.getDefaultProvider("rinkeby");
let privateKey = "0xA6D5A42D93548E651DADF701F254BADF58ECFA077CE5D0CE16B069D196F1DAAD"
let wallet = new ethers.Wallet(privateKey,provider);
async function deployC () {
    

    var bytecode = createCode("mimc",91);
    const factory = new ethers.ContractFactory(abi, bytecode, wallet);

    var contract = await factory.deploy();
    console.log(contract.address);
    console.log(contract.deployTransaction.hash);
    await contract.deployed();
}
// deployC();
console.log(mimc7.getConstants());
// var addressContract = "0xfdf88F12Ef292f88d9086DCA25E75e8538fdF34F";
// var cont = new ethers.Contract(addressContract,abi,wallet);

// (async function (){
//     await cont.MiMCpe7(10,2).then(res => console.log(res.toString()));
// })();

