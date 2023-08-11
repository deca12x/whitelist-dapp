// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Whitelist {
    uint8 public maxWhitelistedAddresses;
    uint8 public numWhitelistedAddresses;
    mapping(address => bool) public whitelistedAddresses;

    // Contract owner decides max number of whitelisted addresses
    constructor(uint8 _maxWhitelistedAddresses) {
        maxWhitelistedAddresses = _maxWhitelistedAddresses;
    }

    // Users call the function themselves - i.e. whitelist themselves on a first come first serve basis
    function addAddressToWhitelist() public {
        require(
            !whitelistedAddresses[msg.sender],
            "User has already been whitelisted"
        );
        require(
            numWhitelistedAddresses < maxWhitelistedAddresses,
            "More addresses cant be added, limit reached"
        );
        whitelistedAddresses[msg.sender] = true;
        numWhitelistedAddresses += 1;
    }
}
