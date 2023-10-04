
//
//  swiftAbi
//  Don't change the files! this file is generated!
//  https://github.com/imanrep/
//

import BigInt
import Foundation
import web3

public enum CoffeeNFTFunctions {
  public struct balanceOf: ABIFunction {
    public static let name = "balanceOf"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    public let owner: EthereumAddress
    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil,
        owner: EthereumAddress
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.owner = owner
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      try encoder.encode(owner)
      
    }
}
   public struct getApproved: ABIFunction {
    public static let name = "getApproved"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    public let tokenId: BigUInt
    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil,
        tokenId: BigUInt
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.tokenId = tokenId
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      try encoder.encode(tokenId)
      
    }
}
   public struct getCoffeeCoupon: ABIFunction {
    public static let name = "getCoffeeCoupon"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    public let tokenId: BigUInt
    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil,
        tokenId: BigUInt
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.tokenId = tokenId
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      try encoder.encode(tokenId)
      
    }
}
   public struct isApprovedForAll: ABIFunction {
    public static let name = "isApprovedForAll"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    public let owner: EthereumAddress
    public let `operator`: EthereumAddress
    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil,
        owner: EthereumAddress,
        `operator`: EthereumAddress
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.owner = owner
        self.`operator` = `operator`
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      try encoder.encode(owner)
      try encoder.encode(`operator`)
      
    }
}
   public struct locked: ABIFunction {
    public static let name = "locked"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    public let tokenId: BigUInt
    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil,
        tokenId: BigUInt
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.tokenId = tokenId
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      try encoder.encode(tokenId)
      
    }
}
   public struct maxMintAmount: ABIFunction {
    public static let name = "maxMintAmount"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      
    }
}
   public struct maxSupply: ABIFunction {
    public static let name = "maxSupply"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      
    }
}
   public struct name: ABIFunction {
    public static let name = "name"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      
    }
}
   public struct owner: ABIFunction {
    public static let name = "owner"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      
    }
}
   public struct ownerOf: ABIFunction {
    public static let name = "ownerOf"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    public let tokenId: BigUInt
    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil,
        tokenId: BigUInt
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.tokenId = tokenId
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      try encoder.encode(tokenId)
      
    }
}
   public struct supportsInterface: ABIFunction {
    public static let name = "supportsInterface"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    public let interfaceId: BigUInt
    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil,
        interfaceId: BigUInt
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.interfaceId = interfaceId
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      try encoder.encode(interfaceId)
      
    }
}
   public struct symbol: ABIFunction {
    public static let name = "symbol"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      
    }
}
   public struct tokenByIndex: ABIFunction {
    public static let name = "tokenByIndex"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    public let index: BigUInt
    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil,
        index: BigUInt
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.index = index
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      try encoder.encode(index)
      
    }
}
   public struct tokenOfOwnerByIndex: ABIFunction {
    public static let name = "tokenOfOwnerByIndex"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    public let owner: EthereumAddress
    public let index: BigUInt
    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil,
        owner: EthereumAddress,
        index: BigUInt
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.owner = owner
        self.index = index
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      try encoder.encode(owner)
      try encoder.encode(index)
      
    }
}
   public struct tokenURI: ABIFunction {
    public static let name = "tokenURI"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    public let tokenId: BigUInt
    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil,
        tokenId: BigUInt
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.tokenId = tokenId
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      try encoder.encode(tokenId)
      
    }
}
   public struct totalSupply: ABIFunction {
    public static let name = "totalSupply"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      
    }
}
   public struct walletOfOwner: ABIFunction {
    public static let name = "walletOfOwner"
    public let gasPrice: BigUInt?
    public let gasLimit: BigUInt?
    public var contract: EthereumAddress
    public let from: EthereumAddress?

    public let _owner: EthereumAddress
    

    public init(
        contract: EthereumAddress,
        from: EthereumAddress? = nil,
        gasPrice: BigUInt? = nil,
        gasLimit: BigUInt? = nil,
        _owner: EthereumAddress
        
    ) {
        self.contract = contract
        self.from = from
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self._owner = _owner
        
    }

    public func encode(to encoder: ABIFunctionEncoder) throws {
      try encoder.encode(_owner)
      
    }
}

}
