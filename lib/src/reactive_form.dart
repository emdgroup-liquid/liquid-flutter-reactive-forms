import 'package:flutter/material.dart';
import 'package:liquid_flutter/liquid_flutter.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../liquid_flutter_reactive_forms.dart';

/// A wrapper around [LdSubmitConfig] that strips away the [action] property,
/// as this will have a pre-defined behavior (form validation, calling
/// [onSubmit] function, etc.).
class LdFormSubmitConfig extends LdSubmitConfig {
  LdFormSubmitConfig({
    super.loadingText,
    super.submitText,
    super.allowRetry,
    super.allowResubmit,
    super.withHaptics,
    super.autoTrigger,
    super.timeout,
    super.allowCancel,
    super.onCanceled,
  }) : super(action: () async {});

  LdSubmitConfig<T> copyWithAction<T>(LdSubmitCallback<T> action) {
    return LdSubmitConfig<T>(
      loadingText: loadingText,
      submitText: submitText,
      allowRetry: allowRetry,
      allowResubmit: allowResubmit,
      withHaptics: withHaptics,
      autoTrigger: autoTrigger,
      timeout: timeout,
      allowCancel: allowCancel,
      onCanceled: onCanceled,
      action: action,
    );
  }
}

/// A container for [LdReactiveFormItem]s that manages the form state and
/// validation. It also provides a submit button that will call the provided
/// [onSubmit] function when pressed.
class LdReactiveForm<T> extends StatefulWidget {
  final List<LdReactiveFormItem<dynamic, dynamic>> items;
  final List<LdFormValidator<dynamic>> validators;
  final Map<String, ValidationMessageFunction>? validationMessages;
  final LdFormSubmitConfig? submitConfig;
  final LdFormSubmitBuilder? submitBuilder;
  final Future<T> Function(LdFormGroup form) onSubmit;

  const LdReactiveForm({
    super.key,
    required this.items,
    required this.onSubmit,
    this.validators = const [],
    this.validationMessages,
    this.submitBuilder,
    this.submitConfig,
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
          config: (widget.submitConfig ?? LdFormSubmitConfig()).copyWithAction(
            () async {
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
          ),
          builder: widget.submitBuilder?.call(context, form, child),
        );
      },
    );
  }
}
