
//
//  swiftAbi
//  Don't change the files! this file is generated!
//  https://github.com/imanrep/
//

import BigInt
import Foundation
import web3

public protocol CoffeeNFTProtocol {
  init(client: EthereumClientProtocol)

  func balanceOf(contractAddress: EthereumAddress , owner: EthereumAddress ) async throws -> BigUInt
  func getApproved(contractAddress: EthereumAddress , tokenId: BigUInt ) async throws -> EthereumAddress
  func getCoffeeCoupon(contractAddress: EthereumAddress , tokenId: BigUInt ) async throws -> String
  func isApprovedForAll(contractAddress: EthereumAddress , owner: EthereumAddress, `operator`: EthereumAddress ) async throws -> Bool
  func locked(contractAddress: EthereumAddress , tokenId: BigUInt ) async throws -> Bool
  func maxMintAmount(contractAddress: EthereumAddress  ) async throws -> BigUInt
  func maxSupply(contractAddress: EthereumAddress  ) async throws -> BigUInt
  func name(contractAddress: EthereumAddress  ) async throws -> String
  func owner(contractAddress: EthereumAddress  ) async throws -> EthereumAddress
  func ownerOf(contractAddress: EthereumAddress , tokenId: BigUInt ) async throws -> EthereumAddress
  func supportsInterface(contractAddress: EthereumAddress , interfaceId: BigUInt ) async throws -> Bool
  func symbol(contractAddress: EthereumAddress  ) async throws -> String
  func tokenByIndex(contractAddress: EthereumAddress , index: BigUInt ) async throws -> BigUInt
  func tokenOfOwnerByIndex(contractAddress: EthereumAddress , owner: EthereumAddress, index: BigUInt ) async throws -> BigUInt
  func tokenURI(contractAddress: EthereumAddress , tokenId: BigUInt ) async throws -> String
  func totalSupply(contractAddress: EthereumAddress  ) async throws -> BigUInt
  func walletOfOwner(contractAddress: EthereumAddress , _owner: EthereumAddress ) async throws -> [BigUInt]
}

open class CoffeeNFT: CoffeeNFTProtocol {
  let client: EthereumClientProtocol

  required public init(client: EthereumClientProtocol) {
      self.client = client
  }

  public func balanceOf(contractAddress: EthereumAddress , owner: EthereumAddress) async throws -> BigUInt {
    let function = CoffeeNFTFunctions.balanceOf(contract: contractAddress , owner: owner)
    let data = try await function.call(withClient: client, responseType: CoffeeNFTResponses.balanceOfResponse.self)
    return data.value
}
  public func getApproved(contractAddress: EthereumAddress , tokenId: BigUInt) async throws -> EthereumAddress {
    let function = CoffeeNFTFunctions.getApproved(contract: contractAddress , tokenId: tokenId)
    let data = try await function.call(withClient: client, responseType: CoffeeNFTResponses.getApprovedResponse.self)
    return data.value
}
  public func getCoffeeCoupon(contractAddress: EthereumAddress , tokenId: BigUInt) async throws -> String {
    let function = CoffeeNFTFunctions.getCoffeeCoupon(contract: contractAddress , tokenId: tokenId)
    let data = try await function.call(withClient: client, responseType: CoffeeNFTResponses.getCoffeeCouponResponse.self)
    return data.value
}
  public func isApprovedForAll(contractAddress: EthereumAddress , owner: EthereumAddress, `operator`: EthereumAddress) async throws -> Bool {
    let function = CoffeeNFTFunctions.isApprovedForAll(contract: contractAddress , owner: owner, `operator`: `operator`)
    let data = try await function.call(withClient: client, responseType: CoffeeNFTResponses.isApprovedForAllResponse.self)
    return data.value
}
  public func locked(contractAddress: EthereumAddress , tokenId: BigUInt) async throws -> Bool {
    let function = CoffeeNFTFunctions.locked(contract: contractAddress , tokenId: tokenId)
    let data = try await function.call(withClient: client, responseType: CoffeeNFTResponses.lockedResponse.self)
    return data.value
}
  public func maxMintAmount(contractAddress: EthereumAddress ) async throws -> BigUInt {
    let function = CoffeeNFTFunctions.maxMintAmount(contract: contractAddress )
    let data = try await function.call(withClient: client, responseType: CoffeeNFTResponses.maxMintAmountResponse.self)
    return data.value
}
  public func maxSupply(contractAddress: EthereumAddress ) async throws -> BigUInt {
    let function = CoffeeNFTFunctions.maxSupply(contract: contractAddress )
    let data = try await function.call(withClient: client, responseType: CoffeeNFTResponses.maxSupplyResponse.self)
    return data.value
}
  public func name(contractAddress: EthereumAddress ) async throws -> String {
    let function = CoffeeNFTFunctions.name(contract: contractAddress )
    let data = try await function.call(withClient: client, responseType: CoffeeNFTResponses.nameResponse.self)
    return data.value
}
  public func owner(contractAddress: EthereumAddress ) async throws -> EthereumAddress {
    let function = CoffeeNFTFunctions.owner(contract: contractAddress )
    let data = try await function.call(withClient: client, responseType: CoffeeNFTResponses.ownerResponse.self)
    return data.value
}
  public func ownerOf(contractAddress: EthereumAddress , tokenId: BigUInt) async throws -> EthereumAddress {
    let function = CoffeeNFTFunctions.ownerOf(contract: contractAddress , tokenId: tokenId)
    let data = try await function.call(withClient: client, responseType: CoffeeNFTResponses.ownerOfResponse.self)
    return data.value
}
  public func supportsInterface(contractAddress: EthereumAddress , interfaceId: BigUInt) async throws -> Bool {
    let function = CoffeeNFTFunctions.supportsInterface(contract: contractAddress , interfaceId: interfaceId)
    let data = try await function.call(withClient: client, responseType: CoffeeNFTResponses.supportsInterfaceResponse.self)
    return data.value
}
  public func symbol(contractAddress: EthereumAddress ) async throws -> String {
    let function = CoffeeNFTFunctions.symbol(contract: contractAddress )
    let data = try await function.call(withClient: client, responseType: CoffeeNFTResponses.symbolResponse.self)
    return data.value
}
  public func tokenByIndex(contractAddress: EthereumAddress , index: BigUInt) async throws -> BigUInt {
    let function = CoffeeNFTFunctions.tokenByIndex(contract: contractAddress , index: index)
    let data = try await function.call(withClient: client, responseType: CoffeeNFTResponses.tokenByIndexResponse.self)
    return data.value
}
  public func tokenOfOwnerByIndex(contractAddress: EthereumAddress , owner: EthereumAddress, index: BigUInt) async throws -> BigUInt {
    let function = CoffeeNFTFunctions.tokenOfOwnerByIndex(contract: contractAddress , owner: owner, index: index)
    let data = try await function.call(withClient: client, responseType: CoffeeNFTResponses.tokenOfOwnerByIndexResponse.self)
    return data.value
}
  public func tokenURI(contractAddress: EthereumAddress , tokenId: BigUInt) async throws -> String {
    let function = CoffeeNFTFunctions.tokenURI(contract: contractAddress , tokenId: tokenId)
    let data = try await function.call(withClient: client, responseType: CoffeeNFTResponses.tokenURIResponse.self)
    return data.value
}
  public func totalSupply(contractAddress: EthereumAddress ) async throws -> BigUInt {
    let function = CoffeeNFTFunctions.totalSupply(contract: contractAddress )
    let data = try await function.call(withClient: client, responseType: CoffeeNFTResponses.totalSupplyResponse.self)
    return data.value
}
  public func walletOfOwner(contractAddress: EthereumAddress , _owner: EthereumAddress) async throws -> [BigUInt] {
    let function = CoffeeNFTFunctions.walletOfOwner(contract: contractAddress , _owner: _owner)
    let data = try await function.call(withClient: client, responseType: CoffeeNFTResponses.walletOfOwnerResponse.self)
    return data.value
}

}
open class CoffeeNFTContract {
  var CoffeeNFTCall: CoffeeNFT?
  var client: EthereumClientProtocol
  var contract: web3.EthereumAddress
  
  init(contract: String, client: EthereumClientProtocol) {
      self.contract = EthereumAddress(contract)
      self.client = client
      self.CoffeeNFTCall = CoffeeNFT(client: client)
      }
  public func balanceOf(owner: EthereumAddress) async throws -> BigUInt{
      return try await (CoffeeNFTCall?.balanceOf(contractAddress: contract, owner: owner))!
   }
   
  public func getApproved(tokenId: BigUInt) async throws -> EthereumAddress{
      return try await (CoffeeNFTCall?.getApproved(contractAddress: contract, tokenId: tokenId))!
   }
   
  public func getCoffeeCoupon(tokenId: BigUInt) async throws -> String{
      return try await (CoffeeNFTCall?.getCoffeeCoupon(contractAddress: contract, tokenId: tokenId))!
   }
   
  public func isApprovedForAll(owner: EthereumAddress, `operator`: EthereumAddress) async throws -> Bool{
      return try await (CoffeeNFTCall?.isApprovedForAll(contractAddress: contract, owner: owner, `operator`: `operator`))!
   }
   
  public func locked(tokenId: BigUInt) async throws -> Bool{
      return try await (CoffeeNFTCall?.locked(contractAddress: contract, tokenId: tokenId))!
   }
   
  public func maxMintAmount() async throws -> BigUInt{
      return try await (CoffeeNFTCall?.maxMintAmount(contractAddress: contract))!
   }
   
  public func maxSupply() async throws -> BigUInt{
      return try await (CoffeeNFTCall?.maxSupply(contractAddress: contract))!
   }
   
  public func name() async throws -> String{
      return try await (CoffeeNFTCall?.name(contractAddress: contract))!
   }
   
  public func owner() async throws -> EthereumAddress{
      return try await (CoffeeNFTCall?.owner(contractAddress: contract))!
   }
   
  public func ownerOf(tokenId: BigUInt) async throws -> EthereumAddress{
      return try await (CoffeeNFTCall?.ownerOf(contractAddress: contract, tokenId: tokenId))!
   }
   
  public func supportsInterface(interfaceId: BigUInt) async throws -> Bool{
      return try await (CoffeeNFTCall?.supportsInterface(contractAddress: contract, interfaceId: interfaceId))!
   }
   
  public func symbol() async throws -> String{
      return try await (CoffeeNFTCall?.symbol(contractAddress: contract))!
   }
   
  public func tokenByIndex(index: BigUInt) async throws -> BigUInt{
      return try await (CoffeeNFTCall?.tokenByIndex(contractAddress: contract, index: index))!
   }
   
  public func tokenOfOwnerByIndex(owner: EthereumAddress, index: BigUInt) async throws -> BigUInt{
      return try await (CoffeeNFTCall?.tokenOfOwnerByIndex(contractAddress: contract, owner: owner, index: index))!
   }
   
  public func tokenURI(tokenId: BigUInt) async throws -> String{
      return try await (CoffeeNFTCall?.tokenURI(contractAddress: contract, tokenId: tokenId))!
   }
   
  public func totalSupply() async throws -> BigUInt{
      return try await (CoffeeNFTCall?.totalSupply(contractAddress: contract))!
   }
   
  public func walletOfOwner(_owner: EthereumAddress) async throws -> [BigUInt]{
      return try await (CoffeeNFTCall?.walletOfOwner(contractAddress: contract, _owner: _owner))!
   }
   
      
}
extension CoffeeNFT {
  public func balanceOf(contractAddress: EthereumAddress, owner: EthereumAddress,  completionHandler: @escaping (Result<BigUInt, Error>) -> Void) {
    Task {
        do {
            let balanceOf = try await balanceOf(contractAddress: contractAddress , owner: owner)
            completionHandler(.success(balanceOf))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func getApproved(contractAddress: EthereumAddress, tokenId: BigUInt,  completionHandler: @escaping (Result<EthereumAddress, Error>) -> Void) {
    Task {
        do {
            let getApproved = try await getApproved(contractAddress: contractAddress , tokenId: tokenId)
            completionHandler(.success(getApproved))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func getCoffeeCoupon(contractAddress: EthereumAddress, tokenId: BigUInt,  completionHandler: @escaping (Result<String, Error>) -> Void) {
    Task {
        do {
            let getCoffeeCoupon = try await getCoffeeCoupon(contractAddress: contractAddress , tokenId: tokenId)
            completionHandler(.success(getCoffeeCoupon))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func isApprovedForAll(contractAddress: EthereumAddress, owner: EthereumAddress, `operator`: EthereumAddress,  completionHandler: @escaping (Result<Bool, Error>) -> Void) {
    Task {
        do {
            let isApprovedForAll = try await isApprovedForAll(contractAddress: contractAddress , owner: owner, `operator`: `operator`)
            completionHandler(.success(isApprovedForAll))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func locked(contractAddress: EthereumAddress, tokenId: BigUInt,  completionHandler: @escaping (Result<Bool, Error>) -> Void) {
    Task {
        do {
            let locked = try await locked(contractAddress: contractAddress , tokenId: tokenId)
            completionHandler(.success(locked))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func maxMintAmount(contractAddress: EthereumAddress,  completionHandler: @escaping (Result<BigUInt, Error>) -> Void) {
    Task {
        do {
            let maxMintAmount = try await maxMintAmount(contractAddress: contractAddress )
            completionHandler(.success(maxMintAmount))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func maxSupply(contractAddress: EthereumAddress,  completionHandler: @escaping (Result<BigUInt, Error>) -> Void) {
    Task {
        do {
            let maxSupply = try await maxSupply(contractAddress: contractAddress )
            completionHandler(.success(maxSupply))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func name(contractAddress: EthereumAddress,  completionHandler: @escaping (Result<String, Error>) -> Void) {
    Task {
        do {
            let name = try await name(contractAddress: contractAddress )
            completionHandler(.success(name))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func owner(contractAddress: EthereumAddress,  completionHandler: @escaping (Result<EthereumAddress, Error>) -> Void) {
    Task {
        do {
            let owner = try await owner(contractAddress: contractAddress )
            completionHandler(.success(owner))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func ownerOf(contractAddress: EthereumAddress, tokenId: BigUInt,  completionHandler: @escaping (Result<EthereumAddress, Error>) -> Void) {
    Task {
        do {
            let ownerOf = try await ownerOf(contractAddress: contractAddress , tokenId: tokenId)
            completionHandler(.success(ownerOf))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func supportsInterface(contractAddress: EthereumAddress, interfaceId: BigUInt,  completionHandler: @escaping (Result<Bool, Error>) -> Void) {
    Task {
        do {
            let supportsInterface = try await supportsInterface(contractAddress: contractAddress , interfaceId: interfaceId)
            completionHandler(.success(supportsInterface))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func symbol(contractAddress: EthereumAddress,  completionHandler: @escaping (Result<String, Error>) -> Void) {
    Task {
        do {
            let symbol = try await symbol(contractAddress: contractAddress )
            completionHandler(.success(symbol))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func tokenByIndex(contractAddress: EthereumAddress, index: BigUInt,  completionHandler: @escaping (Result<BigUInt, Error>) -> Void) {
    Task {
        do {
            let tokenByIndex = try await tokenByIndex(contractAddress: contractAddress , index: index)
            completionHandler(.success(tokenByIndex))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func tokenOfOwnerByIndex(contractAddress: EthereumAddress, owner: EthereumAddress, index: BigUInt,  completionHandler: @escaping (Result<BigUInt, Error>) -> Void) {
    Task {
        do {
            let tokenOfOwnerByIndex = try await tokenOfOwnerByIndex(contractAddress: contractAddress , owner: owner, index: index)
            completionHandler(.success(tokenOfOwnerByIndex))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func tokenURI(contractAddress: EthereumAddress, tokenId: BigUInt,  completionHandler: @escaping (Result<String, Error>) -> Void) {
    Task {
        do {
            let tokenURI = try await tokenURI(contractAddress: contractAddress , tokenId: tokenId)
            completionHandler(.success(tokenURI))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func totalSupply(contractAddress: EthereumAddress,  completionHandler: @escaping (Result<BigUInt, Error>) -> Void) {
    Task {
        do {
            let totalSupply = try await totalSupply(contractAddress: contractAddress )
            completionHandler(.success(totalSupply))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
  public func walletOfOwner(contractAddress: EthereumAddress, _owner: EthereumAddress,  completionHandler: @escaping (Result<[BigUInt], Error>) -> Void) {
    Task {
        do {
            let walletOfOwner = try await walletOfOwner(contractAddress: contractAddress , _owner: _owner)
            completionHandler(.success(walletOfOwner))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
}
