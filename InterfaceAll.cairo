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

@contract_interface
namespace IZkPadIDOContract:
    func get_ido_launch_date() -> (res : felt):
    end

    func register_user(amount : Uint256, account : felt) -> (res : felt):
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
end

@contract_interface
namespace IERC1155_Receiver:
    func onERC1155Received(
            operator : felt, _from : felt, id : Uint256, value : Uint256, data_len : felt,
            data : felt*) -> (selector : felt):
    end

    func onERC1155BatchReceived(
            operator : felt, _from : felt, ids_len : felt, ids : Uint256*, values_len : felt,
            values : Uint256*, data_len : felt, data : felt*) -> (selector : felt):
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
    func redistribute(
        pool_id : felt, 
        user_address : felt,
        amount_to_burn : felt):
    end

    func deposited(pool_id : felt, user_address : felt) -> (res : felt):
    end

    func set_tokens_unlock_time(
        pool_id : felt,
        user_address : felt,
        token_unlock_time : felt
    ):
    end
end

@contract_interface
namespace IERC4626:
    func asset() -> (assetTokenAddress : felt):
    end

    func totalAssets() -> (totalManagedAssets : Uint256):
    end

    func convertToShares(assets : Uint256) -> (shares : Uint256):
    end

    func convertToAssets(shares : Uint256) -> (assets : Uint256):
    end

    func maxDeposit(receiver : felt) -> (maxAssets : Uint256):
    end

    func previewDeposit(assets : Uint256) -> (shares : Uint256):
    end

    func deposit(assets : Uint256, receiver : felt) -> (shares : Uint256):
    end

    func maxMint(receiver : felt) -> (maxShares : Uint256):
    end

    func previewMint(shares : Uint256) -> (assets : Uint256):
    end

    func mint(shares : Uint256, receiver : felt) -> (assets : Uint256):
    end

    func maxWithdraw(owner : felt) -> (maxAssets : Uint256):
    end

    func previewWithdraw(assets : Uint256) -> (shares : Uint256):
    end

    func withdraw(assets : Uint256, receiver : felt, owner : felt) -> (shares : Uint256):
    end

    func maxRedeem(owner : felt) -> (maxShares : Uint256):
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
end

const XOROSHIRO_ADDR = 0x0236b6c5722c5b5e78c215d72306f642de0424a6b56f699d43c98683bea7460d

@contract_interface
namespace IXoroshiro:
    func next() -> (rnd : felt):
    end
end

@contract_interface
namespace ITask:
    ## @notice Called by task automators to see if task needs to be executed.
    ## @dev Do not return other values as keeper behavior is undefined.
    ## @return taskReady Assumes the value 1 if automation is ready to be called and 0 otherwise.
    func probeTask() -> (taskReady: felt):
    end

    ## @notice Main endpoint for task execution. Task automators call this to execute your task.
    ## @dev This function should not have access restrictions. However, this function could
    ## still be called even if `probeTask` returns 0 and needs to be protected accordingly.
    func executeTask() -> ():
    end
end
