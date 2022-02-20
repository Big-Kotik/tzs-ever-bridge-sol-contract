pragma ton-solidity >= 0.56.0;
pragma AbiHeader pubkey;

import "../interfaces/ExtendedTokenRoot.sol";
import "../interfaces/TIP3TokenWallet.sol";
import "../library/TokenContractFlags.sol";
import "../library/TokenContractErrors.sol";
import "../abstract/Ownable.sol";
import "./TokenWallet.sol";

contract TokenRoot is ExtendedTokenRoot, Ownable {
    string static name_;
    string static symbol_;
    uint8 static decimals_;
    address static quorumAddress_;

    TvmCell static walletCode_;

    uint128 totalSupply_;

    modifier onlyQuorum() {
        require(msg.sender == quorumAddress_, TokenContractErrors.ERROR_MESSAGE_SENDER_IS_NOT_QUORUM);
        _;
    }

    constructor() {
        require(tvm.pubkey() != 0, TokenContractErrors.ERROR_TVM_PUBKEY_NOT_SET);
        //require(quorumAddress_ != address(0), TokenContractErrors.ERROR_QUORUM_ADDRESS_NOT_SET);
        tvm.accept();
    }

    function acceptBurn(uint128 _value, uint256 _senderPublicKey) functionID(0x192B51B1) override external {
        require(msg.sender == _getWalletAddress(_senderPublicKey), TokenContractErrors.ERROR_ACCEPT_BURN_WRONG_SENDER);
        totalSupply_ -= _value;
        msg.sender.transfer({value: 0, bounce: false, flag: TokenContractFlags.REMAINING_VALUE});
    }
    
    function mint(uint128 _value, uint256 _recipientPublicKey) override external onlyQuorum {
        require(_value > 0, TokenContractErrors.ERROR_CANNOT_MINT_ZERO_TOKENS);
        totalSupply_ += _value;
        address to = _getWalletAddress(_recipientPublicKey);
        TIP3TokenWallet(to).acceptMint{flag: TokenContractFlags.SENDER_PAYS_FEES, bounce: true} (_value);
        //TODO: return remaining evers to sender, bounce acceptMint
    }

    function name() override external view responsible returns (string) {
        return{value: 0, bounce: false, flag: TokenContractFlags.REMAINING_VALUE} name_;
    }

    function symbol() override external view responsible returns (string) {
        return{value: 0, bounce: false, flag: TokenContractFlags.REMAINING_VALUE} symbol_;
    }

    function decimals() override external view responsible returns (uint8) {
        return{value: 0, bounce: false, flag: TokenContractFlags.REMAINING_VALUE} decimals_;
    } 

    function totalSupply() override external view responsible returns (uint128) {
        return{value: 0, bounce: false, flag: TokenContractFlags.REMAINING_VALUE} totalSupply_;
    }

    function walletCode() override external view responsible returns (TvmCell) {
        return{value: 0, bounce: false, flag: TokenContractFlags.REMAINING_VALUE} walletCode_;
    }
     
    function _getWalletAddress(uint256 _walletPublicKey) private view returns (address) {
        TvmCell stateInit = tvm.buildStateInit({
            contr: TokenWallet,
            varInit: {
                rootAddress_: address(this)
            },
            pubkey: _walletPublicKey,
            code: walletCode_
        });
        return address(tvm.hash(stateInit));
    }
    //TODO: deploy
}