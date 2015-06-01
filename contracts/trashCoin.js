
// reference:
// https://dappsforbeginners.wordpress.com/tutorials/your-first-dapp/

contract trashCoin {
  mapping (address => uint) balances;
  address createdBy;

  function trashCoin() {
    createdBy            = msg.sender;
    balances[msg.sender] = 10000;
  }

  function sendCoin(address receiver, uint amount) returns (bool isEnough) {
    if (balances[msg.sender] < amount) {
      return false;
    }
    balances[msg.sender] -= amount;
    balances[receiver]   += amount;
    return true;
  }
   
  function checkBalance(address account) returns (uint balance) {
    return balances[account];
  }
  
  function returnCoins() {
    if (msg.sender != createdBy) {
      balances[createdBy] += balances[msg.sender];
      balances[msg.sender] = 0;
    }
  }
  
}
