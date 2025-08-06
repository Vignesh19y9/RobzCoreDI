import Foundation

public struct DependencyValues: Sendable {
    fileprivate static let shared = DependencyValues()
    
    private var storage: [ObjectIdentifier: AnySendable] = [:]
    
    init() { }
    
    public subscript<Key: DependencyKey>(
        key: Key.Type
    ) -> Key.Value where Key.Value: Sendable {
        get {
            if let base = self.storage[ObjectIdentifier(key)]?.base,
                let dependency = base as? Key.Value {
                return dependency
            } else {
                return key.value
            }
        }
        set {
            self.storage[ObjectIdentifier(key)] = AnySendable(newValue)
        }
    }
    
    public static func value<T>(for keyPath: KeyPath<DependencyValues, T>) -> T {
        return shared[keyPath: keyPath]
    }
}

private struct AnySendable: @unchecked Sendable {
    let base: Any
    @inlinable
    init<Base: Sendable>(_ base: Base) {
        self.base = base
    }
}
