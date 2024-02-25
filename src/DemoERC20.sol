//SPDX-License-Identifier:MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DemoERC20 is ERC20, Ownable {
    constructor() ERC20("SomeToken", "SMT") Ownable(msg.sender) {}

    function initialMint() public {
        uint256 _amount = 1000000;
        _mint(address(this), _amount * 1e18);
    }

    function externalTransfer(
        address destinationAddr,
        uint256 amount
    ) public onlyOwner {
        _transfer(address(this), destinationAddr, amount);
    }
}
