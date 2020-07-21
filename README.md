### ERC20 ZKP

Le fichier public.json contient:

- hash solde de départ
- hash valeur du transfert
- hash solde d'arrivée

Le fichier input.json contient:

- solde de départ
- valeur du transfert

Le transfert de fond est collaboratif, les deux parties ont des actions à réaliser. Ils doivent se communiquer la valeur du transfert et doivent publier le hash de leur solde d'arrivée, le hash du solde de départ étant normalement accessible à travers la fonction du smart-contract "getBalanceHash".


Il faudrait rendre la fonction native ERC20 "balanceOf" inaccessible sauf à l'utilisateur.

Comment cacher à tous les sections  et  de cette page: https://rinkeby.etherscan.io/tx/0xf5800405c2b9d9c9ffe1948f39980990510e4234fadf6db48b4e7cc19fbdc62e#statechange ? On voit toujours le solde avant et après.