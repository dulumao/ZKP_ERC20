const myToken = artifacts.require('myToken');

contracts('myToken', accounts =>{
    const _name = 'MECKER';
    const _symbol = "MKR";
    const _decimals = 2;
    
    it('should have the good name', () =>
    myToken.deployed()
        .then(instance => instance.name())
        .then(nom => {
            assert.equal(nom,_name,'pas le bon nom')
        })
    )

})
