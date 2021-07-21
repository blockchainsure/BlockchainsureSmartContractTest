pragma solidity ^0.4.14;

import "./Ownable.sol";
import "./BlockchaInsureCountries.sol";

//import "./SafeMath.sol";

library SafeMath {
    function mul(uint256 a, uint256 b) internal constant returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal constant returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal constant returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal constant returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract BlockchaInsurePolicy is Ownable {
    using SafeMath for uint256;

    uint256 public totalInsurers;
    uint256 public totalClaimsPaid;

    uint128 public investmentsLimit;

    uint8 constant DECIMAL_PRECISION = 8;
    uint24 constant ALLOWED_RETURN_INTERVAL_SEC = 24 * 60 * 60; // each 24 hours

    // Insurance data
    uint256 public policiesLimit;
    mapping(address => mapping(string => PolicyData)) insurancePolicies;
    mapping(address => uint256) insurancePoliciesIndex;
    BlockchaInsureCountries insuranceParameters;
    uint256 public basePremium;
    uint256 public maxPayout;
    uint256 loading;
    uint256 public writtenPremiumAmount;
    uint32 public lastPolicyDate;

    event Insured(address insurer, string packageId, uint256 insurancePrice);
    event Claimed(uint256 payout);

    struct PolicyData {
        PackageData package;
        uint256 maxPayout;
        uint256 totalPrice;
        bool claimed;
        bool confirmed;
    }

    struct PackageData {
        string packageId;
        string packageFrom;
        string packageTo;
        uint256 packageValue;
    }

    function BlockchaInsurePolicy(address _insuranceParameters) {
        // Initial funds

        setInitialInsuranceParameters(_insuranceParameters);
    }

    // Loads smart contract properties
    function setInitialInsuranceParameters(address _insuranceParameters)
        internal
    {
        insuranceParameters = BlockchaInsureCountries(_insuranceParameters);

        // Base premium (0.001 ETH)
        basePremium = 1000000000000000;

        // Max payout (0.01 ETH)
        maxPayout = 10000000000000000;

        policiesLimit = 10000;

        // Loading percentage (expenses, etc)
        loading = 50;
    }

    // fallback functon not to take ethers
    function() public payable {
        //revert();
    }

    // policy part
    // More parameters should be included
    // That function calculates the policy price based on parameters.
    function policyPrice(
        string countryFrom,
        string countryTo,
        uint256 packageValue
    ) public constant returns (uint256 price) {
        // set defaults
        uint256 countryFromMultiplier = insuranceParameters.getParameter(
            "country",
            countryFrom
        );
        uint256 countryToMultiplier = insuranceParameters.getParameter(
            "country",
            countryTo
        );

        // / 100 is due to Solidity not supporting doubles
        uint256 officePremium = (packageValue * countryFromMultiplier) /
            (packageValue * countryToMultiplier);
        return officePremium;
    }

    // Function to insure an item, here run the PolicyPrice and setup all the policy settings.
    function insure(
        string packageId,
        string countryFrom,
        string countryTo,
        uint256 packageValue
    ) public payable returns (bool insured) {
        require(insurancePoliciesIndex[msg.sender] <= policiesLimit);
        uint256 totalPrice = policyPrice(countryFrom, countryTo, packageValue);

        writtenPremiumAmount += totalPrice;

        require(msg.value >= totalPrice);

        var packageData = PackageData(
            packageId,
            countryFrom,
            countryTo,
            packageValue
        );
        var policy = PolicyData(
            packageData,
            maxPayout,
            totalPrice,
            false,
            false
        );

        insurancePoliciesIndex[msg.sender] =
            insurancePoliciesIndex[msg.sender] +
            1;
        insurancePolicies[msg.sender][policy.package.packageId] = policy;

        Insured(msg.sender, packageId, msg.value);
        return true;
    }

    // Function to confirmPolicy, an unconfirmed policy can't be claimed. It is onlyOwner
    function confirmPolicy(address policyOwner, string packageId)
        public
        onlyOwner
    {
        insurancePolicies[policyOwner][packageId].confirmed = true;
    }

    // Function to claim the insurance payout, it could be executed just by the policy owner but needs to be confirmed by the smart contract owner.
    function claim(string packageId) public returns (bool) {
        require(bytes(packageId).length != 0);
        var userPolicy = insurancePolicies[msg.sender][packageId];

        if (!userPolicy.claimed && userPolicy.confirmed) {
            if (this.balance > userPolicy.maxPayout) {
                userPolicy.claimed = true;

                totalClaimsPaid = totalClaimsPaid + userPolicy.maxPayout;
                msg.sender.transfer(userPolicy.maxPayout);
                Claimed(userPolicy.maxPayout);
                return true;
            }
            return false;
        } else {
            revert();
        }
    }

    // check if user policy has been claimed
    function claimed(string packageId) public constant returns (bool) {
        return insurancePolicies[msg.sender][packageId].claimed;
    }

    // check tracking items limits
    function validateNumberInsuredItems() public constant returns (bool) {
        return insurancePoliciesIndex[msg.sender] <= policiesLimit;
    }

    // check if tracking number is already insured
    function checkPolicyExists(string packageId)
        public
        constant
        returns (bool)
    {
        var userPolicy = insurancePolicies[msg.sender][packageId];
        return keccak256(userPolicy.package.packageId) == keccak256(packageId);
    }
}
