import { useState, useEffect } from 'react';
import { ethers } from 'ethers';
import crowdfundingArtifact from './contracts/Crowdfunding.json';

const CONTRACT_ADDRESS = '0x93c1bCC51DC27CEd786c14B84Fe352255E7130f9';

function App() {
  const [account, setAccount] = useState(null);
  const [contract, setContract] = useState(null);
  const [campaigns, setCampaigns] = useState([]);

  const connectWallet = async () => {
    if (!window.ethereum) return alert("Install MetaMask!");

    const provider = new ethers.BrowserProvider(window.ethereum);
    const signer = await provider.getSigner();
    const accounts = await provider.send("eth_requestAccounts", []);
    setAccount(accounts[0]);

    const crowdfund = new ethers.Contract(
      CONTRACT_ADDRESS,
      crowdfundingArtifact.abi,
      signer
    );

    setContract(crowdfund);
  };

  useEffect(() => {
    const fetchCampaigns = async () => {
      if (contract) {
        try {
          const data = await contract.getCampaigns(); 
          setCampaigns(data);
          console.log("Campaigns:", data);
        } catch (err) {
          console.error("Failed to fetch campaigns:", err);
        }
      }
    };

    fetchCampaigns();
  }, [contract]);

  return (
    <div style={{ padding: 20 }}>
      <h1>Decentralized Crowdfunding</h1>

      {account ? (
        <div>
          <p>🔗 Connected: {account}</p>
          <h2>📦 Campaigns:</h2>
          <pre>{JSON.stringify(campaigns, null, 2)}</pre>
        </div>
      ) : (
        <button onClick={connectWallet}>Connect Wallet</button>
      )}
    </div>
  );
}

export default App;
