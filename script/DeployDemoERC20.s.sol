//SPDX-License-Identifier:MIT

pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {DemoERC20} from "../src/DemoERC20.sol";

contract DeployDemoERC20 is Script {
    function run() public returns (DemoERC20) {
        vm.startBroadcast();
        DemoERC20 demoToken = new DemoERC20();
        vm.stopPrank();
        return demoToken;
    }
}
