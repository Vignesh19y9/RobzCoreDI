
@attached(peer, names: arbitrary)
@attached(accessor, names: named(get), named(set))
public macro DependencyRegister() = #externalMacro(
    module: "DependencyMacroImpl",
    type: "DependencyRegisterImpl"
)

@attached(memberAttribute)
public macro DependencyContainer() = #externalMacro(module: "DependencyMacroImpl", type: "DependencyContainerImpl")
