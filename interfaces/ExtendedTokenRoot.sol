pragma ton-solidity >= 0.56.0;
import "./TIP3TokenRoot.sol";

interface ExtendedTokenRoot is TIP3TokenRoot {
     function mint(uint128 _value, uint256 _recipientPublicKey) external;
}