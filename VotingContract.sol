// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Voting {
    struct Vote {
        bool choice;
        bool voted;
    }

    struct Topic {
        string name;
        string description;
        bool open;
        mapping(address => Vote) votes;
        uint256 yesCount;
        uint256 noCount;
    }

    address public admin;
    ERC20 public token;
    mapping(uint256 => Topic) public topics;
    uint256 public nextTopicId;

    constructor(address _token) {
        admin = msg.sender;
        token = ERC20(_token);
    }

    function createTopic(string memory name, string memory description) external {
        require(msg.sender == admin, "only admin");

        Topic storage topic = topics[nextTopicId++];
        topic.name = name;
        topic.description = description;
        topic.open = true;
    }

    function vote(uint256 topicId, bool choice) external {
        Topic storage topic = topics[topicId];

        require(msg.sender != admin, "admin cannot vote");
        require(topic.open, "voting not open");

        Vote storage v = topic.votes[msg.sender];
        require(!v.voted, "already voted");

        v.choice = choice;
        v.voted = true;

        if (choice) {
            topic.yesCount++;
        } else {
            topic.noCount++;
        }
    }

    function closeVoting(uint256 topicId) external {
        require(msg.sender == admin, "only admin");
        
        Topic storage topic = topics[topicId];
        require(topic.open, "voting already closed");

        topic.open = false;

        // Rewarding logic goes here.
    }
}
