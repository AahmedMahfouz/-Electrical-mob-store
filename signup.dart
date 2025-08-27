import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _loading = false;
  bool _obscureText = true;
  bool _obscureConfirmText = true;

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      _showMessage("كلمات المرور غير متطابقة");
      return;
    }

    setState(() => _loading = true);

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        await userCredential.user!.sendEmailVerification();

        // مسح الحقول بعد إنشاء الحساب بنجاح
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();

        // إظهار رسالة النجاح
        _showSuccessMessage("لقد سجلت بنجاح! يرجى التحقق من بريدك الإلكتروني لتفعيل الحساب.");
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "حدث خطأ أثناء إنشاء الحساب";

      if (e.code == 'weak-password') {
        errorMessage = "كلمة المرور ضعيفة جداً";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "هذا البريد الإلكتروني مستخدم بالفعل";
      } else if (e.code == 'invalid-email') {
        errorMessage = "بريد إلكتروني غير صالح";
      }

      _showMessage(errorMessage);
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showMessage(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "تنبيه",
          style: TextStyle(fontFamily: 'Almarai'),
        ),
        content: Text(
          msg,
          style: TextStyle(fontFamily: 'Almarai'),
        ),
        actions: [
          TextButton(
            child: Text(
              "موافق",
              style: TextStyle(fontFamily: 'Almarai'),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }

  void _showSuccessMessage(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "تم بنجاح",
          style: TextStyle(fontFamily: 'Almarai', color: Colors.green),
        ),
        content: Text(
          msg,
          style: TextStyle(fontFamily: 'Almarai'),
        ),
        actions: [
          TextButton(
            child: Text(
              "حسناً",
              style: TextStyle(fontFamily: 'Almarai'),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // خلفية الصورة المعدلة
          SizedBox.expand(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.darken,
              ),
              child: Image.asset(
                "assets/images/img_1.png",
                fit: BoxFit.cover,
              ),
            ),
          ),

          // محتوى النموذج
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // شعار التطبيق
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: Icon(
                        Icons.person_add,
                        size: 60,
                        color: kPrimaryColor,
                      ),
                    ),

                    SizedBox(height: 30),

                    Text(
                        "انضم إلينا اليوم!",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Almarai',
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        )
                    ),

                    SizedBox(height: 10),

                    Text(
                      "أنشئ حسابك واستمتع بأفضل العروض والتجربة",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontFamily: 'Almarai',
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 30),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "البريد الإلكتروني",
                          labelStyle: TextStyle(fontFamily: 'Almarai', color: Colors.grey[700]),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          prefixIcon: Icon(Icons.email, color: kPrimaryColor),
                        ),
                        validator: (val) => val!.isEmpty ? "يرجى إدخال البريد الإلكتروني" : null,
                        style: TextStyle(fontFamily: 'Almarai'),
                      ),
                    ),

                    SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: "كلمة المرور",
                          labelStyle: TextStyle(fontFamily: 'Almarai', color: Colors.grey[700]),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          prefixIcon: Icon(Icons.lock, color: kPrimaryColor),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility : Icons.visibility_off,
                              color: kPrimaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        validator: (val) => val!.length < 6 ? "كلمة المرور يجب أن تكون 6 أحرف على الأقل" : null,
                        style: TextStyle(fontFamily: 'Almarai'),
                      ),
                    ),

                    SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmText,
                        decoration: InputDecoration(
                          labelText: "تأكيد كلمة المرور",
                          labelStyle: TextStyle(fontFamily: 'Almarai', color: Colors.grey[700]),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          prefixIcon: Icon(Icons.lock_outline, color: kPrimaryColor),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmText ? Icons.visibility : Icons.visibility_off,
                              color: kPrimaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmText = !_obscureConfirmText;
                              });
                            },
                          ),
                        ),
                        validator: (val) => val!.isEmpty ? "يرجى تأكيد كلمة المرور" : null,
                        style: TextStyle(fontFamily: 'Almarai'),
                      ),
                    ),

                    SizedBox(height: 30),

                    _loading
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3,
                    )
                        : SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _signup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          shadowColor: Colors.black38,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_add_alt_1, size: 22),
                            SizedBox(width: 10),
                            Text(
                              "إنشاء حساب جديد",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // زر العودة لتسجيل الدخول
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.white, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        child: Text(
                          "العودة لتسجيل الدخول",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    Text(
                      "بإنشائك للحساب فإنك توافق على الشروط والأحكام",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontFamily: 'Almarai',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}