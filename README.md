## Chainlink PhoneValidator

Creating the largest index of chainlink-validated phone numbers.

Not a DeFi app, but a useful service.

- Spam phone calls are at a all time high.
- Robocalls that originate from telephony (nonphysical address) services or act as imposters of locations has boomed due to an addition of services like twilio.com and bandwidth.com, for better or for worse.
- Phone number may be spam at one time and may later become a valid number. Validating the number both times with timestamp is saved via events emitted from the contract.
- Use chainlink to do an API call to a live phone validating service
- Use the thegraph to quick index and find the validity/history of past entered phone numbers.

## TODO

- Limited number of free validations, could add paid validations in the future.
- Expand to support international numbers (US only).

Chainlink Contract: https://ropsten.etherscan.io/address/0x7c68a3c9477f9b7bd491f2c788873cd6aa7630c0#code

The Graph API: https://thegraph.com/explorer/subgraph/cbonoz/phone-validator

Chris Buonocore

Built for the Chainlink Hackathon 2020.

<!--
Useful links
* https://github.com/robin-thomas/flyt/blob/master/src/truffle/contracts/Flyt.sol
-->