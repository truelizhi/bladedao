# bladedao
npx hardhat run whitelist.mjs

正式部署前checklist：
1 使用whitelist.mjs本地生成默克尔树的根哈希，并修改root哈希值：bytes32 public immutable root = xxxx
2 修改白名单锁定60秒变为锁定4个小时：block.timestamp - deployTime < 14400
3 修改最大mint个数10个到2000个：require(tokenId < 2000, "mint is over")
