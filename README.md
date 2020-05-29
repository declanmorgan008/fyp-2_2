# Blockchains for Smart Manufacturing
This project demonstrates the ability to create and deploy a decentralised application (daap) that enables the trace-ability 
of an industrial process. The project is a generalised approach to the supply chain problem and offers the ability to extend 
the solution to include further detailed functions, events and entities. This solution offers a Role Based Access Control (RBAC) 
strategy to determining the access controls of users to functions. The fundamental aim of this project is to enable an 
organisation to identify, trace and analyse every aspect of a product in a supply chain utilising a blockchain.


## Installation

1. Install [Truffle](https://www.trufflesuite.com/docs/truffle/getting-started/installation).

```bash
npm install -g truffle
```

2. Download and install [Ganache](https://www.trufflesuite.com/ganache).

3. Install [Metamask](https://metamask.io/) browser extension.

3.Clone this repo.

4. Open a command prompt and navigate to root directory of project and install npm.

```bash
npm install
```

5. Install npm lite-server.

```bash
npm install lite-server
```

6. Open [Ganache](https://www.trufflesuite.com/ganache), and create a 'new workspace' selecting the 'truffle-config.js' file as the truffle project.

7. Copy seed phrase from Ganache and use it to set up a MetaMask account.

8. Navigate to root directory of project and run command to deploy contracts.
```bash
truffle migrate --reset
```

9. After deployment of contracts, run command to run the web app:
```bash
npm run dev
```

10. After web app is finished loading, refresh the page one last time and check if MetaMask is linked to Ganache accounts.

## Usage

