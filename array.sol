pragma solidity ^0.8.3;

contract Array {
   
    uint[] public arr;
    uint[] public arr2 = [1, 2, 3];
   
    uint[10] public myFixedSizeArr;
    uint[3] public arr3 = [0, 1, 2];

    function get(uint i) public view returns (uint) {
        return arr[i];
    }

    function getArr() public view returns (uint[3] memory) {
        return arr3;
    }

    function push(uint i) public {
      
        arr.push(i);
    }

    function pop() public {
       
        arr.pop();
    }

    function getLength() public view returns (uint) {
        return arr.length;
    }

    function remove(uint index) public {
       
        delete arr[index];
    }
}

contract newArray {
    uint[] public arr;

    function remove(uint index) public {
        // Move the last element into the place to delete
        arr[index] = arr[arr.length - 1];
        // Remove the last element
        arr.pop();
    }

    function test() public {
        arr.push(1);
        arr.push(2);
        arr.push(3);
        arr.push(4);
        // [1, 2, 3, 4]

        remove(1);
        // [1, 4, 3]

        remove(2);
        // [1, 4]
    }
}
