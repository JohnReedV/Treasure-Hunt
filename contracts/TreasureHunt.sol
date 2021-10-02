// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract TreasureHunt is ERC721URIStorage {
    address[] public treasureHolders;
    uint256 public tokenCounter;

    constructor(string memory tokenURI) ERC721("Burried Treasure", "TRES") {
        tokenCounter = 0;
        tokenURI;
    }

    function main(address _user) public {
        treasureHolders.push(_user);
        string memory tokenURI;
        createTreasure(tokenURI, _user);
    }

    function createTreasure(string memory _tokenURI, address _user) public {
        uint256 newTokenId = tokenCounter;
        _safeMint(_user, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);
        tokenCounter++;
    }
}
