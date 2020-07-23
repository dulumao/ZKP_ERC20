### ERC20 ZKP

## PROGRAMME NON FONCTIONNEL

##### Prérequis:

- git

- node v14

  ```
  npm install -g circom@latest
  npm install -g snarkjs@latest
  ```

Repo of the great library snarkjs: https://github.com/iden3/snarkjs

and circom: https://github.com/iden3/circom



Le fichier public.json contient:

- hash solde de départ
- hash valeur du transfert
- hash solde d'arrivée

Le fichier input.json contient:

- solde de départ
- valeur du transfert

Le transfert de fond est collaboratif, les deux parties ont des actions à réaliser. Ils doivent se communiquer la valeur du transfert et doivent publier le hash de leur solde d'arrivée, le hash du solde de départ étant normalement accessible à travers la fonction du smart-contract "getBalanceHash".

Il faudrait rendre la fonction native ERC20 "balanceOf" inaccessible sauf à l'utilisateur.

Comment cacher les sections en clair de cette page: https://rinkeby.etherscan.io/tx/0xf5800405c2b9d9c9ffe1948f39980990510e4234fadf6db48b4e7cc19fbdc62e#statechange ? On voit toujours le solde avant et après, on peut donc savoir le montant de la transaction. Soit on ajoute de la cryptographie pour cacher les soldes mais alors à quoi ça sert d'avoir et les soldes encryptés et les hashs sur la blockchain, autant en ne garder qu'un des deux. Soit on stocke les soldes on dehors de la chaîne mais s'il y a un bug et que les soldes sont modifiés on ne peut plus accéder aux données on-chain.

Par rapport à la fonction confidentialTransfer, si les soldes sont stockés off-chain il faut entrer les hashs "après-transaction" en paramètre de la fonction et écrire: _balancesHashes[addr] = hashAddrAfterTx 