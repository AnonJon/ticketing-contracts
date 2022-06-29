// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../contracts/EventFactory.sol";

contract EventFactoryUpgrade is Script {
    function run() external {
        vm.startBroadcast();

        EventFactory factory = new EventFactory();

        vm.stopBroadcast();
    }
}