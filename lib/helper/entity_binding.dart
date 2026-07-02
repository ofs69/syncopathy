/// Two-way copy for a single mirrored field between a persistent entity and a
/// signal. [loadFromEntity] pulls the entity's value into its signal (on load);
/// [saveToEntity] pushes the signal's value back into the entity (on save).
/// Reading the signal inside [saveToEntity] is what registers it as a
/// dependency of an auto-save effect that iterates the bindings.
///
/// Collecting every mirrored field into one `List<EntityBinding>` gives a single
/// source of truth for what persists: declaring a field means adding one binding,
/// with no second copy site to keep in sync. Signals absent from the list are
/// intentionally not mirrored.
class EntityBinding {
  final void Function() loadFromEntity;
  final void Function() saveToEntity;
  const EntityBinding(this.loadFromEntity, this.saveToEntity);
}
