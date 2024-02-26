//SPDX-License-Identifier:MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
//Error
error ELOCK__InsufficientTokenBalance();
error ELOCK__InvalidTokenAddress();
error ELOCK__InvalidChain();
error ELOCK__SenderMustBeCaller();
error ELOCK__BridgeFailed();

contract ERC20Lock {
    IERC20 public immutable i_tokenToLock;

    struct Token {
        address sender;
        address destToken;
        string chainId;
        uint256 ercAmount;
    }

    mapping(address => mapping(bytes4 => Token)) public bridgeDetails;
    mapping(address => uint256) public balances;

    event tokenBridgeDone(
        address sender,
        address destToken,
        string chainId,
        uint256 ercAmount
    );

    modifier validateLock(
        address token,
        uint256 amount,
        address sender
    ) {
        if (sender != msg.sender) revert ELOCK__SenderMustBeCaller();
        if (token == address(0)) revert ELOCK__InvalidTokenAddress();
        if (amount == 0) revert ELOCK__InsufficientTokenBalance();
        _;
    }

    constructor(IERC20 _tokenToLock) {
        i_tokenToLock = _tokenToLock;
    }

    function bridgeToken(
        Token memory newTransfer
    )
        public
        validateLock(
            newTransfer.destToken,
            newTransfer.ercAmount,
            newTransfer.sender
        )
    {
        string memory acceptedChain = "devnet";

        if (
            keccak256(abi.encodePacked(newTransfer.chainId)) !=
            keccak256(abi.encodePacked(acceptedChain))
        ) revert ELOCK__InvalidChain();

        // if (_destAddr == address(0)) revert ELOCK__InvalidAddress();
        // Token memory tokenBridge = Token(
        //     msg.sender,
        //     chainId,
        //     _amountToBridge,
        //     _destAddr
        // );
        balances[newTransfer.sender] += newTransfer.ercAmount;

        bytes4 bridgeId = bytes4(
            keccak256(
                abi.encodePacked(
                    block.timestamp,
                    newTransfer.destToken,
                    newTransfer.sender
                )
            )
        );
        bridgeDetails[msg.sender][bridgeId] = newTransfer;

        uint256 amountToSend = newTransfer.ercAmount;
        newTransfer.ercAmount = 0;

        if (
            !i_tokenToLock.transferFrom(
                newTransfer.sender,
                address(this),
                amountToSend
            )
        ) revert ELOCK__BridgeFailed();
        emit tokenBridgeDone(
            newTransfer.sender,
            newTransfer.destToken,
            newTransfer.chainId,
            amountToSend
        );
    }
}
