// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


/**
 * @title MyNFT
 * @dev NFT合约、铸造、元数据管理和供应量控制
 * @notice 
 */
contract MyNFT is ERC721, ERC721URIStorage, Ownable {
    
    // token计数器
    uint256 private _tokenIdCounter;

    // 最大供应量
    uint256 public constant MAX_SUPPLY = 10000;

    // 铸造价格
    uint256 public mintPrice = 0.01 ether;

    /**
    * @dev NFT铸造事件
    * @param minter 铸造者地址
    * @param tokenId 新创建的Token ID
    * @param uri 元数据URI
    */
    event NFTMinted(
        address indexed minter,
        uint256 indexed tokenId,
        string uri
    );

    /**
     * @dev 构造函数
     * @notice 初始化
     */
    constructor() ERC721("MyNFT", "MNFT") Ownable(msg.sender) {}

    function mint(string memory uri) public payable returns(uint256) {
        // 检查供应量限制
        require(_tokenIdCounter < MAX_SUPPLY, "Max supply reached");

        // 检查支付金额
        require(msg.value >= mintPrice, "Insufficient payment");

        // 递增计数器
        _tokenIdCounter++;
        uint256 newTokenId = _tokenIdCounter;

        // 安全铸造NFT
        _safeMint(msg.sender, newTokenId);

        // 设置元数据URI
        _setTokenURI(newTokenId, uri);

        // 触发事件
        emit NFTMinted(msg.sender, newTokenId, uri);

        return newTokenId;
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

    /**
     * @dev 查询总供应量
     * @return 已铸造的NFT数量
     */  
    function totalSupply() public view returns(uint256) {
        return _tokenIdCounter;
    }
    
    
    /**
     * @dev 提取铸造费
     * @notice
     */    
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        payable(owner()).transfer(balance);
    }
    
    /**
     * @dev 设置铸造价格
     * @param newPrice 新的铸造价格(wei)
     * @notice
     */
    function setMintPrice(uint256 newPrice) public onlyOwner {
        mintPrice = newPrice;
    }
}