// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: yac.proto
//
// For information on using the generated types, please see the documenation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that your are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct Iroha_Consensus_Yac_Proto_Signature {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var pubkey: Data = SwiftProtobuf.Internal.emptyData

  var signature: Data = SwiftProtobuf.Internal.emptyData

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Iroha_Consensus_Yac_Proto_Hash {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var proposal: Data {
    get {return _storage._proposal}
    set {_uniqueStorage()._proposal = newValue}
  }

  var block: Data {
    get {return _storage._block}
    set {_uniqueStorage()._block = newValue}
  }

  var blockSignature: Iroha_Consensus_Yac_Proto_Signature {
    get {return _storage._blockSignature ?? Iroha_Consensus_Yac_Proto_Signature()}
    set {_uniqueStorage()._blockSignature = newValue}
  }
  /// Returns true if `blockSignature` has been explicitly set.
  var hasBlockSignature: Bool {return _storage._blockSignature != nil}
  /// Clears the value of `blockSignature`. Subsequent reads from it will return its default value.
  mutating func clearBlockSignature() {_storage._blockSignature = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

struct Iroha_Consensus_Yac_Proto_Vote {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var hash: Iroha_Consensus_Yac_Proto_Hash {
    get {return _storage._hash ?? Iroha_Consensus_Yac_Proto_Hash()}
    set {_uniqueStorage()._hash = newValue}
  }
  /// Returns true if `hash` has been explicitly set.
  var hasHash: Bool {return _storage._hash != nil}
  /// Clears the value of `hash`. Subsequent reads from it will return its default value.
  mutating func clearHash() {_storage._hash = nil}

  var signature: Iroha_Consensus_Yac_Proto_Signature {
    get {return _storage._signature ?? Iroha_Consensus_Yac_Proto_Signature()}
    set {_uniqueStorage()._signature = newValue}
  }
  /// Returns true if `signature` has been explicitly set.
  var hasSignature: Bool {return _storage._signature != nil}
  /// Clears the value of `signature`. Subsequent reads from it will return its default value.
  mutating func clearSignature() {_storage._signature = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

struct Iroha_Consensus_Yac_Proto_Commit {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var votes: [Iroha_Consensus_Yac_Proto_Vote] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Iroha_Consensus_Yac_Proto_Reject {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var votes: [Iroha_Consensus_Yac_Proto_Vote] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "iroha.consensus.yac.proto"

extension Iroha_Consensus_Yac_Proto_Signature: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Signature"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "pubkey"),
    2: .same(proto: "signature"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularBytesField(value: &self.pubkey)
      case 2: try decoder.decodeSingularBytesField(value: &self.signature)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.pubkey.isEmpty {
      try visitor.visitSingularBytesField(value: self.pubkey, fieldNumber: 1)
    }
    if !self.signature.isEmpty {
      try visitor.visitSingularBytesField(value: self.signature, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  func _protobuf_generated_isEqualTo(other: Iroha_Consensus_Yac_Proto_Signature) -> Bool {
    if self.pubkey != other.pubkey {return false}
    if self.signature != other.signature {return false}
    if unknownFields != other.unknownFields {return false}
    return true
  }
}

extension Iroha_Consensus_Yac_Proto_Hash: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Hash"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "proposal"),
    2: .same(proto: "block"),
    3: .standard(proto: "block_signature"),
  ]

  fileprivate class _StorageClass {
    var _proposal: Data = SwiftProtobuf.Internal.emptyData
    var _block: Data = SwiftProtobuf.Internal.emptyData
    var _blockSignature: Iroha_Consensus_Yac_Proto_Signature? = nil

    static let defaultInstance = _StorageClass()

    private init() {}

    init(copying source: _StorageClass) {
      _proposal = source._proposal
      _block = source._block
      _blockSignature = source._blockSignature
    }
  }

  fileprivate mutating func _uniqueStorage() -> _StorageClass {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _StorageClass(copying: _storage)
    }
    return _storage
  }

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    _ = _uniqueStorage()
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      while let fieldNumber = try decoder.nextFieldNumber() {
        switch fieldNumber {
        case 1: try decoder.decodeSingularBytesField(value: &_storage._proposal)
        case 2: try decoder.decodeSingularBytesField(value: &_storage._block)
        case 3: try decoder.decodeSingularMessageField(value: &_storage._blockSignature)
        default: break
        }
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if !_storage._proposal.isEmpty {
        try visitor.visitSingularBytesField(value: _storage._proposal, fieldNumber: 1)
      }
      if !_storage._block.isEmpty {
        try visitor.visitSingularBytesField(value: _storage._block, fieldNumber: 2)
      }
      if let v = _storage._blockSignature {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 3)
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  func _protobuf_generated_isEqualTo(other: Iroha_Consensus_Yac_Proto_Hash) -> Bool {
    if _storage !== other._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((_storage, other._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let other_storage = _args.1
        if _storage._proposal != other_storage._proposal {return false}
        if _storage._block != other_storage._block {return false}
        if _storage._blockSignature != other_storage._blockSignature {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if unknownFields != other.unknownFields {return false}
    return true
  }
}

extension Iroha_Consensus_Yac_Proto_Vote: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Vote"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "hash"),
    2: .same(proto: "signature"),
  ]

  fileprivate class _StorageClass {
    var _hash: Iroha_Consensus_Yac_Proto_Hash? = nil
    var _signature: Iroha_Consensus_Yac_Proto_Signature? = nil

    static let defaultInstance = _StorageClass()

    private init() {}

    init(copying source: _StorageClass) {
      _hash = source._hash
      _signature = source._signature
    }
  }

  fileprivate mutating func _uniqueStorage() -> _StorageClass {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _StorageClass(copying: _storage)
    }
    return _storage
  }

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    _ = _uniqueStorage()
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      while let fieldNumber = try decoder.nextFieldNumber() {
        switch fieldNumber {
        case 1: try decoder.decodeSingularMessageField(value: &_storage._hash)
        case 2: try decoder.decodeSingularMessageField(value: &_storage._signature)
        default: break
        }
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if let v = _storage._hash {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
      }
      if let v = _storage._signature {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  func _protobuf_generated_isEqualTo(other: Iroha_Consensus_Yac_Proto_Vote) -> Bool {
    if _storage !== other._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((_storage, other._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let other_storage = _args.1
        if _storage._hash != other_storage._hash {return false}
        if _storage._signature != other_storage._signature {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if unknownFields != other.unknownFields {return false}
    return true
  }
}

extension Iroha_Consensus_Yac_Proto_Commit: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Commit"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "votes"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeRepeatedMessageField(value: &self.votes)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.votes.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.votes, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  func _protobuf_generated_isEqualTo(other: Iroha_Consensus_Yac_Proto_Commit) -> Bool {
    if self.votes != other.votes {return false}
    if unknownFields != other.unknownFields {return false}
    return true
  }
}

extension Iroha_Consensus_Yac_Proto_Reject: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Reject"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "votes"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeRepeatedMessageField(value: &self.votes)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.votes.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.votes, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  func _protobuf_generated_isEqualTo(other: Iroha_Consensus_Yac_Proto_Reject) -> Bool {
    if self.votes != other.votes {return false}
    if unknownFields != other.unknownFields {return false}
    return true
  }
}
