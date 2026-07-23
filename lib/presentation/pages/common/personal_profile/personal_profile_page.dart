import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../widgets/buyer_detail_app_bar.dart';
import '../../../widgets/custom_button.dart';
import 'personal_profile_cubit.dart';
import 'personal_profile_initial_params.dart';
import 'personal_profile_state.dart';
import 'widgets/personal_profile_content.dart';

class PersonalProfilePage extends StatefulWidget {
  const PersonalProfilePage({
    super.key,
    required this.cubit,
    required this.initialParams,
  });

  static const path = '/buyer/personal-profile';

  final PersonalProfileCubit cubit;
  final PersonalProfileInitialParams initialParams;

  @override
  State<PersonalProfilePage> createState() => _PersonalProfilePageState();
}

class _PersonalProfilePageState extends State<PersonalProfilePage> {
  PersonalProfileCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
    cubit.onInit(widget.initialParams);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalProfileCubit, PersonalProfileState>(
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                BuyerDetailAppBar(
                  title: 'Personal profile',
                  onBack: cubit.navigator.goBack,
                ),
                Expanded(
                  child: state.user == null
                      ? Center(
                          child: Text(
                            'Your profile is not available.',
                            style: context.textTheme.bodyMedium,
                          ),
                        )
                      : SingleChildScrollView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.lg,
                            AppSpacing.sm,
                            AppSpacing.lg,
                            AppSpacing.xxl,
                          ),
                          child: PersonalProfileContent(
                            cubit: cubit,
                            state: state,
                          ),
                        ),
                ),
                if (state.user != null)
                  SafeArea(
                    top: false,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.md,
                        AppSpacing.lg,
                        AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: context.colorTheme.surface,
                        border: Border(
                          top: BorderSide(
                            color: context.colorTheme.outlineVariant,
                          ),
                        ),
                      ),
                      child: CustomButton(
                        text: 'Save changes',
                        isLoading: state.saving,
                        onTap: cubit.save,
                        leadingIcon: const Icon(Icons.check_rounded, size: 19),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
