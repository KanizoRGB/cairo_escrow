core::starknet::ContractAddress;
#[starknet::interface]
trait IEscrowFunctions<TContractState> {
    fn deposit(ref self: TContractState, amount: felt252);
    fn confirm_delivery(self: @TContractState);
    fn refund_buyer(self: @TContractState);
}

#[starknet::contract]
mod escrow {
    use core::starknet::ContractAddress;
    use core::starknet::get_caller_address;
    use starknet::storage::{
        Map, StorageMapReadAccess, StorageMapWriteAccess, StoragePointerReadAccess,
        StoragePointerWriteAccess
    };

    #[storage]
    struct Storage {
        buyer:ContractAddress,
        seller:ContractAddress,
        agent:ContractAddress,
        balance: u256, 
        acct_balances:Map<ContractAddress,u256>
    }

    #[constructor]
    fn constructor(
        ref self:ContractState,
        _seller:ContractAddress,
        _agent:ContractAddress
    ){
        let buyer = get_caller_address();
        let seller = _seller;
        let agent = _agent;
    }

    #[abi(embed_v0)]
    impl EscrowFunctions of super::IEscrowFunctions<ContractState> {
        fn deposit(ref self: ContractState, amount: felt252) {
            assert!(amount != 0, 'Amount cannot be 0');
            self.balance = amount;
            let caller_address:ContractAddress = get_caller_address();

            let caller_balance = self.acct_balances.read(caller_address)
            caller_balance-=amount;
            self.balance.write(amount);
        }

        fn confirm_delivery(self: @ContractState){
            let caller:ContractAddress = get_caller_address()
            assert!(caller=self.agent)

            self.acct_balances.write(self.seller,self.acct_balances.read(self.seller)+self.balance)
            //Your code goes here
        }
        fn refund_buyer(self:@ContractState){
            let caller:ContractAddress = get_caller_address()
            assert!(caller=self.agent)

            self.acct_balances.write(self.buyer,self.acct_balances.read(self.buyer)+self.balance)
            //Your code goes here
        }
    }
}
