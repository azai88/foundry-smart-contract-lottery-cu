// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract HelperConfigTest is Test {
    function testGetConfigLocalChain() public {
        HelperConfig config = new HelperConfig();

        vm.chainId(31337);

        HelperConfig.NetworkConfig memory net = config.getConfig();

        assertTrue(net.vrfCoordinatorV2_5 != address(0));
    }

    function testInvalidChainReverts() public {
        HelperConfig config = new HelperConfig();

        vm.expectRevert(HelperConfig.HelperConfig__InvalidChainId.selector);
        config.getConfigByChainId(999999);
    }
}
