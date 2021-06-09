pragma solidity ^0.4.18;

import "./ERC20.sol";

contract TimeLockedWallet {
    address public creator;
    //owner is whatever address the locked tokens has been delegated to. It could be the same as msg.sender or not
    address public owner;
    //unlock date and created at are not modified in the contract, so the appropriate format needs to be outputed by the website itself
    uint256 public unlockDate;
    uint256 public createdAt;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    //constructor function, takes the inputs from the timeless factory contract, and feeds it into the defined variables
    function TimeLockedWallet(address _creator, address _owner, uint256 _unlockDate) public {
        creator = _creator;
        owner = _owner;
        unlockDate = _unlockDate;
        createdAt = now;
    }

    // this makes the function able to keep all the ether sent to this address
    function() payable public {
        Received(msg.sender, msg.value);
    }

    // callable by owner only, after specified time
    function withdraw() onlyOwner public {
        require(now >= unlockDate);
        //now send all the balance
        msg.sender.transfer(this.balance);
        Withdrew(msg.sender, this.balance);
    }

    // callable by owner only, after specified time, only for Tokens implementing ERC20
    function withdrawTokens(address _tokenContract) onlyOwner public {
        require(now >= unlockDate);
        ERC20 token = ERC20(_tokenContract);
        //now send all the token balance
        uint256 tokenBalance = token.balanceOf(this);
        token.transfer(owner, tokenBalance);
        WithdrewTokens(_tokenContract, msg.sender, tokenBalance);
    }

    function info() public view returns(address, address, uint256, uint256, uint256) {
        return (creator, owner, unlockDate, createdAt, this.balance);
    }

    event Received(address from, uint256 amount);
    event Withdrew(address to, uint256 amount);
    event WithdrewTokens(address tokenContract, address to, uint256 amount);
}
