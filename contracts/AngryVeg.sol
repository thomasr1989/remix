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
    uint private  publicMintPrice = 0.01 ether;
    

    function mintToken()  external payable mintOngoing{
        require(msg.value == publicMintPrice,string(abi.encodePacked("Minting an Angry Vegetable costs ",Strings.toString(publicMintPrice))));
        require(balanceOf(msg.sender) == 0, "Max one Angry Tomaty per wallet.");
        _tokenIdCounter.increment();
        _safeMint(msg.sender,_tokenIdCounter.current());
        // _safeMint(msg.sender, _tokenIdCounter.increment());
        

        // string memory uri = string(abi.encodePacked(tokenURI,Strings.toString(_tokenIdCounter.current())));
    }

    function nextMint() public view returns(uint nMint){
        return _tokenIdCounter.current();
    }


    function setBaseUri(string calldata _baseUri) external onlyOwner{
        baseUri = _baseUri;

    }

    function _baseURI() internal view override returns (string memory) {
        return baseUri;
    }

    function setPause(bool _pause) external onlyOwner{
        paused = _pause;
    }

     

  

    function withdraw(uint amount,address payable receiver) public onlyOwner{
        require(amount < address(this).balance, "Insufficient Balance");
        receiver.transfer(amount);

    }

    function updateMintPrice(uint amount) external onlyOwner {
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