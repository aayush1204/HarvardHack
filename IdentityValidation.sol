pragma solidity >=0.8.2 <0.9.0;
import "hardhat/console.sol";


contract IdentityValidation {
    IdentityStorage identityStorageContract; // Reference to the IdentityStorage contract
    mapping(uint256 => bool) public messages;
    uint256 public val;
    
    constructor(address _identityStorageContractAddress) {
        identityStorageContract = IdentityStorage(_identityStorageContractAddress);
    }

    function setMessage(uint256 id, bool message) public {
        messages[id] = message;
    }

    function validateIdentity(
        string memory _name,
        string memory _dateOfBirth,
        string memory _email,
        string memory _wordPhrases,
        string memory _encryptedValue,
        uint256 i
    ) external returns (uint256) {
        (
            bytes32 storedNameHash,
            bytes32 storedDateOfBirthHash,
            bytes32 storedEmailHash,
            bytes32 storedWordPhrasesHash,
            bytes32 storedEncryptedValueHash
        ) = identityStorageContract.getIdentity();

        uint256 nameScore = (_nameHash(_name) == storedNameHash) ? 20 : 0;
        uint256 dobScore = (_dateOfBirthHash(_dateOfBirth) == storedDateOfBirthHash) ? 20 : 0;
        uint256 emailScore = (_emailHash(_email) == storedEmailHash) ? 20 : 0;
        uint256 phraseScore = _wordPhraseScore(_wordPhrases, storedWordPhrasesHash);
        uint256 encryptedScore = _encryptedValueScore(_encryptedValue, storedEncryptedValueHash);
        setMessage(i,true);
        uint256 value = nameScore + dobScore + emailScore + phraseScore + encryptedScore;

        uint256 ans = value == 60 ? 0 : 1;
        
        
        val = 1;
        return ans;
    }

    

    function _nameHash(string memory _name) private pure returns (bytes32) {
        return keccak256(bytes(_name));
    }

    function _dateOfBirthHash(string memory _dateOfBirth) private pure returns (bytes32) {
        return keccak256(bytes(_dateOfBirth));
    }

    function _emailHash(string memory _email) private pure returns (bytes32) {
        return keccak256(bytes(_email));
    }

    function _wordPhrasesHash(string memory _wordPhrases) private pure returns (bytes32) {
        return keccak256(bytes(_wordPhrases));
    }

    function _encryptedValueHash(string memory _encryptedValue) private pure returns (bytes32) {
        return keccak256(bytes(_encryptedValue));
    }

    function _wordPhraseScore(string memory _inputPhrases, bytes32 _storedPhrasesHash) private pure returns (uint256) {
        uint256 ans = (_wordPhrasesHash(_inputPhrases) == _storedPhrasesHash) ? 1 : 0;
        return ans;
    }

    function _encryptedValueScore(string memory _inputValue, bytes32 _storedValueHash) private pure returns (uint256) {
        uint256 ans = (_encryptedValueHash(_inputValue) == _storedValueHash) ? 1 : 0;
        return ans;
    }
}

