// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/AccessControl.sol";
import {Event} from "./Event-NonUpgrade.sol";
import {Utils} from "./utils/Utils.sol";

contract EventFactoryNonUpgradeable is Utils {
    Event[] public deployedEvents;
    EventDetails[] public deployedEventsDetails;
    address public manager;

    constructor(address creator) {
        manager = creator;
    }

    function createEvent(
        string[] memory tickets,
        uint256[] memory amounts,
        string memory uri,
        uint256[] memory costs,
        EventDetails calldata details) public {
        //deploys events and returns address
        Event newEvent = new Event(
            msg.sender,
            tickets,
            amounts,
            uri,
            costs,
            details);
        deployedEvents.push(newEvent);

        deployedEventsDetails.push(details);
    }

    // Returns the first found token type if user has one.  -1 if no tickets.
    function hasTicket(address user, uint256 eventId) public view returns (int256) {
        require(user != address(0), "EventFactory: address zero is not a valid owner");

        Event deployedEvent = deployedEvents[eventId];

        return deployedEvent.hasTicket(user);
    }

    function transferTicket(uint256 eventId, address to, uint256 token, uint256 amount) public {
        Event deployedEvent = deployedEvents[eventId];

        deployedEvent.transferTicket(manager, to, token, amount);
    }

    function getDeployedEvents() public view returns (Event[] memory) {
        return deployedEvents;
    }

    function getDeployedEventsDetails() public view returns (EventDetails[] memory) {
        return deployedEventsDetails;
    }
}