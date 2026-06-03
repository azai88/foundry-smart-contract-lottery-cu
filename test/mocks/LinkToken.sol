// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface ERC677Receiver {
    function onTokenTransfer(
        address sender,
        uint256 value,
        bytes memory data
    ) external;
}

contract LinkToken is ERC20 {
    uint256 public constant INITIAL_SUPPLY = 1_000_000 ether;

    constructor() ERC20("LinkToken", "LINK") {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    function mint(address to, uint256 value) public {
        _mint(to, value);
    }

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value,
        bytes data
    );

    function transferAndCall(
        address to,
        uint256 value,
        bytes memory data
    ) public returns (bool) {
        transfer(to, value);

        emit Transfer(msg.sender, to, value, data);

        if (to.code.length > 0) {
            ERC677Receiver(to).onTokenTransfer(msg.sender, value, data);
        }

        return true;
    }
}
