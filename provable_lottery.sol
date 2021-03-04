pragma solidity 0.5.8;
//import "github.com/oraclize/ethereum-api/oraclizeAPI_0.4.sol";
//import "./oracle.sol";
//import "github.com/provable-things/ethereum-api/provableAPI.sol";
import "https://github.com/provable-things/ethereum-api/blob/master/provableAPI_0.5.sol";
//import "./oracle2.sol";
contract Lottery is  usingProvable{
uint public randomNumber;
struct Users{
    address player;
    uint8 no1;
    uint8 no2;
    uint8 no3;
    uint8 no4;
    uint8 no5;
    uint8 no6;
    uint8 payout;
}
Users[] users;
uint8 numberOfOwners;
address[] owners;
uint count =0;
uint[] winnerlog;
mapping(address => bool) public multiMap;
mapping(address => bool) public trueOwner;
uint height =0;
uint splitValue =1000;
uint8 multiflag = 0;
uint multitime = block.timestamp;
address payable owner;
address flagged;
event Logging(string s);
bool waiting=false;
uint newRandom;
uint8 upperLimit = 22;
uint8 lowerLimit = 10;
uint8 powerBall =7;
uint  winner = 0;
uint8 i;
uint val = 100000000000000000;
uint256 constant MAX_INT_FROM_BYTE = 256;
uint256 constant NUM_RANDOM_BYTES_REQUESTED = 7;
//uint winNum[6];
uint[] public winNum = new uint[](5);

    event LogNewProvableQuery(string description);
    event generatedRandomNumber(uint256 randomNumber);

 modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
modifier multiOwnerUnlock {
    require(multiflag == 2 && multiMap[msg.sender] == true);
    _;
}


constructor()payable public {
    owner = msg.sender;
    multiMap[owner] = true;
    trueOwner[owner]=true;
    owners.push(owner);
    numberOfOwners =1;
    provable_setProof(proofType_Ledger);
        //update();
//oraclize_setProof(proofType_Ledger);
}

function setOwner(address _newOwner)external onlyOwner {
    require(_newOwner != owner);
    owners.push(_newOwner);
    multiMap[_newOwner] = true;
    numberOfOwners++;
}

function deleteOwner(address _toDelete)external onlyOwner{
    require(_toDelete != owner, "cannot delete main owner, please change main owner and then delete");
    uint len=owners.length;
    for(uint8 i=0;i<len;i++){
        if(owners[i] == _toDelete){
            delete owners[i];
            if(i!=(len -1)){
                owners[i]=owners[len -1];
                delete owners[len -1];
                delete multiMap[_toDelete];
                len--;
                i--;
                
            }
            else {
                len--;
            }
        }
    }
}

function returnOwners() external view returns(address []memory){
    return (owners);
}

function play(uint8 _no1,uint8 _no2,uint8 _no3,uint8 _no4,uint8 _no5,uint8 _no6) public payable {
                require (msg.value == val);
                require (waiting == false);
                if(count >= height)
                {
                    users.push(Users(msg.sender,_no1,_no2,_no3,_no4,_no5,_no6,0));
                    count++;
                    height++;
                }
                else
                {
                users[count].player=msg.sender;
                users[count].no1=_no1;
                users[count].no2=_no2;
                users[count].no3=_no3;
                users[count].no4=_no4;
                users[count].no5=_no5;
                users[count].no6=_no6;
                users[count].payout=0;
                count++;
    }
}

function startstop(bool _waiting) external multiOwnerUnlock {
    waiting = _waiting;
   
}

function changeSPlitValue(uint _splitValue) external multiOwnerUnlock {
    splitValue = _splitValue;
   
}


function getwaiting() external view returns(bool){
        return(waiting);
}

function checkRandom()external view returns(string memory){
    return uintToStr(randomNumber);
}

      function counter() external view returns(uint){
        return(count);
    }
   
   
     function see_amount() external view returns(uint){
        return((address(this).balance));
    }
    
    
    function knowvalue() external view returns(uint) {
        return val;
        }

         function ownerCheck() external view returns(bool){
       if(msg.sender == owner){
           return true;
       }
       else
            return false;
       
    }


function updaterules(uint _val, uint8 _upperLimit,uint8 _lowerLimit,uint8 _powerBall) external multiOwnerUnlock returns (bool) {
    if(_powerBall != 0)
        powerBall = _powerBall;
    if(_lowerLimit != 0)
        lowerLimit=_lowerLimit;
    if(_val != 0)
        val = _val;
    if(_upperLimit != 0)
        upperLimit=_upperLimit;
    return true;
}

        
function returnplayers() external view returns(address[]memory,uint[]memory,uint[]memory,uint[]memory,uint[]memory,uint[]memory,uint[]memory) {
        
        address[] memory addrs = new address[](count);
        uint[]   memory balls_a = new uint[](count);
        uint[]   memory balls_b = new uint[](count);
        uint[]   memory balls_c = new uint[](count);
        uint[]   memory balls_d = new uint[](count);
        uint[]   memory balls_e = new uint[](count);
        uint[]   memory balls_mega = new uint[](count);
        
        for (uint i = 0; i < count; i++) {
            Users memory user = users[i];
            addrs[i] = user.player;
            balls_a[i] = user.no1;
            balls_b[i] = user.no2;
            balls_c[i] = user.no3;
            balls_d[i] = user.no4;
            balls_e[i] = user.no5;
            balls_mega[i] = user.no6;
        }
        
        return (addrs, balls_a, balls_b, balls_c, balls_d, balls_e, balls_mega);
}
    
    

    function checkWinningNumbers() external view returns(string memory){
        return uintToStr(winner);
    }
    
    function split()external {
    require(randomNumber != 0);
    uint temp;
    for(uint8 i=0;i<5;i++){
        temp = randomNumber%splitValue;
        if(temp < 22){
            temp = temp + 22;
        }
        winNum[i]= temp;
        randomNumber = randomNumber/splitValue;
    }
}
    
    function getWinningNumbers() external  returns(uint){
        
        require(randomNumber != 0);
        require(winNum[0] != 0);
        
        for(i=0;i<5;i++){
            newRandom=winNum[i];
            while(newRandom>lowerLimit){
                if(newRandom<=upperLimit){
                    winner=(winner*100)+newRandom;
                    break;
                }
                else{
                    newRandom=newRandom%upperLimit;
                    if(newRandom<lowerLimit){
                        newRandom=newRandom+lowerLimit;
                    }
                }
            }
        }
            // for(i=0;i<5;i++){
                
                
            //     if(newRandom>lowerLimit && newRandom<=upperLimit){
            //     winner=(winner*100)+newRandom;
            //     i++;
            //     newRandom = winNum[i];
            //     }
            //     else{
            //         newRandom=newRandom%upperLimit;
            //         newRandom=newRandom+lowerLimit;
            //     }
            // }
            winner=(winner*10)+((winNum[0]%powerBall)+1);
            return winner;
        }
    
  function payWinners(uint _prize,address payable _winner,uint8 _index) external payable multiOwnerUnlock returns(bool){
      if(users[_index].payout == 0){
        _winner.transfer(_prize);
        users[_index].payout = 1;
        return true;
        }
        else
            return false;
        
  }
    
   function reset() external payable {//add multiOwnerUnlock here
        winnerlog.push(winner);
        count = 0;
        winner =0;
        multiflag =0;
        randomNumber =0;
        winNum = [0,0,0,0,0];
        owner.transfer(address(this).balance);
    }

     //new function
    function unlock()external {
    if(multiflag == 1 && (block.timestamp-multitime <600) && multiMap[msg.sender] == true && msg.sender!= flagged){
         multiflag = 2;
    }
    else if(multiflag == 1 && (block.timestamp-multitime >600) && multiMap[msg.sender] == true && msg.sender!= flagged){
         multiflag = 0;
         //delete flagged;
    }
    else if(multiflag == 0 && multiMap[msg.sender] == true){
        multiflag = 1;
        multitime=block.timestamp;
        flagged = msg.sender;
    }
     else if(multiflag == 1  &&  msg.sender == flagged || multiflag == 1  && multiMap[msg.sender] != true ){
        multiflag = 0;
}
else if(multiflag == 2){
    multiflag =0;
}
}

function checkLock()external view returns(bool) {
    if(multiflag == 2)
    {
        return true;
    }
    else{
        return false;
}
}


function uintToStr(uint _i) internal pure returns (string memory _uintAsString) {
        uint number = _i;
        if (number == 0) {
            return "0";
        }
        uint j = number;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (number != 0) {
            bstr[k--] = byte(uint8(48 + number % 10));
            number /= 10;
        }
        return string(bstr);
    }
//___________________________________________________________________________\\
//oraclize functions

function __callback(
        bytes32 _queryId,
        string memory _result,
        bytes memory _proof
    )
        public
    {
        require(msg.sender == provable_cbAddress());

        if (
            provable_randomDS_proofVerify__returnCode(
                _queryId,
                _result,
                _proof
            ) != 0
        ) {
            /**
             * @notice  The proof verification has failed! Handle this case
             *          however you see fit.
             */
        } else {
            /**
             *
             * @notice  The proof verifiction has passed!
             *
             *          Let's convert the random bytes received from the query
             *          to a `uint256`.
             *
             *          To do so, We define the variable `ceiling`, where
             *          `ceiling - 1` is the highest `uint256` we want to get.
             *          The variable `ceiling` should never be greater than:
             *          `(MAX_INT_FROM_BYTE ^ NUM_RANDOM_BYTES_REQUESTED) - 1`.
             *
             *          By hashing the random bytes and casting them to a
             *          `uint256` we can then modulo that number by our ceiling
             *          in order to get a random number within the desired
             *          range of [0, ceiling - 1].
             *
             */
            uint256 ceiling = (MAX_INT_FROM_BYTE ** NUM_RANDOM_BYTES_REQUESTED) - 1;
            randomNumber = uint256(keccak256(abi.encodePacked(_result))) % ceiling;
            emit generatedRandomNumber(randomNumber);
        }
    }
    

    function update()
        payable
        public
    {
        uint256 QUERY_EXECUTION_DELAY = 0;
        uint256 GAS_FOR_CALLBACK = 200000;
        provable_newRandomDSQuery(
            QUERY_EXECUTION_DELAY,
            NUM_RANDOM_BYTES_REQUESTED,
            GAS_FOR_CALLBACK
        );
        emit LogNewProvableQuery("Provable query was sent, standing by for the answer...");
    }

}