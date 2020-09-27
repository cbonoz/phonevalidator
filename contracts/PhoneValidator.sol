pragma solidity 0.6.6;
pragma experimental ABIEncoderV2;

import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";

// https://phonenumbervalidation.apifex.com/

contract PhoneValidator is ChainlinkClient, Ownable {
    uint256 private constant ORACLE_PAYMENT = 0.1 * 10**18; // 0.1 LINK
    string
        private constant VALIDATE_PHONE_URL = "https://phonenumbervalidation.apifex.com/api/v1/validate?phonenumber=%2B1%20";

    string public lastPhone;
    string public lastLocation;

    address private oracle;
    bytes32 private jobId;

    event LastPhoneValidated(
        bytes32 indexed requestId,
        string indexed phone,
        bool valid,
        string location
    );

    uint256 public data;

    /**
     * @notice Deploy the contract with a specified address for the LINK
     * and Oracle contract addresses
     * @dev Sets the storage for the specified addresses
     * @param _link The address of the LINK token contract
     */
    constructor(address _link) public {
        if (_link == address(0)) {
            setPublicChainlinkToken();
        } else {
            setChainlinkToken(_link);
        }
        oracle = 0x2f90A6D021db21e1B2A077c5a37B3C7E75D15b7e;
        jobId = "29fa9aa13bf1468788b7cc4a500a45b8";
    }

    // REQUIRED PHONE FORMAT XXX-XXX-XXXX
    function validatePhone(string memory _phone) public onlyOwner {
        Chainlink.Request memory req = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfillLastPhone.selector
        );

        string memory _url = string(
            abi.encodePacked(VALIDATE_PHONE_URL, _phone)
        );
        req.add("get", _url);
        req.add("path", "location");
        lastPhone = _phone;
        sendChainlinkRequestTo(oracle, req, ORACLE_PAYMENT);
    }

    function fulfillLastPhone(bytes32 _requestId, string memory _data)
        public
        recordChainlinkFulfillment(_requestId)
    {
        emit LastPhoneValidated(_requestId, lastPhone, true, _data);
        lastPhone = _data;
    }

    // UTILITY

    function getChainlinkToken() public view returns (address) {
        return chainlinkTokenAddress();
    }

    /**
     * @notice Allows the owner to withdraw any LINK balance on the contract
     */
    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        require(
            link.transfer(msg.sender, link.balanceOf(address(this))),
            "Unable to transfer"
        );
    }

    function cancelRequest(
        bytes32 _requestId,
        uint256 _payment,
        bytes4 _callbackFunctionId,
        uint256 _expiration
    ) public onlyOwner {
        cancelChainlinkRequest(
            _requestId,
            _payment,
            _callbackFunctionId,
            _expiration
        );
    }
}
