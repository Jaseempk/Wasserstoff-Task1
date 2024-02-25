//SPDX-License-Identifier:MIT

pragma solidity ^0.8.19;

import "forge-std/Test.sol";

import "../src/DemoERC20.sol";
import "../src/ERC20Lock.sol";

contract ERC20LockTest is Test {
    address user1 = makeAddr("user1");
    struct Token {
        address sender;
        address destToken;
        string chainId;
        uint256 ercAmount;
    }
    DemoERC20 bridgeToken;
    ERC20Lock evmBridge;

    function setup() public {
        bridgeToken = new DemoERC20();
        evmBridge = new ERC20Lock(bridgeToken);
        vm.prank(address(bridgeToken));
        bridgeToken.externalTransfer(user1, 100000000000000000000);
    }

    function testTokenBridge() public {
        vm.startPrank(user1);
        Token memory newTokenTransfer = Token(
            user1,
            user1,
            "devnet",
            100000000000000000000
        );
        evmBridge.bridgeToken(newTokenTransfer);
    }
}
