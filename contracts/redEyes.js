// https://dappsforbeginners.wordpress.com/tutorials/typing-and-your-contracts-storage/
//
// hash:     256-bit, 32-byte data chunk, indexable into bytes and operable with bitwise operations.
// uint:     256-bit unsigned integer, operable with bitwise and unsigned arithmetic operations.
// int:      256-bit signed integer, operable with bitwise and signed arithmetic operations.
// string32: zero-terminated ASCII string of maximum length 32-bytes (256-bit).
// address:  account identifier, similar to a 160-bit hash type.
// bool:     two-state value.

contract redEyes {
  mapping (string32 => string32) data;
    
  function redEyes() {
  }
  
  function put(string32 key, string32 value) {
    data[key] = value;
  }
  
  function get(string32 key) returns (string32 value) {
    return data[key];
  }
  
  function del(string32 key) {
    data[key] = "";
  }
}