# iradamobile

We wanted to build something around intents. The idea is to let users store addresses as contacts and integrate voice assistants like google assistant / siri / alexa to initiate transactions seamlessly. A simple instruction like "Send X 5 ETH on Polygon" will go through the following process
1. Go to the contacts app figure and figure out wallet address of X
2. Figure out (through intents) what the user wants to do, in this case a simple transaction 
3. Initiate a transaction so that the user only clicks sign.

The idea seems interesting but we spent majority of time in figuring out how to integrate google assistant into our application and hence we couldn't complete the project.

## How its built
The project uses web3Auth flutter sdk for connecting wallet and a basic flutter application to store contacts. We tried using google assistant and Open AI's api keys to resolve intents.

The application stores data locally, a simple DB structure with ContactName as primary key and contacts are stored in key value pairs inorder to enable intents of the type "Send X 5 ETH on his dev wallet"


