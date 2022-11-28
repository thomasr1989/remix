// SPDX-License-Identifier: GPL-3.0
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts@4.7.2/utils/Counters.sol";


pragma solidity ^0.8.7;

contract AngryVeg is ERC721("Angry Tomatoes","ANGRY TOMATOES"), Ownable{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor(string memory _baseUri){
        baseUri = _baseUri;
    }

    string private baseUri;
    bool private paused;
    uint private constant MAX_SUPPLY  = 5;
    uint private  publicMintPrice = 0.005 ether;
    

    function mintToken()  external payable mintOngoing{
        require(msg.value == publicMintPrice,string(abi.encodePacked("Minting an Angry Vegetable costs ",Strings.toString(publicMintPrice))));
        require(balanceOf(msg.sender) == 0, "Max one Angry Tomaty per wallet.");
        _tokenIdCounter.increment();
        _safeMint(msg.sender,_tokenIdCounter.current());
    }

    function _baseURI() internal view override returns (string memory) {
        return baseUri;
    }

    function withdraw(uint amount,address payable receiver) public onlyOwner{
        require(amount < address(this).balance, "Insufficient Balance");
        receiver.transfer(amount);
    }

    function setBaseUri(string calldata _baseUri) external onlyOwner{
        baseUri = _baseUri;
    }

    function setPause(bool _pause) external onlyOwner{
        paused = _pause;
    }


    function setMintPrice(uint amount) external onlyOwner {
        publicMintPrice = amount;
    }

    function getCurrentMintPrice()  external view returns (uint mintPrice){
        return publicMintPrice;
    }

    modifier mintOngoing(){
        require(_tokenIdCounter.current() < MAX_SUPPLY && !paused, "Mint paused / ended.");
        _;
    }
}