// SPDX-License-Identidier:MIT
pragma solidity ^0.8.11;


contract PurchaseAgreement {
    uint public value;
    address payable public seller;
    address payable public buyer;
    

    enum state { Created, Locked, Release, Inactive}
    State public state;

    constructor() payable {
        seller = payable(msg.sender);
        value = msg.value / 2;

    }

    /// The function can not be called at the current state.
    error InvalidState();
    /// Only the buyer can call this function
    error onlyBuyer();

    /// Only the seller can call this function
    error onlySeller();

    modifier inState(State state_) {
        if (state != state_) {
            revert InvalideState();
        }
        _;
    }

    modifier onBuyer(){
        if (msg.sender != buyer){
            revert onlyBuyer();
        }
        _;
    }

     modifier onSeller(){
        if (msg.sender != seller){
            revert onlySeller();
        }
        _;
    }
    function confirmPurchase() external onlyBuyer inState(State.Created) payable {

        require(msg.value == (2* value, "Please send in 2x the purchase amount");
        buyer = payable(msg.sender);
        state = State.Locked;



    }

    function confirmReceived() external onlyBuyer inState(State.Locked) {
        state = State.Release;
        buyer.transfer(value);
    }

    function paySeller () external onlySeller inState(State.Release){
        state =State.Inactive;

        seller.transfer(3 * value);
    }

    function abort() external onlySeller inState(State.Created){
        state = State.Inactive;
        seller.transfer(address(this).balance);
    }
}