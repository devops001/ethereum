
contract investedParty {

  struct Investor {
    address addr;
    uint    amount;
  }

  struct Campaign {
    string32 name;
    address  creator;
    address  beneficiary;
    uint     goal;
    uint     amount;
    uint     numInvestors;
    bool     isGoalMet;
    mapping (uint => Investor) investors;
  }

  uint numCampaigns;
  mapping (uint => Campain) campaigns;

  function newCampaign(string32 name, address wallet, uint goal) returns (uint campaignID) {
    campaignID    = numCampaigns++;
    Campaign cam  = campaigns[id];
    cam.name      = name;
    cam.creator   = msg.sender;
    cam.wallet    = wallet;
    cam.goal      = goal;
    cam.isGoalMet = false;
  }

  function invest(uint campaignID) returns (bool isInvested) {
    Campaign cam = campaigns[campaignID];
    if (cam.isGoalMet) {
      return false;
    }
    Investor inv = cam.investors[cam.numInvestors++];
    inv.addr     = msg.sender;
    inv.amount   = msg.value;
    cam.amount  += msg.value;
    if (cam.amount >= cam.goal) {
      cam.isGoalMet = true;
    }
    return  true;
  }

  function isGoalMet(uint campaignID) returns (bool isGoalMet) {
    return campaigns[campaignID].isGoalMet;
  }

}
