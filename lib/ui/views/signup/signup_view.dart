import 'package:flutter/material.dart';
import 'package:friends_around_me/utils/utils.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'signup_view.form.dart';
import 'signup_viewmodel.dart';

@FormView(
  autoTextFieldValidation: false,
  fields: [
    FormTextField(
      name: 'fullName',
      validator: Validator.validateFullName,
    ),
    FormTextField(
      name: 'email',
      validator: Validator.validateEmail,
    ),
    FormTextField(
      name: 'password',
      validator: Validator.validateNewPassword,
    ),
  ],
)
class SignupView extends StackedView<SignupViewModel> with $SignupView {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SignupViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("SignupView")),
      ),
    );
  }

  @override
  void onViewModelReady(SignupViewModel viewModel) {
    syncFormWithViewModel(viewModel);
    super.onViewModelReady(viewModel);
  }

  @override
  void onDispose(SignupViewModel viewModel) {
    disposeForm();
    super.onDispose(viewModel);
  }

  @override
  SignupViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SignupViewModel();
}
