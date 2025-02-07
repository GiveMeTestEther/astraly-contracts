####################################################################################
# SPDX-License-Identifier: MIT
# @title InterfaceAll contract
# @dev put all interfaces here
# Interfaces include
# - IZkIDOContract
# - IERC4626
# - ITask
# - IZkIDOFactory
# @author zkpad
####################################################################################

%lang starknet
from starkware.cairo.common.uint256 import Uint256

from openzeppelin.introspection.IERC165 import IERC165

struct UserInfo:
    member amount : Uint256
    member reward_debt : Uint256
end

struct Purchase_Round:
    member time_starts : felt
    member time_ends : felt
    member number_of_purchases : Uint256
end

struct Registration:
    member registration_time_starts : felt
    member registration_time_ends : felt
    member number_of_registrants : Uint256
end

@contract_interface
namespace IZkPadIDOContract:
    func get_ido_launch_date() -> (res : felt):
    end

    func register_user(amount : Uint256, account : felt, nb_quest : felt) -> (res : felt):
    end

    func get_purchase_round() -> (res : Purchase_Round):
    end

    func get_registration() -> (res : Registration):
    end

    func calculate_allocation():
    end
end

@contract_interface
namespace IAccount:
    func is_valid_signature(hash : felt, signature_len : felt, signature : felt*) -> (
        is_valid : felt
    ):
    end
end

@contract_interface
namespace IZKPadIDOFactory:
    func get_ido_launch_date(id : felt) -> (res : felt):
    end

    func get_ido_address(id : felt) -> (res : felt):
    end

    func set_sale_owner_and_token(sale_owner_address : felt, sale_token_address : felt):
    end

    func is_sale_created_through_factory(sale_address : felt) -> (res : felt):
    end

    func get_lottery_ticket_contract_address() -> (lottery_ticket_address : felt):
    end

    func get_random_number_generator_address() -> (random_number_generator_address : felt):
    end

    func get_payment_token_address() -> (payment_token_address : felt):
    end

    func get_merkle_root(id : felt) -> (merkle_root : felt):
    end

    func create_ido(ido_admin : felt) -> (new_ido_contract_address : felt):
    end

    func get_ido_contract_class_hash() -> (class_hash : felt):
    end

    func set_ido_contract_class_hash(new_class_hash : felt):
    end
end

@contract_interface
namespace IERC1155_Receiver:
    func onERC1155Received(
        operator : felt, _from : felt, id : Uint256, value : Uint256, data_len : felt, data : felt*
    ) -> (selector : felt):
    end

    func onERC1155BatchReceived(
        operator : felt,
        _from : felt,
        ids_len : felt,
        ids : Uint256*,
        values_len : felt,
        values : Uint256*,
        data_len : felt,
        data : felt*,
    ) -> (selector : felt):
    end

    func supportsInterface(interfaceId : felt) -> (success : felt):
    end
end

@contract_interface
namespace IAdmin:
    func is_admin(user_address : felt) -> (res : felt):
    end
end

@contract_interface
namespace IZkStakingVault:
    func redistribute(pool_id : felt, user_address : felt, amount_to_burn : felt):
    end

    func deposited(pool_id : felt, user_address : felt) -> (res : felt):
    end

    func set_tokens_unlock_time(pool_id : felt, user_address : felt, token_unlock_time : felt):
    end
end

@contract_interface
namespace IERC4626:
    func asset() -> (asset_token_address : felt):
    end

    func totalAssets() -> (total_managed_assets : Uint256):
    end

    func convertToShares(assets : Uint256) -> (shares : Uint256):
    end

    func convertToAssets(shares : Uint256) -> (assets : Uint256):
    end

    func maxDeposit(receiver : felt) -> (max_assets : Uint256):
    end

    func previewDeposit(assets : Uint256) -> (shares : Uint256):
    end

    func deposit(assets : Uint256, receiver : felt) -> (shares : Uint256):
    end

    func maxMint(receiver : felt) -> (max_shares : Uint256):
    end

    func previewMint(shares : Uint256) -> (assets : Uint256):
    end

    func mint(shares : Uint256, receiver : felt) -> (assets : Uint256):
    end

    func maxWithdraw(owner : felt) -> (max_assets : Uint256):
    end

    func previewWithdraw(assets : Uint256) -> (shares : Uint256):
    end

    func withdraw(assets : Uint256, receiver : felt, owner : felt) -> (shares : Uint256):
    end

    func maxRedeem(owner : felt) -> (max_shares : Uint256):
    end

    func previewRedeem(shares : Uint256) -> (assets : Uint256):
    end

    func redeem(shares : Uint256, receiver : felt, owner : felt) -> (assets : Uint256):
    end
end

@contract_interface
namespace IERC20:
    func name() -> (name : felt):
    end

    func symbol() -> (symbol : felt):
    end

    func decimals() -> (decimals : felt):
    end

    func totalSupply() -> (totalSupply : Uint256):
    end

    func balanceOf(account : felt) -> (balance : Uint256):
    end

    func allowance(owner : felt, spender : felt) -> (remaining : Uint256):
    end

    func transfer(recipient : felt, amount : Uint256) -> (success : felt):
    end

    func transferFrom(sender : felt, recipient : felt, amount : Uint256) -> (success : felt):
    end

    func approve(spender : felt, amount : Uint256) -> (success : felt):
    end

    func mint(to : felt, amount : Uint256):
    end
end

const XOROSHIRO_ADDR = 0x0236b6c5722c5b5e78c215d72306f642de0424a6b56f699d43c98683bea7460d

@contract_interface
namespace IXoroshiro:
    func next() -> (rnd : felt):
    end
end

@contract_interface
namespace ITask:
    # # @notice Called by task automators to see if task needs to be executed.
    # # @dev Do not return other values as keeper behavior is undefined.
    # # @return taskReady Assumes the value 1 if automation is ready to be called and 0 otherwise.
    func probeTask() -> (taskReady : felt):
    end

    # # @notice Main endpoint for task execution. Task automators call this to execute your task.
    # # @dev This function should not have access restrictions. However, this function could
    # # still be called even if `probeTask` returns 0 and needs to be protected accordingly.
    func executeTask() -> ():
    end

    func setIDOContractAddress(address : felt) -> ():
    end
end

@contract_interface
namespace IVault:
    func feePercent() -> (fee_percent : felt):
    end

    func lockedProfit() -> (res : Uint256):
    end

    func harvestDelay() -> (harvest_delay : felt):
    end

    func harvestWindow() -> (harvest_window : felt):
    end

    func targetFloatPercent() -> (float_percent : felt):
    end

    func canHarvest() -> (yes_no : felt):
    end

    func lastHarvestWindowStart() -> (last_harvest_window_start : felt):
    end

    func getWithdrawalStack() -> (strategies_len : felt, strategies : felt*):
    end

    func rewardPerBlock() -> (reward : Uint256):
    end

    func startBlock() -> (block : felt):
    end

    func endBlock() -> (block : felt):
    end

    func lastRewardBlock() -> (block : felt):
    end

    func accTokenPerShare() -> (res : Uint256):
    end

    func getMultiplier(_from : felt, _to : felt) -> (multiplier : felt):
    end

    func userInfo(user : felt) -> (info : UserInfo):
    end

    func totalFloat() -> (float : Uint256):
    end

    func harvest(strategies_len : felt, strategies : felt*):
    end

    func setFeePercent(new_fee_percent : felt):
    end

    func setHarvestDelay(new_harvest_delay : felt):
    end

    func setHarvestWindow(new_harvest_window : felt):
    end

    func setTargetFloatPercent(float_percent : felt):
    end

    func setHarvestTaskContract(address : felt):
    end

    func updateRewardPerBlockAndEndBlock(_reward_per_block : Uint256, new_end_block : felt):
    end

    func initializer(
        name : felt,
        symbol : felt,
        asset_addr : felt,
        owner : felt,
        reward_per_block : Uint256,
        start_reward_block : felt,
        end_reward_block : felt,
    ):
    end

    func harvestRewards():
    end

    func calculatePendingRewards(user : felt) -> (rewards : Uint256):
    end

    func pushToWithdrawalStack(strategy : felt):
    end

    func popFromWithdrawalStack():
    end

    func setWithdrawalStack(stack_len : felt, stack : felt*):
    end

    func replaceWithdrawalStackIndex(index : felt, address : felt):
    end

    func swapWithdrawalStackIndexes(index1 : felt, index2 : felt):
    end
end

@contract_interface
namespace IERC721:
    func balanceOf(owner : felt) -> (balance : Uint256):
    end

    func ownerOf(tokenId : Uint256) -> (owner : felt):
    end

    func safeTransferFrom(
        from_ : felt, to : felt, tokenId : Uint256, data_len : felt, data : felt*
    ):
    end

    func transferFrom(from_ : felt, to : felt, tokenId : Uint256):
    end

    func approve(approved : felt, tokenId : Uint256):
    end

    func setApprovalForAll(operator : felt, approved : felt):
    end

    func getApproved(tokenId : Uint256) -> (approved : felt):
    end

    func isApprovedForAll(owner : felt, operator : felt) -> (isApproved : felt):
    end

    func mint(to : felt, tokenId : Uint256):
    end
end
