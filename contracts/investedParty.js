
contract investedParty {

  struct Investor {
    address addr;
    uint    amount;
    // TODO: add dates: investedAt, investedUntil
    // TODO: return investment after investedUntil
  }

  struct Company {
    string32 dapp;
    address  creator;
    address  wallet;
    uint     amount;
    uint     numInvestors;
    mapping (uint => Investor) investors;
  }

  uint numCompanies;
  mapping (uint => Companies) companies;

  function newCompany(string32 dapp, address wallet) returns (uint companyID) {
    companyID    = numCompanies++;
    Company com  = companies[companyID];
    com.dapp     = dapp;
    com.creator  = msg.sender;
    com.wallet   = wallet;
  }

  function invest(uint companyID) {
    Company com  = companies[companyID];
    Investor inv = com.investors[com.numInvestors++];
    inv.addr     = msg.sender;
    inv.amount   = msg.value;
    com.amount  += msg.value;
  }

  function getCompany(unit companyID) returns (Company) {
    return companies[companyID];
  }

  function getInvestors(uint companyID) returns (mapping (uint=>Investor) investors) {
    return campaigns[campaignID].investors;
  }

}
