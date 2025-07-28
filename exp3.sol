// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract Election
{
    struct Candidate
    {
        uint id;
        string name;
        uint voteCount;
    }

    bool goingon = true;
    mapping(address => bool) public voters;
    mapping(uint => Candidate) public candidates;
    uint public candidatesCount;

    event votedEvent ( uint indexed _candidateId);

    constructor ()
    {
        addCandidate("Bob");
        addCandidate("Allice");
        addCandidate("Pranali");
    }

    function addCandidate (string memory _name) private
    {
        candidatesCount ++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function END () public
    {
        goingon = false;
    }

    function VOTE (uint _candidateId) public
    {
        require(!voters[msg.sender],"Already voted");
        require(_candidateId>0 && _candidateId<=candidatesCount,"Invalid candidate");
        require(goingon,"Election ended");

        voters[msg.sender] = true;

        candidates[_candidateId].voteCount ++;

        emit votedEvent(_candidateId);
    }

    function getVotesByName(string memory _name) public view returns (uint) {
        for (uint i = 1; i <= candidatesCount; i++) {
            if (keccak256(bytes(candidates[i].name)) == keccak256(bytes(_name))) {
                return candidates[i].voteCount;
            }
        }
        return 0; 
    }

}
