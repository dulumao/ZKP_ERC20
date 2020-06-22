const Migrations = artifacts.require("myToken");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
