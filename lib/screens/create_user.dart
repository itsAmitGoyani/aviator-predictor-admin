import 'package:aviator_predictor_admin/services/toasting.dart';
import 'package:aviator_predictor_admin/utils/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateUserScreen extends StatefulWidget {
  CreateUserScreen({Key? key}) : super(key: UniqueKey());

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen>
    with SingleTickerProviderStateMixin {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _emailController, _passwordController;
  late FocusNode emailFocusNode, passwordFocusNode;
  bool checked = false, isLoading = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create User"),
        elevation: 5,
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    focusNode: emailFocusNode,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      hintText: "Email",
                      isDense: true,
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(width: 1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return "Please enter email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    focusNode: passwordFocusNode,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      hintText: "Password",
                      isDense: true,
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(width: 1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return "Please enter password";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF67DF65),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            emailFocusNode.unfocus();
                            passwordFocusNode.unfocus();
                            if (_formKey.currentState?.validate() ?? false) {
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                final credential = await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                );
                                showToast(context,
                                    text: "Created successfully...");
                                _emailController.text = "";
                                _passwordController.text = "";
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  showErrorToast(context,
                                      text:
                                          'The password provided is too weak.');
                                } else if (e.code == 'email-already-in-use') {
                                  showErrorToast(context,
                                      text:
                                          'The account already exists for that email.');
                                }
                              } catch (e) {
                                showErrorToast(context,
                                    text: 'Unknown error: $e');
                              }
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                    child: Center(
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Color(0xFF67DF65),
                                strokeWidth: 3,
                              ),
                            )
                          : const Text(
                              "CREATE",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
