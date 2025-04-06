import 'package:flutter/material.dart';
import 'package:friends_around_me/utils/utils.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'signin_view.form.dart';
import 'signin_viewmodel.dart';

@FormView(
  autoTextFieldValidation: false,
  fields: [
    FormTextField(
      name: 'email',
      validator: Validator.validateEmail,
    ),
    FormTextField(
      name: 'password',
      validator: Validator.validatePassword,
    ),
  ],
)
class SigninView extends StackedView<SigninViewModel> with $SigninView {
  const SigninView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SigninViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("SigninView")),
      ),
    );
  }

  @override
  void onViewModelReady(SigninViewModel viewModel) {
    syncFormWithViewModel(viewModel);
    super.onViewModelReady(viewModel);
  }

  @override
  void onDispose(SigninViewModel viewModel) {
    disposeForm();
    super.onDispose(viewModel);
  }

  @override
  SigninViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SigninViewModel();
}
