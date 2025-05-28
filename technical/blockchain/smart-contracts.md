# Smart Contract Implementation

This document provides detailed information about the smart contracts used in the TuneMantra platform for blockchain-based rights management and NFT minting. These contracts form the foundation of TuneMantra's decentralized rights verification system.

## Overview

TuneMantra employs several smart contracts to manage digital rights and create NFT representations of musical assets. These contracts are designed to work across multiple blockchain networks, with primary development focused on Polygon (Mumbai testnet and Mainnet) and Ethereum.

## Core Smart Contracts

### Rights Registry Contract

The Rights Registry contract is the central component of TuneMantra's blockchain rights management system.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract RightsRegistry is Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _rightsIdCounter;
    
    struct RightsRecord {
        uint256 id;
        string contentId;
        address artistAddress;
        string rightType;
        uint256 startTimestamp;
        uint256 endTimestamp;
        string metadataURI;
        uint256 timestamp;
    }
    
    // Mapping from rights ID to rights record
    mapping(uint256 => RightsRecord) private _rightsRecords;
    
    // Mapping from content ID to rights IDs
    mapping(string => uint256[]) private _contentRights;
    
    // Mapping from artist address to rights IDs
    mapping(address => uint256[]) private _artistRights;
    
    // Events
    event RightsRegistered(
        uint256 indexed id,
        string contentId,
        address indexed artistAddress,
        string rightType,
        uint256 startTimestamp,
        uint256 endTimestamp,
        string metadataURI
    );
    
    event RightsTransferred(
        uint256 indexed id,
        address indexed fromAddress,
        address indexed toAddress
    );
    
    /**
     * @dev Register a new rights record
     */
    function registerRights(
        string memory contentId,
        address artistAddress,
        string memory rightType,
        uint256 startTimestamp,
        uint256 endTimestamp,
        string memory metadataURI
    ) external returns (uint256) {
        require(bytes(contentId).length > 0, "Content ID cannot be empty");
        require(artistAddress != address(0), "Artist address cannot be zero");
        require(bytes(rightType).length > 0, "Right type cannot be empty");
        require(startTimestamp < endTimestamp, "End time must be after start time");
        
        _rightsIdCounter.increment();
        uint256 rightsId = _rightsIdCounter.current();
        
        _rightsRecords[rightsId] = RightsRecord({
            id: rightsId,
            contentId: contentId,
            artistAddress: artistAddress,
            rightType: rightType,
            startTimestamp: startTimestamp,
            endTimestamp: endTimestamp,
            metadataURI: metadataURI,
            timestamp: block.timestamp
        });
        
        _contentRights[contentId].push(rightsId);
        _artistRights[artistAddress].push(rightsId);
        
        emit RightsRegistered(
            rightsId,
            contentId,
            artistAddress,
            rightType,
            startTimestamp,
            endTimestamp,
            metadataURI
        );
        
        return rightsId;
    }
    
    /**
     * @dev Transfer rights ownership to another address
     */
    function transferRights(uint256 rightsId, address toAddress) external {
        require(_rightsRecords[rightsId].id != 0, "Rights do not exist");
        require(_rightsRecords[rightsId].artistAddress == msg.sender, "Not the rights owner");
        require(toAddress != address(0), "Cannot transfer to zero address");
        
        address fromAddress = _rightsRecords[rightsId].artistAddress;
        _rightsRecords[rightsId].artistAddress = toAddress;
        
        // Update artist rights mappings
        _removeFromArtistRights(fromAddress, rightsId);
        _artistRights[toAddress].push(rightsId);
        
        emit RightsTransferred(rightsId, fromAddress, toAddress);
    }
    
    /**
     * @dev Get rights record by ID
     */
    function getRightsRecord(uint256 rightsId) external view returns (RightsRecord memory) {
        require(_rightsRecords[rightsId].id != 0, "Rights do not exist");
        return _rightsRecords[rightsId];
    }
    
    /**
     * @dev Get all rights IDs for a content
     */
    function getContentRightsIds(string memory contentId) external view returns (uint256[] memory) {
        return _contentRights[contentId];
    }
    
    /**
     * @dev Get all rights IDs for an artist
     */
    function getArtistRightsIds(address artistAddress) external view returns (uint256[] memory) {
        return _artistRights[artistAddress];
    }
    
    /**
     * @dev Verify if an address has specific rights to a content
     */
    function verifyRights(
        address artistAddress,
        string memory contentId,
        string memory rightType
    ) external view returns (bool) {
        uint256[] memory rightsIds = _contentRights[contentId];
        
        for (uint i = 0; i < rightsIds.length; i++) {
            RightsRecord memory record = _rightsRecords[rightsIds[i]];
            
            if (record.artistAddress == artistAddress &&
                keccak256(bytes(record.rightType)) == keccak256(bytes(rightType)) &&
                block.timestamp >= record.startTimestamp &&
                block.timestamp <= record.endTimestamp) {
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * @dev Helper function to remove a rights ID from an artist's rights array
     */
    function _removeFromArtistRights(address artistAddress, uint256 rightsId) private {
        uint256[] storage artistRights = _artistRights[artistAddress];
        for (uint i = 0; i < artistRights.length; i++) {
            if (artistRights[i] == rightsId) {
                // Move the last element to the position of the element to delete
                artistRights[i] = artistRights[artistRights.length - 1];
                // Remove the last element
                artistRights.pop();
                break;
            }
        }
    }
}
```

### Music NFT Contract

The Music NFT contract handles the creation and management of non-fungible tokens representing musical assets.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./RightsRegistry.sol";

contract MusicNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    // Reference to the rights registry
    RightsRegistry private _rightsRegistry;
    
    // Mapping from token ID to content ID
    mapping(uint256 => string) private _tokenContents;
    
    // Mapping from content ID to token IDs
    mapping(string => uint256[]) private _contentTokens;
    
    // Events
    event NFTMinted(
        uint256 indexed tokenId,
        string contentId,
        address indexed artist,
        string tokenURI
    );
    
    /**
     * @dev Constructor sets the name and symbol of the NFT
     */
    constructor(address rightsRegistryAddress) ERC721("TuneMantra Music NFT", "TMNT") {
        _rightsRegistry = RightsRegistry(rightsRegistryAddress);
    }
    
    /**
     * @dev Mint a new music NFT
     * @param contentId The content identifier
     * @param tokenURI The URI for token metadata
     */
    function mintTrackNFT(
        string memory contentId,
        string memory tokenURI,
        string memory rightType
    ) external returns (uint256) {
        // Verify the sender has rights to the content
        require(
            _rightsRegistry.verifyRights(msg.sender, contentId, rightType),
            "Sender does not have rights to mint this content"
        );
        
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();
        
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);
        
        _tokenContents[tokenId] = contentId;
        _contentTokens[contentId].push(tokenId);
        
        emit NFTMinted(tokenId, contentId, msg.sender, tokenURI);
        
        return tokenId;
    }
    
    /**
     * @dev Get content ID for a token
     */
    function getTokenContent(uint256 tokenId) external view returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        return _tokenContents[tokenId];
    }
    
    /**
     * @dev Get all token IDs for a content
     */
    function getContentTokens(string memory contentId) external view returns (uint256[] memory) {
        return _contentTokens[contentId];
    }
    
    /**
     * @dev Update the rights registry address
     */
    function setRightsRegistry(address rightsRegistryAddress) external onlyOwner {
        require(rightsRegistryAddress != address(0), "Rights registry cannot be zero address");
        _rightsRegistry = RightsRegistry(rightsRegistryAddress);
    }
}
```

### Royalty Splitter Contract

The Royalty Splitter contract manages the distribution of royalties to rights holders.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./RightsRegistry.sol";

contract RoyaltySplitter is Ownable {
    using SafeMath for uint256;
    
    // Reference to the rights registry
    RightsRegistry private _rightsRegistry;
    
    struct RoyaltySplit {
        string contentId;
        address[] recipients;
        uint256[] shares; // Shares are expressed as percentages with 2 decimal places (10000 = 100%)
        bool active;
    }
    
    // Mapping from content ID to royalty split configuration
    mapping(string => RoyaltySplit) private _royaltySplits;
    
    // Mapping to track recipient balances
    mapping(address => uint256) private _balances;
    
    // Events
    event RoyaltySplitCreated(string contentId, address[] recipients, uint256[] shares);
    event RoyaltySplitUpdated(string contentId, address[] recipients, uint256[] shares);
    event RoyaltyDistributed(string contentId, uint256 amount);
    event PaymentWithdrawn(address recipient, uint256 amount);
    
    /**
     * @dev Constructor sets the rights registry address
     */
    constructor(address rightsRegistryAddress) {
        _rightsRegistry = RightsRegistry(rightsRegistryAddress);
    }
    
    /**
     * @dev Create a new royalty split for a content
     */
    function createRoyaltySplit(
        string memory contentId,
        address[] memory recipients,
        uint256[] memory shares
    ) external {
        require(bytes(contentId).length > 0, "Content ID cannot be empty");
        require(recipients.length > 0, "Recipients array cannot be empty");
        require(recipients.length == shares.length, "Recipients and shares must have the same length");
        require(!_royaltySplits[contentId].active, "Royalty split already exists for this content");
        
        uint256 totalShares = 0;
        for (uint i = 0; i < shares.length; i++) {
            totalShares = totalShares.add(shares[i]);
        }
        require(totalShares == 10000, "Total shares must equal 10000 (100%)");
        
        _royaltySplits[contentId] = RoyaltySplit({
            contentId: contentId,
            recipients: recipients,
            shares: shares,
            active: true
        });
        
        emit RoyaltySplitCreated(contentId, recipients, shares);
    }
    
    /**
     * @dev Update an existing royalty split
     */
    function updateRoyaltySplit(
        string memory contentId,
        address[] memory recipients,
        uint256[] memory shares
    ) external {
        require(_royaltySplits[contentId].active, "Royalty split does not exist");
        require(recipients.length > 0, "Recipients array cannot be empty");
        require(recipients.length == shares.length, "Recipients and shares must have the same length");
        
        uint256 totalShares = 0;
        for (uint i = 0; i < shares.length; i++) {
            totalShares = totalShares.add(shares[i]);
        }
        require(totalShares == 10000, "Total shares must equal 10000 (100%)");
        
        _royaltySplits[contentId].recipients = recipients;
        _royaltySplits[contentId].shares = shares;
        
        emit RoyaltySplitUpdated(contentId, recipients, shares);
    }
    
    /**
     * @dev Distribute royalties for a content
     */
    function distributeRoyalty(string memory contentId) external payable {
        require(_royaltySplits[contentId].active, "Royalty split does not exist");
        require(msg.value > 0, "Amount must be greater than zero");
        
        RoyaltySplit storage split = _royaltySplits[contentId];
        
        for (uint i = 0; i < split.recipients.length; i++) {
            uint256 recipientShare = msg.value.mul(split.shares[i]).div(10000);
            _balances[split.recipients[i]] = _balances[split.recipients[i]].add(recipientShare);
        }
        
        emit RoyaltyDistributed(contentId, msg.value);
    }
    
    /**
     * @dev Allow recipients to withdraw their balance
     */
    function withdrawPayment() external {
        uint256 amount = _balances[msg.sender];
        require(amount > 0, "No balance to withdraw");
        
        _balances[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
        
        emit PaymentWithdrawn(msg.sender, amount);
    }
    
    /**
     * @dev Get the royalty split for a content
     */
    function getRoyaltySplit(string memory contentId) external view returns (
        address[] memory recipients,
        uint256[] memory shares,
        bool active
    ) {
        RoyaltySplit storage split = _royaltySplits[contentId];
        return (split.recipients, split.shares, split.active);
    }
    
    /**
     * @dev Get the balance of a recipient
     */
    function getBalance(address recipient) external view returns (uint256) {
        return _balances[recipient];
    }
    
    /**
     * @dev Update the rights registry address
     */
    function setRightsRegistry(address rightsRegistryAddress) external onlyOwner {
        require(rightsRegistryAddress != address(0), "Rights registry cannot be zero address");
        _rightsRegistry = RightsRegistry(rightsRegistryAddress);
    }
}
```

## Contract Interactions

The TuneMantra smart contracts interact with each other to provide a comprehensive solution for blockchain-based rights management:

1. **Rights Registration**: Artists or rights holders register their rights to musical content in the `RightsRegistry` contract
2. **NFT Minting**: Once rights are registered, the owner can mint NFTs representing the content through the `MusicNFT` contract
3. **Royalty Configuration**: Revenue splitting arrangements are configured in the `RoyaltySplitter` contract
4. **Royalty Distribution**: When royalties are received, they are automatically split according to the configured shares

## Network Deployment

The contracts are deployed across multiple blockchain networks to support different use cases:

| Network | Purpose | Contract Addresses |
|---------|---------|-------------------|
| Polygon Mumbai | Testing and development | RightsRegistry: 0x1234...5678<br>MusicNFT: 0x8765...4321<br>RoyaltySplitter: 0xabcd...ef01 |
| Polygon Mainnet | Production environment | RightsRegistry: 0x2345...6789<br>MusicNFT: 0x9876...5432<br>RoyaltySplitter: 0xbcde...f012 |
| Ethereum Mainnet | High-value assets | RightsRegistry: 0x3456...7890<br>MusicNFT: 0xa987...6543<br>RoyaltySplitter: 0xcdef...0123 |

*Note: The contract addresses above are examples only. Actual deployed contract addresses should be obtained from the latest deployment documentation.*

## Security Measures

The TuneMantra smart contracts implement several security measures:

- **Access Control**: OpenZeppelin's `Ownable` pattern to restrict sensitive operations
- **Input Validation**: Comprehensive validation of all input parameters
- **Safe Math**: Use of SafeMath to prevent integer overflow/underflow
- **Reentrancy Protection**: Protection against reentrancy attacks
- **Regular Audits**: Contracts undergo regular security audits

## Integration with TuneMantra Platform

The TuneMantra platform integrates with these smart contracts through the Blockchain Connector, which provides a simplified interface for interacting with the contracts across different networks.

Integration points include:

- **Rights Management**: Registration and verification of rights through the platform UI
- **NFT Management**: Minting and managing music NFTs directly from the platform
- **Royalty Management**: Setting up and monitoring royalty splits
- **Blockchain Explorer**: Viewing transaction history and contract interactions
- **Wallet Integration**: Connecting user wallets for signing transactions

## Testing Framework

The blockchain components include a comprehensive testing framework:

- **Unit Tests**: Individual contract function tests
- **Integration Tests**: Tests of interactions between contracts
- **Simulation Mode**: Testing environment that simulates blockchain behavior without actual transactions
- **Network-Specific Tests**: Tests targeting specific blockchain networks

For detailed testing information, refer to the [Blockchain Testing Guide](testing-guide.md).

## Future Enhancements

Planned enhancements to the smart contracts include:

- **Layer 2 Integration**: Supporting Ethereum scaling solutions like Optimism and Arbitrum
- **Multi-Chain Rights Verification**: Cross-chain verification of rights ownership
- **Enhanced Royalty Models**: Support for more complex royalty distribution models
- **DAO Governance**: Transitioning contract management to a decentralized autonomous organization
- **Zero-Knowledge Proofs**: Adding privacy features through ZK technology

## References

For more information, refer to:

- [Blockchain Overview](overview-architecture.md)
- [Implementation Guide](implementation-guide.md)
- [Integration Guide](integration-guide.md)
- [Testing Guide](testing-guide.md)

---

*This documentation is maintained based on the smart contract implementations found primarily in the 17032025 branch.*