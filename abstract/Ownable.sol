pragma ton-solidity >= 0.56.0;

import "../library/TokenContractErrors.sol";

abstract contract Ownable {
    modifier onlyOwner() {
        require(tvm.pubkey() != 0 && msg.pubkey() == tvm.pubkey(), TokenContractErrors.ERROR_MESSAGE_SENDER_IS_NOT_MY_OWNER);
        _;
    }
}