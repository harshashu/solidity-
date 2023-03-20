//calculate the sum and get this sum value from the smart contract
 
pragma solidity >=0.8.2 <0.9.0;
 contract valuetest
{
    uint public val1;
    uint public val2;
    uint public sum;

     function set(uint x ,uint y) public
     {
     val1=x;
     val2=y;
     sum=val1+val2;
     }

    function get() public view returns (uint){
    return sum;
 }
 }
