// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

contract ERC721 {

    event Transfer(address indexed from, address indexed to, uint256 indexed id);

    string public name;

    string public symbol;

    mapping(uint256 => address) internal _ownerOf;

    mapping(address => uint256) internal _balanceOf;

    uint256 tokenId;

    uint256 totalSize = 10;

    function ownerOf(uint256 id) public view returns (address owner) {
        require((owner = _ownerOf[id]) != address(0), "NOT_MINTED");
    }

    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "ZERO_ADDRESS");

        return _balanceOf[owner];
    }


    function maxTokenId() public view returns (uint256){
        return tokenId;
    }

    constructor() {
        name = "Effective ERC";
        symbol = "ITM";
    }

    function transferFrom(
        address from,
        address to,
        uint256 id
    ) public {
        require(from == _ownerOf[id], "WRONG_FROM");

        require(to != address(0), "INVALID_RECIPIENT");

        require(_balanceOf[to] < 2, "OVER_TWO_TOKEN");

        require(
            msg.sender == from,
            "NOT_AUTHORIZED"
        );


        unchecked {
            _balanceOf[from]--;

            _balanceOf[to]++;
        }

        _ownerOf[id] = to;

        emit Transfer(from, to, id);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id
    ) public {
        transferFrom(from, to, id);

        require(
            to.code.length == 0 ||
                ERC721Recipient(to).onERC721Received(msg.sender, from, id, "") ==
                ERC721Recipient.onERC721Received.selector,
            "UNSAFE_RECIPIENT"
        );
    }

    function supportsInterface(bytes4 interfaceId) public pure returns (bool) {
        return
            interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
            interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
            interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
    }

    function _mint(address to, uint256 id) internal {
        require(to != address(0), "INVALID_RECIPIENT");

        require(_ownerOf[id] == address(0), "ALREADY_MINTED");

        require(_balanceOf[to] < 2 , "OVER_TWO_TOKEN");

        unchecked {
            _balanceOf[to]++;
        }

        _ownerOf[id] = to;

        emit Transfer(address(0), to, id);
    }

    function safeMint(address to) external {
        require(tokenId < totalSize, "MINT_IS_OVER");
        unchecked {
            tokenId += 1;
        }

        _mint(to, tokenId);

        require(
            to.code.length == 0 ||
                ERC721Recipient(to).onERC721Received(msg.sender, address(0), tokenId, "") ==
                ERC721Recipient.onERC721Received.selector,
            "UNSAFE_RECIPIENT"
        );
    }

    function mintIsOver() view external {
        require(tokenId < totalSize, "MINT_IS_OVER");
    }
}

abstract contract ERC721TokenReceiver {
    function onERC721Received (
        address,
        address,
        uint256,
        bytes calldata
    ) external virtual returns (bytes4) {
        return ERC721TokenReceiver.onERC721Received.selector;
    }
}

contract ERC721Recipient is ERC721TokenReceiver {
    address public operator;
    address public from;
    uint256 public id;
    bytes public data;

    function onERC721Received(
        address _operator,
        address _from,
        uint256 _id,
        bytes calldata _data
    ) public virtual override returns (bytes4) {
        operator = _operator;
        from = _from;
        id = _id;
        data = _data;

        return ERC721TokenReceiver.onERC721Received.selector;
    }
}
