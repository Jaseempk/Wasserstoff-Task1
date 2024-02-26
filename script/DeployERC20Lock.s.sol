//SPDX-License-Identifier:MIT

pragma solidity ^0.8.19;

import "forge-std/Script.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC20Lock} from "../src/ERC20Lock.sol";
import {DemoERC20} from "../src/DemoERC20.sol";

contract DeployERC20Lock is Script {
    function run() public returns (ERC20Lock) {
        DemoERC20 demoToken = new DemoERC20();
        vm.startBroadcast();
        ERC20Lock evmBridge = new ERC20Lock(IERC20(demoToken));
        vm.stopBroadcast();
        return evmBridge;
    }
}
