%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.starknet.common.syscalls import get_caller_address, get_block_timestamp, deploy

from openzeppelin.access.ownable import Ownable

from InterfaceAll import IZkPadIDOContract, ITask

@storage_var
func ido_contract_addresses(id : felt) -> (address : felt):
end

@storage_var
func current_id() -> (id : felt):
end

@storage_var
func random_number_generator_address() -> (res : felt):
end

@storage_var
func task_address() -> (res : felt):
end

@storage_var
func lottery_ticket_contract_address() -> (res : felt):
end

@storage_var
func payment_token_address() -> (res : felt):
end

@storage_var
func merkle_root(id : felt) -> (root : felt):
end

@storage_var
func ido_contract_class_hash() -> (class_hash : felt):
end

@event
func IDO_Created(id : felt, address : felt):
end

@view
func get_ido_launch_date{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    id : felt
) -> (launch_date : felt):
    let (the_address : felt) = ido_contract_addresses.read(id)
    let (launch_date) = IZkPadIDOContract.get_ido_launch_date(contract_address=the_address)
    return (launch_date)
end

@view
func get_ido_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    id : felt
) -> (address : felt):
    alloc_locals
    let (the_address : felt) = ido_contract_addresses.read(id)

    return (the_address)
end

@view
func get_random_number_generator_address{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}() -> (res : felt):
    let (rnd_nbr_gen_adr) = random_number_generator_address.read()
    return (res=rnd_nbr_gen_adr)
end

@view
func get_lottery_ticket_contract_address{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}() -> (res : felt):
    let (ltry_tckt_addr) = lottery_ticket_contract_address.read()
    return (res=ltry_tckt_addr)
end

@view
func get_payment_token_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ) -> (payment_token_address : felt):
    let (pmt_tkn_addr) = payment_token_address.read()
    return (payment_token_address=pmt_tkn_addr)
end

@view
func get_merkle_root{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    id : felt
) -> (merkle_root : felt):
    let (res : felt) = merkle_root.read(id)
    return (merkle_root=res)
end

@view
func get_ido_contract_class_hash{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    ) -> (class_hash : felt):
    let (class_hash : felt) = ido_contract_class_hash.read()
    return (class_hash)
end

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(_ido_contract_class_hash : felt, owner_: felt):
    Ownable.initializer(owner_)

    ido_contract_class_hash.write(_ido_contract_class_hash)
    return ()
end

@external
func create_ido{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(ido_admin : felt) -> (new_ido_contract_address : felt):
    alloc_locals
    Ownable.assert_only_owner()
    let (_id) = current_id.read()
    let (ido_contract_class : felt) = get_ido_contract_class_hash()
    with_attr error_message("IDO contract class hash is not set"):
        assert_not_zero(ido_contract_class)
    end
    let (new_ido_contract_address : felt) = deploy(
        class_hash=ido_contract_class,
        contract_address_salt=_id,
        constructor_calldata_size=1,
        constructor_calldata=cast(new (ido_admin), felt*),
    )
    ido_contract_addresses.write(_id, new_ido_contract_address)
    let (task_addr : felt) = task_address.read()
    ITask.setIDOContractAddress(task_addr, new_ido_contract_address)
    current_id.write(_id + 1)
    IDO_Created.emit(_id, new_ido_contract_address)
    return (new_ido_contract_address)
end

@external
func set_random_number_generator_address{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(rnd_nbr_gen_adr : felt):
    Ownable.assert_only_owner()
    with_attr error_message("Invalid address"):
        assert_not_zero(rnd_nbr_gen_adr)
    end
    random_number_generator_address.write(rnd_nbr_gen_adr)
    return ()
end

@external
func set_task_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    task_addr : felt
):
    Ownable.assert_only_owner()
    with_attr error_message("Invalid address"):
        assert_not_zero(task_addr)
    end
    task_address.write(task_addr)
    return ()
end

@external
func set_lottery_ticket_contract_address{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(_lottery_ticket_contract_address : felt):
    Ownable.assert_only_owner()
    with_attr error_message("Invalid address"):
        assert_not_zero(_lottery_ticket_contract_address)
    end
    lottery_ticket_contract_address.write(_lottery_ticket_contract_address)
    return ()
end

@external
func set_payment_token_address{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    _pmt_tkn_addr : felt
):
    Ownable.assert_only_owner()
    with_attr error_message("Invalid address"):
        assert_not_zero(_pmt_tkn_addr)
    end
    payment_token_address.write(_pmt_tkn_addr)
    return ()
end

@external
func set_merkle_root{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    _merkle_root : felt, _id : felt
):
    Ownable.assert_only_owner()
    # with_attr error_message("Invalid id"):
    #     assert_not_zero(_id)
    # end
    with_attr error_message("Invalid merkle root"):
        assert_not_zero(_merkle_root)
    end
    merkle_root.write(_id, _merkle_root)
    return ()
end

@external
func set_ido_contract_class_hash{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
    new_class_hash : felt
):
    Ownable.assert_only_owner()
    with_attr error_message("Invalid contract class hash"):
        assert_not_zero(new_class_hash)
    end
    ido_contract_class_hash.write(new_class_hash)
    return ()
end
