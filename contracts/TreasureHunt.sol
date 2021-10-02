// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract TreasureHunt is VRFConsumerBase, ERC721URIStorage {
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;

    address[] public noTreasure;
    address[] public treasureHolders;
    mapping(bytes32 => address) public users;
    bool internal permitted;
    uint256 public tokenCounter;

    constructor(
        address _vrfCoordinator,
        address _linkToken,
        uint256 _fee,
        bytes32 _keyhash,
        string memory tokenURI
    )
        VRFConsumerBase(_vrfCoordinator, _linkToken)
        ERC721("Burried Treasure", "TRES")
    {
        tokenCounter = 0;
        keyHash = _keyhash;
        fee = _fee;
    }

    function main(bytes32 _twitter, address _user) public {
        for (uint256 i = 0; i < noTreasure.length; i++) {
            if (noTreasure[i] == _user) {
                permitted = false;
                break;
            } else {
                permitted = true;
            }
        }
        require(permitted == true, "You have no treasure");
        users[_twitter] = _user;
        getRandomNumber();
        if (calculateTreasure(randomResult) == true) {
            treasureHolders.push(_user);
            string memory tokenURI;
            createTreasure(tokenURI, _user);
        } else {
            noTreasure.push(_user);
        }
    }

    function calculateTreasure(uint256 _rand) internal returns (bool) {
        if (_rand % 11 == 0) {
            return true;
        } else {
            return false;
        }
    }

    function getRandomNumber() public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK");
        return requestRandomness(keyHash, fee);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness)
        internal
        override
    {
        randomResult = randomness;
    }

    function createTreasure(string memory _tokenURI, address _user) public {
        uint256 newTokenId = tokenCounter;
        _safeMint(_user, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);
        tokenCounter++;
    }
}
