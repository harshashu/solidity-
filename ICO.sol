
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface ERC20Interface {
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function transfer(address to, uint tokens) external returns (bool success);
    
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract AlphaToken is ERC20Interface{
    string public name = "Alphatoken";
    string public symbol = "AlphaT";
    uint public decimals = 0;
    uint public override totalSupply;
    
    address public founder;
    mapping(address => uint) public balances;
   
    
    mapping(address => mapping(address => uint)) allowed;
      
    constructor(){
        totalSupply = 1000000;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }
    
    
    function balanceOf(address tokenOwner) public view override returns (uint balance){
        return balances[tokenOwner];
    }
    
    
    function transfer(address to, uint tokens) public virtual override returns(bool success){
        require(balances[msg.sender] >= tokens);
        
        balances[to] += tokens;
        balances[msg.sender] -= tokens;
        emit Transfer(msg.sender, to, tokens);
        
        return true;
    }
    
    function allowance(address tokenOwner,address spender) public view override returns(uint){
        return allowed[tokenOwner][spender];
    }
    function approve(address spender,uint tokens) public override returns(bool success){
        require(balances[msg.sender] >= tokens);
        allowed[msg.sender][spender]=tokens;
        emit Approval(msg.sender,spender,tokens);
        return true;
    }
 function transferFrom(address from,address to,uint tokens) public virtual override returns(bool success){
     require(allowed[from][to]>=tokens);
     require(balances[from]>=tokens);
     balances[from] -=tokens;
     balances[to] +=tokens;
     allowed[from][to] -=tokens;
     return true;
 }
}

contract ICO is AlphaToken{
    address public admin;

    address payable public deposit;

    uint tokenPrice= 0.001 ether;

    uint public hardCap= 300 ether;

    uint public saleStart=block.timestamp;

    uint public saleEnd=block.timestamp+ 172800 ;          //2X24X3600--2 days
    uint public raisedAmount;

    uint public tokenTradeStart=saleEnd+604800; //one 
    enum State{beforeStart,running,afterEnd,halted}

    State public icoState;

    uint public maxInvestment= 5 ether;
    uint public minInvestment= 0.1 ether;

    constructor(address payable _deposit){
        deposit=_deposit;
        admin=msg.sender;
        icoState=State.beforeStart;
    }
 modifier onlyAdmin(){
     require(msg.sender==admin);
     _;
 }
 function halt() public onlyAdmin{
     icoState=State.halted;
 }

 function starting() public onlyAdmin{
     icoState=State.running;
 }
function getCurrentState() public view returns(State){
    if(icoState==State.halted){
        return State.halted;
    }
    else if(block.timestamp<saleStart){
        return State.beforeStart;
    }
    else if(block.timestamp>=saleStart && block.timestamp<=saleEnd){
        return State.running;
    }
    else{
        return State.afterEnd;
    }
}
function changeDepositAddress(address payable newDeposit) public onlyAdmin{
    deposit= newDeposit;
}
event Invest(address investor,uint value,uint tokens);
function investment() payable public returns(bool){
    icoState=getCurrentState();

    require(icoState==State.running);

    require(msg.value>=minInvestment && msg.value<=maxInvestment);

    raisedAmount +=msg.value;
    uint tokens= msg.value/tokenPrice;

    balances[msg.sender] +=tokens;
    balances[founder] -=tokens;
    deposit.transfer(msg.value);

 emit Invest(msg.sender,msg.value,tokens);

 return true;

}
receive () payable external{
    investment();
}
//burn

function burntoken() public returns(bool){
    icoState=getCurrentState();
    require(icoState==State.afterEnd);
    balances[founder]=0;
    return true;
}
//lockin

function transfer(address to,uint tokens) public override returns (bool success){
require(block.timestamp>tokenTradeStart);
AlphaToken.transfer(to,tokens);
return true;
}

 function transferFrom(address from,address to,uint tokens) public override returns (bool success){
    require(block.timestamp>tokenTradeStart);
 AlphaToken.transferFrom(from,to,tokens);
return true;
}   
}
