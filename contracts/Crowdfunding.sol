// SPDX-License-Identifier: MIT
// author: achillegley
pragma solidity >=0.4.22 <0.9.0;

// Crowdfunding contract
contract Crowdfunding {
    // Address of the campaign organizer
    address payable public organizer;

    // Funding goal
    uint public goal;

    // Amount of funds raised
    uint public fundsRaised;

    // Deadline for the campaign
    uint public deadline;

    // Flag indicating whether the campaign is active
    bool public isActive;

    // Event for successful contribution
    event Contribution(address _contributor, uint _amount);

    // Constructor function to set up the campaign
    constructor(address payable _organizer, uint _goal, uint _deadline) {
        organizer = _organizer;
        goal = _goal;
        deadline = _deadline;
        isActive = true;
    }

    // Function to contribute funds to the campaign
    function contribute(uint _value) public payable {
        require(isActive, "Campaign is not active");
        require(block.timestamp <= deadline, "Campaign has expired");
        require(msg.value == _value, "Incorrect contribution amount");
        fundsRaised += _value;
        emit Contribution(msg.sender, _value);
    }

    // Function to refund a contributor
    function refund(address payable _contributor) public  payable{
        require(fundsRaised > 0, "No funds to refund");
        require(_contributor.balance >= msg.value, "Insufficient balance to refund");
        _contributor.transfer(msg.value);
    }

    // Function for the organizer to withdraw funds
    function withdraw() public {
        require(msg.sender == organizer, "Only the organizer can withdraw funds");
        require(fundsRaised >= goal, "Goal must be reached to withdraw funds");
        organizer.transfer(fundsRaised);
    }
}
