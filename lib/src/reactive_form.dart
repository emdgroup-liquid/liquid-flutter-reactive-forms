import 'package:flutter/material.dart';
import 'package:liquid_flutter/liquid_flutter.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../liquid_flutter_reactive_forms.dart';

/// A container for [LdReactiveFormItem]s that manages the form state and
/// validation. It also provides a submit button that will call the provided
/// [onSubmit] function when pressed.
class LdReactiveForm extends StatefulWidget {
  final List<LdReactiveFormItem<dynamic, dynamic>> items;
  final List<LdFormValidator<dynamic>> validators;
  final Map<String, ValidationMessageFunction>? validationMessages;
  final Future<void> Function(FormGroup form) onSubmit;
  final LdFormSubmitBuilder? submitBuilder;

  const LdReactiveForm({
    super.key,
    required this.items,
    required this.onSubmit,
    this.validators = const [],
    this.validationMessages,
    this.submitBuilder,
  });

  @override
  State<LdReactiveForm> createState() => _LdReactiveFormState();
}

class _LdReactiveFormState extends State<LdReactiveForm> {
  late final FormGroup _form;

  @override
  void initState() {
    super.initState();
    _form = FormGroup(
      {for (var item in widget.items) item.key: item.createFormControl()},
      validators: widget.validators,
    );
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveFormConfig(
      validationMessages: widget.validationMessages ?? {},
      child: ReactiveForm(
        formGroup: _form,
        child: LdAutoSpace(
          children: [
            ...widget.items.map(
              (item) => item.createFormField(),
            ),
            _buildFormSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormSubmitButton() {
    return ReactiveFormConsumer(
      builder: (context, form, child) {
        return LdSubmit<void>(
          config: LdSubmitConfig(
            action: () async {
              if (form.invalid) {
                form.controls.forEach((key, control) {
                  control.markAsTouched();
                  control.markAsDirty();
                });
                return;
              }
              form.markAsDisabled();
              final result = await widget.onSubmit(form);
              form.markAsEnabled();
              return result;
            },
            allowRetry: true,
            allowResubmit: true,
          ),
          builder: widget.submitBuilder?.call(context, form, child),
        );
      },
    );
  }
}
