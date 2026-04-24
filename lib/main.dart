import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';
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
      'subjects': 'المواد الدراسية',
      'lesson': 'الدرس',
      'edit_title': 'تعديل عنوان الدرس',
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
      'add_content': 'إضافة محتوى للدرس',
      'content_type': 'نوع المحتوى',
      'text_type': 'نص عادي',
      'img_type': 'رابط صورة (URL)',
      'vid_type': 'رابط فيديو (URL)',
      'content': 'اكتب المحتوى أو الرابط هنا',
      'score': 'نتيجتك هي',
      'watch_video': 'مشاهدة الفيديو',
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
      'subjects': 'Subjects',
      'lesson': 'Lesson',
      'edit_title': 'Edit Lesson Title',
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
      'add_content': 'Add Lesson Content',
      'content_type': 'Content Type',
      'text_type': 'Text',
      'img_type': 'Image URL',
      'vid_type': 'Video URL',
      'content': 'Enter content or link',
      'score': 'Your Score is',
      'watch_video': 'Watch Video',
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

// --- هياكل البيانات ---
class ContentBlock {
  String type;
  String data;
  ContentBlock({required this.type, required this.data});
}

class MockDatabase {
  static Map<String, String> customLessonTitles = {};
  static Map<String, List<ContentBlock>> lessonContents = {};
  static Map<String, List<Map<String, dynamic>>> quizzes = {};
}

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

// --- نظام توجيه الدخول وتحديد الأستاذ سرياً ---
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

        // --- تحديد الأستاذ هنا بناءً على الإيميل ---
        if (currentUserEmailGlobal == 'bilal38jaafari@gmail.com') {
          isTeacherGlobal = true; // أنت الأستاذ!
        } else {
          isTeacherGlobal = false; // أي شخص آخر هو تلميذ
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

// --- 1. واجهة تسجيل الدخول الزجاجية (Apple Glassmorphism) واللوجو المينيمالي ---
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

        // حفظ حساب جديد كتلميذ دائماً
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
      _showError(e.message ?? "حدث خطأ");
    }

    if (mounted) setState(() => isLoading = false);
  }

  // اللوجو المبرمج: قبعة التخرج مدمجة مع كتاب بستايل آبل النظيف
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
          // الخلفية الداكنة الأنيقة بستايل نظام ماك
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
          // الدوائر التجميلية في الخلفية
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
                  filter: ImageFilter.blur(
                    sigmaX: 20,
                    sigmaY: 20,
                  ), // التأثير الزجاجي القوي
                  child: Container(
                    width: 350,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1), // شفافية زجاجية
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

// قائمة المواد
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

// --- 3. واجهة الدروس ---
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
  void _editLessonTitle(String lessonId, String currentTitle) {
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
            onPressed: () {
              setState(
                () => MockDatabase.customLessonTitles[lessonId] = ctrl.text,
              );
              Navigator.pop(context);
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
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: 15,
        itemBuilder: (ctx, index) {
          int lessonNum = index + 1;
          String lessonId = "${widget.subject.id}_lesson_$lessonNum";
          String displayTitle =
              MockDatabase.customLessonTitles[lessonId] ??
              "${S.get('lesson')} $lessonNum";

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
                      onPressed: () => _editLessonTitle(lessonId, displayTitle),
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
      ),
    );
  }
}

// --- 4. صفحة محتوى الدرس الغني ---
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
  List<ContentBlock> contents = [];

  @override
  void initState() {
    super.initState();
    contents = MockDatabase.lessonContents[widget.lessonId] ?? [];
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
                    value: 'image',
                    child: Text(S.get('img_type')),
                  ),
                  DropdownMenuItem(
                    value: 'video',
                    child: Text(S.get('vid_type')),
                  ),
                ],
                onChanged: (v) => setDialogState(() => selectedType = v!),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: ctrl,
                maxLines: selectedType == 'text' ? 5 : 1,
                decoration: InputDecoration(
                  labelText: S.get('content'),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: Text(S.get('cancel')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (ctrl.text.isNotEmpty) {
                  setState(() {
                    contents.add(
                      ContentBlock(type: selectedType, data: ctrl.text),
                    );
                    MockDatabase.lessonContents[widget.lessonId] = contents;
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(S.get('save')),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchVideo(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri))
      await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
      ),
      body: contents.isEmpty
          ? const Center(
              child: Text(
                "محتوى الدرس غير متوفر بعد.",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: contents.length,
              itemBuilder: (ctx, i) {
                final block = contents[i];
                if (block.type == 'image') {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(block.data, fit: BoxFit.cover),
                    ),
                  );
                } else if (block.type == 'video') {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: InkWell(
                      onTap: () => _launchVideo(block.data),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: widget.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: widget.color),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.play_circle_fill,
                              size: 40,
                              color: widget.color,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              S.get('watch_video'),
                              style: TextStyle(
                                fontSize: 18,
                                color: widget.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    block.data,
                    style: const TextStyle(fontSize: 18, height: 1.6),
                  ),
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

// --- 5. نظام الاختبارات المتقدم ---
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

class SubjectQuizzesListPage extends StatelessWidget {
  final SubjectData subject;
  const SubjectQuizzesListPage({super.key, required this.subject});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${S.get('quiz_title')} - ${S.get(subject.nameKey)}"),
        backgroundColor: subject.color,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: 15,
        itemBuilder: (ctx, i) {
          int lessonNum = i + 1;
          String quizId = "${subject.id}_quiz_$lessonNum";
          return Card(
            child: ListTile(
              leading: const Icon(Icons.quiz, color: Colors.orange),
              title: Text("اختبار ${S.get('lesson')} $lessonNum"),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: subject.color,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.push(
                  ctx,
                  MaterialPageRoute(
                    builder: (_) => QuizPlayArea(
                      quizId: quizId,
                      color: subject.color,
                      title: "اختبار الدرس $lessonNum",
                    ),
                  ),
                ),
                child: Text(isTeacherGlobal ? "إدارة" : S.get('start')),
              ),
            ),
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
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool isFinished = false;

  @override
  void initState() {
    super.initState();
    questions = MockDatabase.quizzes[widget.quizId] ?? [];
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
              onPressed: () {
                setState(() {
                  questions.add({
                    'q': qCtrl.text,
                    'opts': [opt1.text, opt2.text, opt3.text, opt4.text],
                    'ans': correctOpt - 1,
                  });
                  MockDatabase.quizzes[widget.quizId] = questions;
                });
                Navigator.pop(context);
              },
              child: Text(S.get('save')),
            ),
          ],
        ),
      ),
    );
  }

  void _answerQuestion(int selectedIndex) {
    if (selectedIndex == questions[currentQuestionIndex]['ans']) score++;
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
      ),
      body: questions.isEmpty
          ? Center(
              child: Text(
                isTeacherGlobal
                    ? "لا توجد أسئلة، أضف أسئلة الآن"
                    : "الاختبار غير متاح بعد",
                style: const TextStyle(fontSize: 18),
              ),
            )
          : isFinished
          ? Center(
              child: Text(
                "${S.get('score')}: $score / ${questions.length}",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "السؤال ${currentQuestionIndex + 1}/${questions.length}",
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    questions[currentQuestionIndex]['q'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ...List.generate(
                    4,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 55),
                          alignment: Alignment.centerRight,
                        ),
                        onPressed: () => _answerQuestion(index),
                        child: Text(
                          questions[currentQuestionIndex]['opts'][index],
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
