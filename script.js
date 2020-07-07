const ethers = require("ethers");
const snarkjs = require("snarkjs");
const {stringifyBigInts, unstringifyBigInts} = require("ffjavascript").utils;
const fs = require("fs");
const { Console } = require("console");
const { removeListener } = require("process");


var provider = ethers.providers.getDefaultProvider("rinkeby");
var abi = [
	{
		"inputs": [],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "owner",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "spender",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "value",
				"type": "uint256"
			}
		],
		"name": "Approval",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "spender",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "approve",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "spender",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "subtractedValue",
				"type": "uint256"
			}
		],
		"name": "decreaseAllowance",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "spender",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "addedValue",
				"type": "uint256"
			}
		],
		"name": "increaseAllowance",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_addressVerif",
				"type": "address"
			}
		],
		"name": "setAddressVerif",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "recipient",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "transfer",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "from",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "to",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "value",
				"type": "uint256"
			}
		],
		"name": "Transfer",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_to",
				"type": "address"
			},
			{
				"internalType": "string",
				"name": "hashSenderBalanceAfter",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "hashReceiverBalanceAfter",
				"type": "string"
			},
			{
				"components": [
					{
						"internalType": "uint256[2]",
						"name": "a",
						"type": "uint256[2]"
					},
					{
						"internalType": "uint256[2][2]",
						"name": "b",
						"type": "uint256[2][2]"
					},
					{
						"internalType": "uint256[2]",
						"name": "c",
						"type": "uint256[2]"
					},
					{
						"internalType": "uint256[3]",
						"name": "input",
						"type": "uint256[3]"
					}
				],
				"internalType": "struct myToken.VerifParameters",
				"name": "vSender",
				"type": "tuple"
			},
			{
				"components": [
					{
						"internalType": "uint256[2]",
						"name": "a",
						"type": "uint256[2]"
					},
					{
						"internalType": "uint256[2][2]",
						"name": "b",
						"type": "uint256[2][2]"
					},
					{
						"internalType": "uint256[2]",
						"name": "c",
						"type": "uint256[2]"
					},
					{
						"internalType": "uint256[3]",
						"name": "input",
						"type": "uint256[3]"
					}
				],
				"internalType": "struct myToken.VerifParameters",
				"name": "vReceiver",
				"type": "tuple"
			}
		],
		"name": "transferConfidentiel",
		"outputs": [
			{
				"internalType": "bool",
				"name": "val",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "sender",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "recipient",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "amount",
				"type": "uint256"
			}
		],
		"name": "transferFrom",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "_decimals",
		"outputs": [
			{
				"internalType": "uint8",
				"name": "",
				"type": "uint8"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "_INITIAL_SUPPLY",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "_name",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "_symbol",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "owner",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "spender",
				"type": "address"
			}
		],
		"name": "allowance",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "account",
				"type": "address"
			}
		],
		"name": "balanceOf",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "decimals",
		"outputs": [
			{
				"internalType": "uint8",
				"name": "",
				"type": "uint8"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getAddressVerif",
		"outputs": [
			{
				"internalType": "address",
				"name": "adr",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_addr",
				"type": "address"
			}
		],
		"name": "getBalanceHash",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "name",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "symbol",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "totalSupply",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
];


// var addressContractOLD  = '0xcA7977e12e736d4d228B4f33a7e9dAFEcb96A77e';
// var addressVerifierOLD = "0x4a97BA615e661aC592AF23d6D71706B8e1B97002";
var addressContract = "0x02135DAeFEb5bB48A04A44b28979c56Dc0Da409C";
var addressVerifier = "0x787f18d8a1FFbdbf8656743466c903f955b4c07E";


var privateKey = "0xA6D5A42D93548E651DADF701F254BADF58ECFA077CE5D0CE16B069D196F1DAAD"
var wallet = new ethers.Wallet(privateKey,provider);

var contract = new ethers.Contract(addressContract,abi,wallet);

let overrides = {
    // The maximum units of gas for the transaction to use
    gasLimit: 625000
}

// var vSender = [["0x02063a81fb6c8269ab6175f0cda21da7126186336e4ccb9212bea2a7f91f124f", "0x2738baee46bd09ca0d1a731da5798f8429d0b32f9880553ccad68b7996d1e82a"],[["0x25d4b24ad5306aaabad209f86e59c70ad6f9aa394a2d19dd9bbf0a77b1076f49", "0x1bbd87820d15e15782917bdad10ccf3253562a2a3e064f021ba1526e3697aad0"],["0x025cae085ca5a62dff7101afb55041f5fc83e4d177f6ded46b6c2564d6c4e37e", "0x12372b7d5757c26871e202b82a57c12dc45c6bcd8f4d03986b0ac00c1ca30c14"]],["0x21f16692f1d7560b221934076b4d9c504b436ccd9a61bc6ae07fd165157624fa", "0x13c41cd1c18fee688a9bb7b471121717b17bc7cf8d7d5ab5560b3592614a0741"],["0x06c21403ae2da0469f41827322f010fb3bcbdd888f004a70f6b0edb19b96fcd9"]];
// var vReceiver = [["0x19f23b4a9bc9aafe551322fd5320b6c7a384c6673e553cfa4d603a9b43568be7", "0x1a4e99262103b15d1f627003e4c9bf154e8b6196579cce7cf8648f949006bbaa"],[["0x118ff885da791ec76bb356300a48dd588e576b635383bc5347ed6108a16e7a5b", "0x001eb5705e337fd797e642aec592fabdc3596262bc9e66f92ab8f6f924e73ae1"],["0x26a0808f13ff0051b6e17a4ec4cf5b6f36756df1382b1eac3ca12af2241e6368", "0x2c3e986dff4f6ac7affb74e373c307b8114a57f0bf4bc8cbec17a3c1fa5986a0"]],["0x05c12562441fbfd1af107073ed1407c6c47e1011a78e65f3cec23c5d6a0f13ff", "0x058fcc192d2a82898a5ed51612dd598de31e6a9c17ab40432bea0feb54e71f11"],["0x03e6c0e50c3b31d9188922b3aad10b033f9fe3c1f183922f8d76d0dbbf488b0d"]];

function p256(n) {
    let nstr = n.toString(16);
    while (nstr.length < 64) nstr = "0"+nstr;
    nstr = `"0x${nstr}"`;
    return nstr;
}
function generatecall(proofName, publicName) {
    const public = unstringifyBigInts(publicName);
    const proof = unstringifyBigInts(proofName);

    let inputs = "";
    for (let i=0; i<public.length; i++) {
        if (inputs != "") inputs = inputs + ",";
        inputs = inputs + p256(public[i]);
    }

    let S = [];
    if ((typeof proof.protocol === "undefined") || (proof.protocol == "original")) {
        S=`[${p256(proof.pi_a[0])}, ${p256(proof.pi_a[1])}],` +
          `[${p256(proof.pi_ap[0])}, ${p256(proof.pi_ap[1])}],` +
          `[[${p256(proof.pi_b[0][1])}, ${p256(proof.pi_b[0][0])}],[${p256(proof.pi_b[1][1])}, ${p256(proof.pi_b[1][0])}]],` +
          `[${p256(proof.pi_bp[0])}, ${p256(proof.pi_bp[1])}],` +
          `[${p256(proof.pi_c[0])}, ${p256(proof.pi_c[1])}],` +
          `[${p256(proof.pi_cp[0])}, ${p256(proof.pi_cp[1])}],` +
          `[${p256(proof.pi_h[0])}, ${p256(proof.pi_h[1])}],` +
          `[${p256(proof.pi_kp[0])}, ${p256(proof.pi_kp[1])}],` +
          `[${inputs}]`;
    } else if ((proof.protocol == "groth")||(proof.protocol == "kimleeoh")) {
        S.push([`${p256(proof.pi_a[0])}`, `${p256(proof.pi_a[1])}`]);
        S.push([[`${p256(proof.pi_b[0][1])}`, `${p256(proof.pi_b[0][0])}`],[`${p256(proof.pi_b[1][1])}`, `${p256(proof.pi_b[1][0])}`]]) +
        S.push([`${p256(proof.pi_c[0])}`, `${p256(proof.pi_c[1])}`]) +
        S.push([`${inputs}`]);
    } else {
        throw new Error("InvalidProof");
    }

    return(S);
}


// var verifSender  = generatecall("./circuitTset/proof.json","./circuitTset/public.json");
// var verifReceiver = generatecall("./circuitTsetReceiver/proof.json","./circuitTsetReceiver/public.json");

function cleanCalls(vSender, vReceiver){
	function removeElts(str) {
		str = str.slice(1);
		str = str.slice(0,str.length-1);
		return str;
	}
	var len = vSender.length;
	for( var i =0; i< len; i++){
		if (i==3){
			vSender[i] = vSender[i].toString().split(",");
		}
		for( var j =0, c = vSender[i].length;j < c; j++){
			if(i == 1){
				for (var k=0, d = vSender[i][j].length;k<d;k++){
					vSender[i][j][k] = removeElts(vSender[i][j][k]);
				}
			}
			else {
				vSender[i][j] = removeElts(vSender[i][j]);
			}
		}
	}
	len = vReceiver.length;
	for( var i =0; i< len; i++){
		if (i == 3){
			vReceiver[i] = vReceiver[i].toString().split(",");
		}
		for( var j =0, c = vReceiver[i].length;j < c; j++){
			if(i == 1){
				for (var k=0, d = vReceiver[i][j].length;k<d;k++){
					vReceiver[i][j][k] = removeElts(vReceiver[i][j][k]);
				}
			}
			else {
				vReceiver[i][j] = removeElts(vReceiver[i][j]);
			}
		}
	}
}

// cleanCalls(verifSender,verifReceiver);
async function setVerifier(){
	await contract.setAddressVerif(addressVerifier).then(tx => console.log(tx));
}

async function interactWContract(){
    contract.name().then(res => console.log(res));
	contract.totalSupply().then(res => console.log(ethers.utils.formatUnits(res,0)));
	// contract.getAddressVerif().then(res => console.log(res))
    await contract.transferConfidentiel(verifSender,verifReceiver).then(res => console.log(res));
}

// interactWContract();

bob = "0x96d0B08E918D20B7Cc82729C18bF9934B235cA7e";

// PUBLIC FILES
var publicJsonReceiver = JSON.parse(fs.readFileSync("./circuitTsetReceiver/public.json","utf-8"));
var publicJsonSender = JSON.parse(fs.readFileSync("./circuitTset/public.json","utf-8"));
// PROOFS
var proofSender = JSON.parse(fs.readFileSync("./circuitTset/proof.json"));
var proofReceiver = JSON.parse(fs.readFileSync("./circuitTsetReceiver/proof.json"));

// hashValue25 = "4736446568872575060005712851072254579580333210376619673682138501339752681384";
// hashSenderBalanceAfter 

// , _hashValue, _hashSenderBalanceAfter, _hashReceiverBalanceAfter
async function transfer(_to, _hashValues){

	// var hashSenderBalanceBefore = contrat.getBalanceHash(wallet.address);
	// var hashReceiverBalanceBefore = contrat.getBalanceHash(_to);
	var hashSenderBalanceAfter = publicJsonSender[2];
	var hashReceiverBalanceAfter = publicJsonReceiver[2];
	
	var verifSender= generatecall(proofSender, publicJsonSender);
	var verifReceiver= generatecall(proofReceiver, publicJsonReceiver);
	cleanCalls(verifSender,verifReceiver);
	// contract.totalSupply().then(res => console.log(ethers.utils.formatUnits(res,0)));

	await contract.transferConfidentiel(_to, hashSenderBalanceAfter, hashReceiverBalanceAfter,
		verifSender, verifReceiver).then(res => console.log(res));
}

transfer(bob, publicJsonSender[1]);