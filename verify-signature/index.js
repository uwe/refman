const { ethers } = require("ethers");

const token = process.argv[2];
const block = process.argv[3];
const signature = process.argv[4];

const message = "Block: " + block + "\nReferral token:\n" + token;

console.log(ethers.utils.verifyMessage(message, signature));