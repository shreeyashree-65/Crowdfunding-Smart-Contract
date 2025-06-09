# Decentralized Crowdfunding Smart Contract

This is a simple Ethereum-based crowdfunding platform built with Solidity. It allows anyone to create fundraising campaigns, accept contributions from users, and withdraw funds if the goal is met. Contributors can get refunds if the campaign fails.

## 🔧 Features

- Campaign creation with goal and deadline
- ETH contributions from multiple users
- Automatic refund if goal not met
- Only creator can withdraw funds on success

## 📦 Technologies

- Solidity `^0.8.20`
- Remix IDE (for development and testing)

## 🧪 How to Test (Remix)

1. Open [Remix](https://remix.ethereum.org)
2. Paste code in `contracts/Crowdfunding.sol`
3. Deploy the contract
4. Call `createCampaign()`
5. Use multiple test accounts to `contribute()`
6. After deadline:
   - Call `withdrawFunds()` if goal met
   - Or `refund()` if goal not met

## 📝 License

This project is licensed under the MIT License.
