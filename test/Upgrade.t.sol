// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {Proxy} from "../contracts/utils/Proxy.sol";
import {EventFactory} from "../contracts/EventFactory.sol";


contract EventFactoryUpgradeTest is Test {
    Proxy proxy;
    EventFactory impl;

    address proxyAddress;
    address admin;
    function setUp() public {
        proxy = new Proxy();
        impl = new EventFactory(address(69));
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

    function testUpgradeUUPS() public {
        testDeployUUPS();
        EventFactory newImpl = new EventFactory(address(69));
        /// Since the admin is an EOA, it doesn't have an owner
        proxy.upgrade(address(newImpl), admin, address(0));
        bytes32 implSlot = bytes32(
            uint256(keccak256("eip1967.proxy.implementation")) - 1
        );
        bytes32 proxySlot = vm.load(proxyAddress, implSlot);
        address addr;
        assembly {
            mstore(0, proxySlot)
            addr := mload(0)
        }
        assertEq(address(newImpl), addr);
    }

    function testDeployBeacon() public {
        proxy.setType("beaconProxy");
        // need an extra Proxy to become the beacon
        Proxy beaconTester = new Proxy();
        beaconTester.setType("beacon");
        beaconTester.deploy(address(impl));
        proxy.deploy(address(beaconTester.beacon()));
        assertEq(address(impl), beaconTester.beacon().implementation());
        bytes32 beaconSlot = bytes32(
            uint256(keccak256("eip1967.proxy.beacon")) - 1
        );
        bytes32 proxySlot = vm.load(proxy.proxyAddress(), beaconSlot);
        address addr;
        assembly {
            mstore(0, proxySlot)
            addr := mload(0)
        }
        assertEq(addr, beaconTester.beaconAddress());
    }

    function testDeployTransparent() public {
        proxy.setType("transparent");
        proxyAddress = proxy.deploy(address(impl), admin);
        assertEq(proxyAddress, proxy.proxyAddress());
        assertEq(proxyAddress, address(proxy.transparent()));
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