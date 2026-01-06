// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract TokenNFT is ERC721, ERC721URIStorage, Ownable{
    uint256 private _tokenIdCounter;
    uint256 public constant MAX_SUPPLY = 10;
    uint256 public mintPrice = 0.01 ether;

    event NFTMint(address indexed seller, uint256 indexed tokenId, string uri);


    constructor() ERC721("TokenNFT", "TNFT") Ownable(msg.sender) {}

    function mint(string memory uri) public payable returns(uint256) {
        // 检查供应量
        require(_tokenIdCounter < MAX_SUPPLY, "Max supply reached");
        // 检查余额
        require(msg.value >= mintPrice, "Insufficient  payment");

        _tokenIdCounter++;
        uint256 newTokenId = _tokenIdCounter;

        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, uri);

        emit NFTMint(msg.sender, newTokenId, uri);
        return newTokenId;
    }

    // 查看tokenId总数
    function getTokenIdCounter() public view returns(uint256) {
        return _tokenIdCounter;
    }

    /**
     * @dev 重写tokenURI函数
     * @param tokenId token id
     * @return 元数据uri
     */  
    function tokenURI(uint256 tokenId) public view 
        virtual 
        override(ERC721, ERC721URIStorage) 
        returns (string memory) 
    {
        return super.tokenURI(tokenId);
    }

    /**
     * @dev 检查接口支持
     * @param interfaceId 接口id
     * @return 是否支持该接口
     */  
    function supportsInterface(bytes4 interfaceId) public view 
        virtual 
        override(ERC721, ERC721URIStorage) 
        returns (bool) 
    {
        return super.supportsInterface(interfaceId);
    }
}