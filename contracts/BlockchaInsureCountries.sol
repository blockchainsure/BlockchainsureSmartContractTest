pragma solidity ^0.4.4;

import "./Ownable.sol";

contract BlockchaInsureCountries is Ownable {
    mapping(string => mapping(string => uint256)) insuranceParameters;

    // fallback functon not to take ethers
    function() public payable {
        revert();
    }

    function BlockchaInsureCountries() public {
        // constructor
        setInitialInsuranceParameters();
    }

    // Loads smart contract properties
    function setInitialInsuranceParameters() internal {
        // Countries whitelist
        insuranceParameters["country"]["APO"] = 5;
        insuranceParameters["country"]["FPO"] = 10;
        insuranceParameters["country"]["DPO"] = 15;
        insuranceParameters["country"]["ARG"] = 20;
        insuranceParameters["country"]["AUS"] = 25;
        insuranceParameters["country"]["AUT"] = 30;
        insuranceParameters["country"]["BHS"] = 35;
        insuranceParameters["country"]["BGD"] = 40;
        insuranceParameters["country"]["BRB"] = 45;
        insuranceParameters["country"]["BEL"] = 50;
        insuranceParameters["country"]["BMU"] = 55;
        insuranceParameters["country"]["CAN"] = 60;
        insuranceParameters["country"]["CHL"] = 65;
        insuranceParameters["country"]["CHN"] = 70;
        insuranceParameters["country"]["CRI"] = 75;
        insuranceParameters["country"]["CYP"] = 80;
        insuranceParameters["country"]["CZE"] = 85;
        insuranceParameters["country"]["ECU"] = 90;
        insuranceParameters["country"]["EGY"] = 95;
        insuranceParameters["country"]["EST"] = 100;
        insuranceParameters["country"]["FIN"] = 5;
        insuranceParameters["country"]["FRA"] = 10;
        insuranceParameters["country"]["DEU"] = 15;
        insuranceParameters["country"]["GRL"] = 20;
        insuranceParameters["country"]["GTM"] = 25;
        insuranceParameters["country"]["GUY"] = 30;
        insuranceParameters["country"]["HKG"] = 35;
        insuranceParameters["country"]["HUN"] = 40;
        insuranceParameters["country"]["ISL"] = 45;
        insuranceParameters["country"]["IND"] = 50;
        insuranceParameters["country"]["IRL"] = 55;
        insuranceParameters["country"]["ISR"] = 60;
        insuranceParameters["country"]["ITA"] = 65;
        insuranceParameters["country"]["JAM"] = 70;
        insuranceParameters["country"]["JPN"] = 75;
        insuranceParameters["country"]["LUX"] = 80;
        insuranceParameters["country"]["MUS"] = 85;
        insuranceParameters["country"]["MEX"] = 90;
        insuranceParameters["country"]["MAR"] = 95;
        insuranceParameters["country"]["NAM"] = 100;
        insuranceParameters["country"]["NLD"] = 5;
        insuranceParameters["country"]["NZL"] = 10;
        insuranceParameters["country"]["NOR"] = 15;
        insuranceParameters["country"]["POL"] = 20;
        insuranceParameters["country"]["PRT"] = 25;
        insuranceParameters["country"]["ROU"] = 30;
        insuranceParameters["country"]["WSM"] = 35;
        insuranceParameters["country"]["SVK"] = 40;
        insuranceParameters["country"]["KOR"] = 45;
        insuranceParameters["country"]["ESP"] = 50;
        insuranceParameters["country"]["SWE"] = 55;
        insuranceParameters["country"]["CHE"] = 60;
        insuranceParameters["country"]["TWN"] = 65;
        insuranceParameters["country"]["TTO"] = 70;
        insuranceParameters["country"]["TUR"] = 75;
        insuranceParameters["country"]["UKR"] = 80;
        insuranceParameters["country"]["GBR"] = 85;
        insuranceParameters["country"]["USA"] = 90;

        // US zip codes black listed
        insuranceParameters["USBlacklist"]["10017"] = 1;
        insuranceParameters["USBlacklist"]["10036"] = 1;
        insuranceParameters["USBlacklist"]["94102"] = 1;
        insuranceParameters["USBlacklist"]["94108"] = 1;

        // Valid Status
        insuranceParameters["Status"]["InfoReceived"] = 1;
        insuranceParameters["Status"]["InTransit"] = 1;
        insuranceParameters["Status"]["OutForDelivery"] = 1;
    }

    function deleteParameter(string first, string second) public onlyOwner {
        delete insuranceParameters[first][second];
    }

    function addParameter(
        string first,
        string second,
        uint256 value
    ) public onlyOwner {
        insuranceParameters[first][second] = value;
    }

    function getParameter(string first, string second)
        public
        constant
        returns (uint256 value)
    {
        return insuranceParameters[first][second];
    }
}
