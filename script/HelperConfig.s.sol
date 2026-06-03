// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract HelperConfig {
    struct NetworkConfig {
        address vrfCoordinator;
        uint256 entranceFee;
        bytes32 gasLane;
        uint64 subscriptionId;
        uint32 callbackGasLimit;
        uint256 interval;
    }

    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaConfig();
        } else {
            activeNetworkConfig = getAnvilConfig();
        }
    }

    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                vrfCoordinator: 0x0000000000000000000000000000000000000000,
                entranceFee: 0.01 ether,
                gasLane: 0x0000000000000000000000000000000000000000000000000000000000000000,
                subscriptionId: 0,
                callbackGasLimit: 500000,
                interval: 30
            });
    }

    function getAnvilConfig() public pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                vrfCoordinator: 0x0000000000000000000000000000000000000000,
                entranceFee: 0.01 ether,
                gasLane: 0x0000000000000000000000000000000000000000000000000000000000000000,
                subscriptionId: 0,
                callbackGasLimit: 500000,
                interval: 30
            });
    }

    function getConfig() public view returns (NetworkConfig memory) {
        return activeNetworkConfig;
    }
}
