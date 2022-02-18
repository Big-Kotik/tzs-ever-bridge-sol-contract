pragma ton-solidity >= 0.56.0;

interface TIP3TokenRoot {
    //function acceptBurn(uint128 _value) functionID(0x192B51B1) public view responsible;
    
    function name() public view responsible returns (string);
    function symbol() public view responsible returns (string);
    function decimals() public view responsible returns (uint8); 
    function totalSupply() public view responsible returns (uint128);
    function walletCode() public view responsible returns (TvmCell);
}