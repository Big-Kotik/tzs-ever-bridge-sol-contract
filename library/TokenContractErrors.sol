pragma ton-solidity >= 0.56.0;

library TokenContractErrors {
    //ROOT_NOT_SET
    //WALLET_NOT_SET
    //
    //WRONG_AMOUNT
    //NOT_ENOUGH_BALANCE       
    //LOW_GAS_VALUE                                                          
    uint8 constant ERROR_TVM_PUBKEY_NOT_SET = 100;
    uint8 constant ERROR_MESSAGE_SENDER_IS_NOT_MY_OWNER = 101;
    uint8 constant ERROR_DEPLOY_EVER_TO_SMALL = 102;
    uint8 constant ERROR_INSUFFICIENT_EVERS_ON_CONTRACT_BALANCE = 103;
    uint8 constant ERROR_DEPLOY_WALLET_PUBKEY_NOT_SET = 104;
    uint8 constant ERROR_ACCEPT_BURN_WRONG_SENDER = 110;
    uint8 constant ERROR_CANNOT_MINT_ZERO_TOKENS = 111;
    uint8 constant ERROR_MESSAGE_SENDER_IS_NOT_QUORUM = 112;
    uint8 constant ERROR_ROOT_ADDRESS_NOT_SET = 113;
    uint8 constant ERROR_QUORUM_ADDRESS_NOT_SET = 114;

    uint8 constant ERROR_ACCEPT_TRANSFER_WRONG_SENDER = 105;
    uint8 constant ERROR_MESSAGE_SENDER_IS_NOT_ROOT = 106;
    uint8 constant ERROR_TRANSFER_INSUFFICIENT_TOKEN_BALANCE = 107;
    uint8 constant ERROR_TRANSFER_INSUFFICIENT_EVER_BALANCE = 108;
    uint8 constant ERROR_TRANSFER_WRONG_RECIPIENT = 109;
}