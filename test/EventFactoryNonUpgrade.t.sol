// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "../contracts/EventFactory-NonUpgrade.sol";
import "../contracts/Event-NonUpgrade.sol";
import {Utils} from "../contracts/utils/Utils.sol";

contract EventFactoryTest is Test, Utils {
    EventFactoryNonUpgradeable factory;
    Event e;

    string[] tickets;
    uint256[] amounts;
    uint256[] costs;

    string name;
    string description;
    uint256 start;
    uint256 finish;
    string location;
    string host;
    string uri;
    string thumbnail;

    address jon;
    address brent;

    EventDetails details;

    function setUp() public {
        jon = address(0xa0Ee7A142d267C1f36714E4a8F75612F20a79720);
        brent = address(0x24534ea237dA564fdC7584a2f58a3E4B570DE503);

        // Event details and metadata.
        tickets = ["one", "two", "three", "four", "five", "six"];
        amounts = [5, 100, 100, 100, 100, 100];
        uri = "http://localhost:8080";
        costs = [
            1000000000000000000,
            1000000000000000000,
            1000000000000000000,
            1000000000000000000,
            1000000000000000000,
            1000000000000000000
        ];

        name = "Austin Event";
        description = "Amazing Event At the Park";
        start = 34534535;
        finish = 34535345;
        location = "Zilker Park";
        host = "ATX DAO";
        thumbnail = "https://www.austinimage.com/imageA";

        details = EventDetails(name, description, location, start, finish, host, thumbnail);
        factory = new EventFactoryNonUpgradeable(jon);
    }

    function test_deployFactory() public {
        vm.prank(jon);

        // Create Event.
        factory.createEvent(tickets, amounts, uri, costs, details);

        // Access created Event.
        e = factory.getDeployedEvents()[0];
        assertEq(factory.getDeployedEvents().length, 1);
        assertEq(e.manager(), jon);
        assertTrue(e.getTotalTicketTypes() == 6);
        console2.log(e.balanceOf(jon, 1));

        // Access Event details on created Event.
        assertEq(e.name(), name);
        assertEq(e.description(), description);
        assertEq(e.location(), location);
        assertEq(e.thumbnail(), thumbnail);

        // Access EventDetails from created Event.
        EventDetails[] memory detailsArray = factory.getDeployedEventsDetails();
        EventDetails memory d = detailsArray[0];
        assertEq(d._name, name);
        assertEq(d._description, description);
        assertEq(d._thumbnail, thumbnail);
    }

    function test_hasTicket() public {
        // Create an event.
        vm.prank(jon);
        factory.createEvent(
            tickets,
            amounts,
            uri,
            costs,
            EventDetails(name, description, location, start, finish, host, thumbnail)
        );
        e = factory.getDeployedEvents()[0];

        // Check for Ticket #2.
        assertTrue(factory.hasTicket(brent, 0) == -1);

        // Buy a ticket from Event.
        vm.prank(jon);
        e.safeTransferFrom(jon, brent, 2, 1, "0x0");
        assertTrue(e.balanceOf(brent, 2) == 1);
        assertTrue(e.balanceOf(jon, 2) == 99);

        // Check for Ticket #2.
        assertTrue(e.hasTicket(brent) == 2);
        assertTrue(factory.hasTicket(brent, 0) == 2);

        // Buy a ticket from Factory.
        vm.prank(jon);
        factory.transferTicket(0, brent, 2, 1);
        assertTrue(e.balanceOf(brent, 2) == 2);
        assertTrue(e.balanceOf(jon, 2) == 98);

        // Check for Ticket #2.
        assertTrue(e.hasTicket(brent) == 2);
        assertTrue(factory.hasTicket(brent, 0) == 2);
    }

    function test_buyTicket() public {
        vm.prank(jon);
        factory.createEvent(
            tickets,
            amounts,
            uri,
            costs,
            EventDetails(name, description, location, start, finish, host, thumbnail)
        );

        e = factory.getDeployedEvents()[0];
        vm.prank(brent);
        vm.deal(brent, 3000000000000000000);
        e.buyTicket{value: uint256(1000000000000000000)}(1, 1);

        // test for not enough payment sent
        vm.expectRevert(bytes("Not enough tickets left!"));
        e.buyTicket{value: uint256(1000000000000000000)}(1, 5);
    }

    function test_withdrawFunds() public {
        vm.prank(jon);
        factory.createEvent(
            tickets,
            amounts,
            uri,
            costs,
            EventDetails(name, description, location, start, finish, host, thumbnail)
        );

        e = factory.getDeployedEvents()[0];
        vm.prank(brent);
        vm.deal(brent, 3000000000000000000);
        e.buyTicket{value: uint256(1000000000000000000)}(1, 1);

        // test withdraw
        vm.prank(brent);
        vm.expectRevert(bytes("Ownable: caller is not the owner"));
        e.sweep();
        vm.prank(jon);
        e.sweep();


    }
}
