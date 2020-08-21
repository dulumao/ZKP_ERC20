### ERC20 ZKP

## PROGRAMME NON FONCTIONNEL



Liste de ressources utiles pour la compréhension notamment sur théorie:

https://github.com/matter-labs/awesome-zero-knowledge-proofs



Programme insipré de cet article de Consensys: https://media.consensys.net/introduction-to-zksnarks-with-examples-3283b554fc3b



##### Prérequis:

- git

- node v14

  ```
  npm install -g circom@latest
  npm install -g snarkjs@latest
  ```

Repo of the library snarkjs: https://github.com/iden3/snarkjs

and circom: https://github.com/iden3/circom



En plus du contrat principal [myToken](https://github.com/AntoineMkr/ZKP_ERC20/blob/master/contracts/myToken.sol), j'ai modifié un peu le code du contrat [ERC20](https://github.com/AntoineMkr/ZKP_ERC20/blob/master/contracts/ERC20.sol) d'OpenZeppelin. J'ai aussi modifié le contrat "verifier.sol" pour qu'il puisse vérifier les preuves du sender et du receiver.

Le dossier PTAU contient la cérémonie PowersOfTau.

Il devrait noramlement être nécessaire de cloner le répo circomlib: https://github.com/iden3/circomlib. Celui ci contient des cricuits pré-conçus par l'équipe de Circom.

Le dossier scipts contient: 

- app.html (ce fichier aurait été utilisé pour créer une interface graphique web)
- genContract.js, utilisé pour publier le contrat mimc qui n'est finalement pas utilisé.
- mimc7.js, implémentation du hash mimc. Le code provient de circomlib.
- script.js, me sert à interagir avec le contrat.

Le dossier migrations contient des scripts migrations générés par Truffle. J'ai commencé à créer le projet en utilisant Truffle mais je ne l'utilise plus. Remix m'a paru bien plus pratique.

Les dossiers circuitReceiver/Sender contiennent tous les fichiers générés pas snarkjs ainsi que les circuits créés en utilisant circom.

Le fichier public.json contient:

- hash solde de départ
- hash valeur du transfert
- hash solde d'arrivée

Le fichier input.json contient:

- solde de départ
- valeur du transfert

Le transfert de fond est collaboratif, les deux parties ont des actions à réaliser. Ils doivent se communiquer la valeur du transfert et doivent publier le hash de leur solde d'arrivée, le hash du solde de départ étant normalement accessible à travers la fonction du smart-contract "getBalanceHash".

Il faudrait rendre la fonction native ERC20 "balanceOf" inaccessible sauf à l'utilisateur. (require(msg.sender == adresseEnParametre))

Comment cacher les sections en clair de cette page: https://rinkeby.etherscan.io/tx/0xf5800405c2b9d9c9ffe1948f39980990510e4234fadf6db48b4e7cc19fbdc62e#statechange ? On voit toujours le solde avant et après, on peut donc savoir le montant de la transaction. Soit on ajoute de la cryptographie pour cacher les soldes mais alors à quoi ça sert d'avoir et les soldes encryptés et les hashs sur la blockchain, autant en ne garder qu'un des deux. Soit on stocke les soldes on dehors de la chaîne mais s'il y a un bug et que les soldes sont modifiés on ne peut plus accéder aux données on-chain. Pourquoi pas créer un second token par dessus comme sur-couche.

Par rapport à la fonction confidentialTransfer, si les soldes sont stockés off-chain il faut entrer les hashs "après-transaction" en paramètre de la fonction et écrire: _balancesHashes[addr] = hashBalanceAfterTx 