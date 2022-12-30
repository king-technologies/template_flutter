import 'package:flutter/material.dart';

import '../../utils/small_widgets.dart';
import '../home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isObscure = true, _isLoading = false;
  final FocusNode _mobileNode = FocusNode(), _passwordNode = FocusNode();
  final TextEditingController _mobileController = TextEditingController(),
      _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _mobileNode.dispose();
    _passwordNode.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Login to Continue'),
                  const SizedBox(height: 12),
                  TextFormField(
                    maxLength: 10,
                    onFieldSubmitted: (_) => _passwordNode.requestFocus(),
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    focusNode: _mobileNode,
                    onChanged: (value) => setState(() {}),
                    textInputAction: TextInputAction.next,
                    controller: _mobileController,
                    decoration: const InputDecoration(
                      labelText: 'Mobile',
                      counterText: '',
                      prefixIcon: Icon(Icons.phone_android),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordNode,
                    textInputAction: TextInputAction.done,
                    onChanged: (value) => setState(() {}),
                    onFieldSubmitted: (_) {},
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 18,
                            ),
                            onPressed: () =>
                                setState(() => _isObscure = !_isObscure))),
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    onTap: _mobileController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty
                        ? () {
                            setState(() => _isLoading = true);
                            Future.delayed(const Duration(seconds: 2), () {
                              setState(() => _isLoading = false);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const Home()));
                            });
                          }
                        : null,
                    label: 'LOGIN',
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: mediaQuery.viewInsets.bottom > size.height * 0.2
                        ? size.height * 0.3
                        : 0,
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              width: size.width,
              height: size.height,
              color: Colors.transparent,
              child: const Center(child: CircularProgressIndicator()),
            )
        ],
      ),
    );
  }
}
