Veriphone - Chainlink-backed phone validation

---

Yellow books are a thing of the past.

Veriphone is a project with the goal of creating the largest index of chainlink-validated phone numbers.

Not a DeFi or currency app, but a useful service.

Marketers and sales people have huge incentives for getting and checking for valid phone numbers to close deals. In the non-business world, it can also feel like the amount of spam phone calls have reached an all time high. Robocalls that originate from telephony (nonphysical address) services who act as imposters of people and locations has boomed due to an addition of services like twilio.com and bandwidth.com, for better or for worse.

Veriphone is a Chainlink app centered around a 'PhoneValidator' smart contract. This contract stores and emits events for phone validations whenever the contract validate method is invoked. Every update is tracked - phone numbers may be spam at one time and may later become a valid number.

The Veriphone contract service is currently free, and returns valid / isValid becased on the phone number entered.

Uses the <a href="https://phonenumbervalidation.apifex.com/" target="_blank">APIFEX</a> phone validation API in combination with Chainlink and theGraph.

Uses thegraph service to index the events emitted whenever a phone number is validated. Use graphql to find the history of a given phone number by entering it in the graphql interface.

## Technical

The phone validation API currently returns an internal error whenever an invalid phone number is provided, making the API difficult to directly insert into a chainlink contract and work correctly. To bypass this, I set up an external adapter to proxy the chainlink API calls (via a lambda function) and process the event such that a consistent response could be delivered back to the smart contract.

Chainlink API calls were key to wire in the external phone validation data into the smart contract.

Every requested validation (as of the last deployed contract) is emitted as part of the smart contract and ready to be indexed by theGraph. See the attached schema and graphql interface. Using this service can open up possibilities for indexing and providing hosted / blockchain-backed phone records.

## What's next for Veriphone:

- Add support for pulling more data out of the API response
- Could add paid validations in the future.
- Expand to support international numbers (US only).

Project is open source.

Chainlink Contract: https://ropsten.etherscan.io/address/0x7c68a3c9477f9b7bd491f2c788873cd6aa7630c0#code

The Graph API: https://thegraph.com/explorer/subgraph/cbonoz/phone-validator

Chris Buonocore
Prototyped for the Chainlink Hackathon 2020.

<!--
Useful links
* https://github.com/robin-thomas/flyt/blob/master/src/truffle/contracts/Flyt.sol
-->
