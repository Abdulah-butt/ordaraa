import '../../../core/enums/user_role.dart';

class ChooseRoleState {
  const ChooseRoleState({required this.selectedRole});

  final UserRole selectedRole;

  factory ChooseRoleState.initial() {
    return const ChooseRoleState(selectedRole: UserRole.buyer);
  }

  ChooseRoleState copyWith({UserRole? selectedRole}) {
    return ChooseRoleState(selectedRole: selectedRole ?? this.selectedRole);
  }
}
