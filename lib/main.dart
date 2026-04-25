import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:ui';
import 'dart:io';
import 'firebase_options.dart';
import 'package:url_launcher/url_launcher.dart';

// --- نظام الترجمة الشامل ---
class S {
  static const Map<String, Map<String, String>> _data = {
    'ar': {
      'app_title': 'Jaafari Guide',
      'lessons': 'الدروس',
      'quizzes': 'الاختبارات',
      'profile': 'حسابي',
      'email': 'البريد الإلكتروني',
      'pass': 'كلمة المرور',
      'confirm_pass': 'تأكيد كلمة المرور',
      'first_name': 'الاسم الشخصي',
      'last_name': 'النسب (اللقب)',
      'login': 'تسجيل الدخول',
      'register': 'إنشاء حساب تلميذ',
      'have_acc': 'لديك حساب؟ سجل الدخول',
      'no_acc': 'تلميذ جديد؟ أنشئ حساباً',
      'pass_mismatch': 'كلمات المرور غير متطابقة!',
      'fill_fields': 'يرجى ملء جميع الحقول',
      'wrong_auth': 'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
      'auth_error': 'حدث خطأ أثناء تسجيل الدخول. يرجى المحاولة لاحقاً.',
      'subjects': 'المواد الدراسية',
      'lesson': 'الدرس',
      'edit_title': 'تعديل العنوان',
      'new_title': 'العنوان الجديد',
      'finish_lesson': 'إنهاء الدرس',
      'quiz_title': 'الاختبارات QCM',
      'start': 'ابدأ الاختبار',
      'dark_mode': 'الوضع الليلي',
      'lang': 'لغة التطبيق',
      'logout': 'تسجيل الخروج',
      'support': 'التواصل مع الدعم',
      // المواد
      'math': 'الرياضيات',
      'physics': 'الفيزياء',
      'science': 'العلوم',
      'arabic': 'العربية',
      'french': 'الفرنسية',
      'english': 'الإنجليزية',
      'history': 'التاريخ',
      'geography': 'الجغرافيا',
      'islamic': 'التربية الإسلامية',
      'philosophy': 'الفلسفة',
      'it': 'الإعلاميات',
      // إضافة المحتوى
      'add_q': 'إضافة سؤال',
      'q_text': 'نص السؤال',
      'opt': 'الخيار',
      'correct_opt': 'الخيار الصحيح (1-4)',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'add_content': 'إضافة محتوى',
      'content_type': 'نوع المحتوى',
      'text_type': 'نص عادي',
      'file_type': 'رفع ملف (صورة، فيديو، PDF)',
      'content': 'اكتب المحتوى هنا',
      'score': 'نتيجتك هي',
      'open_file': 'فتح الملف / مشاهدة المرفق',
      'uploading': 'جاري الرفع...',
      'exam_img': 'إضافة صورة للامتحان (مساعد)',
      'delete': 'حذف',
    },
    'en': {
      'app_title': 'Jaafari Guide',
      'lessons': 'Lessons',
      'quizzes': 'Quizzes',
      'profile': 'Profile',
      'email': 'Email',
      'pass': 'Password',
      'confirm_pass': 'Confirm Password',
      'first_name': 'First Name',
      'last_name': 'Last Name',
      'login': 'Login',
      'register': 'Student Sign Up',
      'have_acc': 'Have an account? Login',
      'no_acc': 'New student? Sign Up',
      'pass_mismatch': 'Passwords do not match!',
      'fill_fields': 'Please fill all fields',
      'wrong_auth': 'Incorrect email or password.',
      'auth_error': 'An authentication error occurred. Please try again.',
      'subjects': 'Subjects',
      'lesson': 'Lesson',
      'edit_title': 'Edit Title',
      'new_title': 'New Title',
      'finish_lesson': 'Finish Lesson',
      'quiz_title': 'QCM Quizzes',
      'start': 'Start Quiz',
      'dark_mode': 'Dark Mode',
      'lang': 'App Language',
      'logout': 'Logout',
      'support': 'Contact Support',
      'math': 'Mathematics',
      'physics': 'Physics',
      'science': 'Science',
      'arabic': 'Arabic',
      'french': 'French',
      'english': 'English',
      'history': 'History',
      'geography': 'Geography',
      'islamic': 'Islamic Ed',
      'philosophy': 'Philosophy',
      'it': 'Computer Science',
      'add_q': 'Add Question',
      'q_text': 'Question Text',
      'opt': 'Option',
      'correct_opt': 'Correct Option (1-4)',
      'save': 'Save',
      'cancel': 'Cancel',
      'add_content': 'Add Content',
      'content_type': 'Content Type',
      'text_type': 'Text',
      'file_type': 'Upload File (Image, Video, PDF)',
      'content': 'Enter text here',
      'score': 'Your Score is',
      'open_file': 'Open File / View Attachment',
      'uploading': 'Uploading...',
      'exam_img': 'Add Exam Helper Image',
      'delete': 'Delete',
    },
  };
  static String get(String key) =>
      _data[localeNotifier.value.languageCode]?[key] ?? key;
}

// محركات الحالة العالمية
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);
final ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('ar'));

// بيانات المستخدم الحالي
bool isTeacherGlobal = false;
String currentUserEmailGlobal = '';
String currentUserNameGlobal = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase Init Error: $e");
  }
  runApp(const JaafariGuideApp());
}

class JaafariGuideApp extends StatelessWidget {
  const JaafariGuideApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) => ValueListenableBuilder<Locale>(
        valueListenable: localeNotifier,
        builder: (_, locale, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: locale,
          themeMode: mode,
          title: 'Jaafari Guide',
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.deepPurple,
            brightness: Brightness.light,
            fontFamily: 'Cairo',
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.deepPurple,
            brightness: Brightness.dark,
            fontFamily: 'Cairo',
          ),
          home: const AuthWrapper(),
        ),
      ),
    );
  }
}

// --- نظام توجيه الدخول ---
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return UserDataFetcher(uid: snapshot.data!.uid);
        }
        return const AppleGlassLoginScreen();
      },
    );
  }
}

class UserDataFetcher extends StatelessWidget {
  final String uid;
  const UserDataFetcher({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        currentUserEmailGlobal = FirebaseAuth.instance.currentUser?.email ?? '';

        // تحديد الأستاذ
        if (currentUserEmailGlobal == 'bilal38jaafari@gmail.com') {
          isTeacherGlobal = true;
        } else {
          isTeacherGlobal = false;
        }

        if (snapshot.hasData && snapshot.data!.exists) {
          var data = snapshot.data!.data() as Map<String, dynamic>;
          currentUserNameGlobal = "${data['firstName']} ${data['lastName']}";
        } else {
          currentUserNameGlobal = isTeacherGlobal
              ? "أستاذ بلال الجعفري"
              : "تلميذ";
        }
        return const MainNavigation();
      },
    );
  }
}

// --- 1. واجهة تسجيل الدخول ---
class AppleGlassLoginScreen extends StatefulWidget {
  const AppleGlassLoginScreen({super.key});
  @override
  State<AppleGlassLoginScreen> createState() => _AppleGlassLoginScreenState();
}

class _AppleGlassLoginScreenState extends State<AppleGlassLoginScreen> {
  bool isRegistering = false;
  bool isLoading = false;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }

  Future<void> _submit() async {
    String email = _emailCtrl.text.trim();
    String pass = _passCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      _showError(S.get('fill_fields'));
      return;
    }

    setState(() => isLoading = true);

    try {
      if (isRegistering) {
        String confPass = _confirmPassCtrl.text.trim();
        String fname = _firstNameCtrl.text.trim();
        String lname = _lastNameCtrl.text.trim();

        if (pass != confPass) {
          _showError(S.get('pass_mismatch'));
          setState(() => isLoading = false);
          return;
        }
        if (fname.isEmpty || lname.isEmpty) {
          _showError(S.get('fill_fields'));
          setState(() => isLoading = false);
          return;
        }

        UserCredential cred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: pass);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .set({
              'firstName': fname,
              'lastName': lname,
              'role': 'تلميذ',
              'email': email,
              'createdAt': FieldValue.serverTimestamp(),
            });
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: pass,
        );
      }
    } on FirebaseAuthException catch (e) {
      // إصلاح رسائل الخطأ لتكون مفهومة
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        _showError(S.get('wrong_auth'));
      } else {
        _showError(S.get('auth_error'));
      }
    } catch (e) {
      _showError(S.get('auth_error'));
    }

    if (mounted) setState(() => isLoading = false);
  }

  Widget _buildMinimalistLogo() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white30, Colors.white10],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.menu_book_rounded, size: 45, color: Colors.white70),
          Positioned(
            top: 15,
            child: Transform.rotate(
              angle: -0.1,
              child: const Icon(Icons.school, size: 55, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                  Color(0xFF2C5364),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: -50,
            left: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.deepPurpleAccent.withOpacity(0.3),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: CircleAvatar(
              radius: 120,
              backgroundColor: Colors.tealAccent.withOpacity(0.2),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    width: 350,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMinimalistLogo(),
                        const SizedBox(height: 20),
                        Text(
                          S.get('app_title'),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 30),

                        if (isRegistering) ...[
                          Row(
                            children: [
                              Expanded(
                                child: _buildGlassField(
                                  _firstNameCtrl,
                                  S.get('first_name'),
                                  Icons.person,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildGlassField(
                                  _lastNameCtrl,
                                  S.get('last_name'),
                                  Icons.person_outline,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                        ],

                        _buildGlassField(
                          _emailCtrl,
                          S.get('email'),
                          Icons.email,
                        ),
                        const SizedBox(height: 15),
                        _buildGlassField(
                          _passCtrl,
                          S.get('pass'),
                          Icons.lock,
                          obscure: true,
                        ),

                        if (isRegistering) ...[
                          const SizedBox(height: 15),
                          _buildGlassField(
                            _confirmPassCtrl,
                            S.get('confirm_pass'),
                            Icons.lock_reset,
                            obscure: true,
                          ),
                        ],

                        const SizedBox(height: 30),

                        isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(
                                    0.2,
                                  ),
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 55),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: _submit,
                                child: Text(
                                  isRegistering
                                      ? S.get('register')
                                      : S.get('login'),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                        const SizedBox(height: 15),
                        TextButton(
                          onPressed: () => setState(() {
                            isRegistering = !isRegistering;
                            _emailCtrl.clear();
                            _passCtrl.clear();
                          }),
                          child: Text(
                            isRegistering ? S.get('have_acc') : S.get('no_acc'),
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassField(
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    bool obscure = false,
  }) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        prefixIcon: Icon(icon, color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
      ),
    );
  }
}

// --- 2. الواجهة الرئيسية والتنقل ---
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const [
        LessonsGridPage(),
        QuizzesGridPage(),
        ProfilePage(),
      ][_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.book),
            label: S.get('lessons'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.quiz),
            label: S.get('quizzes'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person),
            label: S.get('profile'),
          ),
        ],
      ),
    );
  }
}

class SubjectData {
  final String id;
  final String nameKey;
  final IconData icon;
  final Color color;
  SubjectData(this.id, this.nameKey, this.icon, this.color);
}

final List<SubjectData> appSubjects = [
  SubjectData("math", "math", Icons.calculate, Colors.deepOrange),
  SubjectData("physics", "physics", Icons.wb_iridescent, Colors.blueAccent),
  SubjectData("science", "science", Icons.biotech, Colors.lightGreen),
  SubjectData("arabic", "arabic", Icons.history_edu, Colors.redAccent),
  SubjectData("french", "french", Icons.language, Colors.indigoAccent),
  SubjectData("english", "english", Icons.public, Colors.orange),
  SubjectData("history", "history", Icons.account_balance, Colors.brown),
  SubjectData("geography", "geography", Icons.map, Colors.teal),
  SubjectData("islamic", "islamic", Icons.mosque, Colors.green),
  SubjectData("philosophy", "philosophy", Icons.psychology, Colors.purple),
  SubjectData("it", "it", Icons.computer, Colors.blueGrey),
];

// --- 3. واجهة الدروس (الآن متصلة بـ Firestore) ---
class LessonsGridPage extends StatelessWidget {
  const LessonsGridPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.get('subjects'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: appSubjects.length,
        itemBuilder: (ctx, i) => InkWell(
          onTap: () => Navigator.push(
            ctx,
            MaterialPageRoute(
              builder: (c) => SubjectLessonsPage(subject: appSubjects[i]),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  appSubjects[i].color,
                  appSubjects[i].color.withOpacity(0.6),
                ],
                begin: Alignment.topLeft,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: appSubjects[i].color.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(appSubjects[i].icon, size: 50, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  S.get(appSubjects[i].nameKey),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubjectLessonsPage extends StatefulWidget {
  final SubjectData subject;
  const SubjectLessonsPage({super.key, required this.subject});
  @override
  State<SubjectLessonsPage> createState() => _SubjectLessonsPageState();
}

class _SubjectLessonsPageState extends State<SubjectLessonsPage> {
  void _editTitle(String docId, String currentTitle, String collectionPath) {
    final ctrl = TextEditingController(text: currentTitle);
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(S.get('edit_title')),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(labelText: S.get('new_title')),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: Text(S.get('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.subject.color,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (ctrl.text.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection(collectionPath)
                    .doc(docId)
                    .set({'custom_title': ctrl.text}, SetOptions(merge: true));
              }
              if (mounted) Navigator.pop(context);
            },
            child: Text(S.get('save')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.get(widget.subject.nameKey)),
        backgroundColor: widget.subject.color,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('lesson_metadata')
            .where('subjectId', isEqualTo: widget.subject.id)
            .snapshots(),
        builder: (context, snapshot) {
          Map<String, String> customTitles = {};
          if (snapshot.hasData) {
            for (var doc in snapshot.data!.docs) {
              var data = doc.data() as Map<String, dynamic>;
              if (data.containsKey('custom_title')) {
                customTitles[doc.id] = data['custom_title'];
              }
            }
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: 15,
            itemBuilder: (ctx, index) {
              int lessonNum = index + 1;
              String lessonId = "${widget.subject.id}_lesson_$lessonNum";
              String displayTitle =
                  customTitles[lessonId] ?? "${S.get('lesson')} $lessonNum";

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: widget.subject.color.withOpacity(0.2),
                    child: Text(
                      "$lessonNum",
                      style: TextStyle(
                        color: widget.subject.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    displayTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: isTeacherGlobal
                      ? IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueGrey),
                          onPressed: () => _editTitle(
                            lessonId,
                            displayTitle,
                            'lesson_metadata',
                          ),
                        )
                      : const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LessonContentPage(
                        lessonId: lessonId,
                        title: displayTitle,
                        color: widget.subject.color,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// --- 4. صفحة محتوى الدرس الغني (مربوطة بـ Firestore و Storage) ---
class LessonContentPage extends StatefulWidget {
  final String lessonId;
  final String title;
  final Color color;
  const LessonContentPage({
    super.key,
    required this.lessonId,
    required this.title,
    required this.color,
  });
  @override
  State<LessonContentPage> createState() => _LessonContentPageState();
}

class _LessonContentPageState extends State<LessonContentPage> {
  bool isUploading = false;

  Future<String?> _uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() => isUploading = true);
      try {
        File file = File(result.files.single.path!);
        String fileName =
            "${DateTime.now().millisecondsSinceEpoch}_${result.files.single.name}";
        Reference ref = FirebaseStorage.instance.ref(
          'lesson_files/${widget.lessonId}/$fileName',
        );
        UploadTask uploadTask = ref.putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() => isUploading = false);
        return downloadUrl;
      } catch (e) {
        setState(() => isUploading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("فشل الرفع: $e")));
      }
    }
    return null;
  }

  void _addContentDialog() {
    final ctrl = TextEditingController();
    String selectedType = 'text';

    showDialog(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(S.get('add_content')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: selectedType,
                isExpanded: true,
                items: [
                  DropdownMenuItem(
                    value: 'text',
                    child: Text(S.get('text_type')),
                  ),
                  DropdownMenuItem(
                    value: 'file',
                    child: Text(S.get('file_type')),
                  ),
                ],
                onChanged: (v) => setDialogState(() => selectedType = v!),
              ),
              const SizedBox(height: 15),
              if (selectedType == 'text')
                TextField(
                  controller: ctrl,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: S.get('content'),
                    border: const OutlineInputBorder(),
                  ),
                )
              else
                isUploading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        onPressed: () async {
                          setDialogState(() => isUploading = true);
                          String? fileUrl = await _uploadFile();
                          setDialogState(() => isUploading = false);

                          if (fileUrl != null) {
                            // بمجرد رفع الملف بنجاح، يتم حفظه مباشرة كعنصر محتوى
                            await FirebaseFirestore.instance
                                .collection('lesson_contents')
                                .add({
                                  'lessonId': widget.lessonId,
                                  'type': 'file',
                                  'data': fileUrl,
                                  'timestamp': FieldValue.serverTimestamp(),
                                });
                            if (mounted) Navigator.pop(ctx);
                          }
                        },
                        icon: const Icon(Icons.upload_file),
                        label: Text(S.get('file_type')),
                      ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: Text(S.get('cancel')),
            ),
            if (selectedType == 'text')
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.color,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  if (ctrl.text.isNotEmpty) {
                    await FirebaseFirestore.instance
                        .collection('lesson_contents')
                        .add({
                          'lessonId': widget.lessonId,
                          'type': 'text',
                          'data': ctrl.text,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                    if (mounted) Navigator.pop(context);
                  }
                },
                child: Text(S.get('save')),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri))
      await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _deleteContent(String docId) async {
    await FirebaseFirestore.instance
        .collection('lesson_contents')
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('lesson_contents')
            .where('lessonId', isEqualTo: widget.lessonId)
            .orderBy('timestamp')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "محتوى الدرس غير متوفر بعد.",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          var contents = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: contents.length,
            itemBuilder: (ctx, i) {
              var block = contents[i].data() as Map<String, dynamic>;
              String type = block['type'];
              String data = block['data'];
              String docId = contents[i].id;

              Widget contentWidget;

              if (type == 'file') {
                // التعرف البسيط على الصور من خلال الرابط (الامتدادات الشائعة)
                bool isImage =
                    data.contains('.png') ||
                    data.contains('.jpg') ||
                    data.contains('.jpeg') ||
                    data.contains('alt=media');

                if (isImage) {
                  contentWidget = ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      data,
                      fit: BoxFit.cover,
                      loadingBuilder: (c, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  );
                } else {
                  contentWidget = InkWell(
                    onTap: () => _launchURL(data),
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: widget.color),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.insert_drive_file,
                            size: 30,
                            color: widget.color,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            S.get('open_file'),
                            style: TextStyle(
                              fontSize: 16,
                              color: widget.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              } else {
                contentWidget = Text(
                  data,
                  style: const TextStyle(fontSize: 18, height: 1.6),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: isTeacherGlobal
                    ? Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            child: contentWidget,
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteContent(docId),
                            ),
                          ),
                        ],
                      )
                    : contentWidget,
              );
            },
          );
        },
      ),
      floatingActionButton: isTeacherGlobal
          ? FloatingActionButton.extended(
              onPressed: _addContentDialog,
              backgroundColor: widget.color,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                S.get('add_content'),
                style: const TextStyle(color: Colors.white),
              ),
            )
          : null,
    );
  }
}

// --- 5. نظام الاختبارات المتقدم (مربوط بـ Firestore) ---
class QuizzesGridPage extends StatelessWidget {
  const QuizzesGridPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.get('quiz_title'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: appSubjects.length,
        itemBuilder: (ctx, i) => Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: appSubjects[i].color,
              child: Icon(appSubjects[i].icon, color: Colors.white),
            ),
            title: Text(
              S.get(appSubjects[i].nameKey),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Navigator.push(
              ctx,
              MaterialPageRoute(
                builder: (c) => SubjectQuizzesListPage(subject: appSubjects[i]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SubjectQuizzesListPage extends StatefulWidget {
  final SubjectData subject;
  const SubjectQuizzesListPage({super.key, required this.subject});

  @override
  State<SubjectQuizzesListPage> createState() => _SubjectQuizzesListPageState();
}

class _SubjectQuizzesListPageState extends State<SubjectQuizzesListPage> {
  void _editQuizTitle(String docId, String currentTitle) {
    final ctrl = TextEditingController(text: currentTitle);
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(S.get('edit_title')),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(labelText: S.get('new_title')),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: Text(S.get('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.subject.color,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (ctrl.text.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('quiz_metadata')
                    .doc(docId)
                    .set({'custom_title': ctrl.text}, SetOptions(merge: true));
              }
              if (mounted) Navigator.pop(context);
            },
            child: Text(S.get('save')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${S.get('quiz_title')} - ${S.get(widget.subject.nameKey)}",
        ),
        backgroundColor: widget.subject.color,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('quiz_metadata')
            .where('subjectId', isEqualTo: widget.subject.id)
            .snapshots(),
        builder: (context, snapshot) {
          Map<String, String> customTitles = {};
          if (snapshot.hasData) {
            for (var doc in snapshot.data!.docs) {
              var data = doc.data() as Map<String, dynamic>;
              if (data.containsKey('custom_title')) {
                customTitles[doc.id] = data['custom_title'];
              }
            }
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: 15,
            itemBuilder: (ctx, i) {
              int lessonNum = i + 1;
              String quizId = "${widget.subject.id}_quiz_$lessonNum";
              String displayTitle =
                  customTitles[quizId] ??
                  "اختبار ${S.get('lesson')} $lessonNum";

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.quiz, color: Colors.orange),
                  title: Text(
                    displayTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: isTeacherGlobal
                      ? IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueGrey),
                          onPressed: () => _editQuizTitle(quizId, displayTitle),
                        )
                      : null,
                  onTap: () => Navigator.push(
                    ctx,
                    MaterialPageRoute(
                      builder: (_) => QuizPlayArea(
                        quizId: quizId,
                        color: widget.subject.color,
                        title: displayTitle,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class QuizPlayArea extends StatefulWidget {
  final String quizId;
  final Color color;
  final String title;
  const QuizPlayArea({
    super.key,
    required this.quizId,
    required this.color,
    required this.title,
  });
  @override
  State<QuizPlayArea> createState() => _QuizPlayAreaState();
}

class _QuizPlayAreaState extends State<QuizPlayArea> {
  int currentQuestionIndex = 0;
  int score = 0;
  bool isFinished = false;
  bool isUploadingImg = false;

  Future<void> _uploadExamImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null && result.files.single.path != null) {
      setState(() => isUploadingImg = true);
      try {
        File file = File(result.files.single.path!);
        String fileName =
            "exam_${DateTime.now().millisecondsSinceEpoch}_${result.files.single.name}";
        Reference ref = FirebaseStorage.instance.ref(
          'quiz_images/${widget.quizId}/$fileName',
        );
        await ref.putFile(file);
        String downloadUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('quiz_metadata')
            .doc(widget.quizId)
            .set({'exam_image': downloadUrl}, SetOptions(merge: true));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("خطأ في الرفع: $e")));
      }
      setState(() => isUploadingImg = false);
    }
  }

  void _addQuestionDialog() {
    final qCtrl = TextEditingController();
    final opt1 = TextEditingController();
    final opt2 = TextEditingController();
    final opt3 = TextEditingController();
    final opt4 = TextEditingController();
    int correctOpt = 1;

    showDialog(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text(S.get('add_q')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: qCtrl,
                  decoration: InputDecoration(labelText: S.get('q_text')),
                ),
                TextField(
                  controller: opt1,
                  decoration: InputDecoration(labelText: "${S.get('opt')} 1"),
                ),
                TextField(
                  controller: opt2,
                  decoration: InputDecoration(labelText: "${S.get('opt')} 2"),
                ),
                TextField(
                  controller: opt3,
                  decoration: InputDecoration(labelText: "${S.get('opt')} 3"),
                ),
                TextField(
                  controller: opt4,
                  decoration: InputDecoration(labelText: "${S.get('opt')} 4"),
                ),
                DropdownButton<int>(
                  value: correctOpt,
                  items: [1, 2, 3, 4]
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text("الجواب الصحيح: $e"),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setStateDialog(() => correctOpt = v!),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                if (qCtrl.text.isNotEmpty && opt1.text.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('quiz_questions')
                      .add({
                        'quizId': widget.quizId,
                        'q': qCtrl.text,
                        'opts': [opt1.text, opt2.text, opt3.text, opt4.text],
                        'ans': correctOpt - 1,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                  if (mounted) Navigator.pop(context);
                }
              },
              child: Text(S.get('save')),
            ),
          ],
        ),
      ),
    );
  }

  void _answerQuestion(
    int selectedIndex,
    List<QueryDocumentSnapshot> questions,
  ) {
    var qData = questions[currentQuestionIndex].data() as Map<String, dynamic>;
    if (selectedIndex == qData['ans']) score++;

    if (currentQuestionIndex < questions.length - 1) {
      setState(() => currentQuestionIndex++);
    } else {
      setState(() => isFinished = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
        actions: [
          if (isTeacherGlobal)
            isUploadingImg
                ? const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : IconButton(
                    icon: const Icon(Icons.add_photo_alternate),
                    tooltip: S.get('exam_img'),
                    onPressed: _uploadExamImage,
                  ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('quiz_metadata')
            .doc(widget.quizId)
            .snapshots(),
        builder: (ctx, metaSnapshot) {
          String? examImageUrl;
          if (metaSnapshot.hasData && metaSnapshot.data!.exists) {
            var mData = metaSnapshot.data!.data() as Map<String, dynamic>;
            if (mData.containsKey('exam_image'))
              examImageUrl = mData['exam_image'];
          }

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('quiz_questions')
                .where('quizId', isEqualTo: widget.quizId)
                .orderBy('timestamp')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return const Center(child: CircularProgressIndicator());

              var questions = snapshot.data?.docs ?? [];

              if (questions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (examImageUrl != null)
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Image.network(examImageUrl, height: 200),
                        ),
                      Text(
                        isTeacherGlobal
                            ? "لا توجد أسئلة، أضف أسئلة الآن"
                            : "الاختبار غير متاح بعد",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                );
              }

              if (isFinished) {
                return Center(
                  child: Text(
                    "${S.get('score')}: $score / ${questions.length}",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              var currentQData =
                  questions[currentQuestionIndex].data()
                      as Map<String, dynamic>;
              List<dynamic> options = currentQData['opts'];

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (examImageUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(examImageUrl, fit: BoxFit.cover),
                        ),
                      ),
                    Text(
                      "السؤال ${currentQuestionIndex + 1}/${questions.length}",
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      currentQData['q'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ...List.generate(
                      options.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 55),
                            alignment: Alignment.centerRight,
                          ),
                          onPressed: () => _answerQuestion(index, questions),
                          child: Text(
                            options[index],
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: isTeacherGlobal
          ? FloatingActionButton.extended(
              onPressed: _addQuestionDialog,
              backgroundColor: widget.color,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                S.get('add_q'),
                style: const TextStyle(color: Colors.white),
              ),
            )
          : null,
    );
  }
}

// --- 6. حسابي والدعم ---
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _contactSupport() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'bilal38jaafari@gmail.com',
      queryParameters: {'subject': 'طلب دعم من تطبيق Jaafari Guide'},
    );
    try {
      await launchUrl(emailLaunchUri);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.get('profile'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.deepPurple,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 15),
          Center(
            child: Text(
              currentUserNameGlobal,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              currentUserEmailGlobal,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          Center(
            child: Text(
              isTeacherGlobal ? "أستاذ / مدير 👨‍🏫" : "تلميذ 🎓",
              style: TextStyle(
                color: isTeacherGlobal ? Colors.redAccent : Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 30),

          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: Text(
              S.get('dark_mode'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Switch(
              value: themeNotifier.value == ThemeMode.dark,
              onChanged: (v) =>
                  themeNotifier.value = v ? ThemeMode.dark : ThemeMode.light,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(
              S.get('lang'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_drop_down),
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (c) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text("العربية"),
                    onTap: () {
                      localeNotifier.value = const Locale('ar');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text("English"),
                    onTap: () {
                      localeNotifier.value = const Locale('en');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.support_agent),
            title: Text(
              S.get('support'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: _contactSupport,
          ),
          const Divider(height: 40),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              S.get('logout'),
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              isTeacherGlobal = false;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AuthWrapper()),
              );
            },
          ),
        ],
      ),
    );
  }
}
