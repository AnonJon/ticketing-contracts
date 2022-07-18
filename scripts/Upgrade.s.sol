// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import "../contracts/Event.sol";
import {Proxy} from "../contracts/utils/Proxy.sol";

contract EventBeacon is Script {
    string[] tickets;
    uint256[] amounts;
    uint256[] costs;
    string name;
    string description;
    uint256 start;
    uint256 finish;
    string location;
    string uri;
    Proxy proxy;

    function run() external {
        address admin = 0x4Fdd54a50623a7C7b5b3055700eB4872356bd5b3;
        vm.startBroadcast(admin);

        proxy = new Proxy();
        proxy.setType("beaconProxy");
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

        name = "";
        description = "";
        start = 34534535;
        finish = 34535345;
        location = "";

        Event impl = new Event(
            admin,
            tickets,
            amounts,
            uri,
            costs,
            name,
            description,
            start,
            finish,
            location
        );
        Proxy beaconTester = new Proxy();
        beaconTester.setType("beacon");
        beaconTester.deploy(address(impl));
        proxy.deploy(address(beaconTester.beacon()));
        console.log(beaconTester.beaconAddress());

        vm.stopBroadcast();
    }
}
