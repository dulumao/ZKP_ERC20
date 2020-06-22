pragma solidity ^0.6.0;


import "node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract myToken is ERC20 {

    string public _name = "NomDuToken";
    string public _symbol = "NDT";
    uint8 public _decimals = 2;
    uint public _INITIAL_SUPPLY = 12000000;

    //Mapping des hash des balances au lieu des montants
    mapping (address => bytes32) balanceHashes;

    constructor() public ERC20(_name,_symbol,_decimals){
    _mint(msg.sender, _INITIAL_SUPPLY);
    }


    // IL FAUT APPELER LES FONCTIONS DU CONTRAT VERIFIER.SOL
    
    // function transfer(address _to, bytes32 hashValue, bytes32 hashSenderBalanceAfter, bytes32 hashReceiverBalanceAfter,
    //     bytes zkProofSender, bytes zkProofReceiver) public
    // {
    //     bytes32 hashSenderBalanceBefore = balanceHashes[msg.sender];
    //     bytes32 hashReceiverBalanceBefore = balanceHashes[_to];

    //     bool senderProofIsCorrect = zksnarkverify(confTxSenderVk, [hashSenderBalanceBefore, hashSenderBalanceAfter, hashValue], zkProofSender);

    //     bool receiverProofIsCorrect = zksnarkverify(confTxReceiverVk,
    //         [hashReceiverBalanceBefore, hashReceiverBalanceAfter, hashValue], zkProofReceiver);

    //     if(senderProofIsCorrect && receiverProofIsCorrect) {
    //         balanceHashes[msg.sender] = hashSenderBalanceAfter;
    //         balanceHashes[_to] = hashReceiverBalanceAfter;
    //     }
    // }

}





// METAMASK:
// sheriff token scene pond roof diet gain ship gossip carbon detail tribe