pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Pokemon is ERC1155, Ownable{
    
    string public name;
    string public symbol;
    uint256 public mintFee = 0.02 ether;
    uint256[] totalSupply = [20,30,50]; //total supply of all 3 types of NFTs
    uint256[] mintedSupply = [0,0,0];   // to track minted nfts
    uint256[] mintPrices = [0.03 ether, 0.06 ether, 0.08 ether]; // mint price for each nft

    constructor(string memory _uri, string memory _name, string memory _symbol) 
    ERC1155(_uri){
        name = _name;
        symbol = _symbol;
    }
    
    
       function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mint(uint256 id, uint256 amount)
     public 
     payable
    {
        require( id <= totalSupply.length, "Token ID does not exist");
        require( id != 0, "token id does not exist");
        uint256 index = id - 1;

       require(mintedSupply[index] + amount <= totalSupply[index], "Not Enough Supply");
       require( msg.value >= amount * mintPrices[index], "Not enough ether sent" );

        _mint(msg.sender, id, amount, "");
        mintedSupply[index] += amount;
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
    {
        _mintBatch(to, ids, amounts, data);
    }

//withdraw funds from contract
    function withDraw() 
    public onlyOwner  
    {
        require( address(this).balance > 0, "Balance is 0");
        payable(owner()).transfer(address(this).balance);
    }
    
    function uri(uint256 id) 
    override public pure  returns(string memory) 
    {
        return(
        string(abi.encodePacked(
            "https://gateway.pinata.cloud/ipfs/QmdWW9pB6oe3Q61BPAjuEa4aAVUNH8MDwB3FnPRahENpFM",
            Strings.toString(id),
            ".json"
        ))
        );
    }
}