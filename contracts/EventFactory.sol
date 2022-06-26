// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Event} from "./Event.sol";

contract EventFactory {
    address[] public deployedEvents;

    function createEvent(string[] memory tickets, uint256[] memory amounts, string memory uri) public {
        //deploys events and returns address
        address newEvent = address(new Event(msg.sender, tickets, amounts, uri));
        deployedEvents.push(newEvent);
    }

    function getDeployedEvents() public view returns (address[] memory) {
        return deployedEvents;
    }
}
