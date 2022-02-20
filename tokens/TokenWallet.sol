pragma ton-solidity >= 0.56.0;
pragma AbiHeader pubkey;

import "../interfaces/TIP3TokenWallet.sol";
import "../library/TokenContractFlags.sol";
import "../library/TokenContractErrors.sol";
import "../abstract/Ownable.sol";

contract TokenWallet is TIP3TokenWallet, Ownable {
    address static rootAddress_;
    uint128 balance_;

    constructor() public {
        require(tvm.pubkey() != 0, TokenContractErrors.ERROR_TVM_PUBKEY_NOT_SET);
        require(rootAddress_ != address(0), TokenContractErrors.ERROR_ROOT_ADDRESS_NOT_SET);
        tvm.accept();
    }

    modifier onlyRoot() {
        require(msg.sender == rootAddress_, TokenContractErrors.ERROR_MESSAGE_SENDER_IS_NOT_ROOT);
        _;
    }

    function acceptTransfer(uint128 _value, uint256 _senderPublicKey) functionID(0x67A0B95F) override external {
        require(msg.sender == _getWalletAddress(_getStateInit(_senderPublicKey)), TokenContractErrors.ERROR_ACCEPT_TRANSFER_WRONG_SENDER);
        balance_ += _value;
        msg.sender.transfer({value: 0, bounce: false, flag: TokenContractFlags.REMAINING_VALUE});
    }

    function acceptMint(uint128 _value) functionID(0x4384F298) override external onlyRoot {
        balance_ += _value;
        msg.sender.transfer({value: 0, bounce: false, flag: TokenContractFlags.REMAINING_VALUE});
    }

    /*
        @dev External inbound message
        @notice Taken from https://github.com/mnill/everscale-education-simple-tip3
    */
    function transferToRecipient(
    uint256 _recipientPublicKey,
    uint128 _value,
    uint128 _deployEvers,
    uint128 _transferEvers
  ) external onlyOwner {
    require(_value > 0);
    require(_value <= balance_, TokenContractErrors.ERROR_TRANSFER_INSUFFICIENT_TOKEN_BALANCE);
    require(_recipientPublicKey != 0, TokenContractErrors.ERROR_TRANSFER_WRONG_RECIPIENT);
    require(_recipientPublicKey != tvm.pubkey(), TokenContractErrors.ERROR_TRANSFER_WRONG_RECIPIENT);
    require(address(this).balance > _deployEvers + _transferEvers, TokenContractErrors.ERROR_TRANSFER_INSUFFICIENT_EVER_BALANCE);

    tvm.accept();
    TvmCell stateInit = _getStateInit(_recipientPublicKey);
    address to;
    if (_deployEvers > 0) {
        to = new TokenWallet{
            stateInit: stateInit,
            value: _deployEvers, //??
            wid: address(this).wid,
            bounce: false,
            flag: TokenContractFlags.SENDER_PAYS_FEES
        }();
    } else {
        to = _getWalletAddress(stateInit);
    }
    balance_ -= _value;
    TIP3TokenWallet(to).acceptTransfer{value: _transferEvers, flag: TokenContractFlags.SENDER_PAYS_FEES, bounce: true} (
        _value,
        tvm.pubkey()
    );
  }
    
    function root() override external view responsible returns (address) {
        return{value: 0, bounce: false, flag: TokenContractFlags.REMAINING_VALUE} rootAddress_;
    }

    function balance() override external view responsible returns (uint128) {
        return{value: 0, bounce: false, flag: TokenContractFlags.REMAINING_VALUE} balance_;
    }

    function walletCode() override external view responsible returns (TvmCell) {
        return{value: 0, bounce: false, flag: TokenContractFlags.REMAINING_VALUE} tvm.code();
    }

    function _getStateInit(uint256 _walletPublicKey) private view returns (TvmCell) {
        return tvm.buildStateInit({
          contr: TokenWallet,
          varInit: {
              rootAddress_: rootAddress_
          },
          pubkey: _walletPublicKey,
          code: tvm.code()
        });
    }
    function _getWalletAddress(TvmCell _stateInit) private pure returns (address) {
        return address(tvm.hash(_stateInit));
    }

    onBounce(TvmSlice body) external {
        tvm.accept();
        uint32 functionId = body.decode(uint32);
        if(functionId == tvm.functionId(TIP3TokenWallet.acceptTransfer)) {
            uint128 amount = body.decode(uint128);
            balance_ += amount;
        }
    }
    //TODO: burn
}