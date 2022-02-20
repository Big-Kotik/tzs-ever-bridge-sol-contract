pragma ton-solidity >= 0.56.0;

interface TIP3TokenWallet {
    function acceptTransfer(uint128 _value, uint256 _sender_public_key) functionID(0x67A0B95F) external;
    function acceptMint(uint128 _value) functionID(0x4384F298) external;
    
    function root() external view responsible returns (address);
    function balance() external view responsible returns (uint128);
    function walletCode() external view responsible returns (TvmCell);
}