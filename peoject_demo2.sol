pragma solidity 0.5.0;
contract Project{
    struct Patient{
        
        uint256 patientId;
        string name;
        string doctorNotes;
        
    }
    
    struct Doctor{
        uint256 doctorId;
        string docName;
        string patientNotes;
    }
    
    Patient[] public patients;
    Doctor[] public doctors;
    address payable owner;

    modifier onlyOwner{
        require(msg.sender==owner);
        _;
    }
    
    constructor() public{
        owner=msg.sender;
    }
    
    uint256 docCount=0;
    uint256 patientCount=0;
    
    function addDoc(string memory _name) public onlyOwner{
        doctors.push(Doctor(docCount,_name,""));
    }
    
    function addPatient(string memory _name) public{
        patients.push(Patient(patientCount,_name,""));
    }
    
    function drNotes(uint256 _id,string memory _notes) public{
        doctors[_id].patientNotes=_notes;
    }
    
    
    
    
    
    
}