// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../contracts/EventFactory.sol";

contract EventFactoryScript is Script {
    function run() external {
        vm.startBroadcast();

        EventFactory factory = new EventFactory();

        vm.stopBroadcast();
    }
}