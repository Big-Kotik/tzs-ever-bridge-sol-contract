pragma ton-solidity >= 0.56.0;

interface TIP3TokenWallet {
    //function acceptTransfer(uint128 _value) functionID(0x67A0B95F) external;
    //function acceptMint(uint128 _value) functionID(0x4384F298) external;
    
    function root() public view responsible returns (address);
    function balance() public view responsible returns (uint128);
    function walletCode() public view responsible returns (TvmCell);
}