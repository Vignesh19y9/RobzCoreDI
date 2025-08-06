@frozen @propertyWrapper public struct Dependency<Value> {
    private let keyPath: KeyPath<DependencyValues, Value>
    
    public init(_ keyPath: KeyPath<DependencyValues, Value>){
        self.keyPath = keyPath
    }
    
    public var wrappedValue: Value {
        DependencyValues.value(for: keyPath)
    }

}
