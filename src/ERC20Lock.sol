//SPDX-License-Identifier:MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
//Error
error ELOCK__InsufficientTokenBalance();
error ELOCK__InvalidAddress();
error ELOCK__InvalidChain();

contract ERC20Lock {
    IERC20 public immutable i_tokenToLock;

    struct Token {
        address sender;
        string chainId;
        uint256 amount;
        address mirroreTokenAddress;
    }

    mapping(address => Token) public addressToBridge;

    event tokenBridgeDone(Token someTokenBridge);

    constructor(IERC20 _tokenToLock) {
        i_tokenToLock = _tokenToLock;
    }

    function bridgeToken(
        address _destAddr,
        uint256 _amountToBridge,
        string memory chainId
    ) public {
        string memory acceptedChain = "devnet";

        if (
            i_tokenToLock.balanceOf(msg.sender) < _amountToBridge ||
            i_tokenToLock.balanceOf(msg.sender) == 0
        ) revert ELOCK__InsufficientTokenBalance();
        if (
            keccak256(abi.encodePacked(chainId)) !=
            keccak256(abi.encodePacked(acceptedChain))
        ) revert ELOCK__InvalidChain();

        if (_destAddr == address(0)) revert ELOCK__InvalidAddress();
        Token memory tokenBridge = Token(
            msg.sender,
            chainId,
            _amountToBridge,
            _destAddr
        );
        addressToBridge[msg.sender] = tokenBridge;

        i_tokenToLock.transfer(address(this), _amountToBridge);
        emit tokenBridgeDone(tokenBridge);
    }
}
