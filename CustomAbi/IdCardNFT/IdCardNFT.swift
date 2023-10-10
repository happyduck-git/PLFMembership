
//
//  swiftAbi
//  Don't change the files! this file is generated!
//  https://github.com/imanrep/
//

import BigInt
import Foundation
import web3

public protocol IdCardNFTProtocol {
  init(client: EthereumClientProtocol)

  func balanceOf(contractAddress: EthereumAddress , owner: EthereumAddress ) async throws -> BigUInt
  func getApproved(contractAddress: EthereumAddress , tokenId: BigUInt ) async throws -> EthereumAddress
  func getCurrentUserTier(contractAddress: EthereumAddress , user: EthereumAddress ) async throws -> BigUInt
  func isApprovedForAll(contractAddress: EthereumAddress , owner: EthereumAddress, `operator`: EthereumAddress ) async throws -> Bool
  func locked(contractAddress: EthereumAddress , tokenId: BigUInt ) async throws -> Bool
  func name(contractAddress: EthereumAddress  ) async throws -> String
  func owner(contractAddress: EthereumAddress  ) async throws -> EthereumAddress
  func ownerOf(contractAddress: EthereumAddress , tokenId: BigUInt ) async throws -> EthereumAddress
  func supportsInterface(contractAddress: EthereumAddress , _interfaceId: BigUInt ) async throws -> Bool
  func symbol(contractAddress: EthereumAddress  ) async throws -> String
  func tokenByIndex(contractAddress: EthereumAddress , index: BigUInt ) async throws -> BigUInt
  func tokenOfOwnerByIndex(contractAddress: EthereumAddress , owner: EthereumAddress, index: BigUInt ) async throws -> BigUInt
  func tokenURI(contractAddress: EthereumAddress , tokenId: BigUInt ) async throws -> String
  func totalSupply(contractAddress: EthereumAddress  ) async throws -> BigUInt
}

open class IdCardNFT: IdCardNFTProtocol {
  let client: EthereumClientProtocol

  required public init(client: EthereumClientProtocol) {
      self.client = client
  }

  public func balanceOf(contractAddress: EthereumAddress , owner: EthereumAddress) async throws -> BigUInt {
    let function = IdCardNFTFunctions.balanceOf(contract: contractAddress , owner: owner)
    let data = try await function.call(withClient: client, responseType: IdCardNFTResponses.balanceOfResponse.self)
    return data.value
}
  public func getApproved(contractAddress: EthereumAddress , tokenId: BigUInt) async throws -> EthereumAddress {
    let function = IdCardNFTFunctions.getApproved(contract: contractAddress , tokenId: tokenId)
    let data = try await function.call(withClient: client, responseType: IdCardNFTResponses.getApprovedResponse.self)
    return data.value
}
  public func getCurrentUserTier(contractAddress: EthereumAddress , user: EthereumAddress) async throws -> BigUInt {
    let function = IdCardNFTFunctions.getCurrentUserTier(contract: contractAddress , user: user)
    let data = try await function.call(withClient: client, responseType: IdCardNFTResponses.getCurrentUserTierResponse.self)
    return data.value
}
  public func isApprovedForAll(contractAddress: EthereumAddress , owner: EthereumAddress, `operator`: EthereumAddress) async throws -> Bool {
    let function = IdCardNFTFunctions.isApprovedForAll(contract: contractAddress , owner: owner, `operator`: `operator`)
    let data = try await function.call(withClient: client, responseType: IdCardNFTResponses.isApprovedForAllResponse.self)
    return data.value
}
  public func locked(contractAddress: EthereumAddress , tokenId: BigUInt) async throws -> Bool {
    let function = IdCardNFTFunctions.locked(contract: contractAddress , tokenId: tokenId)
    let data = try await function.call(withClient: client, responseType: IdCardNFTResponses.lockedResponse.self)
    return data.value
}
  public func name(contractAddress: EthereumAddress ) async throws -> String {
    let function = IdCardNFTFunctions.name(contract: contractAddress )
    let data = try await function.call(withClient: client, responseType: IdCardNFTResponses.nameResponse.self)
    return data.value
}
  public func owner(contractAddress: EthereumAddress ) async throws -> EthereumAddress {
    let function = IdCardNFTFunctions.owner(contract: contractAddress )
    let data = try await function.call(withClient: client, responseType: IdCardNFTResponses.ownerResponse.self)
    return data.value
}
  public func ownerOf(contractAddress: EthereumAddress , tokenId: BigUInt) async throws -> EthereumAddress {
    let function = IdCardNFTFunctions.ownerOf(contract: contractAddress , tokenId: tokenId)
    let data = try await function.call(withClient: client, responseType: IdCardNFTResponses.ownerOfResponse.self)
    return data.value
}
  public func supportsInterface(contractAddress: EthereumAddress , _interfaceId: BigUInt) async throws -> Bool {
    let function = IdCardNFTFunctions.supportsInterface(contract: contractAddress , _interfaceId: _interfaceId)
    let data = try await function.call(withClient: client, responseType: IdCardNFTResponses.supportsInterfaceResponse.self)
    return data.value
}
  public func symbol(contractAddress: EthereumAddress ) async throws -> String {
    let function = IdCardNFTFunctions.symbol(contract: contractAddress )
    let data = try await function.call(withClient: client, responseType: IdCardNFTResponses.symbolResponse.self)
    return data.value
}
  public func tokenByIndex(contractAddress: EthereumAddress , index: BigUInt) async throws -> BigUInt {
    let function = IdCardNFTFunctions.tokenByIndex(contract: contractAddress , index: index)
    let data = try await function.call(withClient: client, responseType: IdCardNFTResponses.tokenByIndexResponse.self)
    return data.value
}
  public func tokenOfOwnerByIndex(contractAddress: EthereumAddress , owner: EthereumAddress, index: BigUInt) async throws -> BigUInt {
    let function = IdCardNFTFunctions.tokenOfOwnerByIndex(contract: contractAddress , owner: owner, index: index)
    let data = try await function.call(withClient: client, responseType: IdCardNFTResponses.tokenOfOwnerByIndexResponse.self)
    return data.value
}
  public func tokenURI(contractAddress: EthereumAddress , tokenId: BigUInt) async throws -> String {
    let function = IdCardNFTFunctions.tokenURI(contract: contractAddress , tokenId: tokenId)
    let data = try await function.call(withClient: client, responseType: IdCardNFTResponses.tokenURIResponse.self)
    return data.value
}
  public func totalSupply(contractAddress: EthereumAddress ) async throws -> BigUInt {
    let function = IdCardNFTFunctions.totalSupply(contract: contractAddress )
    let data = try await function.call(withClient: client, responseType: IdCardNFTResponses.totalSupplyResponse.self)
    return data.value
}

}
open class IdCardNFTContract {
  var IdCardNFTCall: IdCardNFT?
  var client: EthereumClientProtocol
  var contract: web3.EthereumAddress
  
  init(contract: String, client: EthereumClientProtocol) {
      self.contract = EthereumAddress(contract)
      self.client = client
      self.IdCardNFTCall = IdCardNFT(client: client)
      }
  public func balanceOf(owner: EthereumAddress) async throws -> BigUInt{
      return try await (IdCardNFTCall?.balanceOf(contractAddress: contract, owner: owner))!
   }
   
  public func getApproved(tokenId: BigUInt) async throws -> EthereumAddress{
      return try await (IdCardNFTCall?.getApproved(contractAddress: contract, tokenId: tokenId))!
   }
   
  public func getCurrentUserTier(user: EthereumAddress) async throws -> BigUInt{
      return try await (IdCardNFTCall?.getCurrentUserTier(contractAddress: contract, user: user))!
   }
   
  public func isApprovedForAll(owner: EthereumAddress, `operator`: EthereumAddress) async throws -> Bool{
      return try await (IdCardNFTCall?.isApprovedForAll(contractAddress: contract, owner: owner, `operator`: `operator`))!
   }
   
  public func locked(tokenId: BigUInt) async throws -> Bool{
      return try await (IdCardNFTCall?.locked(contractAddress: contract, tokenId: tokenId))!
   }
   
  public func name() async throws -> String{
      return try await (IdCardNFTCall?.name(contractAddress: contract))!
   }
   
  public func owner() async throws -> EthereumAddress{
      return try await (IdCardNFTCall?.owner(contractAddress: contract))!
   }
   
  public func ownerOf(tokenId: BigUInt) async throws -> EthereumAddress{
      return try await (IdCardNFTCall?.ownerOf(contractAddress: contract, tokenId: tokenId))!
   }
   
  public func supportsInterface(_interfaceId: BigUInt) async throws -> Bool{
      return try await (IdCardNFTCall?.supportsInterface(contractAddress: contract, _interfaceId: _interfaceId))!
   }
   
  public func symbol() async throws -> String{
      return try await (IdCardNFTCall?.symbol(contractAddress: contract))!
   }
   
  public func tokenByIndex(index: BigUInt) async throws -> BigUInt{
      return try await (IdCardNFTCall?.tokenByIndex(contractAddress: contract, index: index))!
   }
   
  public func tokenOfOwnerByIndex(owner: EthereumAddress, index: BigUInt) async throws -> BigUInt{
      return try await (IdCardNFTCall?.tokenOfOwnerByIndex(contractAddress: contract, owner: owner, index: index))!
   }
   
  public func tokenURI(tokenId: BigUInt) async throws -> String{
      return try await (IdCardNFTCall?.tokenURI(contractAddress: contract, tokenId: tokenId))!
   }
   
  public func totalSupply() async throws -> BigUInt{
      return try await (IdCardNFTCall?.totalSupply(contractAddress: contract))!
   }
   
      
}
extension IdCardNFT {
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
  public func getCurrentUserTier(contractAddress: EthereumAddress, user: EthereumAddress,  completionHandler: @escaping (Result<BigUInt, Error>) -> Void) {
    Task {
        do {
            let getCurrentUserTier = try await getCurrentUserTier(contractAddress: contractAddress , user: user)
            completionHandler(.success(getCurrentUserTier))
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
  public func supportsInterface(contractAddress: EthereumAddress, _interfaceId: BigUInt,  completionHandler: @escaping (Result<Bool, Error>) -> Void) {
    Task {
        do {
            let supportsInterface = try await supportsInterface(contractAddress: contractAddress , _interfaceId: _interfaceId)
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
}
