// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Event is ERC1155, Ownable {
    using Counters for Counters.Counter;
    address public manager;
    Counters.Counter private _tokenIds;

    constructor(address creator, string[] memory tickets, uint256[] memory amounts, string memory _uri) ERC1155(_uri) {
        manager = creator;
        for (uint256 i = 0; i < tickets.length; i++) {
             _tokenIds.increment();
             uint256 newTokenId = _tokenIds.current();
            _mint(manager, newTokenId, amounts[i], "");
        }
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function addTicket(string memory name, uint256 amount) public onlyOwner {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _mint(manager, newTokenId, amount, "");
    }

    function getTotalTicketTypes() public returns(uint256) {
        return _tokenIds.current();
    }

    function sweep() public onlyOwner {
        uint256 _balance = address(this).balance;
        payable(manager).transfer(_balance);
    }
}