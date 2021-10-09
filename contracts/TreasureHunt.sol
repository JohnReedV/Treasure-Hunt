// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TreasureHunt is ERC721URIStorage, Ownable {
    address[] public treasureHolders;
    uint256 public tokenCounter;
    uint256 public totalStakeAmount;
    mapping(address => uint256) public userBalance;
    IERC20 public maskToken;

    event MoveMaskToken(uint256 date, address from, address to, uint256 amount);
    event MintNFT(uint256 date, address to);

    constructor(string memory tokenURI, address _maskTokenAddress)
        ERC721("Burried Treasure", "TRES")
    {
        tokenCounter = 0;
        tokenURI;
        maskToken = IERC20(_maskTokenAddress);
    }

    function maskTokenDeposit(uint256 _amount) public payable {
        require(_amount > 0, "Cannot send 0");
        maskToken.transferFrom(msg.sender, address(this), _amount);
        totalStakeAmount += _amount;
        userBalance[msg.sender] += _amount;
        emit MoveMaskToken(block.timestamp, msg.sender, address(this), _amount);
    }

    function withdrawMaskToken(uint256 _amount) public onlyOwner {
        uint256 balance = userBalance[msg.sender];
        require(balance > 0, "You cannot withdraw nothing");
        require(balance >= _amount, "Cannout send more than you have");
        maskToken.transfer(msg.sender, balance);
        userBalance[msg.sender] -= balance;
        totalStakeAmount -= balance;
        emit MoveMaskToken(block.timestamp, address(this), msg.sender, _amount);
    }

    function sendMaskToken(uint256 _amount, address _to) public onlyOwner {
        require(totalStakeAmount >= _amount, "Not enough mask token");
        maskToken.transferFrom(address(this), _to, _amount);
        emit MoveMaskToken(block.timestamp, address(this), _to, _amount);
    }

    function mintNFT(address _user) public onlyOwner {
        treasureHolders.push(_user);
        string memory tokenURI;
        createTreasure(tokenURI, _user);
        emit MintNFT(block.timestamp, _user);
    }

    function createTreasure(string memory _tokenURI, address _user) public {
        uint256 newTokenId = tokenCounter;
        _safeMint(_user, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);
        tokenCounter++;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        transferOwnership(_newOwner);
    }
}
