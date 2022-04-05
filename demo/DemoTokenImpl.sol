pragma ton-solidity >= 0.56.0;
pragma AbiHeader pubkey;

import "../interfaces/DemoToken.sol";
import "../library/TokenContractFlags.sol";
import "../library/TokenContractErrors.sol";
import "../abstract/Ownable.sol";

contract DemoTokenImpl is DemoToken, Ownable {

    address quorumAddress_;
    mapping(address => uint128) ledger_;

    event UnwrapTokenEvent(string addr, uint128 amount);

    modifier onlyQuorum() {
        require(msg.sender == quorumAddress_, TokenContractErrors.ERROR_MESSAGE_SENDER_IS_NOT_QUORUM);
        _;
    }

    constructor() public {
        require(tvm.pubkey() != 0, TokenContractErrors.ERROR_TVM_PUBKEY_NOT_SET);
        tvm.accept();
    }
    
    function mint(uint128 _value, address _recepient) override external onlyQuorum {
        ledger_.getSet(_recepient, ledger_[_recepient] + _value);
        msg.sender.transfer({value: 0, bounce: false, flag: TokenContractFlags.REMAINING_VALUE});
    }

    function burn(uint128 _value, address _recepient, string destination) override external {
        uint128 remainingValue = ledger_[_recepient];
        require(remainingValue >= _value);
        tvm.accept();
        ledger_.replace(_recepient, remainingValue - _value);
        emit UnwrapTokenEvent(destination, _value);
    }

    function getBalance(address _recepient) external view returns(uint128) {
        tvm.accept();
        return ledger_[_recepient];
    }

    function setQuorumAddress(address _quorumAddress) external onlyOwner {
        tvm.accept();
        quorumAddress_ = _quorumAddress;
    }
}