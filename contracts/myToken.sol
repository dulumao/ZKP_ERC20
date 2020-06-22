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
    // // sender:
    // // w = (startingBalance, TxValue)
    // // x = (hash(StartingBalance),hash(EndingBalance),hash(TxValue))
    // //PrivateInputSender
    // struct PrInputS {
    //     uint256 senderBalanceBefore;
    //     uint256 value;
    // }
    // //PublicInputSender
    // struct  PubInputS {
    //     bytes32 hashValue;
    //     bytes32 hashSenderBalanceBefore;
    //     bytes32 hashSenderBalanceAfter;
    // }
    // function toBytes(uint256 x) internal pure returns (bytes memory b) {
    //     b = new bytes(32);
    //     for (uint i = 0; i < 32; i++) {
    //         b[i] = byte(uint8(x / (2**(8*(31 - i)))));
    //     }
    // }
    // //PrivateInputReceiver
    // struct PrInputR {
    //     uint256 receiverBalanceBefore;
    //     uint256 value;
    // }
    // //PublicInputReceiver
    // struct  PubInputR {
    //     bytes32 hashValue;
    //     bytes32 hashReceiverBalanceBefore;
    //     bytes32 hashReceiverBalanceAfter;
    // }


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