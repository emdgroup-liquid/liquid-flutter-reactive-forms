class DocComponent {
  const DocComponent({
    required this.name,
    required this.isNullSafe,
    required this.description,
    required this.constructors,
    required this.properties,
    required this.methods,
  });

  final String name;
  final bool isNullSafe;
  final String description;
  final List<DocConstructor> constructors;
  final List<DocProperty> properties;
  final List<String> methods;

  // Convert a DocComponent instance to a Map<String, dynamic>
  Map<String, dynamic> toJson() => {
        'name': name,
        'isNullSafe': isNullSafe,
        'description': description,
        'constructors': constructors.map((constructor) => constructor.toJson()).toList(),
        'properties': properties.map((property) => property.toJson()).toList(),
        'methods': methods,
      };

  // Create a DocComponent instance from a Map<String, dynamic>
  factory DocComponent.fromJson(Map<String, dynamic> json) {
    return DocComponent(
      name: json['name'] as String,
      isNullSafe: json['isNullSafe'] as bool,
      description: json['description'] as String,
      constructors: (json['constructors'] as List)
          .map((item) => DocConstructor.fromJson(item as Map<String, dynamic>))
          .toList(),
      properties: (json['properties'] as List)
          .map((item) => DocProperty.fromJson(item as Map<String, dynamic>))
          .toList(),
      methods: (json['methods'] as List).map((item) => item as String).toList(),
    );
  }
}

class DocProperty {
  const DocProperty({
    required this.name,
    required this.type,
    required this.description,
    required this.features,
  });

  final String name;
  final String type;
  final String description;
  final List<String> features;

  // Convert a DocProperty instance to a Map<String, dynamic>
  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'description': description,
        'features': features,
      };

  // Create a DocProperty instance from a Map<String, dynamic>
  factory DocProperty.fromJson(Map<String, dynamic> json) {
    return DocProperty(
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      features: (json['features'] as List).map((item) => item as String).toList(),
    );
  }
}

class DocConstructor {
  const DocConstructor({
    required this.name,
    required this.signature,
    required this.features,
  });

  final String name;
  final List<DocParameter> signature;
  final List<String> features;

  // Convert a DocConstructor instance to a Map<String, dynamic>
  Map<String, dynamic> toJson() => {
        'name': name,
        'signature': signature.map((parameter) => parameter.toJson()).toList(),
        'features': features,
      };

  // Create a DocConstructor instance from a Map<String, dynamic>
  factory DocConstructor.fromJson(Map<String, dynamic> json) {
    return DocConstructor(
      name: json['name'] as String,
      signature: (json['signature'] as List)
          .map((item) => DocParameter.fromJson(item as Map<String, dynamic>))
          .toList(),
      features: (json['features'] as List).map((item) => item as String).toList(),
    );
  }
}

class DocParameter {
  const DocParameter({
    required this.name,
    required this.type,
    required this.description,
    required this.named,
    required this.required,
  });

  final String name;
  final String description;
  final String type;
  final bool named;
  final bool required;

  // Convert a DocParameter instance to a Map<String, dynamic>
  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'description': description,
        'named': named,
        'required': required,
      };

  // Create a DocParameter instance from a Map<String, dynamic>
  factory DocParameter.fromJson(Map<String, dynamic> json) {
    return DocParameter(
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      named: json['named'] as bool,
      required: json['required'] as bool,
    );
  }
}

const docComponents = [
  DocComponent(
    name: 'LdFormSubmitConfig',
    isNullSafe: true,
    description:
        ' A wrapper around [LdSubmitConfig] that strips away the [action] property,\n as this will have a pre-defined behavior (form validation, calling\n [onSubmit] function, etc.).',
    properties: [],
    constructors: [
      DocConstructor(
        name: '',
        signature: [
          DocParameter(
            name: 'loadingText',
            type: 'String?',
            description: '',
            named: true,
            required: false,
          ),
          DocParameter(
            name: 'submitText',
            type: 'String?',
            description: '',
            named: true,
            required: false,
          ),
          DocParameter(
            name: 'allowResubmit',
            type: 'bool?',
            description: '',
            named: true,
            required: false,
          ),
          DocParameter(
            name: 'withHaptics',
            type: 'bool',
            description: '',
            named: true,
            required: false,
          ),
          DocParameter(
            name: 'autoTrigger',
            type: 'bool',
            description: '',
            named: true,
            required: false,
          ),
          DocParameter(
            name: 'timeout',
            type: 'Duration?',
            description: '',
            named: true,
            required: false,
          ),
          DocParameter(
            name: 'allowCancel',
            type: 'bool?',
            description: '',
            named: true,
            required: false,
          ),
          DocParameter(
            name: 'onCanceled',
            type: 'void Function()?',
            description: '',
            named: true,
            required: false,
          ),
          DocParameter(
            name: 'retryConfig',
            type: 'LdRetryConfig?',
            description: '',
            named: true,
            required: false,
          ),
        ],
        features: [],
      )
    ],
    methods: ['copyWithAction'],
  ),
  DocComponent(
    name: 'LdReactiveForm',
    isNullSafe: true,
    description:
        ' A container for [LdReactiveFormItem]s that manages the form state and\n validation. It also provides a submit button that will call the provided\n [onSubmit] function when pressed.',
    properties: [
      DocProperty(
        name: 'items',
        type: 'List<LdReactiveFormItem<dynamic, dynamic>>',
        description: '',
        features: ['final'],
      ),
      DocProperty(
        name: 'validators',
        type: 'List<Validator<dynamic>>',
        description: '',
        features: ['final'],
      ),
      DocProperty(
        name: 'validationMessages',
        type: 'Map<String, String Function(Object)>?',
        description: '',
        features: ['final'],
      ),
      DocProperty(
        name: 'submitConfig',
        type: 'LdFormSubmitConfig?',
        description: '',
        features: ['final'],
      ),
      DocProperty(
        name: 'submitBuilder',
        type: 'Widget Function(BuildContext, FormGroup, Widget?)?',
        description: '',
        features: ['final'],
      ),
      DocProperty(
        name: 'onSubmit',
        type: 'Future<T> Function(FormGroup)',
        description: '',
        features: ['final'],
      ),
    ],
    constructors: [
      DocConstructor(
        name: '',
        signature: [
          DocParameter(
            name: 'key',
            type: 'Key?',
            description: '',
            named: true,
            required: false,
          ),
          DocParameter(
            name: 'items',
            type: 'List<LdReactiveFormItem<dynamic, dynamic>>',
            description: '',
            named: true,
            required: true,
          ),
          DocParameter(
            name: 'onSubmit',
            type: 'Future<T> Function(FormGroup)',
            description: '',
            named: true,
            required: true,
          ),
          DocParameter(
            name: 'validators',
            type: 'List<Validator<dynamic>>',
            description: '',
            named: true,
            required: false,
          ),
          DocParameter(
            name: 'validationMessages',
            type: 'Map<String, String Function(Object)>?',
            description: '',
            named: true,
            required: false,
          ),
          DocParameter(
            name: 'submitBuilder',
            type: 'Widget Function(BuildContext, FormGroup, Widget?)?',
            description: '',
            named: true,
            required: false,
          ),
          DocParameter(
            name: 'submitConfig',
            type: 'LdFormSubmitConfig?',
            description: '',
            named: true,
            required: false,
          ),
        ],
        features: ['const'],
      )
    ],
    methods: ['createState'],
  ),
  DocComponent(
    name: '_LdReactiveFormState',
    isNullSafe: true,
    description: '',
    properties: [
      DocProperty(
        name: '_form',
        type: 'FormGroup',
        description: '',
        features: [
          'final',
          'late',
        ],
      )
    ],
    constructors: [
      DocConstructor(
        name: '',
        signature: [],
        features: [],
      )
    ],
    methods: [
      'initState',
      'dispose',
      'build',
      '_buildFormSubmitButton',
    ],
  ),
  DocComponent(
    name: 'MapValueAccessor',
    isNullSafe: true,
    description: '',
    properties: [
      DocProperty(
        name: 'map',
        type: 'Map<T, String>',
        description: '',
        features: ['final'],
      )
    ],
    constructors: [
      DocConstructor(
        name: '',
        signature: [
          DocParameter(
            name: 'map',
            type: 'Map<T, String>',
            description: '',
            named: false,
            required: true,
          )
        ],
        features: [],
      )
    ],
    methods: [
      'modelToViewValue',
      'viewToModelValue',
    ],
  ),
  DocComponent(
    name: 'LdReactiveFormItem',
    isNullSafe: true,
    description:
        ' A [LdReactiveFormItem] is basically an elaborated wrapper around\n [FormControl] and [ReactiveFormField]. It contains all the necessary\n information to create a form field widget and manage its state.\n\n It offers convenience constructors for common form field types like input,\n select, checkbox, date picker, and slider. It also allows you to create\n custom form fields by providing a [LdFormFieldBuilder].',
    properties: [
      DocProperty(
        name: 'key',
        type: 'String',
        description: '/// The key of the form field.',
        features: ['final'],
      ),
      DocProperty(
        name: 'formFieldBuilder',
        type: 'Widget Function(ReactiveFormFieldState<TModel, TView>)',
        description:
            '/// The builder function that creates the form field widget.',
        features: ['final'],
      ),
      DocProperty(
        name: 'hintBuilder',
        type: 'LdHint? Function(ReactiveFormFieldState<TModel, TView>)?',
        description:
            '/// An optional hint that will be displayed below the form field (if no error\n/// is present.)',
        features: ['final'],
      ),
      DocProperty(
        name: '_valueAccessor',
        type: 'ControlValueAccessor<TModel, TView>?',
        description: '',
        features: ['final'],
      ),
      DocProperty(
        name: 'disabled',
        type: 'bool',
        description: '',
        features: ['final'],
      ),
      DocProperty(
        name: 'validators',
        type: 'List<Validator<dynamic>>',
        description: '',
        features: ['final'],
      ),
      DocProperty(
        name: 'initialValue',
        type: 'TModel?',
        description: '',
        features: ['final'],
      ),
      DocProperty(
        name: 'validationMessages',
        type: 'Map<String, String Function(Object)>?',
        description: '',
        features: ['final'],
      ),
      DocProperty(
        name: 'valueAccessor',
        type: 'ControlValueAccessor<TModel, TView>',
        description: '',
        features: [],
      ),
    ],
    constructors: [
      DocConstructor(
        name: '',
        signature: [
          DocParameter(
            name: 'key',
            type: 'String',
            description: '',
            named: true,
            required: true,
          ),
          DocParameter(
            name: 'formFieldBuilder',
            type: 'Widget Function(ReactiveFormFieldState<TModel, TView>)',
            description: '',
            named: true,
            required: true,
          ),
          DocParameter(
            name: 'hintBuilder',
            type: 'LdHint? Function(ReactiveFormFieldState<TModel, TView>)?',
            description: '',
            named: true,
            required: false,
          ),
          DocParameter(
            name: 'disabled',
            type: 'bool',
            description: '',
            named: true,
            required: false,
          ),
          DocParameter(
            name: 'validators',
            type: 'List<Validator<dynamic>>',
            description: '',
            named: true,
            required: false,
          ),
          DocParameter(
            name: 'initialValue',
            type: 'TModel?',
            description: '',
            named: true,
            required: false,
          ),
          DocParameter(
            name: 'validationMessages',
            type: 'Map<String, String Function(Object)>?',
            description: '',
            named: true,
            required: false,
          ),
          DocParameter(
            name: 'valueAccessor',
            type: 'ControlValueAccessor<TModel, TView>?',
            description: '',
            named: true,
            required: false,
          ),
        ],
        features: ['const'],
      )
    ],
    methods: [
      'input',
      'select',
      'multiSelect',
      'checkbox',
      'datePicker',
      'slider',
      'createFormControl',
      'createFormField',
    ],
  ),
];
