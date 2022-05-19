//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

contract EternalStorage {
    mapping(bytes32 => uint) UIntStorage;
    mapping(bytes32 => bool) BooleanStorage;

    function getUIntValue(bytes32 record) public view returns(uint) { 
        return UIntStorage[record];
    }

    function setUIntValue(bytes32 record, uint newValue) external { 
        UIntStorage[record] = newValue;
    }

    function getBoolValue(bytes32 record) public view returns(bool) { 
        return BooleanStorage[record];
    }

    function setBooleanValue(bytes32 record, bool newValue) external { 
        BooleanStorage[record] = newValue;
    }
}

library ballotLib { 
    function getNumberOfVotes(address _eternalStorage) public view returns(uint) { 
        return EternalStorage(_eternalStorage).getUIntValue(keccak256("votes"));
    }

    function getUserHasVoted(address _eternalStorage) public view returns(bool) { 
        return EternalStorage(_eternalStorage).getBoolValue(keccak256(abi.encodePacked("voted", msg.sender)));
    }

    function setUserHasVoted(address _eternalStorage) public { 
        EternalStorage(_eternalStorage).setBooleanValue(keccak256(abi.encodePacked("voted", msg.sender)), true);
    }

    function setVoteCount(address _eternalStorage, uint _voteCount) public { 
        EternalStorage(_eternalStorage).setUIntValue(keccak256("votes"), _voteCount);
    }
}

contract Ballot { 
    using ballotLib for address;
    address eternalStorage;

    constructor(address _eternalStorage) { 
        eternalStorage = _eternalStorage;
    }

    function getNumberOfVotes() public view returns(uint) { 
        return eternalStorage.getNumberOfVotes();
    }

    function vote() public { 
        require(eternalStorage.getUserHasVoted() == false, "Sorry, you already voted!");
        eternalStorage.setUserHasVoted();
        eternalStorage.setVoteCount(eternalStorage.getNumberOfVotes() + 1);
    }

    function checkKeccakResult() public view returns(bytes32) { 
        return keccak256(abi.encodePacked(msg.sender));
    }
}