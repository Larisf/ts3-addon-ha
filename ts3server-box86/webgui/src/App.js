javascript
import React, { useState, useEffect } from 'react';
import { TeamSpeak } from 'ts3-nodejs-library';

export default function App() {
  const [clients, setClients] = useState([]);
  const [serverInfo, setServerInfo] = useState({});
  
  useEffect(() => {
    const connectTS3 = async () => {
      const ts3 = new TeamSpeak({
        host: "localhost",
        serverport: 10011,
        username: "serveradmin",
        password: process.env.TS3_ADMIN_PASSWORD
      });
      
      ts3.on("ready", async () => {
        setServerInfo(await ts3.serverInfo());
        ts3.on("clientconnect", updateClients);
        ts3.on("clientdisconnect", updateClients);
        updateClients();
      });
    };
    
    connectTS3();
  }, []);

  const updateClients = async () => {
    const clientList = await ts3.clientList({ client_type: 0 });
    setClients(clientList);
  };

  return (
    <div className="admin-panel">
      <h1>{serverInfo.virtualserver_name}</h1>
      <div className="clients-list">
        {clients.map(client => (
          <div key={client.clid} className="client">
            <span>{client.nickname}</span>
            <button onClick={() => ts3.clientKick(client.clid)}>Kick</button>
          </div>
        ))}
      </div>
    </div>
  );
}
