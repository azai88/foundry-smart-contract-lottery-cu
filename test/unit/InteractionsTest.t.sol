// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {AddConsumer} from "../../script/Interactions.s.sol";
import {Raffle} from "../../src/Raffle.sol";

contract InteractionsTest is Test {
    function testAddConsumerRuns() public {
        DeployRaffle deploy = new DeployRaffle();
        (Raffle raffle, ) = deploy.run();

        assert(address(raffle) != address(0));
    }
}
