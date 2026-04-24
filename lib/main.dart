import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui';
import 'firebase_options.dart';
// تحتاج لإضافة url_launcher في ملف pubspec.yaml لعمل الإيميل
import 'package:url_launcher/url_launcher.dart';

// --- نظام الترجمة الموحد ---
class S {
  static const Map<String, Map<String, String>> _data = {
    'ar': {
      'app_title': 'Jaafari Guide',
      'lessons': 'الدروس',
      'quizzes': 'الاختبارات',
      'profile': 'حسابي',
      'email': 'البريد الإلكتروني',
      'pass': 'كلمة المرور',
      'login': 'تسجيل الدخول',
      'register': 'إنشاء حساب كطالب',
      'have_acc': 'لديك حساب؟ سجل الدخول',
      'no_acc': 'طالب جديد؟ أنشئ حساباً',
      'subjects': 'المواد الدراسية',
      'lesson': 'الدرس',
      'finish_lesson': 'إنهاء الدرس',
      'quiz_title': 'الاختبارات QCM',
      'start': 'ابدأ الاختبار',
      'dark_mode': 'الوضع الليلي',
      'lang': 'لغة التطبيق',
      'logout': 'تسجيل الخروج',
      'support': 'التواصل مع الدعم',
      'math': 'الرياضيات',
      'physics': 'الفيزياء',
      'science': 'العلوم',
      'arabic': 'العربية',
      'french': 'الفرنسية',
      'english': 'الإنجليزية',
      'add_q': 'إضافة سؤال',
      'q_text': 'نص السؤال',
      'opt': 'الخيار',
      'correct_opt': 'الخيار الصحيح (1-4)',
      'save': 'حفظ',
      'edit_lesson': 'تعديل محتوى الدرس',
      'content': 'المحتوى (نص/رابط)',
      'score': 'نتيجتك هي',
    },
    'en': {
      'app_title': 'Jaafari Guide',
      'lessons': 'Lessons',
      'quizzes': 'Quizzes',
      'profile': 'Profile',
      'email': 'Email',
      'pass': 'Password',
      'login': 'Login',
      'register': 'Student Register',
      'have_acc': 'Have an account? Login',
      'no_acc': 'New student? Sign Up',
      'subjects': 'Subjects',
      'lesson': 'Lesson',
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
      'add_q': 'Add Question',
      'q_text': 'Question Text',
      'opt': 'Option',
      'correct_opt': 'Correct Option (1-4)',
      'save': 'Save',
      'edit_lesson': 'Edit Lesson Content',
      'content': 'Content (Text/URL)',
      'score': 'Your Score is',
    },
    'fr': {
      'app_title': 'Guide Jaafari',
      'lessons': 'Leçons',
      'quizzes': 'Quiz',
      'profile': 'Profil',
      'email': 'E-mail',
      'pass': 'Mot de passe',
      'login': 'Connexion',
      'register': 'Inscription Étudiant',
      'have_acc': 'Déjà un compte? Connexion',
      'no_acc': 'Nouvel étudiant? S\'inscrire',
      'subjects': 'Matières',
      'lesson': 'Leçon',
      'finish_lesson': 'Terminer la leçon',
      'quiz_title': 'Quiz QCM',
      'start': 'Commencer le Quiz',
      'dark_mode': 'Mode Sombre',
      'lang': 'Langue',
      'logout': 'Déconnexion',
      'support': 'Contacter le support',
      'math': 'Mathématiques',
      'physics': 'Physique',
      'science': 'Sciences',
      'arabic': 'Arabe',
      'french': 'Français',
      'english': 'Anglais',
      'add_q': 'Ajouter Question',
      'q_text': 'Texte de la question',
      'opt': 'Option',
      'correct_opt': 'Option Correcte (1-4)',
      'save': 'Enregistrer',
      'edit_lesson': 'Modifier le contenu',
      'content': 'Contenu (Texte/Lien)',
      'score': 'Votre score est',
    },
  };
  static String get(String key) =>
      _data[localeNotifier.value.languageCode]?[key] ?? key;
}

// محركات الحالة للغة والمظهر وصلاحية الأستاذ
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
final ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('ar'));
bool isTeacher = false; // ستتغير عند تسجيل الدخول
String currentUserEmail = '';

// --- قاعدة بيانات محلية (محاكاة لضمان عمل التطبيق فوراً) ---
class MockData {
  static Map<String, String> lessonContents = {};
  static Map<String, List<Map<String, dynamic>>> quizzes = {};
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // تجاهل خطأ فايربيز للعمل محلياً إذا لم يتم إعداد الملفات
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
            colorSchemeSeed: Colors.black,
            brightness: Brightness.light,
            fontFamily: 'Cairo',
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.white,
            brightness: Brightness.dark,
            fontFamily: 'Cairo',
          ),
          home: const AppleStyleLogin(),
        ),
      ),
    );
  }
}

// --- 1. واجهة تسجيل الدخول (Apple / Modern Style) ---
class AppleStyleLogin extends StatefulWidget {
  const AppleStyleLogin({super.key});
  @override
  State<AppleStyleLogin> createState() => _AppleStyleLoginState();
}

class _AppleStyleLoginState extends State<AppleStyleLogin> {
  bool isRegistering = false;
  final _email = TextEditingController();
  final _pass = TextEditingController();

  void _loginOrRegister() {
    String email = _email.text.trim();
    String pass = _pass.text.trim();

    // التحقق الحصري من حساب الأستاذ
    if (email == 'bilal38jaafari@gmail.com' && pass == 'jaafari2008') {
      isTeacher = true;
      currentUserEmail = email;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
      return;
    }

    // تسجيل دخول الطالب (محاكاة أو فايربيز)
    if (email.isNotEmpty && pass.isNotEmpty) {
      isTeacher = false;
      currentUserEmail = email;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        children: [
          // خلفية عصرية جذابة
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1A1A1A), const Color(0xFF000000)]
                    : [const Color(0xFFE0EAFC), const Color(0xFFCFDEF3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  width: 350,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.apple,
                        size: 60,
                        color: isDark ? Colors.white : Colors.black87,
                      ), // يمكن تغييرها لشعار تطبيقك
                      const SizedBox(height: 20),
                      Text(
                        S.get('app_title'),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 30),

                      TextField(
                        controller: _email,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: S.get('email'),
                          filled: true,
                          fillColor: isDark ? Colors.black45 : Colors.white60,
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _pass,
                        obscureText: true,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: S.get('pass'),
                          filled: true,
                          fillColor: isDark ? Colors.black45 : Colors.white60,
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark
                              ? Colors.white
                              : Colors.black87,
                          foregroundColor: isDark ? Colors.black : Colors.white,
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _loginOrRegister,
                        child: Text(
                          isRegistering ? S.get('register') : S.get('login'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () =>
                            setState(() => isRegistering = !isRegistering),
                        child: Text(
                          isRegistering ? S.get('have_acc') : S.get('no_acc'),
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ),
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

// --- 2. الواجهة الرئيسية ---
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

// بيانات المواد (تعتمد على مفتاح الترجمة لتغيير الاسم فقط)
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
];

// --- 3. جهة الدروس ---
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
        elevation: 0,
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

// صفحة قائمة الدروس (تدخل لصفحة جديدة)
class SubjectLessonsPage extends StatelessWidget {
  final SubjectData subject;
  const SubjectLessonsPage({super.key, required this.subject});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.get(subject.nameKey)),
        backgroundColor: subject.color,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: 10, // 10 دروس افتراضية
        itemBuilder: (ctx, index) {
          int lessonNum = index + 1;
          String lessonId = "${subject.id}_lesson_$lessonNum";
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: subject.color.withOpacity(0.2),
                child: Text(
                  "$lessonNum",
                  style: TextStyle(
                    color: subject.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                "${S.get('lesson')} $lessonNum",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LessonContentPage(
                    lessonId: lessonId,
                    title: "${S.get('lesson')} $lessonNum",
                    color: subject.color,
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

// --- 4. صفحة محتوى الدرس (منفصلة وبها صلاحيات الأستاذ) ---
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
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
      text:
          MockData.lessonContents[widget.lessonId] ??
          "محتوى الدرس غير متوفر بعد.",
    );
  }

  void _saveContent() {
    setState(
      () => MockData.lessonContents[widget.lessonId] = _contentController.text,
    );
    Navigator.pop(context);
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(S.get('edit_lesson')),
        content: TextField(
          controller: _contentController,
          maxLines: 5,
          decoration: InputDecoration(
            labelText: S.get('content'),
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: _saveContent,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.color,
              foregroundColor: Colors.white,
            ),
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
        title: Text(widget.title),
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          MockData.lessonContents[widget.lessonId] ??
              "محتوى الدرس غير متوفر بعد.",
          style: const TextStyle(fontSize: 18),
        ),
      ),
      floatingActionButton: isTeacher
          ? FloatingActionButton.extended(
              onPressed: _showEditDialog,
              backgroundColor: widget.color,
              icon: const Icon(Icons.edit, color: Colors.white),
              label: const Text(
                "تعديل الدرس",
                style: TextStyle(color: Colors.white),
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
        itemCount: 10,
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
                child: Text(isTeacher ? "إدارة" : S.get('start')),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ساحة اللعب أو إدارة الاختبار
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
    questions = MockData.quizzes[widget.quizId] ?? [];
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
                  MockData.quizzes[widget.quizId] = questions;
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
                isTeacher
                    ? "لا توجد أسئلة، أضف أسئلة الآن"
                    : "الاختبار غير متاح بعد",
              ),
            )
          : isFinished
          ? Center(
              child: Text(
                "${S.get('score')}: $score / ${questions.length}",
                style: const TextStyle(
                  fontSize: 24,
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
                          minimumSize: const Size(double.infinity, 50),
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
      floatingActionButton: isTeacher
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
      debugPrint("Could not launch email");
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
            backgroundColor: Colors.black87,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              currentUserEmail,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              isTeacher ? "الأستاذ" : "تلميذ",
              style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
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
                  ListTile(
                    title: const Text("Français"),
                    onTap: () {
                      localeNotifier.value = const Locale('fr');
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
            onTap: () {
              isTeacher = false;
              currentUserEmail = '';
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AppleStyleLogin()),
              );
            },
          ),
        ],
      ),
    );
  }
}
