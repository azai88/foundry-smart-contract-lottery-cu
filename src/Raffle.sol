// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {VRFConsumerBaseV2} from "@chainlink/contracts/VRFConsumerBaseV2.sol";
import {VRFCoordinatorV2Interface} from "@chainlink/contracts/interfaces/VRFCoordinatorV2Interface.sol";
import {AutomationCompatibleInterface} from "@chainlink/contracts/interfaces/AutomationCompatibleInterface.sol";

contract Raffle is VRFConsumerBaseV2, AutomationCompatibleInterface {
    enum RaffleState {
        OPEN,
        CALCULATING
    }

    uint256 private immutable i_entranceFee;
    address payable[] private s_players;
    RaffleState private s_raffleState;

    event EnteredRaffle(address indexed player);

    error Raffle__NotEnoughEthSent();
    error Raffle__RaffleNotOpen();

    constructor(
        uint256 entranceFee,
        address vrfCoordinator
    ) VRFConsumerBaseV2(vrfCoordinator) {
        i_entranceFee = entranceFee;
        s_raffleState = RaffleState.OPEN;
    }

    function enterRaffle() public payable {
        if (s_raffleState == RaffleState.CALCULATING) {
            revert Raffle__RaffleNotOpen();
        }

        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthSent();
        }

        s_players.push(payable(msg.sender));

        emit EnteredRaffle(msg.sender);
    }

    function checkUpkeep(
        bytes calldata
    )
        external
        pure
        override
        returns (bool upkeepNeeded, bytes memory performData)
    {
        return (false, bytes(""));
    }

    function performUpkeep(bytes calldata) external override {}

    function fulfillRandomWords(uint256, uint256[] memory) internal override {}

    // GETTERS

    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }

    function getRaffleState() public view returns (RaffleState) {
        return s_raffleState;
    }

    function getPlayer(uint256 index) public view returns (address) {
        return s_players[index];
    }

    function getNumberOfPlayers() public view returns (uint256) {
        return s_players.length;
    }
}
