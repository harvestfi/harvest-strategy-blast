// SPDX-License-Identifier: Unlicense
pragma solidity 0.6.12;

import "../../VaultProxy.sol";
import "../../interface/IVault.sol";
import "../interface/IVaultFactory.sol";
import "../../inheritance/OwnableWhitelist.sol";

contract RegularVaultFactory is OwnableWhitelist, IVaultFactory {
  address public vaultImplementation = 0x47cAB26Cf72D969bE2af365F23D62d2056ECE1Cf;
  address public lastDeployedAddress = address(0);

  function deploy(address _storage, address underlying) override external onlyWhitelisted returns (address) {
    lastDeployedAddress = address(new VaultProxy(vaultImplementation));
    IVault(lastDeployedAddress).initializeVault(
      _storage,
      underlying,
      10000,
      10000
    );

    return lastDeployedAddress;
  }

  function changeDefaultImplementation(address newImplementation) external onlyOwner {
    require(newImplementation != address(0), "Must be set");
    vaultImplementation = newImplementation;
  }

  function info(address vault) override external view returns(address Underlying, address NewVault) {
    Underlying = IVault(vault).underlying();
    NewVault = vault;
  }
}
