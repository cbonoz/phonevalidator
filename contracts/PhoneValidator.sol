pragma solidity 0.6.6;
pragma experimental ABIEncoderV2;

// import "https://github.com/smartcontractkit/chainlink/evm-contracts/src/v0.6/ChainlinkClient.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.6/ChainlinkClient.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// https://docs.chain.link/docs/fulfilling-requests
// https://phonenumbervalidation.apifex.com/
// private constant VALIDATE_PHONE_URL = "https://phonenumbervalidation.apifex.com/api/v1/validate?phonenumber=%2B1%20";

contract PhoneValidator is ChainlinkClient, Ownable {
    string
        private constant VALIDATE_PHONE_URL = "https://le5f4ysh45.execute-api.us-east-1.amazonaws.com/api/validate/";

    string public lastPhone;
    bytes public lastLocation;
    string public lastRequest;
    bool public lastValid;
    uint256 public ethereumPrice;

    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    event LastPhoneValidated(
        bytes32 indexed requestId,
        string indexed phone,
        bool valid,
        string location
    );

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
        fee = 0.1 * 10**18; // 0.1 LINK
    }

    // REQUIRED PHONE FORMAT XXX-XXX-XXXX
    function requestValidatePhone(string memory _phone)
        public
        returns (bytes32 requestId)
    {
        Chainlink.Request memory req = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );

        string memory _url = getTestPath(_phone);
        req.add("get", _url);
        req.add("path", "is_valid");
        lastPhone = _phone;
        lastRequest = _url;
        return sendChainlinkRequestTo(oracle, req, fee);
    }

    /**
     * Receive the response in the form of uint256
     */

    function fulfill(bytes32 _requestId, uint256 valid)
        public
        recordChainlinkFulfillment(_requestId)
    {
        string memory _location = "";
        bool isValid = valid == 1;
        lastValid = isValid;
        emit LastPhoneValidated(_requestId, lastPhone, isValid, _location);
    }

    // UTILITY

    function getTestPath(string memory _phone)
        public
        pure
        returns (string memory)
    {
        string memory _url = string(
            abi.encodePacked(VALIDATE_PHONE_URL, _phone)
        );
        return _url;
    }

    function getChainlinkToken() public view returns (address) {
        return chainlinkTokenAddress();
    }

    function getLastLocation() public view returns (string memory) {
        string memory converted = string(lastLocation);
        return converted;
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

    function bytes32ToString(bytes32 x) public pure returns (string memory) {
        bytes memory bytesString = new bytes(32);
        uint256 charCount = 0;
        for (uint256 j = 0; j < 32; j++) {
            bytes1 char = bytes1(bytes32(uint256(x) * 2**(8 * j)));
            if (char != 0) {
                bytesString[charCount] = char;
                charCount++;
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (uint256 j = 0; j < charCount; j++) {
            bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
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