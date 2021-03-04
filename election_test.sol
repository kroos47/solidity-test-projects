pragma solidity 0.5.0;
contract simpleElection{
    struct Candidate{
        uint256 id;
        string name;
        uint256 voteCount;
    }
    
        
    
    struct Voter{
        string namaye;
        address voterId;
        bool voted;
        
    }
    
    Candidate[] public candidates;
    mapping(address=>Voter) public voters;
    uint256 candidateCount=0;
    
    
    
    function addCandidate(string memory _name) public {
        candidateCount++;
        candidates.push(Candidate({id:candidateCount,name:_name,voteCount:0}));
    }
    
    function castVote(string memory to_,uint _id) public{
        require(voters[msg.sender].voted==false);
        voters[msg.sender].voted=true;
        candidates[_id].voteCount++;
        voters[msg.sender].namaye=to_;
    }
    
    
    
    
}