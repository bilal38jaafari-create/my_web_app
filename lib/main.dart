import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:ui';
import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

// ==========================================
// 1. نظام الترجمة والثوابت العالمية
// ==========================================
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
      'auth_error': 'حدث خطأ أثناء المصادقة. يرجى المحاولة لاحقاً.',
      'subjects': 'المواد الدراسية',
      'lesson': 'الدرس',
      'edit_title': 'تعديل العنوان',
      'new_title': 'العنوان الجديد',
      'finish_lesson': 'إنهاء الدرس',
      'quiz_title': 'الاختبارات',
      'start': 'ابدأ الاختبار',
      'dark_mode': 'الوضع الليلي',
      'lang': 'لغة التطبيق',
      'logout': 'تسجيل الخروج',
      'support': 'التواصل مع الدعم',
      'add_lesson': 'إضافة درس جديد',
      'add_quiz': 'إضافة اختبار جديد',
      'math': 'الرياضيات',
      'physics': 'الفيزياء',
      'science': 'علوم الحياة والأرض',
      'arabic': 'اللغة العربية',
      'french': 'اللغة الفرنسية',
      'english': 'اللغة الإنجليزية',
      'history': 'التاريخ',
      'geography': 'الجغرافيا',
      'islamic': 'التربية الإسلامية',
      'philosophy': 'الفلسفة',
      'it': 'الإعلاميات',
      'chemistry': 'الكيمياء',
      'biology': 'الأحياء',
      'economics': 'الاقتصاد',
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
      'exam_file': 'ورقة الامتحان (PDF/صورة)',
      'add_exam': 'إرفاق ملف الامتحان',
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
      'quiz_title': 'Quizzes',
      'start': 'Start Quiz',
      'dark_mode': 'Dark Mode',
      'lang': 'App Language',
      'logout': 'Logout',
      'support': 'Contact Support',
      'add_lesson': 'Add New Lesson',
      'add_quiz': 'Add New Quiz',
      'math': 'Mathematics',
      'physics': 'Physics',
      'science': 'Life & Earth Sciences',
      'arabic': 'Arabic',
      'french': 'French',
      'english': 'English',
      'history': 'History',
      'geography': 'Geography',
      'islamic': 'Islamic Ed',
      'philosophy': 'Philosophy',
      'it': 'Computer Science',
      'chemistry': 'Chemistry',
      'biology': 'Biology',
      'economics': 'Economics',
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
      'exam_file': 'Exam Paper (PDF/Image)',
      'add_exam': 'Attach Exam File',
      'delete': 'Delete',
    },
  };
  static String get(String key) =>
      _data[localeNotifier.value.languageCode]?[key] ?? key;
}

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);
final ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('ar'));

bool isTeacherGlobal = false;
String currentUserEmailGlobal = '';
String currentUserNameGlobal = '';
final supabase = Supabase.instance.client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Supabase.initialize(
      url: 'https://vlyikngandsoznwzqtgp.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZseWlrbmdhbmRzb3pud3pxdGdwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzcxMTU0NTgsImV4cCI6MjA5MjY5MTQ1OH0.gLROhgs5rWvRqLVpDR5du7zMgrOsQO6HWraoXnwyBPg',
    );
  } catch (e) {
    debugPrint("Init Error: $e");
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
              fontFamily: 'Cairo'),
          darkTheme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.deepPurple,
              brightness: Brightness.dark,
              fontFamily: 'Cairo'),
          home: const AuthWrapper(),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// نظام المصادقة مع التحقق من بيانات المستخدم
// -----------------------------------------------------------------------------
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});
  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        final session = supabase.auth.currentSession;
        if (session != null) {
          return UserDataFetcher(uid: session.user.id);
        }
        return const AppleGlassLoginScreen();
      },
    );
  }
}

class UserDataFetcher extends StatelessWidget {
  final String uid;
  const UserDataFetcher({super.key, required this.uid});

  Future<Map<String, dynamic>?> _fetchUserData() async {
    try {
      return await supabase.from('users').select().eq('id', uid).maybeSingle();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        currentUserEmailGlobal = supabase.auth.currentUser?.email ?? '';
        isTeacherGlobal =
            (currentUserEmailGlobal == 'bilal38jaafari@gmail.com');

        if (snapshot.hasData && snapshot.data != null) {
          var data = snapshot.data!;
          currentUserNameGlobal =
              "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}";
        } else {
          currentUserNameGlobal =
              isTeacherGlobal ? "أستاذ بلال الجعفري" : "تلميذ";
        }
        return const MainNavigation();
      },
    );
  }
}

// -----------------------------------------------------------------------------
// واجهة تسجيل الدخول الزجاجية
// -----------------------------------------------------------------------------
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

  void _showError(String msg) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent));

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
        if (pass != _confirmPassCtrl.text.trim()) {
          _showError(S.get('pass_mismatch'));
          setState(() => isLoading = false);
          return;
        }
        final res = await supabase.auth.signUp(email: email, password: pass);
        if (res.user != null) {
          await supabase.from('users').upsert({
            'id': res.user!.id,
            'firstName': _firstNameCtrl.text.trim(),
            'lastName': _lastNameCtrl.text.trim(),
            'role': 'تلميذ',
            'email': email,
            'createdAt': DateTime.now().toIso8601String(),
          });
        }
      } else {
        await supabase.auth.signInWithPassword(email: email, password: pass);
      }
    } on AuthException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError(S.get('auth_error'));
    }
    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xFF0F2027),
                Color(0xFF203A43),
                Color(0xFF2C5364)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
          ),
          Positioned(
              top: -50,
              left: -50,
              child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.deepPurpleAccent.withOpacity(0.3))),
          Positioned(
              bottom: -50,
              right: -50,
              child: CircleAvatar(
                  radius: 120,
                  backgroundColor: Colors.tealAccent.withOpacity(0.2))),
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
                            color: Colors.white.withOpacity(0.2), width: 1.5)),
                    child: Column(
                      children: [
                        const Icon(Icons.school, size: 60, color: Colors.white),
                        const SizedBox(height: 20),
                        Text(S.get('app_title'),
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const SizedBox(height: 30),
                        if (isRegistering) ...[
                          Row(children: [
                            Expanded(
                                child: _buildGlassField(_firstNameCtrl,
                                    S.get('first_name'), Icons.person)),
                            const SizedBox(width: 10),
                            Expanded(
                                child: _buildGlassField(_lastNameCtrl,
                                    S.get('last_name'), Icons.person_outline))
                          ]),
                          const SizedBox(height: 15),
                        ],
                        _buildGlassField(
                            _emailCtrl, S.get('email'), Icons.email),
                        const SizedBox(height: 15),
                        _buildGlassField(_passCtrl, S.get('pass'), Icons.lock,
                            obscure: true),
                        if (isRegistering) ...[
                          const SizedBox(height: 15),
                          _buildGlassField(_confirmPassCtrl,
                              S.get('confirm_pass'), Icons.lock_reset,
                              obscure: true)
                        ],
                        const SizedBox(height: 30),
                        isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.white.withOpacity(0.2),
                                    foregroundColor: Colors.white,
                                    minimumSize:
                                        const Size(double.infinity, 55),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                onPressed: _submit,
                                child: Text(
                                    isRegistering
                                        ? S.get('register')
                                        : S.get('login'),
                                    style: const TextStyle(fontSize: 18))),
                        const SizedBox(height: 15),
                        TextButton(
                            onPressed: () =>
                                setState(() => isRegistering = !isRegistering),
                            child: Text(
                                isRegistering
                                    ? S.get('have_acc')
                                    : S.get('no_acc'),
                                style: const TextStyle(color: Colors.white70))),
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
      TextEditingController ctrl, String hint, IconData icon,
      {bool obscure = false}) {
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
    );
  }
}

// -----------------------------------------------------------------------------
// التنقل الرئيسي وقائمة المواد الكاملة
// -----------------------------------------------------------------------------
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
      body: [
        const LessonsGridPage(),
        const QuizzesGridPage(),
        const ProfilePage()
      ][_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.book), label: S.get('lessons')),
          NavigationDestination(
              icon: const Icon(Icons.quiz), label: S.get('quizzes')),
          NavigationDestination(
              icon: const Icon(Icons.person), label: S.get('profile')),
        ],
      ),
    );
  }
}

// قائمة المواد الـ 12 كما كانت تماماً
class SubjectData {
  final String id, nameKey;
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
  SubjectData("chemistry", "chemistry", Icons.science, Colors.cyan),
];

// -----------------------------------------------------------------------------
// واجهة الدروس (الشبكة الرئيسية)
// -----------------------------------------------------------------------------
class LessonsGridPage extends StatelessWidget {
  const LessonsGridPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(S.get('app_title'),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("مرحباً بك،",
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary)),
                Text(currentUserNameGlobal,
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2)),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15),
              itemCount: appSubjects.length,
              itemBuilder: (ctx, i) => InkWell(
                onTap: () => Navigator.push(
                    ctx,
                    MaterialPageRoute(
                        builder: (c) =>
                            SubjectLessonsPage(subject: appSubjects[i]))),
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        appSubjects[i].color,
                        appSubjects[i].color.withOpacity(0.6)
                      ], begin: Alignment.topLeft),
                      borderRadius: BorderRadius.circular(25)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(appSubjects[i].icon, size: 50, color: Colors.white),
                      const SizedBox(height: 10),
                      Text(S.get(appSubjects[i].nameKey),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// صفحة دروس المادة
// -----------------------------------------------------------------------------
class SubjectLessonsPage extends StatefulWidget {
  final SubjectData subject;
  const SubjectLessonsPage({super.key, required this.subject});
  @override
  State<SubjectLessonsPage> createState() => _SubjectLessonsPageState();
}

class _SubjectLessonsPageState extends State<SubjectLessonsPage> {
  void _editTitle(String docId, String currentTitle) {
    final ctrl = TextEditingController(text: currentTitle);
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(S.get('edit_title')),
        content: TextField(
            controller: ctrl,
            decoration: InputDecoration(labelText: S.get('new_title'))),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c), child: Text(S.get('cancel'))),
          ElevatedButton(
            onPressed: () async {
              await supabase.from('lesson_metadata').upsert({
                'id': docId,
                'subjectId': widget.subject.id,
                'custom_title': ctrl.text
              });
              if (mounted) Navigator.pop(context);
            },
            child: Text(S.get('save')),
          ),
        ],
      ),
    );
  }

  void _updateCount(int newCount) async {
    await supabase
        .from('subject_config')
        .upsert({'id': widget.subject.id, 'lesson_count': newCount});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(S.get(widget.subject.nameKey)),
          backgroundColor: widget.subject.color,
          foregroundColor: Colors.white),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase
            .from('subject_config')
            .stream(primaryKey: ['id']).eq('id', widget.subject.id),
        builder: (context, configSnap) {
          int currentCount = 15;
          if (configSnap.hasData && configSnap.data!.isNotEmpty) {
            currentCount = configSnap.data!.first['lesson_count'] ?? 15;
          }

          return StreamBuilder<List<Map<String, dynamic>>>(
            stream: supabase
                .from('lesson_metadata')
                .stream(primaryKey: ['id']).eq('subjectId', widget.subject.id),
            builder: (context, snapshot) {
              Map<String, String> customTitles = {};
              if (snapshot.hasData) {
                for (var row in snapshot.data!) {
                  customTitles[row['id']] = row['custom_title'] ?? '';
                }
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(15),
                      itemCount: currentCount,
                      itemBuilder: (ctx, index) {
                        int lessonNum = index + 1;
                        String lessonId =
                            "${widget.subject.id}_lesson_$lessonNum";
                        String displayTitle = customTitles[lessonId] ??
                            "${S.get('lesson')} $lessonNum";

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            leading: CircleAvatar(
                                backgroundColor:
                                    widget.subject.color.withOpacity(0.2),
                                child: Text("$lessonNum")),
                            title: Text(displayTitle,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            trailing: isTeacherGlobal
                                ? IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () =>
                                        _editTitle(lessonId, displayTitle))
                                : const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => LessonContentPage(
                                        lessonId: lessonId,
                                        title: displayTitle,
                                        color: widget.subject.color))),
                          ),
                        );
                      },
                    ),
                  ),
                  if (isTeacherGlobal)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      color: Colors.grey.withOpacity(0.1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.red, size: 35),
                              onPressed: () {
                                if (currentCount > 1)
                                  _updateCount(currentCount - 1);
                              }),
                          Text("الدروس: $currentCount",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          IconButton(
                              icon: const Icon(Icons.add_circle,
                                  color: Colors.green, size: 35),
                              onPressed: () => _updateCount(currentCount + 1)),
                        ],
                      ),
                    )
                ],
              );
            },
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// صفحة محتوى الدرس
// -----------------------------------------------------------------------------
class LessonContentPage extends StatefulWidget {
  final String lessonId;
  final String title;
  final Color color;
  const LessonContentPage(
      {super.key,
      required this.lessonId,
      required this.title,
      required this.color});
  @override
  State<LessonContentPage> createState() => _LessonContentPageState();
}

class _LessonContentPageState extends State<LessonContentPage> {
  bool isUploading = false;
  Future<String?> _uploadFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(withData: true);
    if (result != null) {
      setState(() => isUploading = true);
      try {
        String fileName =
            "${DateTime.now().millisecondsSinceEpoch}_${result.files.single.name}";
        String path = 'lesson_files/${widget.lessonId}/$fileName';
        if (kIsWeb) {
          await supabase.storage
              .from('jaafari_storage')
              .uploadBinary(path, result.files.single.bytes!);
        } else {
          await supabase.storage
              .from('jaafari_storage')
              .upload(path, File(result.files.single.path!));
        }
        return supabase.storage.from('jaafari_storage').getPublicUrl(path);
      } catch (e) {
        debugPrint("Upload error: $e");
      } finally {
        setState(() => isUploading = false);
      }
    }
    return null;
  }

  void _addContent() {
    final ctrl = TextEditingController();
    String type = 'text';
    showDialog(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: Text(S.get('add_content')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                  value: type,
                  items: [
                    DropdownMenuItem(
                        value: 'text', child: Text(S.get('text_type'))),
                    DropdownMenuItem(
                        value: 'file', child: Text(S.get('file_type')))
                  ],
                  onChanged: (v) => setS(() => type = v!)),
              if (type == 'text')
                TextField(
                    controller: ctrl,
                    maxLines: 3,
                    decoration: InputDecoration(labelText: S.get('content')))
              else
                isUploading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          String? url = await _uploadFile();
                          if (url != null) {
                            await supabase.from('lesson_contents').insert({
                              'lessonId': widget.lessonId,
                              'type': 'file',
                              'data': url,
                              'created_at': DateTime.now().toIso8601String()
                            });
                            if (mounted) Navigator.pop(ctx);
                          }
                        },
                        child: Text(S.get('file_type'))),
            ],
          ),
          actions: [
            if (type == 'text')
              ElevatedButton(
                  onPressed: () async {
                    await supabase.from('lesson_contents').insert({
                      'lessonId': widget.lessonId,
                      'type': 'text',
                      'data': ctrl.text,
                      'created_at': DateTime.now().toIso8601String()
                    });
                    if (mounted) Navigator.pop(ctx);
                  },
                  child: Text(S.get('save')))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: widget.color,
          foregroundColor: Colors.white),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase
            .from('lesson_contents')
            .stream(primaryKey: ['id'])
            .eq('lessonId', widget.lessonId)
            .order('created_at', ascending: true),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          var contents = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: contents.length,
            itemBuilder: (ctx, i) {
              var item = contents[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: item['type'] == 'text'
                    ? Text(item['data'], style: const TextStyle(fontSize: 18))
                    : InkWell(
                        onTap: () => launchUrl(Uri.parse(item['data'])),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              border: Border.all(color: widget.color),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Icon(Icons.file_present, color: widget.color),
                              const SizedBox(width: 10),
                              Text(S.get('open_file'))
                            ],
                          ),
                        ),
                      ),
              );
            },
          );
        },
      ),
      floatingActionButton: isTeacherGlobal
          ? FloatingActionButton(
              onPressed: _addContent, child: const Icon(Icons.add))
          : null,
    );
  }
}

// -----------------------------------------------------------------------------
// واجهة الاختبارات (الجديدة والمتطورة)
// -----------------------------------------------------------------------------
class QuizzesGridPage extends StatelessWidget {
  const QuizzesGridPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(S.get('quiz_title'),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: appSubjects.length,
        itemBuilder: (ctx, i) => Card(
          child: ListTile(
            leading: CircleAvatar(
                backgroundColor: appSubjects[i].color,
                child: Icon(appSubjects[i].icon, color: Colors.white)),
            title: Text(S.get(appSubjects[i].nameKey),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Navigator.push(
                ctx,
                MaterialPageRoute(
                    builder: (c) =>
                        SubjectQuizzesListPage(subject: appSubjects[i]))),
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
  void _updateQuizCount(int newCount) async {
    await supabase
        .from('subject_config')
        .upsert({'id': "${widget.subject.id}_quiz", 'quiz_count': newCount});
  }

  // إضافة دالة تغيير اسم الاختبار (للتحديث في جدول quiz_metadata)
  void _editQuizTitle(String quizId, String currentTitle) {
    final ctrl = TextEditingController(text: currentTitle);
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(S.get('edit_title')),
        content: TextField(
            controller: ctrl,
            decoration: InputDecoration(labelText: S.get('new_title'))),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c), child: Text(S.get('cancel'))),
          ElevatedButton(
            onPressed: () async {
              await supabase.from('quiz_metadata').upsert({
                'id': quizId,
                'subjectId': widget.subject.id,
                'custom_title': ctrl.text
              });
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
          title:
              Text("${S.get('quiz_title')} - ${S.get(widget.subject.nameKey)}"),
          backgroundColor: widget.subject.color,
          foregroundColor: Colors.white),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase
            .from('subject_config')
            .stream(primaryKey: ['id']).eq('id', "${widget.subject.id}_quiz"),
        builder: (context, configSnap) {
          int count = 15;
          if (configSnap.hasData && configSnap.data!.isNotEmpty) {
            count = configSnap.data!.first['quiz_count'] ?? 15;
          }

          // إضافة Stream آخر لجلب أسماء الاختبارات التي غيرها الأستاذ
          return StreamBuilder<List<Map<String, dynamic>>>(
            stream: supabase
                .from('quiz_metadata')
                .stream(primaryKey: ['id']).eq('subjectId', widget.subject.id),
            builder: (context, quizMetaSnap) {
              Map<String, String> customQuizTitles = {};
              if (quizMetaSnap.hasData) {
                for (var row in quizMetaSnap.data!) {
                  customQuizTitles[row['id']] = row['custom_title'] ?? '';
                }
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(15),
                      itemCount: count,
                      itemBuilder: (ctx, i) {
                        String quizId = "${widget.subject.id}_quiz_${i + 1}";
                        String displayTitle =
                            customQuizTitles[quizId] ?? "اختبار ${i + 1}";

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            leading: CircleAvatar(
                                backgroundColor:
                                    widget.subject.color.withOpacity(0.2),
                                child: Icon(Icons.quiz,
                                    color: widget.subject.color)),
                            title: Text(displayTitle,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            trailing: isTeacherGlobal
                                ? IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blueGrey),
                                    onPressed: () =>
                                        _editQuizTitle(quizId, displayTitle))
                                : const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () => Navigator.push(
                                ctx,
                                MaterialPageRoute(
                                    builder: (c) => QuizPlayArea(
                                        quizId: quizId,
                                        color: widget.subject.color,
                                        title: displayTitle))),
                          ),
                        );
                      },
                    ),
                  ),
                  if (isTeacherGlobal)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      color: Colors.grey.withOpacity(0.1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.red, size: 35),
                              onPressed: () {
                                if (count > 1) _updateQuizCount(count - 1);
                              }),
                          Text("الاختبارات: $count",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          IconButton(
                              icon: const Icon(Icons.add_circle,
                                  color: Colors.green, size: 35),
                              onPressed: () => _updateQuizCount(count + 1)),
                        ],
                      ),
                    )
                ],
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
  const QuizPlayArea(
      {super.key,
      required this.quizId,
      required this.color,
      required this.title});
  @override
  State<QuizPlayArea> createState() => _QuizPlayAreaState();
}

class _QuizPlayAreaState extends State<QuizPlayArea> {
  bool isUploadingExam = false;

  // دالة لرفع ملف الامتحان (PDF أو صورة)
  Future<void> _uploadExamPaper() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(withData: true);
    if (result != null) {
      setState(() => isUploadingExam = true);
      try {
        String fileName =
            "exam_${DateTime.now().millisecondsSinceEpoch}_${result.files.single.name}";
        String path = 'quiz_papers/${widget.quizId}/$fileName';

        if (kIsWeb) {
          await supabase.storage
              .from('jaafari_storage')
              .uploadBinary(path, result.files.single.bytes!);
        } else {
          await supabase.storage
              .from('jaafari_storage')
              .upload(path, File(result.files.single.path!));
        }

        String url =
            supabase.storage.from('jaafari_storage').getPublicUrl(path);

        // حفظ الرابط في جدول quiz_metadata
        await supabase.from('quiz_metadata').upsert({
          'id': widget.quizId,
          'exam_paper_url': url,
          'is_pdf': result.files.single.extension == 'pdf'
        });
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("خطأ: $e")));
      }
      setState(() => isUploadingExam = false);
    }
  }

  // دالة لإنشاء سؤال متعدد الخيارات QCM
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
                    decoration: InputDecoration(labelText: S.get('q_text'))),
                const SizedBox(height: 10),
                TextField(
                    controller: opt1,
                    decoration: const InputDecoration(labelText: "خيار 1")),
                TextField(
                    controller: opt2,
                    decoration: const InputDecoration(labelText: "خيار 2")),
                TextField(
                    controller: opt3,
                    decoration: const InputDecoration(labelText: "خيار 3")),
                TextField(
                    controller: opt4,
                    decoration: const InputDecoration(labelText: "خيار 4")),
                const SizedBox(height: 15),
                DropdownButton<int>(
                    value: correctOpt,
                    items: [1, 2, 3, 4]
                        .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text("الجواب الصحيح: خيار رقم $e")))
                        .toList(),
                    onChanged: (v) => setStateDialog(() => correctOpt = v!)),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(c),
                child: Text(S.get('cancel'))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: widget.color, foregroundColor: Colors.white),
              onPressed: () async {
                if (qCtrl.text.isNotEmpty && opt1.text.isNotEmpty) {
                  await supabase.from('quiz_questions').insert({
                    'quizId': widget.quizId,
                    'q': qCtrl.text,
                    'opts': [opt1.text, opt2.text, opt3.text, opt4.text],
                    'ans': correctOpt - 1, // لأن المصفوفة تبدأ من 0
                    'created_at': DateTime.now().toIso8601String()
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

  void _deleteQuestion(dynamic docId) async {
    await supabase.from('quiz_questions').delete().eq('id', docId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: widget.color,
          foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================== قسم 1: ورقة الامتحان المرفقة ==================
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: supabase
                  .from('quiz_metadata')
                  .stream(primaryKey: ['id']).eq('id', widget.quizId),
              builder: (context, metaSnap) {
                if (!metaSnap.hasData || metaSnap.data!.isEmpty) {
                  return isTeacherGlobal
                      ? Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text("لم تقم برفع ملف الامتحان بعد.",
                              style: TextStyle(color: Colors.grey[600])))
                      : const SizedBox();
                }

                var data = metaSnap.data!.first;
                if (data['exam_paper_url'] == null) return const SizedBox();

                String url = data['exam_paper_url'];
                bool isPdf = data['is_pdf'] ?? false;

                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: widget.color, width: 2)),
                  child: Column(
                    children: [
                      Text(S.get('exam_file'),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: widget.color)),
                      const SizedBox(height: 10),
                      if (!isPdf)
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(url,
                                height: 250, fit: BoxFit.cover)),
                      const SizedBox(height: 15),
                      ElevatedButton.icon(
                        onPressed: () => launchUrl(Uri.parse(url),
                            mode: LaunchMode.externalApplication),
                        icon: const Icon(Icons.open_in_new),
                        label: Text(
                            isPdf ? "تحميل وفتح ملف الـ PDF" : "تكبير الصورة"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: widget.color,
                            foregroundColor: Colors.white),
                      ),
                    ],
                  ),
                );
              },
            ),

            const Divider(thickness: 2),

            // ================== قسم 2: أسئلة الاختبار التفاعلية (QCM) ==================
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text("الأسئلة التفاعلية للاختبار:",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700])),
            ),
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: supabase
                  .from('quiz_questions')
                  .stream(primaryKey: ['id'])
                  .eq('quizId', widget.quizId)
                  .order('created_at', ascending: true),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                var questions = snapshot.data!;
                if (questions.isEmpty) {
                  return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("لا توجد أسئلة تفاعلية مضافة بعد."));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    var qData = questions[index];
                    List<dynamic> options = qData['opts'];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text("س${index + 1}: ${qData['q']}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                                if (isTeacherGlobal)
                                  IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () =>
                                          _deleteQuestion(qData['id'])),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ...List.generate(
                                options.length,
                                (i) => Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Text("- ${options[i]}",
                                          style: TextStyle(
                                              color: (isTeacherGlobal &&
                                                      i == qData['ans'])
                                                  ? Colors.green
                                                  : Colors.black,
                                              fontWeight: (isTeacherGlobal &&
                                                      i == qData['ans'])
                                                  ? FontWeight.bold
                                                  : FontWeight.normal)),
                                    )),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 80), // مسافة للأزرار العائمة
          ],
        ),
      ),
      floatingActionButton: isTeacherGlobal
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isUploadingExam)
                  const CircularProgressIndicator()
                else
                  FloatingActionButton.extended(
                      heroTag: "btn_upload_exam",
                      onPressed: _uploadExamPaper,
                      backgroundColor: Colors.amber,
                      icon: const Icon(Icons.attach_file, color: Colors.black),
                      label: const Text("إرفاق PDF/صورة",
                          style: TextStyle(color: Colors.black))),
                const SizedBox(height: 10),
                FloatingActionButton.extended(
                    heroTag: "btn_add_qcm",
                    onPressed: _addQuestionDialog,
                    backgroundColor: widget.color,
                    icon: const Icon(Icons.add_task, color: Colors.white),
                    label: Text("إضافة سؤال (QCM)",
                        style: const TextStyle(color: Colors.white))),
              ],
            )
          : null,
    );
  }
}

// -----------------------------------------------------------------------------
// صفحة الحساب الشخصي
// -----------------------------------------------------------------------------
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  void _contactSupport() async {
    final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'bilal38jaafari@gmail.com',
        queryParameters: {'subject': 'Support Jaafari Guide'});
    launchUrl(emailLaunchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.get('profile'))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Center(
              child: CircleAvatar(
                  radius: 50, child: Icon(Icons.person, size: 50))),
          const SizedBox(height: 20),
          Center(
              child: Text(currentUserNameGlobal,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold))),
          const SizedBox(height: 30),
          ListTile(
              leading: const Icon(Icons.dark_mode),
              title: Text(S.get('dark_mode')),
              trailing: Switch(
                  value: themeNotifier.value == ThemeMode.dark,
                  onChanged: (v) => themeNotifier.value =
                      v ? ThemeMode.dark : ThemeMode.light)),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(S.get('lang')),
            onTap: () => showModalBottomSheet(
                context: context,
                builder: (c) =>
                    Column(mainAxisSize: MainAxisSize.min, children: [
                      ListTile(
                          title: const Text("العربية"),
                          onTap: () {
                            localeNotifier.value = const Locale('ar');
                            Navigator.pop(context);
                          }),
                      ListTile(
                          title: const Text("English"),
                          onTap: () {
                            localeNotifier.value = const Locale('en');
                            Navigator.pop(context);
                          })
                    ])),
          ),
          ListTile(
              leading: const Icon(Icons.support_agent),
              title: Text(S.get('support')),
              onTap: _contactSupport),
          const Divider(height: 40),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(S.get('logout'),
                style: const TextStyle(color: Colors.red)),
            onTap: () => supabase.auth.signOut(),
          ),
        ],
      ),
    );
  }
}
