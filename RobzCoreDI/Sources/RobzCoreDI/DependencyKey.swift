import Foundation

public protocol DependencyKey {
    associatedtype Value = Self
    static var value: Value { get }
}
