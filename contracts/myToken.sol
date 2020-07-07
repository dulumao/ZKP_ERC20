pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./ERC20.sol";
import "./verifier.sol";

contract myToken is ERC20 {

    string public _name = "NomDuToken";
    string public _symbol = "NDT";
    uint8 public _decimals = 2;
    uint public _INITIAL_SUPPLY = 12000000;

    //Mapping des hash des balances au lieu des montants
    mapping (address => string) balanceHashes;

    constructor() public ERC20(_name,_symbol,_decimals){
    _mint(msg.sender, _INITIAL_SUPPLY);
    }


    // IL FAUT APPELER LES FONCTIONS DU CONTRAT VERIFIER.SOL
    address addressVerifier;
    function setAddressVerif(address _addressVerif) public {
        addressVerifier = _addressVerif;
    }

    function getAddressVerif() public view returns(address adr){
        return addressVerifier;
    }

    function callVerifier(uint[2] memory a,uint[2][2] memory b,uint[2] memory c,uint[3] memory input, uint personne) private view returns(bool) {
        InterfaceVerifier v = InterfaceVerifier(addressVerifier);
        if(personne == 1){
            return v.verifyProofSender(a,b,c,input);
        }
        if(personne == 2){
            return v.verifyProofReceiver(a,b,c,input);
        }
    }

    //Déclaration des paramètres pour la fonction callVerifier(a,b,c,input)
    struct VerifParameters {
        uint[2] a;
        uint[2][2] b;
        uint[2] c;
        uint[3] input;
    }

    function getBalanceHash(address _addr) public view returns (string memory){
        return balanceHashes[_addr];
    }
    //  bool senderProofIsCorrect = zksnarkverify(confTxSenderVk, [hashSenderBalanceBefore, hashSenderBalanceAfter, hashValue], zkProofSender);
    // bool receiverProofIsCorrect = zksnarkverify(confTxReceiverVk, [hashReceiverBalanceBefore, hashReceiverBalanceAfter, hashValue], zkProofReceiver);
    /*function transferConfidentiel(address _to, bytes32 hashSenderBalanceAfter, bytes32 hashReceiverBalanceAfter,
        VerifParameters memory vSender, VerifParameters memory vReceiver)*/
    function transferConfidentiel(address _to, string memory hashSenderBalanceAfter, string memory hashReceiverBalanceAfter,
        VerifParameters memory vSender, VerifParameters memory vReceiver)
        public returns(bool val)
    {
        bool senderProofIsCorrect = callVerifier(vSender.a,vSender.b,vSender.c,vSender.input,1);
        bool receiverProofIsCorrect = callVerifier(vReceiver.a,vReceiver.b,vReceiver.c,vReceiver.input,2);

        val = false;
        if(senderProofIsCorrect && receiverProofIsCorrect){
            balanceHashes[msg.sender] = hashSenderBalanceAfter;
            balanceHashes[_to] = hashReceiverBalanceAfter;
            val = true;
        }
        return val;
    }

}
