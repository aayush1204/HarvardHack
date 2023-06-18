pragma solidity >=0.8.2 <0.9.0;
import "hardhat/console.sol";


contract IdentityValidationCaller {
    IdentityStorage public identityStorageContract;
    IdentityValidation public identityValidationContract;
    
    constructor(address _identityStorageContractAddress, address _identityValidationContractAddress) {
        identityStorageContract = IdentityStorage(_identityStorageContractAddress);
        identityValidationContract = IdentityValidation(_identityValidationContractAddress);
    }
    
    function callValidateIdentity() public {
        (
            bytes32 storedNameHash,
            bytes32 storedDateOfBirthHash,
            bytes32 storedEmailHash,
            bytes32 storedWordPhrasesHash,
            bytes32 storedEncryptedValueHash
        ) = identityStorageContract.getIdentity();
        
        // Convert bytes32 values to string
        string memory name = bytes32ToString(storedNameHash);
        string memory dateOfBirth = bytes32ToString(storedDateOfBirthHash);
        string memory email = bytes32ToString(storedEmailHash);
        string memory wordPhrases = bytes32ToString(storedWordPhrasesHash);
        string memory encryptedValue = bytes32ToString(storedEncryptedValueHash);
        
        identityValidationContract.validateIdentity(name, dateOfBirth, email, wordPhrases, encryptedValue, 0);
    }
    
    // Helper function to convert bytes32 to string
    function bytes32ToString(bytes32 value) private pure returns (string memory) {
        bytes memory bytesData = new bytes(32);
        for (uint256 i = 0; i < 32; i++) {
            bytesData[i] = value[i];
        }
        return string(bytesData);
    }
}