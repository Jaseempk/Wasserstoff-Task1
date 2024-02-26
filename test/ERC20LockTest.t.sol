//SPDX-License-Identifier:MIT

pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/DemoERC20.sol";
import "../src/ERC20Lock.sol";

contract ERC20LockTest is Test {
    address user1 = makeAddr("user1");
    // struct Token {
    //     address sender;
    //     address destToken;
    //     string chainId;
    //     uint256 ercAmount;
    // }
    DemoERC20 bridgeToken;
    ERC20Lock evmBridge;

    function setUp() public {
        bridgeToken = new DemoERC20();
        evmBridge = new ERC20Lock(bridgeToken);
        // vm.prank(address(bridgeToken));
        console.log("lockContractAddress:", address(evmBridge));
        bridgeToken.initialMint();
        bridgeToken.externalTransfer(user1, 100000000000000000000);
        console.log("User1-Balance:", bridgeToken.balanceOf(user1));
    }

    function testTokenBridge() public {
        vm.startPrank(user1);
        ERC20Lock.Token memory newTokenTransfer = ERC20Lock.Token(
            user1,
            user1,
            "devnet",
            95000000000000000000
        );
        // console.log("bridge-Caller:", msg.sender);
        // console.log("this-Contract:", address(this));

        bridgeToken.approve(address(evmBridge), 95000000000000000000);
        evmBridge.bridgeToken(newTokenTransfer);
    }

    function testForInvalidCaller() public {
        ERC20Lock.Token memory newTokenTransfer = ERC20Lock.Token(
            user1,
            user1,
            "devnet",
            95000000000000000000
        );

        bridgeToken.approve(address(evmBridge), 95000000000000000000);
        bytes4 customError = bytes4(keccak256("ELOCK__SenderMustBeCaller()"));
        vm.expectRevert(customError);
        evmBridge.bridgeToken(newTokenTransfer);
    }

    function testForInsufficientTokenAmount() public {
        vm.startPrank(user1);

        ERC20Lock.Token memory newTokenTransfer = ERC20Lock.Token(
            user1,
            user1,
            "devnet",
            0
        );

        bridgeToken.approve(address(evmBridge), 95000000000000000000);
        bytes4 customError = bytes4(
            keccak256("ELOCK__InsufficientTokenBalance()")
        );
        vm.expectRevert(customError);
        evmBridge.bridgeToken(newTokenTransfer);
    }

    function testForInvalidChain() public {
        vm.startPrank(user1);

        ERC20Lock.Token memory newTokenTransfer = ERC20Lock.Token(
            user1,
            user1,
            "vere-chain",
            95000000000000000000
        );

        bridgeToken.approve(address(evmBridge), 95000000000000000000);
        bytes4 customError = bytes4(keccak256("ELOCK__InvalidChain()"));
        vm.expectRevert(customError);
        evmBridge.bridgeToken(newTokenTransfer);
    }

    function testForBridgeBalance() public {
        testTokenBridge();
        assertEq(evmBridge.balances(user1), uint256(95000000000000000000));
    }
}
