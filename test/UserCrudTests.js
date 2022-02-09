const UserCrud = artifacts.require('./UserCrud.sol')
const assert = require('assert')
const truffleAssert = require('truffle-assertions');

let userCrud;

contract('UserCrud', (accounts) => {

    beforeEach(async () => {
        userCrud = await UserCrud.new()
    })

    it('UserCrud test', async () => {


        const userIndex = await userCrud.insertUser("0x7573657231407961686f6f2e636f6d0000000000000000000000000000000000", 25, { "from": accounts[0] });
       // console.log("user index:", userIndex);
       
       truffleAssert.eventEmitted(
            userIndex,
            "LogNewUser",
            (ev) => ev.userAge==25,
            "new user event should be triggered"
        );
       // assert.equal(userIndex, 0);




        const usercount = await userCrud.getUserCount();
        //console.log("usercount:", usercount);
        assert.equal(usercount, 1);

        const userdtls = await userCrud.getUser(accounts[0]);
       // console.log("userdtls.userEmail:", userdtls.userEmail);
       // console.log("userdtls.userAge:", userdtls.userAge);

        assert.equal(userdtls.userEmail, "0x7573657231407961686f6f2e636f6d0000000000000000000000000000000000");
        assert.equal(userdtls.userAge, 25);

        const userAddress = await userCrud.getUserAtIndex(0);
        //console.log("userAddress:", userAddress);
        assert.equal(userAddress, accounts[0]);



        const status = await userCrud.updateUserDetails("0x7573657231757064617465407961686f6f2e636f6d0000000000000000000000", 28);
        //assert.equal(status, "True");

        truffleAssert.eventEmitted(
            status,
            "LogUpdateUser",
            (ev) => ev.userAge==28,
            "update user event should be triggered"
        );

        const userIndexDel = await userCrud.deleteUser(accounts[0]);
       // assert.equal(userIndexDel, 0);
       truffleAssert.eventEmitted(
        userIndexDel,
        "LogDeleteUser",
        (ev) => ev.userAddress==accounts[0],
        "delete user event should be triggered"
    );

    
    })

}) 
