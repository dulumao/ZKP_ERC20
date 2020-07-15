pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./ERC20.sol";
import "./verifier.sol";

/** @title myToken  */
contract myToken is ERC20{

    string private _name = "NomDuToken";
    string private _symbol = "NDT";
    uint8 private _decimals = 2;
    uint private _INITIAL_SUPPLY = 12000000;

    /** @dev constructor calling ERC20 constructor*/
    constructor() public ERC20(_name,_symbol,_decimals){
        _mint(msg.sender, _INITIAL_SUPPLY);
    }
    
    
    // IL FAUT APPELER LES FONCTIONS DU CONTRAT VERIFIER.SOL
    address addressVerifier;

    /**@param _addressVerif, address of the verifier */
    function setAddressVerif(address _addressVerif) public {
        addressVerifier = _addressVerif;
    }

    /** @return adr , address of the verifier, not a really useful function*/
    function getAddressVerif() public view returns(address adr){
        return addressVerifier;
    }

    /**@param a, b, c, input, data returned by the snarkjs function "generatecall"
    * @param personne, 1 or 2 <=> sender or verifier, inputs are differents
    */
    function callVerifier(uint[2] memory a,uint[2][2] memory b,uint[2] memory c,uint[3] memory input, uint personne) private view returns(bool) {
        InterfaceVerifier v = InterfaceVerifier(addressVerifier);
        if(personne == 1){
            return v.verifyProofSender(a,b,c,input);
        }
        if(personne == 2){
            return v.verifyProofReceiver(a,b,c,input);
        }
    }

    /**
    @dev using a struct for the parameters of the callVerifier function is more convenient */
    struct VerifParameters {
        uint[2] a;
        uint[2][2] b;
        uint[2] c;
        uint[3] input;
    }

    /**
    * @param _addr , address to return the balance's hash from
    * @return bytes32 balance's mimc hash
    */
    function getBalanceHash(address _addr) public view returns (bytes32){
        return balanceHashes[_addr];
    }

    /**
    @dev confidential transaction, there should be an interaction between the two parties
    @param _to, address of the receiver,
    @param hashSenderBalanceAfter, hashReceiverBalanceAfter
    @param vSender, vReceiver: two VerifParameters objects, they are used for the zkp approval
    @return val , transaction ok/not ok */
    function transferConfidentiel(address _to, bytes32 hashSenderBalanceAfter, bytes32 hashReceiverBalanceAfter,
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

// METAMASK:
// sheriff token scene pond roof diet gain ship gossip carbon detail tribe