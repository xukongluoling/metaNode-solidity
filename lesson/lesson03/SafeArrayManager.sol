// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SafeArrayManager {
    uint[] public data;
    uint public constant MAX_SIZE = 100;
    
    event ElementAdded(uint value, uint index);
    event ElementRemoved(uint index, uint value);
    
    // TODO: 实现以下功能
    
    // 1. 安全添加
    function safePush(uint value) public {
        require(data.length <= MAX_SIZE, "array is full");
        // 添加元素
        data.push(value);
        emit ElementAdded(value, data.length - 1);
    }
    
    // 2. 保序删除
    function removeOrdered(uint index) public {
        // 检查索引
        uint256 len = data.length;
        require(len > 0, "Array is empty");
        require(index < len, "index is out array legth");
        uint removedValue;
        if(len == 1) {
            removedValue = data[0];
            data.pop();
            emit ElementRemoved(0, removedValue);
            return;
        }
        
        removedValue = data[index];
        // 移动元素
        for (uint i = index; i < len - 1; i++){
            data[i] = data[i+1];
        }
        // pop最后元素
        data.pop();
        emit ElementRemoved(index, removedValue);
    }
    
    // 3. 快速删除
    function removeUnordered(uint index) public {
        // 检查索引
        uint256 len = data.length;
        require(len > 0, "Array is empty");
        require(index < len, "index is out array legth");

        uint removedValue;
        if(len == 1) {
            removedValue = data[0];
            data.pop();
            emit ElementRemoved(0, removedValue);
            return;
        }
        
        removedValue = data[index];
        // 替换为最后元素
        data[index] = data[len - 1];
        // pop
        data.pop();
        emit ElementRemoved(index, removedValue);
    }
    
    // 4. 分批求和
    function sumRange(uint start, uint end) public view returns (uint) {
        // 检查范围
        uint256 len = data.length;
        require(len > 0, "Array is empty");
        require(start < len && end < len, "exceed array length");
        require(start <= end, "start and end value error");
        
        
        if (start == end) {
            return data[start];
        }
        uint sum = 0;
        // 计算总和
        for(uint i = start; i <= end ; i++) {
            sum += data[i];
        }
        return sum;
        
    }
    
    // 5. 查找元素
    function findElement(uint value) public view returns (bool, uint) {
        // 遍历查找
        uint256 len = data.length;
        for (uint i = 0; i < len; i++) {
            uint _value = data[i];
            if (_value == value){
                return (true, i);
            }
        }
        return (false, 0);
        // 返回是否找到和索引
    }

    // 5. 查找元素
    function findElementV2(uint value) public view returns (bool, uint) {
        // 遍历查找
        uint left = 0;
        uint right = data.length - 1;
        
        while(left <= right) {
            uint mid = left + (right - left) / 2;
            uint _v = data[mid];
            if (_v == value) {
                return (true, mid);
            }else if(_v < value) {
                left = mid + 1;
            }else if (_v > value) {
                right = mid - 1;
            }
        }
        return (false, 0);
        // 返回是否找到和索引
    }
    
    // 6. 获取所有元素
    function getAll() public view returns (uint[] memory) {
        // 返回整个数组
        return data;
    }
}