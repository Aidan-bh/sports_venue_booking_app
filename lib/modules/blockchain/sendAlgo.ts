import algosdk from "algosdk";


const algodToken = "a".repeat(64);
const server: string = "http://localhost";
const port: string = "4001";


const mnemonic: string =
  "invest rug clock situate region position notable crazy trick vocal sun street kingdom critic invite habit garlic hammer hello modify easily install ensure above pudding";

export function getClient(): algosdk.Algodv2 {
  return new algosdk.Algodv2(algodToken, server, port);
}

export function getAccount(): algosdk.Account {
  return algosdk.mnemonicToSecretKey(mnemonic);
}

export async function sendAlgos() {
  const client = getClient();
  const sender = getAccount();

  const amount = 1000; 

  try {
    const params = await client.getTransactionParams().do();

    const txn = algosdk.makePaymentTxnWithSuggestedParamsFromObject({
      sender: sender.addr,
      receiver: sender.addr,
      amount: amount,
      suggestedParams: params,
    });

    const signedTxn = txn.signTxn(sender.sk);
    const sendTxn = await client.sendRawTransaction(signedTxn).do();

    console.log("Transaction sent with ID:", sendTxn.txid);

    // Wait for confirmation
    const confirmedTxn = await waitForConfirmation(client, sendTxn.txid);
    console.log("Confirmed in round", confirmedTxn["confirmed-round"]);
  } catch (err) {
    console.error("Failed to send transaction", err);
  }
}

// Wait for confirmation utility
async function waitForConfirmation(client: algosdk.Algodv2, txId: string) {
  let response = await client.status().do();
  let lastRound = response["last-round"];

  while (true) {
    const pendingInfo = await client.pendingTransactionInformation(txId).do();
    if (pendingInfo["confirmed-round"] !== null && pendingInfo["confirmed-round"] > 0) {
      return pendingInfo;
    }
    lastRound++;
    await client.statusAfterBlock(lastRound).do();
  }
}
