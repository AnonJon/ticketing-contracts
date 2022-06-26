// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/EventFactory.sol";
import "../contracts/Event.sol";

contract EventFactoryTest is Test {
    EventFactory factory;
    address eventItem;
    string[] tickets;
    uint256[] amounts;
    string uri;
    address jon;
    function setUp() public {
        factory = new EventFactory();
        tickets = ["one", "two", "three", "four", "five", "six"];
        amounts = [5, 100, 100, 100, 100, 100];
        uri = "http://localhost:8080";
        jon = address(0xa0Ee7A142d267C1f36714E4a8F75612F20a79720);
    }

    function test_deployFactory() public {
        vm.prank(jon);
        factory.createEvent(tickets, amounts, uri);
        eventItem = factory.getDeployedEvents()[0];
        Event e = Event(eventItem);
        assertEq(factory.getDeployedEvents().length, 1);
        assertEq(e.manager(), jon);
        
    }
}
