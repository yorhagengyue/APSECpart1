import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

enum LoginMethod {
  email,
  phone,
}

class LoginEmailPage extends StatefulWidget {
  const LoginEmailPage({super.key});

  @override
  State<LoginEmailPage> createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  LoginMethod _loginMethod = LoginMethod.email;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isLoginButtonPressed = false;
  bool _isGoogleButtonPressed = false;
  String _fullPhoneNumber = '';

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_handleFocusChange);
    _passwordFocusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _smsController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _fullPhoneNumber = '';
    super.dispose();
  }

  void _handleLogin() {
    setState(() => _isLoginButtonPressed = true);
    
    bool isValid = false;
    if (_loginMethod == LoginMethod.email) {
      isValid = _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    } else {
      isValid = _fullPhoneNumber.isNotEmpty && _smsController.text.isNotEmpty;
    }

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all fields').animate().fadeIn(duration: 300.ms).slideY(begin: 0.5, end: 0),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent.shade100,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      Future.delayed(const Duration(milliseconds: 200), () {
        if (!mounted) return;
        setState(() => _isLoginButtonPressed = false);
      });
      return;
    }

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _isLoginButtonPressed = false);
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeOutCubic));
            return SlideTransition(position: animation.drive(tween), child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    });
  }

  void _handleGoogleSignIn() async {
    setState(() => _isGoogleButtonPressed = true);
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final result = await googleSignIn.signIn();
      if (!mounted) return;
      if (result != null) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeOutCubic));
              return SlideTransition(position: animation.drive(tween), child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google sign-in failed: $e').animate().fadeIn(duration: 300.ms).slideY(begin: 0.5, end: 0),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent.shade100,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
    if (!mounted) return;
    setState(() => _isGoogleButtonPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 顶部绿色背景部分 - 带镜像图片
            Stack(
              children: [
                // 镜像图片容器
                Container(
                  height: 250, // 设置适当的高度
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(26),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  // 使用Transform.flip实现镜像
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: Transform.flip(
                      flipX: true, // 水平翻转
                      child: Image.asset(
                        'assets/images/nature2.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
                
                // 内容
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 状态栏空间和时间显示
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '9:41',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B5E20),
                                shadows: [
                                  Shadow(
                                    color: Color(0x80FFFFFF),
                                    blurRadius: 2,
                                    offset: Offset(0.5, 0.5),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.signal_cellular_4_bar, size: 16, color: Color(0xFF1B5E20)),
                                SizedBox(width: 4),
                                Icon(Icons.wifi, size: 16, color: Color(0xFF1B5E20)),
                                SizedBox(width: 4),
                                Icon(Icons.battery_full, size: 16, color: Color(0xFF1B5E20)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // GreenSwap标题
                      Row(
                        children: [
                          const Text(
                            'Green',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B5E20),
                              shadows: [
                                Shadow(
                                  color: Color(0x99FFFFFF),
                                  blurRadius: 2,
                                  offset: Offset(0.5, 0.5),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.2, end: 0),
                          Shimmer.fromColors(
                            baseColor: Colors.black,
                            highlightColor: const Color(0xFF4CAF50),
                            period: const Duration(seconds: 3),
                            child: const Text(
                              'Swap',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                shadows: [
                                  Shadow(
                                    color: Color(0x99FFFFFF),
                                    blurRadius: 2,
                                    offset: Offset(0.5, 0.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ).animate().scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), duration: 600.ms, curve: Curves.elasticOut),
                      const SizedBox(height: 10),
                      
                      // 欢迎文本
                      const Text(
                        'Hi, Welcome Back',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          shadows: [
                            Shadow(
                              color: Color(0xB3FFFFFF),
                              blurRadius: 3,
                              offset: Offset(0.7, 0.7),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 300.ms, duration: 600.ms).slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 20),
                      
                      // 登录方式选择器
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(13),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Email选项卡
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _loginMethod = LoginMethod.email;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _loginMethod == LoginMethod.email
                                        ? Colors.black
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Email',
                                    style: TextStyle(
                                      color: _loginMethod == LoginMethod.email
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ).animate(target: _loginMethod == LoginMethod.email ? 1 : 0)
                              .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 300.ms),
                            
                            // 电话号码选项卡
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _loginMethod = LoginMethod.phone;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _loginMethod == LoginMethod.phone
                                        ? Colors.black
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Phone Number',
                                    style: TextStyle(
                                      color: _loginMethod == LoginMethod.phone
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ).animate(target: _loginMethod == LoginMethod.phone ? 1 : 0)
                              .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 300.ms),
                          ],
                        ),
                      ).animate().fadeIn(delay: 600.ms, duration: 600.ms).slideY(begin: 0.2, end: 0),
                    ],
                  ),
                ),
              ],
            ),
            
            // 主体内容 - 登录表单
            Padding(
              padding: const EdgeInsets.all(20),
              child: _loginMethod == LoginMethod.email 
                ? _buildEmailForm() 
                : _buildPhoneForm(),
            ),
          ],
        ),
      ),
    );
  }

  // 构建电子邮件/密码表单
  Widget _buildEmailForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 电子邮件标签
        const Text(
          'Email',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
        const SizedBox(height: 8),
        _buildEmailTextField(),
        const SizedBox(height: 20),
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ).animate().fadeIn(delay: 1000.ms, duration: 400.ms),
        const SizedBox(height: 8),
        _buildPasswordTextField(),
        const SizedBox(height: 15),
        _buildRememberForgotRow(),
        const SizedBox(height: 30),
        _buildLoginButton(),
        const SizedBox(height: 30),
        _buildDivider(),
        const SizedBox(height: 30),
        _buildGoogleButton(),
        const SizedBox(height: 30),
        _buildRegisterRow(),
      ],
    );
  }

  // 构建电话登录表单
  Widget _buildPhoneForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phone Number',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        IntlPhoneField(
          controller: _phoneController,
          decoration: const InputDecoration(
            hintText: 'Enter phone number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
          ),
          initialCountryCode: 'SG',
          onChanged: (phone) {
            _fullPhoneNumber = phone.completeNumber;
          },
        ),
        const SizedBox(height: 20),
        const Text(
          'SMS Code',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                controller: _smsController,
                decoration: const InputDecoration(
                  hintText: '123456',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB4E082),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text('Get Code'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        _buildLoginButton(text: 'Login'),
        const SizedBox(height: 30),
        _buildDivider(),
        const SizedBox(height: 30),
        _buildGoogleButton(),
        const SizedBox(height: 30),
        _buildRegisterRow(),
      ],
    );
  }

  // Helper widget builders (email/password etc.)
  Widget _buildEmailTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: _emailFocusNode.hasFocus 
            ? const Color(0xFFB4E082) 
            : Colors.grey.shade300,
          width: _emailFocusNode.hasFocus ? 2 : 1,
        ),
        boxShadow: _emailFocusNode.hasFocus ? [
          BoxShadow(
            color: const Color(0x4DB4E082),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: TextField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          hintText: 'user@gmail.com',
          prefixIcon: Icon(Icons.email_outlined),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: _passwordFocusNode.hasFocus 
            ? const Color(0xFFB4E082) 
            : Colors.grey.shade300,
          width: _passwordFocusNode.hasFocus ? 2 : 1,
        ),
        boxShadow: _passwordFocusNode.hasFocus ? [
          BoxShadow(
            color: const Color(0x4DB4E082),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: TextField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          hintText: '********',
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ).animate(
            onPlay: (controller) => controller.repeat(reverse: true),
          ).rotate(
            begin: 0,
            end: 0.05,
            duration: 150.ms,
            delay: 2.seconds,
            curve: Curves.easeInOut,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildRememberForgotRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 记住我复选框
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _rememberMe ? const Color(0xFFB4E082) : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: _rememberMe ? Colors.transparent : Colors.grey.shade300),
              ),
              child: Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
                activeColor: Colors.transparent,
                checkColor: Colors.white,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ).animate(target: _rememberMe ? 1 : 0)
              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 200.ms)
              .rotate(begin: -0.1, end: 0, duration: 200.ms),
            const SizedBox(width: 8),
            const Text(
              'Remember me',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        
        // 忘记密码文本
        GestureDetector(
          onTap: () {
            // 处理忘记密码
          },
          child: const Text(
            'Forgot Password?',
            style: TextStyle(
              color: Color(0xFFB4E082),
              fontSize: 14,
            ),
          ).animate(
            onPlay: (controller) => controller.repeat(reverse: true),
          ).shimmer(
            duration: 2.seconds,
            delay: 3.seconds,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton({String text = 'Login'}) {
    return GestureDetector(
      onTap: _handleLogin,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFFB4E082),
          borderRadius: BorderRadius.circular(50),
          boxShadow: _isLoginButtonPressed ? null : [
            BoxShadow(
              color: const Color(0x80B4E082),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        transform: _isLoginButtonPressed 
          ? Matrix4.translationValues(0, 2, 0)
          : Matrix4.translationValues(0, 0, 0),
        alignment: Alignment.center,
        child: _isLoginButtonPressed
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            )
          : Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey.shade300,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            'Or Sign in with',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return GestureDetector(
      onTap: _handleGoogleSignIn,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: _isGoogleButtonPressed ? null : [
            BoxShadow(
              color: const Color(0x1A000000),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        transform: _isGoogleButtonPressed 
          ? Matrix4.translationValues(0, 2, 0)
          : Matrix4.translationValues(0, 0, 0),
        alignment: Alignment.center,
        child: _isGoogleButtonPressed
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.g_mobiledata,
                  color: Colors.blue,
                  size: 30,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Continue with Google',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
      ),
    );
  }

  Widget _buildRegisterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Don\'t have an account? ',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: () {
            // 导航到注册页面
          },
          child: const Text(
            'Register',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ).animate(
            onPlay: (controller) => controller.repeat(reverse: true),
          ).tint(
            color: const Color(0xFFB4E082),
            duration: 1.seconds,
            delay: 4.seconds,
          ),
        ),
      ],
    );
  }
} 