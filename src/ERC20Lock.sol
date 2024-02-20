//SPDX-License-Identifier:MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
//Error
error ELOCK__InsufficientTokenBalance();
error ELOCK__InvalidAddress();

contract ERC20Lock {
    IERC20 public immutable i_tokenToLock;

    struct Token {
        address sender;
        uint256 amount;
        address destAddr;
    }

    event tokenBridgeDone(Token someTokenBridge);

    constructor(IERC20 _tokenToLock) {
        i_tokenToLock = _tokenToLock;
    }

    function bridgeToken(address _destAddr, uint256 _amountToBridge) public {
        if (
            i_tokenToLock.balanceOf(msg.sender) < _amountToBridge ||
            i_tokenToLock.balanceOf(msg.sender) == 0
        ) revert ELOCK__InsufficientTokenBalance();

        if (_destAddr == address(0)) revert ELOCK__InvalidAddress();
        Token memory tokenBridge = Token(
            msg.sender,
            _amountToBridge,
            _destAddr
        );

        i_tokenToLock.transfer(address(this), _amountToBridge);
        emit tokenBridgeDone(tokenBridge);
    }
}
