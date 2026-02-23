enum RegisterRole { client, provider }

extension RegisterRoleX on RegisterRole {
  String get value => this == RegisterRole.provider ? "provider" : "client";
}
