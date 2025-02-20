import 'package:flutter/material.dart';
import 'package:liquid_flutter/liquid_flutter.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../liquid_flutter_reactive_forms.dart';

/// A [LdReactiveFormItem] is basically an elaborated wrapper around
/// [FormControl] and [ReactiveFormField]. It contains all the necessary
/// information to create a form field widget and manage its state.
///
/// It offers convenience constructors for common form field types like input,
/// select, checkbox, date picker, and slider. It also allows you to create
/// custom form fields by providing a [LdFormFieldBuilder].
@immutable
class LdReactiveFormItem<TModel, TView> {
  /// The key of the form field.
  final String key;

  /// The builder function that creates the form field widget.
  final LdFormFieldBuilder<TModel, TView> formFieldBuilder;

  /// An optional hint that will be displayed below the form field (if no error
  /// is present.)
  final LdHint? Function(LdReactiveFormFieldState<TModel, TView>)? hintBuilder;
  final ControlValueAccessor<TModel, TView>? _valueAccessor;
  ControlValueAccessor<TModel, TView> get valueAccessor =>
      _valueAccessor ??
      DefaultValueAccessor<TModel, TView>()
          as ControlValueAccessor<TModel, TView>;
  final bool disabled;
  final List<LdFormValidator<dynamic>> validators;
  final TModel? initialValue;
  final Map<String, ValidationMessageFunction>? validationMessages;

  const LdReactiveFormItem({
    required this.key,
    required this.formFieldBuilder,
    this.hintBuilder,
    this.disabled = false,
    this.validators = const [],
    this.initialValue,
    this.validationMessages,
    ControlValueAccessor<TModel, TView>? valueAccessor,
  }) : _valueAccessor = valueAccessor;

  /// Input Field Constructor
  static LdReactiveFormItem<T, String> input<T>({
    required String key,
    required String inputFieldHint,
    LdHint? Function(LdReactiveFormFieldState<T, String>)? hintBuilder,
    String? label,
    bool disabled = false,
    List<LdFormValidator<dynamic>> validators = const [],
    String? initialValue,
    Map<String, ValidationMessageFunction>? validationMessages,
  }) {
    final valueAccessor = switch (T) {
      const (int) => IntValueAccessor() as ControlValueAccessor<T, String>,
      const (double) =>
        DoubleValueAccessor() as ControlValueAccessor<T, String>,
      const (DateTime) =>
        DateTimeValueAccessor() as ControlValueAccessor<T, String>,
      const (TimeOfDay) =>
        TimeOfDayValueAccessor() as ControlValueAccessor<T, String>,
      _ => DefaultValueAccessor<T, String>() as ControlValueAccessor<T, String>,
    };
    return LdReactiveFormItem<T, String>(
      key: key,
      hintBuilder: hintBuilder,
      disabled: disabled,
      validators: validators,
      validationMessages: validationMessages,
      initialValue: valueAccessor.viewToModelValue(initialValue),
      valueAccessor: valueAccessor,
      formFieldBuilder: (state) {
        return LdInput(
          hint: inputFieldHint,
          label: label,
          keyboardType: TextInputType.text,
          valid: state.control.valid || state.errorText == null,
          controller: TextEditingController.fromValue(
            TextEditingValue(text: state.control.value?.toString() ?? ''),
          ),
          onChanged: (value) => state.didChange(value),
          disabled: state.control.disabled,
        );
      },
    );
  }

  /// Select Field Constructor
  static LdReactiveFormItem<T, T> select<T>({
    required String key,
    required List<LdSelectItem<T>> items,
    LdHint? Function(LdReactiveFormFieldState<T, T>)? hintBuilder,
    String? label,
    bool disabled = false,
    List<LdFormValidator<dynamic>> validators = const [],
    T? initialValue,
    Map<String, ValidationMessageFunction>? validationMessages,
  }) {
    return LdReactiveFormItem<T, T>(
      key: key,
      hintBuilder: hintBuilder,
      disabled: disabled,
      validators: validators,
      initialValue: initialValue,
      validationMessages: validationMessages,
      formFieldBuilder: (state) {
        return LdSelect<T>(
          label: label,
          items: items,
          value: state.control.value,
          disabled: state.control.disabled,
          onChange: (value) => state.didChange(value),
        );
      },
    );
  }

  /// Multi Select Field Constructor
  static LdReactiveFormItem<Set<T>, Set<T>> multiSelect<T>({
    required String key,
    required List<LdSelectItem<T>> items,
    LdHint? Function(LdReactiveFormFieldState<Set<T>, Set<T>>)? hintBuilder,
    String? label,
    bool disabled = false,
    List<LdFormValidator<dynamic>> validators = const [],
    Set<T>? initialValue,
    Map<String, ValidationMessageFunction>? validationMessages,
  }) {
    return LdReactiveFormItem<Set<T>, Set<T>>(
      key: key,
      hintBuilder: hintBuilder,
      disabled: disabled,
      validators: validators,
      initialValue: initialValue,
      validationMessages: validationMessages,
      formFieldBuilder: (state) {
        return LdChoose<T>(
          label: label,
          items: items,
          multiple: true,
          allowEmpty: true,
          value: state.control.value,
          disabled: state.control.disabled,
          onChange: (value) => state.didChange(Set<T>.from(value)),
        );
      },
    );
  }

  /// Checkbox Field Constructor
  static LdReactiveFormItem<bool, bool> checkbox({
    required String key,
    LdHint? Function(LdReactiveFormFieldState<bool, bool>)? hintBuilder,
    String? label,
    bool disabled = false,
    List<LdFormValidator<dynamic>> validators = const [],
    bool initialValue = false,
    Map<String, ValidationMessageFunction>? validationMessages,
  }) {
    return LdReactiveFormItem<bool, bool>(
      key: key,
      hintBuilder: hintBuilder,
      disabled: disabled,
      validators: validators,
      initialValue: initialValue,
      validationMessages: validationMessages,
      formFieldBuilder: (state) {
        return LdCheckbox(
          label: label,
          color: state.control.valid || state.control.pristine ? null : shadRed,
          checked: state.control.value ?? false,
          onChanged: (value) => state.didChange(value),
          disabled: state.control.disabled,
        );
      },
    );
  }

  /// Date Picker Field Constructor
  static LdReactiveFormItem<DateTime, DateTime> datePicker({
    required String key,
    LdHint? Function(LdReactiveFormFieldState<DateTime, DateTime>)? hintBuilder,
    String? label,
    bool disabled = false,
    List<LdFormValidator<dynamic>> validators = const [],
    DateTime? initialValue,
    Map<String, ValidationMessageFunction>? validationMessages,
  }) {
    return LdReactiveFormItem<DateTime, DateTime>(
      key: key,
      hintBuilder: hintBuilder,
      disabled: disabled,
      validators: validators,
      initialValue: initialValue,
      validationMessages: validationMessages,
      formFieldBuilder: (state) {
        return LdDatePicker(
          label: label,
          value: state.control.value,
          onChanged: (value) => state.didChange(value),
        );
      },
    );
  }

  /// Slider Field Constructor
  static LdReactiveFormItem<double, double> slider({
    required String key,
    LdHint? Function(LdReactiveFormFieldState<double, double>)? hintBuilder,
    String? label,
    bool disabled = false,
    List<LdFormValidator<dynamic>> validators = const [],
    double? initialValue,
    double min = 0,
    double max = 100,
    Map<String, ValidationMessageFunction>? validationMessages,
    String Function(double? value)? valueFormatter,
  }) {
    final defaultPrecision = max - min < 1 ? 2 : 0;
    valueFormatter ??=
        (value) => value?.toStringAsFixed(defaultPrecision) ?? '';
    return LdReactiveFormItem<double, double>(
      key: key,
      hintBuilder: hintBuilder,
      disabled: disabled,
      validators: validators,
      initialValue: initialValue,
      validationMessages: validationMessages,
      formFieldBuilder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (label != null) LdTextL(label, textAlign: TextAlign.start),
                Spacer(),
                LdTextLs(valueFormatter!(state.control.value)),
              ],
            ),
            Slider(
              value: state.control.value ?? 0,
              onChanged: (value) => state.didChange(value),
              min: min,
              max: max,
            ),
          ],
        );
      },
    );
  }

  /// Creates the [FormControl] model for the form item.
  FormControl<TModel> createFormControl() {
    return FormControl<TModel>(
      disabled: disabled,
      validators: validators,
      value: initialValue,
    );
  }

  /// Creates the [ReactiveFormField] widget for the form item.
  ReactiveFormField<TModel, TView> createFormField() {
    return ReactiveFormField<TModel, TView>(
      formControlName: key,
      valueAccessor: valueAccessor,
      validationMessages: validationMessages,
      showErrors: (control) => control.invalid && control.dirty,
      builder: (state) {
        return LdAutoSpace(
          children: [
            formFieldBuilder(state),
            if (state.errorText != null)
              LdHint(type: LdHintType.error, child: Text(state.errorText!))
            else if (hintBuilder != null)
              hintBuilder!.call(state) ?? const SizedBox.shrink(),
            LdSpacer(size: LdSize.l),
          ],
        );
      },
    );
  }
}
