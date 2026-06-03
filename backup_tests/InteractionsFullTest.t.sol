// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {CreateSubscription, FundSubscription, AddConsumer} from "../../script/Interactions.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract InteractionsFullTest is Test {
    function testFullInteractionsFlow() public {
        // Arrange: config local o según chain
        HelperConfig config = new HelperConfig();
        HelperConfig.NetworkConfig memory net = config.getConfig();

        // 1. Create subscription
        CreateSubscription create = new CreateSubscription();

        (uint256 subId, address subOwner) = create.createSubscription(net.vrfCoordinatorV2_5, net.account);

        // sanity check (evita warnings de unused vars)
        assert(subId > 0);
        assert(subOwner != address(0));

        // 2. Fund subscription
        FundSubscription fund = new FundSubscription();

        fund.fundSubscription(net.vrfCoordinatorV2_5, subId, net.link, net.account);

        // 3. Add consumer (mock raffle address para test)
        AddConsumer add = new AddConsumer();

        add.addConsumer(
            address(1), // mock Raffle contract
            net.vrfCoordinatorV2_5,
            subId,
            net.account
        );

        // final assertion to ensure flow executed
        assert(subId != 0);
    }
}
