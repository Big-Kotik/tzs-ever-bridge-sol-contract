pragma ton-solidity >= 0.56.0;
pragma AbiHeader pubkey;

import "../intefaces/DemoToken.sol";
import "../library/TokenContractFlags.sol";
import "../library/TokenContractErrors.sol";

contract DemoTokenImpl is DemoToken {

    address static quorumAddress_;
    mapping(address => uint128) ledger_;

    modifier onlyQuorum() {
        require(msg.sender == quorumAddress_, TokenContractErrors.ERROR_MESSAGE_SENDER_IS_NOT_QUORUM);
        _;
    }

    constructor() public {
        require(tvm.pubkey() != 0, TokenContractErrors.ERROR_TVM_PUBKEY_NOT_SET);
        require(quorumAddress_ != address(0), TokenContractErrors.ERROR_QUORUM_ADDRESS_NOT_SET);
        tvm.accept();
    }
    
    function mint(uint128 _value, address _recepient) override external onlyQuorum {
        ledger_.getSet(_recepient, ledger_[_recepient] + _value);
        msg.sender.transfer({value: 0, bounce: false, flag: TokenContractFlags.REMAINING_VALUE});
    }

    function burn(uint128 _value, address _recepient) override external {
        uint128 remainingValue = ledger_[_recepient];
        require(remainingValue >= value);
        tvm.accept();
        ledger_.replace(_recepient, remainingValue - _value);
    } 
}