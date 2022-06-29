// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {Proxy} from "../contracts/utils/Proxy.sol";
import {EventFactory} from "../contracts/EventFactory.sol";


contract EventFactoryUpgrade is Test {
    Proxy proxy;
    EventFactory impl;

    address proxyAddress;
    address admin;
    function setUp() public {
        proxy = new Proxy();
        impl = new EventFactory();
        admin = vm.addr(69);
    }

     function testDeployUUPS() public {
        proxy.setType("uups");
        proxyAddress = proxy.deploy(address(impl), admin);
        assertEq(proxyAddress, proxy.proxyAddress());
        assertEq(proxyAddress, address(proxy.uups()));
        bytes32 implSlot = bytes32(
            uint256(keccak256("eip1967.proxy.implementation")) - 1
        );
        bytes32 proxySlot = vm.load(proxyAddress, implSlot);
        address addr;
        assembly {
            mstore(0, proxySlot)
            addr := mload(0)
        }
        assertEq(address(impl), addr);
    }
}