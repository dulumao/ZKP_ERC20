 
include "../circomlib/circuits/sha256/sha256.circom"
include "../circomlib/circuits/sha256/sha256_2.circom"

include "../circomlib/circuits/bitify.circom"
include "../circomlib/circuits/mimc.circom"
include "../circomlib/circuits/comparators.circom"


template SenderFunction(){

    //Entrees, valeur du transfert et solde du receveur
    signal private input senderBalanceBefore;
    signal private input value;
    //sortie hash(balance, valeur, balance après transfert)
    signal output hashStartingBalance;
    signal output hashValue;
    signal output hashBalanceAfter;

    //Hash MiMC, code dispo dans ./circomlib/circuits/mimc.circom
    // prends en paramètres le nombre d'entrées et le nombre de "rounds" cryptographiques
    component mimc1 = MultiMiMC7(1,91){
        mimc1.in[0] <== senderBalanceBefore;
        //Quelle valeur pour k ?
        //k est la cle cryptograhique
        mimc1.k <== 2;
    }

    //check Balance >= valeur du transfert
    component valueOK = LessEqThan(10){
        valueOK.in[0] <== value;
        valueOK.in[1] <== senderBalanceBefore;
    }
    // True ou False
    valueOK.out === 1;

    component mimc2 = MultiMiMC7(1,91){
        mimc2.in[0] <== value;
        //Quelle valeur pour k ?
        //k est la cle cryptograhique
        mimc2.k <== 2;
    }
    component mimc3 = MultiMiMC7(1,91){
        mimc3.in[0] <== (senderBalanceBefore - value);
        //Quelle valeur pour k ?
        //k est la cle cryptograhique
        mimc3.k <== 2;
    }

    //Hash de sortie
    mimc1.out ==> hashStartingBalance;
    mimc2.out ==> hashValue;
    mimc3.out ==> hashBalanceAfter;
}

component main = SenderFunction();
