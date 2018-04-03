// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: CentigradeData.proto
//
// For information on using the generated types, please see the documenation:
//   https://github.com/apple/swift-protobuf/

//
// CentigradeData.proto 
// Provides a medium for sensor<->device<->server communication

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

public struct Centigrade_Celsius: SwiftProtobuf.Message {
  public static let protoMessageName: String = _protobuf_package + ".Celsius"

  public var value: Double = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  /// Used by the decoding initializers in the SwiftProtobuf library, not generally
  /// used directly. `init(serializedData:)`, `init(jsonUTF8Data:)`, and other decoding
  /// initializers are defined in the SwiftProtobuf library. See the Message and
  /// Message+*Additions` files.
  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularDoubleField(value: &self.value)
      default: break
      }
    }
  }

  /// Used by the encoding methods of the SwiftProtobuf library, not generally
  /// used directly. `Message.serializedData()`, `Message.jsonUTF8Data()`, and
  /// other serializer methods are defined in the SwiftProtobuf library. See the
  /// `Message` and `Message+*Additions` files.
  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.value != 0 {
      try visitor.visitSingularDoubleField(value: self.value, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }
}

public struct Centigrade_Hectopascals: SwiftProtobuf.Message {
  public static let protoMessageName: String = _protobuf_package + ".Hectopascals"

  public var value: UInt32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  /// Used by the decoding initializers in the SwiftProtobuf library, not generally
  /// used directly. `init(serializedData:)`, `init(jsonUTF8Data:)`, and other decoding
  /// initializers are defined in the SwiftProtobuf library. See the Message and
  /// Message+*Additions` files.
  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularUInt32Field(value: &self.value)
      default: break
      }
    }
  }

  /// Used by the encoding methods of the SwiftProtobuf library, not generally
  /// used directly. `Message.serializedData()`, `Message.jsonUTF8Data()`, and
  /// other serializer methods are defined in the SwiftProtobuf library. See the
  /// `Message` and `Message+*Additions` files.
  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.value != 0 {
      try visitor.visitSingularUInt32Field(value: self.value, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }
}

public struct Centigrade_Meters: SwiftProtobuf.Message {
  public static let protoMessageName: String = _protobuf_package + ".Meters"

  public var value: Int32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  /// Used by the decoding initializers in the SwiftProtobuf library, not generally
  /// used directly. `init(serializedData:)`, `init(jsonUTF8Data:)`, and other decoding
  /// initializers are defined in the SwiftProtobuf library. See the Message and
  /// Message+*Additions` files.
  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularSInt32Field(value: &self.value)
      default: break
      }
    }
  }

  /// Used by the encoding methods of the SwiftProtobuf library, not generally
  /// used directly. `Message.serializedData()`, `Message.jsonUTF8Data()`, and
  /// other serializer methods are defined in the SwiftProtobuf library. See the
  /// `Message` and `Message+*Additions` files.
  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.value != 0 {
      try visitor.visitSingularSInt32Field(value: self.value, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }
}

public struct Centigrade_MetersPerSecond: SwiftProtobuf.Message {
  public static let protoMessageName: String = _protobuf_package + ".MetersPerSecond"

  public var value: Double = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  /// Used by the decoding initializers in the SwiftProtobuf library, not generally
  /// used directly. `init(serializedData:)`, `init(jsonUTF8Data:)`, and other decoding
  /// initializers are defined in the SwiftProtobuf library. See the Message and
  /// Message+*Additions` files.
  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularDoubleField(value: &self.value)
      default: break
      }
    }
  }

  /// Used by the encoding methods of the SwiftProtobuf library, not generally
  /// used directly. `Message.serializedData()`, `Message.jsonUTF8Data()`, and
  /// other serializer methods are defined in the SwiftProtobuf library. See the
  /// `Message` and `Message+*Additions` files.
  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.value != 0 {
      try visitor.visitSingularDoubleField(value: self.value, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }
}

public struct Centigrade_PartsPerBillion: SwiftProtobuf.Message {
  public static let protoMessageName: String = _protobuf_package + ".PartsPerBillion"

  public var value: UInt32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  /// Used by the decoding initializers in the SwiftProtobuf library, not generally
  /// used directly. `init(serializedData:)`, `init(jsonUTF8Data:)`, and other decoding
  /// initializers are defined in the SwiftProtobuf library. See the Message and
  /// Message+*Additions` files.
  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularUInt32Field(value: &self.value)
      default: break
      }
    }
  }

  /// Used by the encoding methods of the SwiftProtobuf library, not generally
  /// used directly. `Message.serializedData()`, `Message.jsonUTF8Data()`, and
  /// other serializer methods are defined in the SwiftProtobuf library. See the
  /// `Message` and `Message+*Additions` files.
  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.value != 0 {
      try visitor.visitSingularUInt32Field(value: self.value, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }
}

public struct Centigrade_PartsPerMillion: SwiftProtobuf.Message {
  public static let protoMessageName: String = _protobuf_package + ".PartsPerMillion"

  public var value: UInt32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  /// Used by the decoding initializers in the SwiftProtobuf library, not generally
  /// used directly. `init(serializedData:)`, `init(jsonUTF8Data:)`, and other decoding
  /// initializers are defined in the SwiftProtobuf library. See the Message and
  /// Message+*Additions` files.
  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularUInt32Field(value: &self.value)
      default: break
      }
    }
  }

  /// Used by the encoding methods of the SwiftProtobuf library, not generally
  /// used directly. `Message.serializedData()`, `Message.jsonUTF8Data()`, and
  /// other serializer methods are defined in the SwiftProtobuf library. See the
  /// `Message` and `Message+*Additions` files.
  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.value != 0 {
      try visitor.visitSingularUInt32Field(value: self.value, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }
}

public struct Centigrade_Percent: SwiftProtobuf.Message {
  public static let protoMessageName: String = _protobuf_package + ".Percent"

  public var value: UInt32 = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  /// Used by the decoding initializers in the SwiftProtobuf library, not generally
  /// used directly. `init(serializedData:)`, `init(jsonUTF8Data:)`, and other decoding
  /// initializers are defined in the SwiftProtobuf library. See the Message and
  /// Message+*Additions` files.
  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularUInt32Field(value: &self.value)
      default: break
      }
    }
  }

  /// Used by the encoding methods of the SwiftProtobuf library, not generally
  /// used directly. `Message.serializedData()`, `Message.jsonUTF8Data()`, and
  /// other serializer methods are defined in the SwiftProtobuf library. See the
  /// `Message` and `Message+*Additions` files.
  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.value != 0 {
      try visitor.visitSingularUInt32Field(value: self.value, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }
}

public struct Centigrade_Radians: SwiftProtobuf.Message {
  public static let protoMessageName: String = _protobuf_package + ".Radians"

  public var value: Double = 0

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  /// Used by the decoding initializers in the SwiftProtobuf library, not generally
  /// used directly. `init(serializedData:)`, `init(jsonUTF8Data:)`, and other decoding
  /// initializers are defined in the SwiftProtobuf library. See the Message and
  /// Message+*Additions` files.
  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularDoubleField(value: &self.value)
      default: break
      }
    }
  }

  /// Used by the encoding methods of the SwiftProtobuf library, not generally
  /// used directly. `Message.serializedData()`, `Message.jsonUTF8Data()`, and
  /// other serializer methods are defined in the SwiftProtobuf library. See the
  /// `Message` and `Message+*Additions` files.
  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.value != 0 {
      try visitor.visitSingularDoubleField(value: self.value, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }
}

public struct Centigrade_Sensor: SwiftProtobuf.Message {
  public static let protoMessageName: String = _protobuf_package + ".Sensor"

  public var uuid: String = String()

  public var sensorType: Centigrade_Sensor.SensorType = .default

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public enum SensorType: SwiftProtobuf.Enum {
    public typealias RawValue = Int
    case `default` // = 0
    case altitude // = 1
    case anemometer // = 2
    case equivalentCo2 // = 3
    case humidity // = 4
    case pressure // = 5
    case temperature // = 6
    case totalVoc // = 7
    case UNRECOGNIZED(Int)

    public init() {
      self = .default
    }

    public init?(rawValue: Int) {
      switch rawValue {
      case 0: self = .default
      case 1: self = .altitude
      case 2: self = .anemometer
      case 3: self = .equivalentCo2
      case 4: self = .humidity
      case 5: self = .pressure
      case 6: self = .temperature
      case 7: self = .totalVoc
      default: self = .UNRECOGNIZED(rawValue)
      }
    }

    public var rawValue: Int {
      switch self {
      case .default: return 0
      case .altitude: return 1
      case .anemometer: return 2
      case .equivalentCo2: return 3
      case .humidity: return 4
      case .pressure: return 5
      case .temperature: return 6
      case .totalVoc: return 7
      case .UNRECOGNIZED(let i): return i
      }
    }

  }

  public init() {}

  /// Used by the decoding initializers in the SwiftProtobuf library, not generally
  /// used directly. `init(serializedData:)`, `init(jsonUTF8Data:)`, and other decoding
  /// initializers are defined in the SwiftProtobuf library. See the Message and
  /// Message+*Additions` files.
  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularStringField(value: &self.uuid)
      case 2: try decoder.decodeSingularEnumField(value: &self.sensorType)
      default: break
      }
    }
  }

  /// Used by the encoding methods of the SwiftProtobuf library, not generally
  /// used directly. `Message.serializedData()`, `Message.jsonUTF8Data()`, and
  /// other serializer methods are defined in the SwiftProtobuf library. See the
  /// `Message` and `Message+*Additions` files.
  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.uuid.isEmpty {
      try visitor.visitSingularStringField(value: self.uuid, fieldNumber: 1)
    }
    if self.sensorType != .default {
      try visitor.visitSingularEnumField(value: self.sensorType, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }
}

///
/// Measurement
public struct Centigrade_Measurement: SwiftProtobuf.Message {
  public static let protoMessageName: String = _protobuf_package + ".Measurement"

  public var time: UInt64 {
    get {return _storage._time}
    set {_uniqueStorage()._time = newValue}
  }

  public var measurement: OneOf_Measurement? {
    get {return _storage._measurement}
    set {_uniqueStorage()._measurement = newValue}
  }

  public var temperature: Centigrade_Celsius {
    get {
      if case .temperature(let v)? = _storage._measurement {return v}
      return Centigrade_Celsius()
    }
    set {_uniqueStorage()._measurement = .temperature(newValue)}
  }

  public var pressure: Centigrade_Hectopascals {
    get {
      if case .pressure(let v)? = _storage._measurement {return v}
      return Centigrade_Hectopascals()
    }
    set {_uniqueStorage()._measurement = .pressure(newValue)}
  }

  public var altitude: Centigrade_Meters {
    get {
      if case .altitude(let v)? = _storage._measurement {return v}
      return Centigrade_Meters()
    }
    set {_uniqueStorage()._measurement = .altitude(newValue)}
  }

  public var windSpeed: Centigrade_MetersPerSecond {
    get {
      if case .windSpeed(let v)? = _storage._measurement {return v}
      return Centigrade_MetersPerSecond()
    }
    set {_uniqueStorage()._measurement = .windSpeed(newValue)}
  }

  public var totalVocs: Centigrade_PartsPerBillion {
    get {
      if case .totalVocs(let v)? = _storage._measurement {return v}
      return Centigrade_PartsPerBillion()
    }
    set {_uniqueStorage()._measurement = .totalVocs(newValue)}
  }

  public var equivalentCo2: Centigrade_PartsPerMillion {
    get {
      if case .equivalentCo2(let v)? = _storage._measurement {return v}
      return Centigrade_PartsPerMillion()
    }
    set {_uniqueStorage()._measurement = .equivalentCo2(newValue)}
  }

  public var humidity: Centigrade_Percent {
    get {
      if case .humidity(let v)? = _storage._measurement {return v}
      return Centigrade_Percent()
    }
    set {_uniqueStorage()._measurement = .humidity(newValue)}
  }

  public var windDirection: Centigrade_Radians {
    get {
      if case .windDirection(let v)? = _storage._measurement {return v}
      return Centigrade_Radians()
    }
    set {_uniqueStorage()._measurement = .windDirection(newValue)}
  }

  public var sensor: Centigrade_Sensor {
    get {return _storage._sensor ?? Centigrade_Sensor()}
    set {_uniqueStorage()._sensor = newValue}
  }
  /// Returns true if `sensor` has been explicitly set.
  public var hasSensor: Bool {return _storage._sensor != nil}
  /// Clears the value of `sensor`. Subsequent reads from it will return its default value.
  public mutating func clearSensor() {_storage._sensor = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public enum OneOf_Measurement: Equatable {
    case temperature(Centigrade_Celsius)
    case pressure(Centigrade_Hectopascals)
    case altitude(Centigrade_Meters)
    case windSpeed(Centigrade_MetersPerSecond)
    case totalVocs(Centigrade_PartsPerBillion)
    case equivalentCo2(Centigrade_PartsPerMillion)
    case humidity(Centigrade_Percent)
    case windDirection(Centigrade_Radians)

    public static func ==(lhs: Centigrade_Measurement.OneOf_Measurement, rhs: Centigrade_Measurement.OneOf_Measurement) -> Bool {
      switch (lhs, rhs) {
      case (.temperature(let l), .temperature(let r)): return l == r
      case (.pressure(let l), .pressure(let r)): return l == r
      case (.altitude(let l), .altitude(let r)): return l == r
      case (.windSpeed(let l), .windSpeed(let r)): return l == r
      case (.totalVocs(let l), .totalVocs(let r)): return l == r
      case (.equivalentCo2(let l), .equivalentCo2(let r)): return l == r
      case (.humidity(let l), .humidity(let r)): return l == r
      case (.windDirection(let l), .windDirection(let r)): return l == r
      default: return false
      }
    }
  }

  public init() {}

  /// Used by the decoding initializers in the SwiftProtobuf library, not generally
  /// used directly. `init(serializedData:)`, `init(jsonUTF8Data:)`, and other decoding
  /// initializers are defined in the SwiftProtobuf library. See the Message and
  /// Message+*Additions` files.
  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    _ = _uniqueStorage()
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      while let fieldNumber = try decoder.nextFieldNumber() {
        switch fieldNumber {
        case 1: try decoder.decodeSingularUInt64Field(value: &_storage._time)
        case 2:
          var v: Centigrade_Celsius?
          if let current = _storage._measurement {
            try decoder.handleConflictingOneOf()
            if case .temperature(let m) = current {v = m}
          }
          try decoder.decodeSingularMessageField(value: &v)
          if let v = v {_storage._measurement = .temperature(v)}
        case 3:
          var v: Centigrade_Hectopascals?
          if let current = _storage._measurement {
            try decoder.handleConflictingOneOf()
            if case .pressure(let m) = current {v = m}
          }
          try decoder.decodeSingularMessageField(value: &v)
          if let v = v {_storage._measurement = .pressure(v)}
        case 4:
          var v: Centigrade_Meters?
          if let current = _storage._measurement {
            try decoder.handleConflictingOneOf()
            if case .altitude(let m) = current {v = m}
          }
          try decoder.decodeSingularMessageField(value: &v)
          if let v = v {_storage._measurement = .altitude(v)}
        case 5:
          var v: Centigrade_MetersPerSecond?
          if let current = _storage._measurement {
            try decoder.handleConflictingOneOf()
            if case .windSpeed(let m) = current {v = m}
          }
          try decoder.decodeSingularMessageField(value: &v)
          if let v = v {_storage._measurement = .windSpeed(v)}
        case 6:
          var v: Centigrade_PartsPerBillion?
          if let current = _storage._measurement {
            try decoder.handleConflictingOneOf()
            if case .totalVocs(let m) = current {v = m}
          }
          try decoder.decodeSingularMessageField(value: &v)
          if let v = v {_storage._measurement = .totalVocs(v)}
        case 7:
          var v: Centigrade_PartsPerMillion?
          if let current = _storage._measurement {
            try decoder.handleConflictingOneOf()
            if case .equivalentCo2(let m) = current {v = m}
          }
          try decoder.decodeSingularMessageField(value: &v)
          if let v = v {_storage._measurement = .equivalentCo2(v)}
        case 8:
          var v: Centigrade_Percent?
          if let current = _storage._measurement {
            try decoder.handleConflictingOneOf()
            if case .humidity(let m) = current {v = m}
          }
          try decoder.decodeSingularMessageField(value: &v)
          if let v = v {_storage._measurement = .humidity(v)}
        case 9:
          var v: Centigrade_Radians?
          if let current = _storage._measurement {
            try decoder.handleConflictingOneOf()
            if case .windDirection(let m) = current {v = m}
          }
          try decoder.decodeSingularMessageField(value: &v)
          if let v = v {_storage._measurement = .windDirection(v)}
        case 10: try decoder.decodeSingularMessageField(value: &_storage._sensor)
        default: break
        }
      }
    }
  }

  /// Used by the encoding methods of the SwiftProtobuf library, not generally
  /// used directly. `Message.serializedData()`, `Message.jsonUTF8Data()`, and
  /// other serializer methods are defined in the SwiftProtobuf library. See the
  /// `Message` and `Message+*Additions` files.
  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if _storage._time != 0 {
        try visitor.visitSingularUInt64Field(value: _storage._time, fieldNumber: 1)
      }
      switch _storage._measurement {
      case .temperature(let v)?:
        try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
      case .pressure(let v)?:
        try visitor.visitSingularMessageField(value: v, fieldNumber: 3)
      case .altitude(let v)?:
        try visitor.visitSingularMessageField(value: v, fieldNumber: 4)
      case .windSpeed(let v)?:
        try visitor.visitSingularMessageField(value: v, fieldNumber: 5)
      case .totalVocs(let v)?:
        try visitor.visitSingularMessageField(value: v, fieldNumber: 6)
      case .equivalentCo2(let v)?:
        try visitor.visitSingularMessageField(value: v, fieldNumber: 7)
      case .humidity(let v)?:
        try visitor.visitSingularMessageField(value: v, fieldNumber: 8)
      case .windDirection(let v)?:
        try visitor.visitSingularMessageField(value: v, fieldNumber: 9)
      case nil: break
      }
      if let v = _storage._sensor {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 10)
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  fileprivate var _storage = _StorageClass.defaultInstance
}

public struct Centigrade_StationRecentMeasurements: SwiftProtobuf.Message {
  public static let protoMessageName: String = _protobuf_package + ".StationRecentMeasurements"

  public var uuid: String = String()

  public var measurements: [Centigrade_Measurement] = []

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  /// Used by the decoding initializers in the SwiftProtobuf library, not generally
  /// used directly. `init(serializedData:)`, `init(jsonUTF8Data:)`, and other decoding
  /// initializers are defined in the SwiftProtobuf library. See the Message and
  /// Message+*Additions` files.
  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularStringField(value: &self.uuid)
      case 2: try decoder.decodeRepeatedMessageField(value: &self.measurements)
      default: break
      }
    }
  }

  /// Used by the encoding methods of the SwiftProtobuf library, not generally
  /// used directly. `Message.serializedData()`, `Message.jsonUTF8Data()`, and
  /// other serializer methods are defined in the SwiftProtobuf library. See the
  /// `Message` and `Message+*Additions` files.
  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.uuid.isEmpty {
      try visitor.visitSingularStringField(value: self.uuid, fieldNumber: 1)
    }
    if !self.measurements.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.measurements, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "Centigrade"

extension Centigrade_Celsius: SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "value"),
  ]

  public func _protobuf_generated_isEqualTo(other: Centigrade_Celsius) -> Bool {
    if self.value != other.value {return false}
    if unknownFields != other.unknownFields {return false}
    return true
  }
}

extension Centigrade_Hectopascals: SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "value"),
  ]

  public func _protobuf_generated_isEqualTo(other: Centigrade_Hectopascals) -> Bool {
    if self.value != other.value {return false}
    if unknownFields != other.unknownFields {return false}
    return true
  }
}

extension Centigrade_Meters: SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "value"),
  ]

  public func _protobuf_generated_isEqualTo(other: Centigrade_Meters) -> Bool {
    if self.value != other.value {return false}
    if unknownFields != other.unknownFields {return false}
    return true
  }
}

extension Centigrade_MetersPerSecond: SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "value"),
  ]

  public func _protobuf_generated_isEqualTo(other: Centigrade_MetersPerSecond) -> Bool {
    if self.value != other.value {return false}
    if unknownFields != other.unknownFields {return false}
    return true
  }
}

extension Centigrade_PartsPerBillion: SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "value"),
  ]

  public func _protobuf_generated_isEqualTo(other: Centigrade_PartsPerBillion) -> Bool {
    if self.value != other.value {return false}
    if unknownFields != other.unknownFields {return false}
    return true
  }
}

extension Centigrade_PartsPerMillion: SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "value"),
  ]

  public func _protobuf_generated_isEqualTo(other: Centigrade_PartsPerMillion) -> Bool {
    if self.value != other.value {return false}
    if unknownFields != other.unknownFields {return false}
    return true
  }
}

extension Centigrade_Percent: SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "value"),
  ]

  public func _protobuf_generated_isEqualTo(other: Centigrade_Percent) -> Bool {
    if self.value != other.value {return false}
    if unknownFields != other.unknownFields {return false}
    return true
  }
}

extension Centigrade_Radians: SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "value"),
  ]

  public func _protobuf_generated_isEqualTo(other: Centigrade_Radians) -> Bool {
    if self.value != other.value {return false}
    if unknownFields != other.unknownFields {return false}
    return true
  }
}

extension Centigrade_Sensor: SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "uuid"),
    2: .standard(proto: "sensor_type"),
  ]

  public func _protobuf_generated_isEqualTo(other: Centigrade_Sensor) -> Bool {
    if self.uuid != other.uuid {return false}
    if self.sensorType != other.sensorType {return false}
    if unknownFields != other.unknownFields {return false}
    return true
  }
}

extension Centigrade_Sensor.SensorType: SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "DEFAULT"),
    1: .same(proto: "ALTITUDE"),
    2: .same(proto: "ANEMOMETER"),
    3: .same(proto: "EQUIVALENT_CO2"),
    4: .same(proto: "HUMIDITY"),
    5: .same(proto: "PRESSURE"),
    6: .same(proto: "TEMPERATURE"),
    7: .same(proto: "TOTAL_VOC"),
  ]
}

extension Centigrade_Measurement: SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "time"),
    2: .same(proto: "temperature"),
    3: .same(proto: "pressure"),
    4: .same(proto: "altitude"),
    5: .standard(proto: "wind_speed"),
    6: .standard(proto: "total_vocs"),
    7: .standard(proto: "equivalent_co2"),
    8: .same(proto: "humidity"),
    9: .standard(proto: "wind_direction"),
    10: .same(proto: "sensor"),
  ]

  fileprivate class _StorageClass {
    var _time: UInt64 = 0
    var _measurement: Centigrade_Measurement.OneOf_Measurement?
    var _sensor: Centigrade_Sensor? = nil

    static let defaultInstance = _StorageClass()

    private init() {}

    init(copying source: _StorageClass) {
      _time = source._time
      _measurement = source._measurement
      _sensor = source._sensor
    }
  }

  fileprivate mutating func _uniqueStorage() -> _StorageClass {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _StorageClass(copying: _storage)
    }
    return _storage
  }

  public func _protobuf_generated_isEqualTo(other: Centigrade_Measurement) -> Bool {
    if _storage !== other._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((_storage, other._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let other_storage = _args.1
        if _storage._time != other_storage._time {return false}
        if _storage._measurement != other_storage._measurement {return false}
        if _storage._sensor != other_storage._sensor {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if unknownFields != other.unknownFields {return false}
    return true
  }
}

extension Centigrade_StationRecentMeasurements: SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "uuid"),
    2: .same(proto: "measurements"),
  ]

  public func _protobuf_generated_isEqualTo(other: Centigrade_StationRecentMeasurements) -> Bool {
    if self.uuid != other.uuid {return false}
    if self.measurements != other.measurements {return false}
    if unknownFields != other.unknownFields {return false}
    return true
  }
}