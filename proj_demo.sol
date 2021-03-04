pragma solidity 0.5.0;
contract Project{
    struct Patient{
        
        uint256 patientId;
        string name;
        string assgnDr;
        address patientAddress;
        string doctorNotes;
        
    }
    
    struct Doctor{
        uint256 doctorId;
        string docName;
        address doctorAddress;
        string patientNotes;
    }
    
    Patient[] public patients;
    Doctor[] public doctors;
    
    modifier onlyOwner{
        require(msg.sender==owner);
        _;
        
    }
    
    constructor() public {
        owner=msg.sender;
    
    }
    uint256 docCount=0;
    uint256 patientCount=0;
    
    function addDoc(string memory _name) public onlyOwner{
        for(uint256 i=0;i<=docCount;i++){
            if(doctors[i].doctorAddress==[msg.sender]){
                console.log("alrdy a Doctor");
                break;
            }
        }
            
         doctors.push(Doctor({doctorId:docCount,name:_name,doctorAddress:[msg.sender],doctorNotes:""}));
                docCount++;
            
    }
    
    function addPatient(string memory _name) public onlyOwner{
        for(uint256 i=0;i<patientCount;i++){
            if(patients[i].patientAddress==[msg.sender]){
                console.log("alrdy a patient");
                break;
            }
        }   
        patient.push(Patient({patientId:patientCount,docName:_name,assgnDr:"",doctorAddress:(msg.sender),patientNotes:""}));
        patientCount++;
    }
    
    function addDocNotes(string memory _notes) public{
        for(uint256 i=0;i<docCount;i++){
            if(msg.sender==doctors[i].doctorAddress){
                doctors[i].push(Doctor{patientNotes:_notes});
                patient[i].push(Patient({doctorNotes:_notes}));
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}