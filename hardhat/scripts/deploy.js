// import the Hardhat runtime environment (HRE) into script - a
const hre = require("hardhat");

// create our own sleep function. Combining setTimeout and Promise, pauses the whole script.
// ... Javascript is asynchronous, so setTimeout by itself won't pause all of the script.
async function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function main() {
  // Using Hardhat's integration with ethers library, deploy a contract named "Whitelist" with a constructor argument of 10
  const whitelistContract = await hre.ethers.deployContract("Whitelist", [10]);
  await whitelistContract.waitForDeployment();
  console.log("Whitelist Contract Address:", whitelistContract.target);
  // Sleep for 30 seconds while Etherscan indexes the new contract deployment, then verify contract
  await sleep(30 * 1000);
  await hre.run("verify:verify", {
    address: whitelistContract.target,
    constructorArguments: [10],
  });
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
