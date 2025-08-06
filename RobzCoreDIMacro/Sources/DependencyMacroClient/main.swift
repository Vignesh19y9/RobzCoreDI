import RobzCoreDIMacro

protocol DependencyKey {
    associatedtype Value = Self
    static var value: Value { get }
}
enum DependencyValues {
    public subscript<Key: DependencyKey>(
        key: Key.Type
    ) -> Key.Value where Key.Value: Sendable {
        get {
            return key.value
        }
        set {
            
        }
    }
}
