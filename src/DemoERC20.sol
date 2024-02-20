//SPDX-License-Identifier:MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DemoERC20 is ERC20 {
    constructor() ERC20("SomeToken", "SMT") {}

    function initialMint() public {
        uint256 _amount = 1000;
        _mint(address(this), _amount * 1e18);
    }

    function externalTransfer(address destinationAddr, uint256 amount) public {
        _transfer(address(this), destinationAddr, amount);
    }
}
