// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.11;

contract UserCrud {

  struct UserStruct {
    bytes32 userEmail;
    uint userAge;
    uint index;
  }

  address owner;

  constructor(){
      owner=msg.sender;
  }

  modifier onlyOwner{
      require(owner==msg.sender,"NOT THE CONTRACT OWNER!!");
      _;
  }
  
  mapping(address => UserStruct) private userStructs;
  address[] private userIndex;

  event LogNewUser   (address indexed userAddress, uint index, bytes32 userEmail, uint userAge);
  event LogUpdateUser(address indexed userAddress, uint index, bytes32 userEmail, uint userAge);
  event LogDeleteUser(address indexed userAddress, uint index);

  function isUser(address userAddress) public view returns(bool isIndeed) {
    if(userIndex.length == 0) return false;

    return (userIndex[userStructs[userAddress].index] == userAddress);
  }

  function insertUser( bytes32 userEmail, uint    userAge) public returns(uint index) {

     address userAddress=msg.sender;
    if(isUser(userAddress)) revert(); 
    userStructs[userAddress].userEmail = userEmail;
    userStructs[userAddress].userAge   = userAge;
    userIndex.push(userAddress);
    userStructs[userAddress].index     = userIndex.length-1;

    emit LogNewUser(
        userAddress, 
        userStructs[userAddress].index, 
        userEmail, 
        userAge);

    return userIndex.length-1;
  }
  
  
  
  function updateUserDetails(bytes32 userEmail, uint userAge ) public returns(bool success) {

      address userAddress=msg.sender;
    if(!isUser(userAddress)) revert(); 
    userStructs[userAddress].userEmail = userEmail;
     userStructs[userAddress].userAge = userAge;

    emit LogUpdateUser(
      userAddress, 
      userStructs[userAddress].index,
      userEmail, 
      userStructs[userAddress].userAge);

    return true;
  }

  function deleteUser(address userAddress) public onlyOwner returns(uint row){

    if(!isUser(userAddress)) revert(); 

    uint rowToDelete = userStructs[userAddress].index;
    address keyToMove = userIndex[userIndex.length-1];
    userIndex[rowToDelete] = keyToMove;
    userStructs[keyToMove].index = rowToDelete; 
    //userIndex.length--;
    userIndex.pop();
    emit LogDeleteUser(
        userAddress, 
        rowToDelete);

   emit  LogUpdateUser(
        keyToMove, 
        rowToDelete, 
        userStructs[keyToMove].userEmail, 
        userStructs[keyToMove].userAge);

    return rowToDelete;
  }

  function getUser(address userAddress) public  view returns(bytes32 userEmail, uint userAge, uint index) {
    if(!isUser(userAddress)) revert(); 
    return(
      userStructs[userAddress].userEmail, 
      userStructs[userAddress].userAge, 
      userStructs[userAddress].index);
  } 
  
  

  function getUserCount()   public  view  returns(uint count)  {
  
    return userIndex.length;
  }

  function getUserAtIndex(uint index)  public view returns(address userAddress){
  
    return userIndex[index];
  }

} 
