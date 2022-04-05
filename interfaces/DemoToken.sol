pragma ton-solidity >= 0.56.0;
pragma AbiHeader pubkey;

interface DemoToken {
    function mint(uint128 _value, address _recepient) external;
    function burn(uint128 _value, address _recepient, string destination) external;
}