pragma solidity >=0.4.0 <0.7.0;


import "node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "./verifier.sol";

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
    address addressVerifier;
    function setAddressVerif(address _addressVerif) external {
        addressVerifier = _addressVerif;
    }

    function callVerifier(uint[2] memory a,uint[2][2] memory b,uint[2] memory c,uint[1] memory input, uint personne) private view returns(bool) {
        InterfaceVerifier v = InterfaceVerifier(addressVerifier);
        if(personne == 1){
            return v.verifyProofSender(a,b,c,input);
        }
        if(personne == 2){
            return v.verifyProofReceiver(a,b,c,input);
        }
    }


    // function transfer(address _to, bytes32 hashValue, bytes32 hashSenderBalanceAfter, bytes32 hashReceiverBalanceAfter,
    //     bytes zkProofSender, bytes zkProofReceiver) public

    function transfer(address _to, bytes32 hashValue, bytes32 hashSenderBalanceAfter, bytes32 hashReceiverBalanceAfter,
        uint[2] memory a,uint[2][2] memory b,uint[2] memory c,uint[1] memory input)
        public returns(bool r)
    {
        // bytes32 hashSenderBalanceBefore = balanceHashes[msg.sender];
        // bytes32 hashReceiverBalanceBefore = balanceHashes[_to];

        bool senderProofIsCorrect = callVerifier(a,b,c,input,1);
        bool receiverProofIsCorrect = callVerifier(a,b,c,input,2);

        r = false;

        if(senderProofIsCorrect && receiverProofIsCorrect){
            balanceHashes[msg.sender] = hashSenderBalanceAfter;
            balanceHashes[_to] = hashReceiverBalanceAfter;

            r = true;
        }
        return r;
    }



}





// METAMASK:
// sheriff token scene pond roof diet gain ship gossip carbon detail tribe