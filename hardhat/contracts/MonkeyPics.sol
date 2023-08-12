// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Whitelist.sol";

contract MonkeyPics is ERC721Enumerable, Ownable {
    uint256 public constant _price = 0.01 ether;
    uint256 public constant collectionSize = 20;
    Whitelist whitelist;
    uint256 public whitelistTokens;
    uint256 public whitelistClaimed = 0;

    constructor(address whitelistContract) ERC721("Monkey Pics", "MP") {
        whitelist = Whitelist(whitelistContract);
        whitelistTokens = whitelist.maxWhitelistedAddresses();
    }

    function mint() public payable {
        // Make sure NFts don't run out for whitelisted addresses
        require(
            totalSupply() + whitelistTokens - whitelistClaimed < collectionSize,
            "EXCEEDED_MAX_SUPPLY"
        );

        // If user is part of the whitelist, make sure there are still reserved tokens left
        if (whitelist.whitelistedAddresses(msg.sender) && msg.value < _price) {
            // Make sure user doesn't already own an NFT
            require(balanceOf(msg.sender) == 0, "ALREADY_OWNED");
            whitelistClaimed += 1;
        } else {
            // If user is not part of the whitelist, make sure they have sent enough ETH
            require(msg.value >= _price, "NOT_ENOUGH_ETHER");
        }
        uint256 tokenId = totalSupply();
        _safeMint(msg.sender, tokenId);
    }

    // withdraw sends all the ether in the contract to the owner of the contract
    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        // Below is a low-level method to send Ether. Returns 2 values: success boolean & data (ignored in this case)
        // Pros of sending Ether this way:
        // - can send Ether to contracts, even if they don't have a payable fallback function.
        // - It's also gas efficient.
        // However, it's important to handle potential failures correctly, which the next line does.
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}
