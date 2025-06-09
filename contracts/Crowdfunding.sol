// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CrowdFund {
    uint public campaignCount;

    struct Campaign {
        address payable creator;
        string title;
        string description;
        uint goal;
        uint deadline;
        uint amountRaised;
        bool withdrawn;
        mapping(address => uint) contributions;
    }
    
    mapping(uint => Campaign) public campaigns;

    event CampaignCreated(uint campaignId, address creator);
    event Contributed(uint campaignId, address contributor, uint amount);
    event FundsWithdrawn(uint campaignId);
    event Refunded(uint campaignId, address contributor, uint amount);

    modifier onlyCreator(uint _id) {
        require(msg.sender == campaigns[_id].creator, "Not campaign creator");
        _;
    }

    function createCampaign(string calldata _title, string calldata _desc, uint _goal, uint _duration) external {
        require(_goal > 0, "Goal must be greater than 0");
        require(_duration > 0, "Duration must be positive");

        campaignCount++;
        Campaign storage c = campaigns[campaignCount];
        c.creator = payable(msg.sender);
        c.title = _title;
        c.description = _desc;
        c.goal = _goal;
        c.deadline = block.timestamp + _duration;

        emit CampaignCreated(campaignCount, msg.sender);
    }

    function contribute(uint _id) external payable {
        Campaign storage c = campaigns[_id];
        require(block.timestamp < c.deadline, "Campaign ended");
        require(msg.value > 0, "Send some ETH");

        c.amountRaised += msg.value;
        c.contributions[msg.sender] += msg.value;

        emit Contributed(_id, msg.sender, msg.value);
    }

    function withdrawFunds(uint _id) external onlyCreator(_id) {
        Campaign storage c = campaigns[_id];
        require(block.timestamp >= c.deadline, "Wait until deadline");
        require(c.amountRaised >= c.goal, "Goal not reached");
        require(!c.withdrawn, "Already withdrawn");

        c.withdrawn = true;
        c.creator.transfer(c.amountRaised);

        emit FundsWithdrawn(_id);
    }

    function refund(uint _id) external {
        Campaign storage c = campaigns[_id];
        require(block.timestamp >= c.deadline, "Campaign still active");
        require(c.amountRaised < c.goal, "Goal met, cannot refund");

        uint contributed = c.contributions[msg.sender];
        require(contributed > 0, "No contributions");

        c.contributions[msg.sender] = 0;
        payable(msg.sender).transfer(contributed);

        emit Refunded(_id, msg.sender, contributed);
    }

    function getContribution(uint _id, address _user) external view returns (uint) {
        return campaigns[_id].contributions[_user];
    }
}