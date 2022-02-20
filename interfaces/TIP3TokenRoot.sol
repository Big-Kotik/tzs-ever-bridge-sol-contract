pragma ton-solidity >= 0.56.0;

interface TIP3TokenRoot {
    function acceptBurn(uint128 _value, uint256 _senderPublicKey) functionID(0x192B51B1) external;
    
    function name() external view responsible returns (string);
    function symbol() external view responsible returns (string);
    function decimals() external view responsible returns (uint8); 
    function totalSupply() external view responsible returns (uint128);
    function walletCode() external view responsible returns (TvmCell);
}