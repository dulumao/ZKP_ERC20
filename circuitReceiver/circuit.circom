 
include "../circomlib/circuits/sha256/sha256.circom"
include "../circomlib/circuits/bitify.circom"
include "../circomlib/circuits/mimc.circom"
include "../circomlib/circuits/comparators.circom"

template SenderFunction(){

    //Entrees, valeur du transfert et solde de l'envoyeur
    signal private input senderBalanceBefore;
    signal private input value;
    //sortie hash(balance, valeur, balance après transfert)
    signal output out;

    //Hash MiMC, code dispo dans ./circomlib/circuits/mimc.circom
    // prends en paramètres le nombre d'entrées et le nombre de "rounds" cryptographiques
    component mimc = MultiMiMC7(3,91){
        mimc.in[0] <== senderBalanceBefore;
        mimc.in[1] <== value;
        mimc.in[2] <== senderBalanceBefore - value;
        //Quelle valeur pour k ?
        //k est la cle cryptograhique
        mimc.k <== 2;
    }

    //check Balance >= valeur du transfert
    component valueOK = LessEqThan(10){
        valueOK.in[0] <== value;
        valueOK.in[1] <== senderBalanceBefore;
    }
    // True ou False
    valueOK.out === 1;
    //Hash de sortie
    mimc.out ==> out;
}

template ReceiverFunction(){

    //Entrees, valeur du transfert et solde du receveur
    signal private input startingBalance;
    signal private input value;
    //sortie hash(balance, valeur, balance après transfert)
    signal output out;

    //Hash MiMC, code dispo dans ./circomlib/circuits/mimc.circom
    // prends en paramètres le nombre d'entrées et le nombre de "rounds" cryptographiques
    component mimc = MultiMiMC7(3,91){
        mimc.in[0] <== startingBalance;
        mimc.in[1] <== value;
        mimc.in[2] <== startingBalance + value;
        //Quelle valeur pour k ?
        //k est la cle cryptograhique
        mimc.k <== 2;
    }
    //Hash de sortie
    mimc.out ==> out;
}

component main = ReceiverFunction();
