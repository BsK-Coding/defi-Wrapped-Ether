// SPDX-License-Identifier: MIT

pragma solidity ^0.8.00;

contract WETH {
    string public name = "Wrapped Ether";
    string public symbol = "WETH";
    uint8 public decimals = 18;

    event Approval(address indexed src, address indexed guy, uint256 wad);
    event Transfer(address indexed src, address indexed dst, uint256 wad);
    event Deposit(address indexed dst, uint256 wad);
    event Withdrawal(address indexed src, uint256 wad);

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    /**
     * @dev Fonction permettant de recevoir des ETHs via web3
     */
    receive() external payable {
        deposit();
    }

    /**
     * @dev Fonction permettant de déposer des fonds dans le SmartContract
     */
    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    /**
     * @dev Fonction permettant de retirer des fonds dans le SmartContract
     */
    function withdraw(uint256 wad) public {
        require(balanceOf[msg.sender] >= wad);
        balanceOf[msg.sender] -= wad;
        payable(msg.sender).transfer(wad);
        emit Withdrawal(msg.sender, wad);
    }

    /**
     * @dev Fonction permettant d'afficher les fonds contenu dans le SmartContract
     */
    function totalSupply() public view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @dev Fonction permettant d'approuver une address via l'owner
     */
    function approve(address guy, uint256 wad) public returns (bool) {
        allowance[msg.sender][guy] = wad;
        emit Approval(msg.sender, guy, wad);
        return true;
    }

    /**
     * @dev Fonction permettant d'initialiser le transfer au sein du smartContract
     */

    function transfer(address dst, uint256 wad) public returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    /**
     * @dev Fonction permettant de transferrer des fonds d'une addresse à une autre dans le smartContract
     *      Si les conditions sont validées
     */

    function transferFrom(
        address src,
        address dst,
        uint256 wad
    ) public returns (bool) {
        require(balanceOf[src] >= wad);

        if (
            src != msg.sender && allowance[src][msg.sender] != type(uint256).max
        ) {
            require(allowance[src][msg.sender] >= wad);
            allowance[src][msg.sender] -= wad;
        }

        balanceOf[src] -= wad;
        balanceOf[dst] += wad;

        emit Transfer(src, dst, wad);

        return true;
    }
}
