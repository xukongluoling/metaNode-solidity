// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

abstract contract Animal {
    string public species;

    constructor(string memory _species) {
        species = _species;
    }

    function makeSound() public virtual returns(string memory);

    function eat() public pure returns(string memory) {
        return "Eating...";
    }

    function sleep() public pure returns(string memory) {
        return "Sleep...";
    }
}

contract Dog is Animal {
    constructor() Animal("Dog") {}

    function makeSound() public pure override returns(string memory) {
        return "wang!wang!";
    }
}

contract Cat is Animal {
    constructor() Animal("Cat") {}

    function makeSound() public pure override returns(string memory) {
        return "mi!mi!";
    }
}
