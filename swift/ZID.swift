/// ZID: Zen Identifier
///
/// This is a secure random identifier, similar to a UUID.
/// The ZID can be represented in many ways, such as a bit array,
/// or an unsigned int, or a hexadecimal lowercase string, etc.
///
/// Examples:
///
///     let zid = ZID.create(128)
///     -> new NSData object containing 128 bits of secure random data
///
///     let string = ZID.toString(zid)
///     -> "82813874591063ecaed8a606d25794d6"
///
/// ## Implementation
///
/// In the Swift language, we choose to implement a ZID class
/// by using a subclass of NSData, which is fast and portable.
/// You're welcome to implement a ZID class using another approach.
///
/// ## Ideas and credits
///
///   * https://github.com/sixarm/sixarm_ruby_zid
///   * https://github.com/mauriciosantos/Buckets-Swift/blob/master/Source/BitArray.swift
///   * https://github.com/CryptoCoinSwift/UInt256/blob/master/Classes/UInt256.swift
///   * http://cocoadocs.org/docsets/Buckets/1.0.1/Extensions/BitArray.html
///   * http://jamescarroll.xyz/2015/09/09/safely-generating-cryptographically-secure-random-numbers-with-swift/
///   * http://stackoverflow.com/questions/1305225/best-way-to-serialize-an-nsdata-into-a-hexadeximal-string/25378464#25378464
///
/// ## Why do we use NSData, instead of any other class or struct?
///
/// We use NSData because it's an easy implementation for arbitrary bits.
/// It is widely supported, widely understood, and is generally stable among
/// various Swift versions and also stable among Objective-C versions.
///
/// NSData is a good choice for distributed objects applications,
/// which is one of our most important use cases for ZID items.
///
/// Apple documentation states:
///
///   * NSData and its mutable subclass NSMutableData provide data objects,
///     object-oriented wrappers for byte buffers. Data objects let simple
///     allocated buffers (that is, data with no embedded pointers) take on
///     the behavior of Foundation objects.
///
///   * NSData creates static data objects, and NSMutableData creates
///     dynamic data objects. NSData and NSMutableData are typically used
///     for data storage and are also useful in Distributed Objects
///     applications, where data contained in data objects can be copied
///     or moved between applications.
///
///   * NSData is “toll-free bridged” with its Core Foundation counterpart,
///     CFDataRef, which means it's fast to switch to a CFDataRef object.
//
/// :author: Joel Parker Henderson ( https://joelparkerhenderson.com )
/// :license: GPL ( https://www.gnu.org/copyleft/gpl.html )

import Foundation

public class ZID : NSData {

  /// Create a new ZID object that has the given number of bits.
  ///
  /// Example to create a 128-bit ZID:
  ///
  ///    let zid = ZID.create(128)
  ///    -> a new NSData object with 128 bits of secure random data
  ///
  /// Note: in the current implementation, the number of bits
  /// must be divisible by 8; this is for ease of implementation.
  ///
  public static func create(count: Int) -> NSData {
     var bytes = [UInt8](count: count/8, repeatedValue: 0)
     SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
     return NSData(bytes: &bytes, length: bytes.count)
  }

  /// Return the string representation of the ZID,
  /// which is a hexadecimal lowercase string.
  ///
  /// In Swift, we implement this as a typical Swift String.
  /// You're free to use any other kind of String if you like.
  ///
  /// Example:
  ///
  ///     let s = ZID.toString(zid)
  ///     -> ""a694f6805d0e49d384479e46e13b10b8"
  ///
  public static func toString(data: NSData) -> String {
    return
      UnsafeBufferPointer<UInt8>(
        start: UnsafePointer(data.bytes),
        count: data.length
        ).map {
          String(format: "%02x", $0)
        }.joinWithSeparator("")
  }

}