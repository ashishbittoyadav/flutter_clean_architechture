import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>()
          .add(AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints) {
        final isTablet = constraints.maxWidth > 600;
        return Scaffold(
          appBar: AppBar(
            title: Text('Login',style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 18.sp),),
          ),
          body: BlocConsumer<AuthBloc, AuthState>(builder: (context, state) {
            final isLoading = state is AuthLoading;
            return Padding(
              padding: EdgeInsetsGeometry.all(24.r)
              , child: Form(key: _formKey
                , child: isTablet ? _buildLoginFormForTablet(isLoading) : _buildLoginFormForMobile(isLoading)),
            );
          }, listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message), backgroundColor: Colors.red,)
              );
            }
          }),
        );
      }
    );
  }

  Widget _buildLoginFormForTablet(bool isLoading){
    return Row(
      children: [
        // Left panel: branding
        Expanded(
          child: Container(
            color: Colors.blue.shade50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 100.r,
                  color: Colors.blue,
                ),
                SizedBox(height: 24.h),
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Sign in to continue',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ],
            ),
          ),
        ),

        // Right panel: login form
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(32.r),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 420,
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      enabled: !isLoading,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter email';
                        }
                        if (!value.contains('@')) {
                          return 'Invalid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h,),
                    TextFormField(
                      controller: _passwordController,
                      enabled: !isLoading,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter password';
                        }
                        if (value.length < 6) {
                          return 'Minimum length is 6';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.h,),
                    ElevatedButton(onPressed: isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),)
                        ,
                        child: isLoading ? SizedBox(height: 20.h,
                          width: 20.w,
                          child: CircularProgressIndicator(strokeWidth: 2.w,),):Text('Login'))
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Show icon in the mobile form.
          // On tablets, the branding panel already has the icon.
          LayoutBuilder(
            builder: (context, constraints) {
              final isTablet = constraints.maxWidth >= 600;

              if (isTablet) {
                return const SizedBox.shrink();
              }

              return Column(
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 80.r,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 32.h),
                ],
              );
            },
          ),

          Text(
            'Sign in',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24.h),

          TextFormField(
            controller: _emailController,
            enabled: !isLoading,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter email';
              }
              if (!value.contains('@')) {
                return 'Invalid email';
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),

          TextFormField(
            controller: _passwordController,
            enabled: !isLoading,
            obscureText: true,
            autofillHints: const [AutofillHints.password],
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter password';
              }
              if (value.length < 6) {
                return 'Minimum length is 6';
              }
              return null;
            },
          ),
          SizedBox(height: 24.h),

          SizedBox(
            height: 48.h,
            child: ElevatedButton(
              onPressed: isLoading ? null : _handleLogin,
              child: isLoading
                  ? SizedBox(
                height: 20.r,
                width: 20.r,
                child: CircularProgressIndicator(
                  strokeWidth: 2.r,
                ),
              )
                  : const Text('Login'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginFormForMobile(bool isLoading){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.lock_outline, size: 80.r, color: Colors.blue,),
        SizedBox(height: 40.h,),
        TextFormField(
          controller: _emailController,
          enabled: !isLoading,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Enter email';
            }
            if (!value.contains('@')) {
              return 'Invalid email';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h,),
        TextFormField(
          controller: _passwordController,
          enabled: !isLoading,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Enter password';
            }
            if (value.length < 6) {
              return 'Minimum length is 6';
            }
            return null;
          },
        ),
        SizedBox(height: 24.h,),
        ElevatedButton(onPressed: isLoading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.h),)
            ,
            child: isLoading ? SizedBox(height: 20.h,
              width: 20.w,
              child: CircularProgressIndicator(strokeWidth: 2.w,),):Text('Login'))
      ],
    );
  }
}
