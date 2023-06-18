pragma solidity >=0.8.2 <0.9.0;
import "hardhat/console.sol";

contract IdentityStorage {
    struct Identity {
        bytes32 nameHash;
        bytes32 dateOfBirthHash;
        bytes32 emailHash;
        bytes32 wordPhrasesHash;
        bytes32 encryptedValueHash;
    }

    mapping(address => Identity) private identities;

    function storeIdentity(
        string memory _name,
        string memory _dateOfBirth,
        string memory _email,
        string memory _wordPhrases,
        string memory _encryptedValue
    ) public {
        identities[msg.sender] = Identity(
            _nameHash(_name),
            _dateOfBirthHash(_dateOfBirth),
            _emailHash(_email),
            _wordPhrasesHash(_wordPhrases),
            _encryptedValueHash(_encryptedValue)
        );
    }

    function getIdentity() public view returns (
        bytes32 nameHash,
        bytes32 dateOfBirthHash,
        bytes32 emailHash,
        bytes32 wordPhrasesHash,
        bytes32 encryptedValueHash
    ) {
        Identity storage identity = identities[msg.sender];
        return (
            identity.nameHash,
            identity.dateOfBirthHash,
            identity.emailHash,
            identity.wordPhrasesHash,
            identity.encryptedValueHash
        );
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
}


