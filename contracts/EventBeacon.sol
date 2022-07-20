// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EventBeacon is Ownable {
    UpgradeableBeacon beacon;

    address public blueprint;

    constructor(address _initBlueprint) {
        beacon = new UpgradeableBeacon(_initBlueprint);

        blueprint = _initBlueprint;
        transferOwnership(tx.origin);
    }

    function update(address _newBlueprint) public onlyOwner {
        beacon.upgradeTo(_newBlueprint);
        blueprint = _newBlueprint;
    }
}
