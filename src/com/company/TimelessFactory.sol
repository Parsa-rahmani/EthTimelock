pragma solidity ^0.4.0;

contract TimelessFactory {

    // Maps all the wallets of a single user to itself.
    mapping(address => address) wallets;

    // Returns all the wallets of a user.
    function getWallets(address _user) public view returns(address[]){
        return wallets[_user];
    }

    // Creates a new wallet for the user and adds it to the list of wallets.
    function createWallet(address _owner ,uint256 _unlockDate) payable public {
        // Creates a new wallet.
        wallet = new TimeLockedWallet(msg.sender, _owner, _unlockDate);

        // Add wallet to user's wallets.
        wallets[msg.sender].push(wallet);

        // Send Eth from this transaction to the created contract.
        wallet.transfer(msg.value);

        // Emit event.
        emit Created(wallet, msg.sender, _owner, now, _unlockDate, msg.value);
    }

    // An event which occurs when a wallet is created.
    event Created(address wallet, address from, address to, uint256 createdAt, uint256 unlockDate, uint256 amount);
}
