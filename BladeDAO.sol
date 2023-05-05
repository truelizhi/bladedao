// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;
import "./ERC721.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BladeDAO is ERC721 {

    bytes32 public immutable root = 0xe665f3df980b27e3b0ade8f15f922467f031537aead8455ba79e2440cfb0f18e; // Merkle树的根

    // 构造函数，初始化NFT合集的名称、代号、Merkle树的根
    constructor() ERC721("BladeDAO", "ITM") {
        
    }

    function safeMint(
        address account,
        bytes32[] calldata proof
    ) external {
        require(_verify(_leaf(account), proof), "Invalid merkle proof"); // Merkle检验通过
        _safeMint(account); // mint
    }

    // 计算Merkle树叶子的哈希值
    function _leaf(address account) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(account));
    }

    // Merkle树验证，调用MerkleProof库的verify()函数
    function _verify(bytes32 leaf, bytes32[] memory proof) internal pure returns (bool)
    {
        return MerkleProof.verify(proof, root, leaf);
    }

}
