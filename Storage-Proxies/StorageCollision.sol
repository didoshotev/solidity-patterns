// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;

// 1. deploy LostStorage 
contract LostStorage {
    address public myAddress; // SLOT 0
    uint public myUint;       // SLOT 1

    function setAddress(address _address) public {
        myAddress = _address;
    }

    function setMyUint(uint _uint) public {
        myUint = _uint;
    }

}

// 2. deploy ProxyClash 
contract ProxyClash {
    address public otherContractAddress; // SLOT 0 - CLASH 

    constructor(address _otherContract) {
        otherContractAddress = _otherContract;
    }

    function setOtherAddress(address _otherContract) public {
        otherContractAddress = _otherContract;
    }

  fallback() external {
    address _impl = otherContractAddress;

    assembly {
      let ptr := mload(0x40)
      calldatacopy(ptr, 0, calldatasize())
      let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
      let size := returndatasize()
      returndatacopy(ptr, 0, size)

      switch result
      case 0 { revert(ptr, size) }
      default { return(ptr, size) }
    }
  }
}