pragma ton-solidity >= 0.35.0;

import "../interfaces/TIP3TokenRoot.sol";

contract TokenRoot is TIP3TokenRoot {
    string name_;
    string symbol_;
    uint8 decimals_;

    TvmCell static walletCode_;

    uint128 totalSupply_;

    function name() public view responsible returns (string) {
        return {/*todo ...*/} name_;
    }

    function symbol() public view responsible returns (string);
        return {/*todo ...*/} symbol_;
    }

    function decimals() public view responsible returns (uint8) {
        return {/*todo ...*/} decimals_;
    } 

    function totalSupply() public view responsible returns (uint128) {
        return {/*todo ...*/} totalSupply_;
    }

    function walletCode() public view responsible returns (TvmCell) {
        return {/*todo ...*/} walletCode_;
    }

}