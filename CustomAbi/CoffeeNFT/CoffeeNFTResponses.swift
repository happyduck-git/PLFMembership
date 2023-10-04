
//
//  swiftAbi
//  Don't change the files! this file is generated!
//  https://github.com/imanrep/
//

import BigInt
import Foundation
import web3

public enum CoffeeNFTResponses {
  public struct balanceOfResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [BigUInt.self]
    public let value: BigUInt
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct getApprovedResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [EthereumAddress.self]
    public let value: EthereumAddress
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct getCoffeeCouponResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [String.self]
    public let value: String
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct isApprovedForAllResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [Bool.self]
    public let value: Bool
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct lockedResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [Bool.self]
    public let value: Bool
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct maxMintAmountResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [BigUInt.self]
    public let value: BigUInt
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct maxSupplyResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [BigUInt.self]
    public let value: BigUInt
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct nameResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [String.self]
    public let value: String
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct ownerResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [EthereumAddress.self]
    public let value: EthereumAddress
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct ownerOfResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [EthereumAddress.self]
    public let value: EthereumAddress
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct supportsInterfaceResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [Bool.self]
    public let value: Bool
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct symbolResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [String.self]
    public let value: String
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct tokenByIndexResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [BigUInt.self]
    public let value: BigUInt
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct tokenOfOwnerByIndexResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [BigUInt.self]
    public let value: BigUInt
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct tokenURIResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [String.self]
    public let value: String
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct totalSupplyResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [BigUInt.self]
    public let value: BigUInt
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decoded()
      
    }
}
  public struct walletOfOwnerResponse: ABIResponse, MulticallDecodableResponse {
    public static var types: [ABIType.Type] = [ABIArray<BigUInt>.self]
    public let value: [BigUInt]
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {

      self.value = try values[0].decodedArray()
      
    }
}

}
