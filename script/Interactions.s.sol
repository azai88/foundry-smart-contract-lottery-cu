// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {CodeConstants} from "./HelperConfig.s.sol";

import {VRFCoordinatorV2_5Mock} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {LinkToken} from "../test/mocks/LinkToken.sol";

//////////////////////////////
// CREATE SUBSCRIPTION
//////////////////////////////
contract CreateSubscription is Script {
    function createSubscription(
        address vrfCoordinator,
        address account
    ) public returns (uint256, address) {
        vm.startBroadcast(account);

        uint256 subId = VRFCoordinatorV2_5Mock(vrfCoordinator)
            .createSubscription();

        vm.stopBroadcast();

        return (subId, vrfCoordinator);
    }

    function createSubscriptionUsingConfig() public returns (uint256, address) {
        HelperConfig config = new HelperConfig();
        HelperConfig.NetworkConfig memory net = config.getConfig();

        return createSubscription(net.vrfCoordinatorV2_5, net.account);
    }

    function run() external returns (uint256, address) {
        return createSubscriptionUsingConfig();
    }
}

//////////////////////////////
// FUND SUBSCRIPTION
//////////////////////////////
contract FundSubscription is Script, CodeConstants {
    uint96 public constant FUND_AMOUNT = 3 ether;

    function fundSubscription(
        address vrfCoordinator,
        uint256 subId,
        address link,
        address account
    ) public {
        vm.startBroadcast(account);

        if (block.chainid == LOCAL_CHAIN_ID) {
            VRFCoordinatorV2_5Mock(vrfCoordinator).fundSubscription(
                subId,
                FUND_AMOUNT
            );
        } else {
            LinkToken(link).transferAndCall(
                vrfCoordinator,
                FUND_AMOUNT,
                abi.encode(subId)
            );
        }

        vm.stopBroadcast();
    }

    function fundSubscriptionUsingConfig() public {
        HelperConfig config = new HelperConfig();
        HelperConfig.NetworkConfig memory net = config.getConfig();

        fundSubscription(
            net.vrfCoordinatorV2_5,
            net.subscriptionId,
            net.link,
            net.account
        );
    }

    function run() external {
        fundSubscriptionUsingConfig();
    }
}

//////////////////////////////
// ADD CONSUMER
//////////////////////////////
contract AddConsumer is Script {
    function addConsumer(
        address raffle,
        address vrfCoordinator,
        uint256 subId,
        address account
    ) public {
        vm.startBroadcast(account);

        VRFCoordinatorV2_5Mock(vrfCoordinator).addConsumer(subId, raffle);

        vm.stopBroadcast();
    }

    function addConsumerUsingConfig(address raffle) public {
        HelperConfig config = new HelperConfig();
        HelperConfig.NetworkConfig memory net = config.getConfig();

        addConsumer(
            raffle,
            net.vrfCoordinatorV2_5,
            net.subscriptionId,
            net.account
        );
    }

    // 🔥 FIX CLAVE: NO filesystem, NO DevOpsTools
    function run(address raffle) external {
        addConsumerUsingConfig(raffle);
    }
}

contract AddConsumerScript is Script {
    function run() external {
        HelperConfig config = new HelperConfig();
        HelperConfig.NetworkConfig memory net = config.getConfig();

        // ❌ NO DevOpsTools
        address raffle = net.account;
        // o mejor: pasar raffle por argumento si lo quieres real

        AddConsumer add = new AddConsumer();

        add.addConsumer(
            raffle,
            net.vrfCoordinatorV2_5,
            net.subscriptionId,
            net.account
        );
    }
}
