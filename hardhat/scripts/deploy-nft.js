const hre = require("hardhat");
const whitelistContractAddress = "0xC14E4E0caa76152895E863CC6397fbd6363965b1";

async function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

// Deploy NFT contract and verify on Etherscan
async function main() {
  const nftContract = await hre.ethers.deployContract("MonkeyPics", [
    whitelistContractAddress,
  ]);
  await nftContract.waitForDeployment();
  console.log("NFT Contract Address:", nftContract.target);
  await sleep(30 * 1000); // 30s = 30 * 1000 milliseconds
  await hre.run("verify:verify", {
    address: nftContract.target,
    constructorArguments: [whitelistContractAddress],
  });
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
