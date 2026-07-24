import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location_picker_plus/location_picker_plus.dart';

import '../../../../../../core/enums/address_type.dart';
import '../../../../../../core/extensions/theme_extension.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../widgets/custom_drop_down.dart';
import '../../../../../widgets/custom_textfield.dart';
import '../../../../../widgets/app_skeleton.dart';
import '../add_address_cubit.dart';
import '../add_address_state.dart';

class AddAddressForm extends StatelessWidget {
  const AddAddressForm({super.key, required this.cubit, required this.state});

  final AddAddressCubit cubit;
  final AddAddressState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          state.isEditing
              ? 'Update organization address'
              : 'Add an organization address',
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Use a clear address so orders, invoices, and business records reach the right place.',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorTheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        _FormSection(
          icon: Icons.location_on_outlined,
          title: 'Address details',
          children: [
            CustomDropdown<AddressType>(
              label: 'Address type',
              items: AddressType.values,
              value: state.type,
              onChanged: cubit.setType,
              itemLabelBuilder: (type) => type.displayText,
              borderRadius: AppRadius.md,
              bottomPadding: AppSpacing.lg,
            ),
            _field(
              controller: cubit.labelController,
              label: 'Address label',
              hint: 'For example, Main warehouse',
              maxLength: 80,
            ),
            _field(
              controller: cubit.line1Controller,
              label: 'Street address',
              hint: 'Street number and name',
              maxLength: 200,
            ),
            _field(
              controller: cubit.line2Controller,
              label: 'Address line 2',
              hint: 'Unit, suite, floor (optional)',
              maxLength: 200,
            ),
            CountryDropdownField(
              key: ValueKey(state.selectedCountry?.id),
              initialValue: state.selectedCountry,
              label: 'Country',
              hint: 'Select country',
              onChanged: cubit.selectCountry,
            ),
            const SizedBox(height: AppSpacing.lg),
            StateDropdownField(
              key: ValueKey(
                '${state.selectedCountry?.id}-${state.selectedState?.id}',
              ),
              initialValue: state.selectedState,
              countryId: state.selectedCountry?.id,
              enabled: state.selectedCountry != null,
              label: 'State or region',
              hint: 'Select state or region',
              onChanged: cubit.selectState,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (state.checkingCities)
              const Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.lg),
                child: AppSkeletonBox(height: 56),
              )
            else if (state.cityPickerAvailable)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: CityDropdownField(
                  key: ValueKey(
                    '${state.selectedState?.id}-${state.selectedCity?.id}',
                  ),
                  initialValue: state.selectedCity,
                  stateId: state.selectedState?.id,
                  label: 'City',
                  hint: 'Select city',
                  onChanged: cubit.selectCity,
                ),
              )
            else
              _field(
                controller: cubit.cityController,
                label: 'City',
                hint: 'Enter city',
                maxLength: 120,
              ),
            _field(
              controller: cubit.postalCodeController,
              label: 'Postal code',
              hint: 'Enter postal code (optional)',
              maxLength: 20,
              bottomPadding: 0,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _FormSection(
          icon: Icons.contact_phone_outlined,
          title: 'Address contact',
          subtitle: 'Optional contact details for this location.',
          children: [
            _field(
              controller: cubit.contactNameController,
              label: 'Contact name',
              hint: 'Enter contact person',
              maxLength: 120,
            ),
            _field(
              controller: cubit.contactPhoneController,
              label: 'Contact phone',
              hint: 'Enter phone number',
              maxLength: 32,
              keyboard: TextInputType.phone,
              bottomPadding: 0,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Material(
          color: context.colorTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.card,
            side: BorderSide(color: context.colorTheme.outlineVariant),
          ),
          clipBehavior: Clip.antiAlias,
          child: SwitchListTile.adaptive(
            value: state.isDefault,
            onChanged: cubit.setDefault,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xs,
            ),
            title: Text(
              'Make this the default',
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Text(
              'Use it automatically for this address type.',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorTheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    required int maxLength,
    TextInputType? keyboard,
    double bottomPadding = AppSpacing.lg,
  }) {
    return CustomTextField(
      controller: controller,
      label: label,
      hint: hint,
      keyboard: keyboard,
      action: TextInputAction.next,
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
      bottomPadding: bottomPadding,
    );
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({
    required this.icon,
    required this.title,
    required this.children,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: context.colorTheme.surface,
        border: Border.all(color: context.colorTheme.outlineVariant),
        borderRadius: AppRadius.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: context.colorTheme.primaryContainer,
                  borderRadius: AppRadius.field,
                ),
                child: Icon(icon, size: 19, color: context.colorTheme.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorTheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ...children,
        ],
      ),
    );
  }
}
