pragma ton-solidity >= 0.56.0;
pragma AbiHeader pubkey;

import "../abstract/Ownable.sol";
import "../interfaces/ExtendedTokenRoot.sol";
import "../library/TokenContractFlags.sol";

contract Quorum is Ownable {
    uint16 static threshold_; //uint16?
    uint256[] relayPubKeys_;
    address static rootAddress_;
    
    struct Transfer {
        uint256 recipientPublicKey;
        uint128 amount;
    }

    struct Signature {
        uint256 signHighPart;
        uint256 signLowPart;
    }

    constructor() public {
        require(tvm.pubkey() != 0, TokenContractErrors.ERROR_TVM_PUBKEY_NOT_SET);
        //require(rootAddress_ != address(0), TokenContractErrors.ERROR_ROOT_ADDRESS_NOT_SET);
        tvm.accept();
    }

    /*
        @dev: External inbound message
    */
    function sendTransaction(Transfer _transfer, Signature[] _signatures) view external {
        require(_signatures.length == relayPubKeys_.length);
        tvm.accept();
        string representation = format("{}-{}", _transfer.recipientPublicKey, _transfer.amount);
        uint256 transferHash = sha256(representation);
        uint signatureCount = 0;
        for (uint i = 0; i < _signatures.length; i++) {
            bool signed = tvm.checkSign(transferHash, 
                                        _signatures[i].signHighPart,
                                        _signatures[i].signLowPart, 
                                        relayPubKeys_[i]);
            if (signed) {
                signatureCount++;
            }
        }
        if (signatureCount >= threshold_) {
            //mint and send
            ExtendedTokenRoot(rootAddress_).mint{flag: TokenContractFlags.SENDER_PAYS_FEES, bounce: false} (_transfer.amount, _transfer.recipientPublicKey);
        }
    }
    
    function setThreshold(uint16 _threshold) external onlyOwner {
        tvm.accept();
        threshold_ = _threshold;
    }

    function setRootAddress(address _rootAddress) external onlyOwner {
        tvm.accept();
        rootAddress_ = _rootAddress;
    }

    function setRelayPubkeys(uint256[] _relayPubKeys) external onlyOwner {
        tvm.accept();
        relayPubKeys_ = _relayPubKeys;
    }
}