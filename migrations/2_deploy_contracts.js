const Crud = artifacts.require("UserCrud");
;

module.exports = function(deployer) {
  deployer.deploy(Crud);
 console.log("deployed successfully");
}