import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import 'dart:io' show File;
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

// ==========================================
// 1. نظام الذاكرة المحلية (Cache Manager)
// ==========================================
late SharedPreferences prefs;

class CacheManager {
  static void save(String key, List<Map<String, dynamic>> data) {
    prefs.setString(key, jsonEncode(data));
  }

  static List<Map<String, dynamic>> load(String key) {
    final String? cachedStr = prefs.getString(key);
    if (cachedStr != null) {
      List<dynamic> decoded = jsonDecode(cachedStr);
      return decoded.map((e) => e as Map<String, dynamic>).toList();
    }
    return [];
  }

  static void saveString(String key, String value) {
    prefs.setString(key, value);
  }

  static String loadString(String key, {String defaultValue = ''}) {
    return prefs.getString(key) ?? defaultValue;
  }
}

// ==========================================
// 2. نظام الترجمة والثوابت العالمية
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
      'correct_opt': 'الخيار الصحيح',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'add_content': 'إضافة محتوى',
      'content_type': 'نوع المحتوى',
      'text_type': 'نص عادي',
      'file_type': 'رفع ملف (صورة، فيديو، PDF)',
      'content': 'اكتب المحتوى هنا',
      'score': 'نتيجتك هي',
      'open_file': 'فتح الملف',
      'view_pdf': 'عرض PDF',
      'uploading': 'جاري الرفع...',
      'exam_file': 'الامتحان الوطني',
      'add_exam': 'إضافة امتحان وطني',
      'delete': 'حذف',
      'confirm_delete': 'تأكيد الحذف',
      'delete_msg': 'هل أنت متأكد من أنك تريد الحذف نهائياً؟',
      'offline_msg': 'أنت الآن تتصفح بدون إنترنت. (بيانات محفوظة)',
      'welcome': 'مرحباً',
      'student': 'تلميذ',
      'teacher': 'أستاذ',
      'national_exams': 'الامتحانات الوطنية',
      'countdown': 'المتبقي على الامتحان',
      'days': 'أيام',
      'hours': 'ساعات',
      'start_quiz': 'ابدأ الاختبار',
      'your_answer': 'إجابتك',
      'submit': 'تأكيد الإجابة',
      'next': 'التالي',
      'previous': 'السابق',
      'finish': 'إنهاء',
      'correct': '✓ إجابة صحيحة',
      'wrong': '✗ إجابة خاطئة',
      'final_score': 'النتيجة النهائية',
      'out_of': 'من',
      'exam_title': 'عنوان الامتحان',
      'exam_date': 'تاريخ الامتحان',
      'add_new_exam': 'إضافة امتحان جديد',
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
      'correct_opt': 'Correct Option',
      'save': 'Save',
      'cancel': 'Cancel',
      'add_content': 'Add Content',
      'content_type': 'Content Type',
      'text_type': 'Text',
      'file_type': 'Upload File',
      'content': 'Enter text here',
      'score': 'Your Score is',
      'open_file': 'Open File',
      'view_pdf': 'View PDF',
      'uploading': 'Uploading...',
      'exam_file': 'National Exam',
      'add_exam': 'Add National Exam',
      'delete': 'Delete',
      'confirm_delete': 'Confirm Deletion',
      'delete_msg': 'Are you sure you want to delete this permanently?',
      'offline_msg': 'You are offline. Showing cached data.',
      'welcome': 'Welcome',
      'student': 'Student',
      'teacher': 'Teacher',
      'national_exams': 'National Exams',
      'countdown': 'Countdown to Exam',
      'days': 'days',
      'hours': 'hours',
      'start_quiz': 'Start Quiz',
      'your_answer': 'Your Answer',
      'submit': 'Submit',
      'next': 'Next',
      'previous': 'Previous',
      'finish': 'Finish',
      'correct': '✓ Correct!',
      'wrong': '✗ Wrong!',
      'final_score': 'Final Score',
      'out_of': 'out of',
      'exam_title': 'Exam Title',
      'exam_date': 'Exam Date',
      'add_new_exam': 'Add New Exam',
    },
    'fr': {
      'app_title': 'Jaafari Guide',
      'lessons': 'Leçons',
      'quizzes': 'Quiz',
      'profile': 'Profil',
      'email': 'Email',
      'pass': 'Mot de passe',
      'confirm_pass': 'Confirmer mot de passe',
      'first_name': 'Prénom',
      'last_name': 'Nom',
      'login': 'Connexion',
      'register': 'Inscription Élève',
      'have_acc': 'Déjà un compte? Connectez-vous',
      'no_acc': 'Nouvel élève? Inscrivez-vous',
      'pass_mismatch': 'Les mots de passe ne correspondent pas!',
      'fill_fields': 'Veuillez remplir tous les champs',
      'wrong_auth': 'Email ou mot de passe incorrect.',
      'auth_error': 'Erreur d\'authentification. Veuillez réessayer.',
      'subjects': 'Matières',
      'lesson': 'Leçon',
      'edit_title': 'Modifier titre',
      'new_title': 'Nouveau titre',
      'finish_lesson': 'Terminer leçon',
      'quiz_title': 'Quiz',
      'start': 'Commencer',
      'dark_mode': 'Mode nuit',
      'lang': 'Langue',
      'logout': 'Déconnexion',
      'support': 'Support',
      'add_lesson': 'Ajouter leçon',
      'add_quiz': 'Ajouter quiz',
      'math': 'Mathématiques',
      'physics': 'Physique',
      'science': 'SVT',
      'arabic': 'Arabe',
      'french': 'Français',
      'english': 'Anglais',
      'history': 'Histoire',
      'geography': 'Géographie',
      'islamic': 'Éducation islamique',
      'philosophy': 'Philosophie',
      'it': 'Informatique',
      'chemistry': 'Chimie',
      'biology': 'Biologie',
      'economics': 'Économie',
      'add_q': 'Ajouter question',
      'q_text': 'Texte question',
      'opt': 'Option',
      'correct_opt': 'Option correcte',
      'save': 'Enregistrer',
      'cancel': 'Annuler',
      'add_content': 'Ajouter contenu',
      'content_type': 'Type contenu',
      'text_type': 'Texte',
      'file_type': 'Fichier',
      'content': 'Texte ici',
      'score': 'Votre score',
      'open_file': 'Ouvrir fichier',
      'view_pdf': 'Voir PDF',
      'uploading': 'Téléchargement...',
      'exam_file': 'Examen National',
      'add_exam': 'Ajouter examen national',
      'delete': 'Supprimer',
      'confirm_delete': 'Confirmer suppression',
      'delete_msg': 'Êtes-vous sûr de vouloir supprimer définitivement?',
      'offline_msg': 'Mode hors ligne. Données en cache.',
      'welcome': 'Bienvenue',
      'student': 'Élève',
      'teacher': 'Professeur',
      'national_exams': 'Examens Nationaux',
      'countdown': 'Temps restant',
      'days': 'jours',
      'hours': 'heures',
      'start_quiz': 'Commencer le quiz',
      'your_answer': 'Votre réponse',
      'submit': 'Valider',
      'next': 'Suivant',
      'previous': 'Précédent',
      'finish': 'Terminer',
      'correct': '✓ Correct',
      'wrong': '✗ Incorrect',
      'final_score': 'Score final',
      'out_of': 'sur',
      'exam_title': 'Titre examen',
      'exam_date': 'Date examen',
      'add_new_exam': 'Ajouter examen',
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
String currentUserFirstNameGlobal = '';
final supabase = Supabase.instance.client;

// ==========================================
// 3. عرض PDF
// ==========================================
class PdfViewerPage extends StatefulWidget {
  final String url;
  final String title;
  const PdfViewerPage({super.key, required this.url, required this.title});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  bool isLoading = true;
  String? localPath;

  Future<void> _downloadPdf() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final fileName = widget.url.split('/').last;
      final file = File('${tempDir.path}/$fileName');

      if (await file.exists()) {
        localPath = file.path;
        if (mounted) setState(() => isLoading = false);
        return;
      }

      final response = await http.get(Uri.parse(widget.url));
      await file.writeAsBytes(response.bodyBytes);
      localPath = file.path;
    } catch (e) {
      debugPrint("PDF Download Error: $e");
    }
    if (mounted) setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _downloadPdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () async {
              await launchUrl(Uri.parse(widget.url));
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.picture_as_pdf, size: 80, color: Colors.red),
                  const SizedBox(height: 20),
                  Text("PDF: ${widget.title}",
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await launchUrl(Uri.parse(widget.url));
                    },
                    icon: const Icon(Icons.open_in_new),
                    label: Text(S.get('view_pdf')),
                  ),
                ],
              ),
            ),
    );
  }
}

// ==========================================
// 4. عرض الصورة بحجم كامل
// ==========================================
void showFullScreenImage(BuildContext context, String imageUrl) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  iconTheme: const IconThemeData(color: Colors.white),
                  elevation: 0,
                ),
                body: Center(
                  child: InteractiveViewer(
                    panEnabled: true,
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(color: Colors.white),
                      errorWidget: (context, url, error) => const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wifi_off, size: 80, color: Colors.white54),
                          SizedBox(height: 15),
                          Text("تحتاج للإنترنت لرؤية هذه الصورة للمرة الأولى",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
              )));
}

// ==========================================
// 5. التشغيل الرئيسي
// ==========================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  try {
    await Supabase.initialize(
      url: 'https://vlyikngandsoznwzqtgp.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZseWlrbmdhbmRzb3pud3pxdGdwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzcxMTU0NTgsImV4cCI6MjA5MjY5MTQ1OH0.gLROhgs5rWvRqLVpDR5du7zMgrOsQO6HWraoXnwyBPg',
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

// ==========================================
// 6. نظام توجيه الدخول وتذكر الحساب
// ==========================================
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
      final data = await supabase
          .from('users')
          .select()
          .eq('id', uid)
          .maybeSingle()
          .timeout(const Duration(seconds: 3));
      if (data != null) CacheManager.save('user_profile', [data]);
      return data;
    } catch (e) {
      final cached = CacheManager.load('user_profile');
      if (cached.isNotEmpty) return cached.first;
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
        isTeacherGlobal = (currentUserEmailGlobal.toLowerCase() ==
            'bilal38jaafari@gmail.com');

        if (snapshot.hasData && snapshot.data != null) {
          var data = snapshot.data!;
          currentUserFirstNameGlobal = data['firstName'] ?? '';
          String lastName = data['lastName'] ?? '';
          currentUserNameGlobal =
              "$currentUserFirstNameGlobal $lastName".trim();
          if (currentUserNameGlobal.isEmpty) {
            currentUserNameGlobal = currentUserFirstNameGlobal;
          }
          if (currentUserNameGlobal.isEmpty) {
            currentUserNameGlobal =
                isTeacherGlobal ? "الأستاذ بلال" : S.get('student');
          }
        } else {
          currentUserNameGlobal =
              isTeacherGlobal ? "الأستاذ بلال" : S.get('student');
          currentUserFirstNameGlobal = currentUserNameGlobal;
        }
        return const MainNavigation();
      },
    );
  }
}

// ==========================================
// 7. واجهة تسجيل الدخول الزجاجية (مختصرة)
// ==========================================
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
        String confPass = _confirmPassCtrl.text.trim();
        if (pass != confPass) {
          _showError(S.get('pass_mismatch'));
          setState(() => isLoading = false);
          return;
        }

        final AuthResponse res =
            await supabase.auth.signUp(email: email, password: pass);
        if (res.user != null) {
          await supabase.from('users').insert({
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
    } on AuthException catch (error) {
      _showError(error.message);
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
          Center(
            child: SingleChildScrollView(
              child: Card(
                elevation: 8,
                margin: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Container(
                  width: 350,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.school,
                          size: 60, color: Colors.deepPurple),
                      const SizedBox(height: 20),
                      Text(S.get('app_title'),
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Colors.deepPurple)),
                      const SizedBox(height: 30),
                      if (isRegistering) ...[
                        TextField(
                            controller: _firstNameCtrl,
                            decoration: InputDecoration(
                                labelText: S.get('first_name'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)))),
                        const SizedBox(height: 15),
                        TextField(
                            controller: _lastNameCtrl,
                            decoration: InputDecoration(
                                labelText: S.get('last_name'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)))),
                        const SizedBox(height: 15),
                      ],
                      TextField(
                          controller: _emailCtrl,
                          decoration: InputDecoration(
                              labelText: S.get('email'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)))),
                      const SizedBox(height: 15),
                      TextField(
                          controller: _passCtrl,
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: S.get('pass'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)))),
                      if (isRegistering) ...[
                        const SizedBox(height: 15),
                        TextField(
                            controller: _confirmPassCtrl,
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: S.get('confirm_pass'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)))),
                      ],
                      const SizedBox(height: 30),
                      isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 55),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onPressed: _submit,
                              child: Text(
                                  isRegistering
                                      ? S.get('register')
                                      : S.get('login'),
                                  style: const TextStyle(fontSize: 18))),
                      const SizedBox(height: 15),
                      TextButton(
                          onPressed: () => setState(() {
                                isRegistering = !isRegistering;
                                _emailCtrl.clear();
                                _passCtrl.clear();
                              }),
                          child: Text(
                              isRegistering
                                  ? S.get('have_acc')
                                  : S.get('no_acc'),
                              style:
                                  const TextStyle(color: Colors.deepPurple))),
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

// ==========================================
// 8. التنقل الرئيسي
// ==========================================
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
        destinations: const [
          NavigationDestination(icon: Icon(Icons.book), label: 'الدروس'),
          NavigationDestination(icon: Icon(Icons.quiz), label: 'الاختبارات'),
          NavigationDestination(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}

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

// ==========================================
// 9. صفحة المواد والدروس
// ==========================================
class LessonsGridPage extends StatelessWidget {
  const LessonsGridPage({super.key});

  String _getWelcomeMessage() {
    if (currentUserNameGlobal.isNotEmpty &&
        currentUserNameGlobal != S.get('student')) {
      return "${S.get('welcome')}، $currentUserNameGlobal ✨";
    }
    return "${S.get('welcome')}، ${S.get('student')} 🎓";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(S.get('app_title'),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_getWelcomeMessage(),
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary)),
                const SizedBox(height: 5),
                Text(
                    isTeacherGlobal
                        ? "ماذا تريد أن تُدرّس اليوم؟ 👨‍🏫"
                        : "اختر مادة وابدأ التعلم 🚀",
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 10),
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
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                            color: appSubjects[i].color.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5))
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(appSubjects[i].icon, size: 50, color: Colors.white),
                      const SizedBox(height: 10),
                      Text(S.get(appSubjects[i].nameKey),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          textAlign: TextAlign.center)
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
            style: ElevatedButton.styleFrom(
                backgroundColor: widget.subject.color,
                foregroundColor: Colors.white),
            onPressed: () async {
              if (ctrl.text.isNotEmpty) {
                await supabase.from('lesson_metadata').upsert({
                  'id': docId,
                  'subjectId': widget.subject.id,
                  'custom_title': ctrl.text
                });
              }
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
            var data = configSnap.data!.first;
            if (data.containsKey('lesson_count'))
              currentCount = data['lesson_count'];
          }

          return StreamBuilder<List<Map<String, dynamic>>>(
            stream: supabase
                .from('lesson_metadata')
                .stream(primaryKey: ['id']).eq('subjectId', widget.subject.id),
            builder: (context, snapshot) {
              List<Map<String, dynamic>> metaDataList = [];
              if (snapshot.hasData) {
                metaDataList = snapshot.data!;
                CacheManager.save('meta_${widget.subject.id}', metaDataList);
              } else {
                metaDataList = CacheManager.load('meta_${widget.subject.id}');
              }

              Map<String, String> customTitles = {};
              for (var row in metaDataList) {
                if (row.containsKey('custom_title'))
                  customTitles[row['id']] = row['custom_title'];
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
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            leading: CircleAvatar(
                                backgroundColor:
                                    widget.subject.color.withOpacity(0.2),
                                child: Text("$lessonNum",
                                    style: TextStyle(
                                        color: widget.subject.color,
                                        fontWeight: FontWeight.bold))),
                            title: Text(displayTitle,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            trailing: isTeacherGlobal
                                ? IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blueGrey),
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
                          Text("الدروس الحالية: $currentCount",
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

// ==========================================
// 10. صفحة محتوى الدرس
// ==========================================
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

  Future<String?> _uploadFileToSupabase() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'mp4'],
        withData: true);
    if (result != null) {
      setState(() => isUploading = true);
      try {
        String fileName =
            "${DateTime.now().millisecondsSinceEpoch}_${result.files.single.name}";
        String storagePath = 'lesson_files/${widget.lessonId}/$fileName';

        if (kIsWeb) {
          Uint8List? fileBytes = result.files.single.bytes;
          if (fileBytes != null)
            await supabase.storage
                .from('jaafari_storage')
                .uploadBinary(storagePath, fileBytes);
        } else {
          if (result.files.single.path != null) {
            File file = File(result.files.single.path!);
            await supabase.storage
                .from('jaafari_storage')
                .upload(storagePath, file);
          }
        }
        String downloadUrl =
            supabase.storage.from('jaafari_storage').getPublicUrl(storagePath);
        setState(() => isUploading = false);
        return downloadUrl;
      } catch (e) {
        setState(() => isUploading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("فشل الرفع: $e")));
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
                      value: 'text', child: Text(S.get('text_type'))),
                  DropdownMenuItem(
                      value: 'file', child: Text(S.get('file_type')))
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
                        border: const OutlineInputBorder()))
              else
                isUploading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        onPressed: () async {
                          setDialogState(() => isUploading = true);
                          String? fileUrl = await _uploadFileToSupabase();
                          setDialogState(() => isUploading = false);
                          if (fileUrl != null) {
                            await supabase.from('lesson_contents').insert({
                              'lessonId': widget.lessonId,
                              'type': 'file',
                              'data': fileUrl,
                              'created_at': DateTime.now().toIso8601String()
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
                child: Text(S.get('cancel'))),
            if (selectedType == 'text')
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: widget.color,
                    foregroundColor: Colors.white),
                onPressed: () async {
                  if (ctrl.text.isNotEmpty) {
                    await supabase.from('lesson_contents').insert({
                      'lessonId': widget.lessonId,
                      'type': 'text',
                      'data': ctrl.text,
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

  void _deleteContent(dynamic docId) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(S.get('confirm_delete'),
            style: const TextStyle(color: Colors.red)),
        content: Text(S.get('delete_msg')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c), child: Text(S.get('cancel'))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(c);
              try {
                await supabase.from('lesson_contents').delete().eq('id', docId);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم الحذف بنجاح')));
              } catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('تعذر الحذف: $e')));
              }
            },
            child: Text(S.get('delete')),
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
          foregroundColor: Colors.white),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase
            .from('lesson_contents')
            .stream(primaryKey: ['id'])
            .eq('lessonId', widget.lessonId)
            .order('created_at', ascending: true),
        builder: (context, snapshot) {
          List<Map<String, dynamic>> contents = [];

          if (snapshot.hasData) {
            contents = snapshot.data!;
            CacheManager.save('contents_${widget.lessonId}', contents);
          } else {
            contents = CacheManager.load('contents_${widget.lessonId}');
          }

          if (contents.isEmpty &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (contents.isEmpty) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("لا يوجد محتوى", style: TextStyle(fontSize: 18)),
                if (snapshot.hasError ||
                    snapshot.connectionState == ConnectionState.waiting)
                  Text(S.get('offline_msg'),
                      style: const TextStyle(color: Colors.red)),
              ],
            ));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: contents.length,
            itemBuilder: (ctx, i) {
              var block = contents[i];
              String type = block['type'];
              String data = block['data'];
              dynamic docId = block['id'];
              Widget contentWidget;
              if (type == 'file') {
                bool isImage = data.toLowerCase().contains('.png') ||
                    data.toLowerCase().contains('.jpg') ||
                    data.toLowerCase().contains('.jpeg');
                bool isPdf = data.toLowerCase().contains('.pdf');

                if (isImage) {
                  contentWidget = GestureDetector(
                    onTap: () => showFullScreenImage(context, data),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                            imageUrl: data,
                            fit: BoxFit.cover,
                            placeholder: (c, u) => Container(
                                height: 150,
                                color: Colors.grey.withOpacity(0.2),
                                child: const Center(
                                    child: CircularProgressIndicator())),
                            errorWidget: (c, e, s) => Container(
                                height: 150,
                                color: Colors.grey.withOpacity(0.2),
                                child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.wifi_off,
                                          size: 50, color: Colors.red),
                                      Text("تحتاج إنترنت لرؤية الصورة")
                                    ])))),
                  );
                } else if (isPdf) {
                  contentWidget = InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => PdfViewerPage(
                                  url: data, title: widget.title)));
                    },
                    child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                            color: widget.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: widget.color)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.picture_as_pdf,
                                  size: 35, color: Colors.red),
                              const SizedBox(width: 10),
                              Text(S.get('view_pdf'),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: widget.color,
                                      fontWeight: FontWeight.bold))
                            ])),
                  );
                } else {
                  contentWidget = InkWell(
                    onTap: () async {
                      await launchUrl(Uri.parse(data));
                    },
                    child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                            color: widget.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: widget.color)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.insert_drive_file,
                                  size: 35, color: widget.color),
                              const SizedBox(width: 10),
                              Text(S.get('open_file'),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: widget.color,
                                      fontWeight: FontWeight.bold))
                            ])),
                  );
                }
              } else {
                contentWidget = Text(data,
                    style: const TextStyle(fontSize: 18, height: 1.6));
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: isTeacherGlobal
                    ? Stack(children: [
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            child: contentWidget),
                        Positioned(
                            top: 0,
                            left: 0,
                            child: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteContent(docId)))
                      ])
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
              label: Text(S.get('add_content'),
                  style: const TextStyle(color: Colors.white)))
          : null,
    );
  }
}

// ==========================================
// 11. واجهة الاختبارات
// ==========================================
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

// ==========================================
// 12. صفحة قائمة الاختبارات
// ==========================================
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
            decoration: InputDecoration(labelText: S.get('new_title'))),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c), child: Text(S.get('cancel'))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: widget.subject.color,
                foregroundColor: Colors.white),
            onPressed: () async {
              if (ctrl.text.isNotEmpty) {
                await supabase.from('quiz_metadata').upsert({
                  'id': docId,
                  'subjectId': widget.subject.id,
                  'custom_title': ctrl.text
                });
              }
              if (mounted) Navigator.pop(context);
            },
            child: Text(S.get('save')),
          ),
        ],
      ),
    );
  }

  void _updateQuizCount(int newCount) async {
    await supabase
        .from('subject_config')
        .upsert({'id': "${widget.subject.id}_quiz", 'quiz_count': newCount});
  }

  void _deleteQuiz(String quizId) async {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(S.get('confirm_delete'),
            style: const TextStyle(color: Colors.red)),
        content: Text(S.get('delete_msg')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c), child: Text(S.get('cancel'))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(c);
              try {
                await supabase.from('quiz_metadata').delete().eq('id', quizId);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم حذف الاختبار بنجاح')));
              } catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('تعذر الحذف: $e')));
              }
            },
            child: Text(S.get('delete')),
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
          int currentCount = 15;
          if (configSnap.hasData && configSnap.data!.isNotEmpty) {
            var data = configSnap.data!.first;
            if (data.containsKey('quiz_count'))
              currentCount = data['quiz_count'];
          }

          return StreamBuilder<List<Map<String, dynamic>>>(
            stream: supabase
                .from('quiz_metadata')
                .stream(primaryKey: ['id']).eq('subjectId', widget.subject.id),
            builder: (context, snapshot) {
              List<Map<String, dynamic>> metaDataList = [];
              if (snapshot.hasData) {
                metaDataList = snapshot.data!;
                CacheManager.save(
                    'quiz_meta_${widget.subject.id}', metaDataList);
              } else {
                metaDataList =
                    CacheManager.load('quiz_meta_${widget.subject.id}');
              }

              Map<String, String> customTitles = {};
              for (var row in metaDataList) {
                if (row.containsKey('custom_title'))
                  customTitles[row['id']] = row['custom_title'];
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(15),
                      itemCount: currentCount,
                      itemBuilder: (ctx, i) {
                        int quizNum = i + 1;
                        String quizId = "${widget.subject.id}_quiz_$quizNum";
                        String displayTitle = customTitles[quizId] ??
                            "اختبار ${S.get('lesson')} $quizNum";

                        return Card(
                          child: ListTile(
                            leading:
                                const Icon(Icons.quiz, color: Colors.orange),
                            title: Text(displayTitle,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            trailing: isTeacherGlobal
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blueGrey),
                                        onPressed: () => _editQuizTitle(
                                            quizId, displayTitle),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => _deleteQuiz(quizId),
                                      ),
                                    ],
                                  )
                                : const Icon(Icons.arrow_forward_ios),
                            onTap: () => Navigator.push(
                                ctx,
                                MaterialPageRoute(
                                    builder: (_) => QuizMainPage(
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
                                if (currentCount > 1)
                                  _updateQuizCount(currentCount - 1);
                              }),
                          Text("الاختبارات الحالية: $currentCount",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          IconButton(
                              icon: const Icon(Icons.add_circle,
                                  color: Colors.green, size: 35),
                              onPressed: () =>
                                  _updateQuizCount(currentCount + 1)),
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

// ==========================================
// 13. الصفحة الرئيسية للاختبار
// ==========================================
class QuizMainPage extends StatefulWidget {
  final String quizId;
  final Color color;
  final String title;
  const QuizMainPage(
      {super.key,
      required this.quizId,
      required this.color,
      required this.title});

  @override
  State<QuizMainPage> createState() => _QuizMainPageState();
}

class _QuizMainPageState extends State<QuizMainPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: widget.color,
          foregroundColor: Colors.white,
          bottom: TabBar(
            tabs: [
              Tab(text: S.get('national_exams')),
              Tab(text: S.get('quiz_title')),
            ],
            onTap: (index) => setState(() => _selectedTab = index),
          ),
        ),
        body: IndexedStack(
          index: _selectedTab,
          children: [
            NationalExamsPage(quizId: widget.quizId, color: widget.color),
            InteractiveQuizPage(quizId: widget.quizId, color: widget.color),
          ],
        ),
        floatingActionButton: isTeacherGlobal && _selectedTab == 0
            ? FloatingActionButton.extended(
                onPressed: () => _addNationalExam(),
                backgroundColor: widget.color,
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text(S.get('add_new_exam'),
                    style: const TextStyle(color: Colors.white)),
              )
            : (isTeacherGlobal && _selectedTab == 1
                ? FloatingActionButton.extended(
                    onPressed: () => _addQuestion(),
                    backgroundColor: widget.color,
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: Text(S.get('add_q'),
                        style: const TextStyle(color: Colors.white)),
                  )
                : null),
      ),
    );
  }

  void _addNationalExam() {
    final titleCtrl = TextEditingController();
    DateTime? selectedDate;
    FilePickerResult? examFile;
    bool isUploading = false;

    showDialog(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(S.get('add_new_exam')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(labelText: S.get('exam_title')),
                ),
                const SizedBox(height: 15),
                ListTile(
                  title: Text(selectedDate == null
                      ? S.get('exam_date')
                      : DateFormat('yyyy/MM/dd').format(selectedDate!)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: ctx,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate:
                          DateTime.now().add(const Duration(days: 365 * 5)),
                    );
                    if (picked != null) {
                      setDialogState(() => selectedDate = picked);
                    }
                  },
                ),
                const SizedBox(height: 15),
                if (examFile == null)
                  ElevatedButton.icon(
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
                      );
                      if (result != null) {
                        setDialogState(() => examFile = result);
                      }
                    },
                    icon: const Icon(Icons.attach_file),
                    label: Text(S.get('exam_file')),
                  )
                else
                  Column(
                    children: [
                      Text(
                          "${S.get('exam_file')}: ${examFile!.files.single.name}"),
                      TextButton(
                        onPressed: () => setDialogState(() => examFile = null),
                        child: const Text("تغيير",
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(S.get('cancel'))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: widget.color, foregroundColor: Colors.white),
              onPressed: () async {
                if (titleCtrl.text.isEmpty ||
                    selectedDate == null ||
                    examFile == null) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(content: Text('يرجى ملء جميع الحقول')));
                  return;
                }
                setDialogState(() => isUploading = true);
                try {
                  String fileName =
                      "exam_${DateTime.now().millisecondsSinceEpoch}_${examFile!.files.single.name}";
                  String storagePath =
                      'national_exams/${widget.quizId}/$fileName';

                  if (kIsWeb) {
                    await supabase.storage.from('jaafari_storage').uploadBinary(
                        storagePath, examFile!.files.single.bytes!);
                  } else {
                    File file = File(examFile!.files.single.path!);
                    await supabase.storage
                        .from('jaafari_storage')
                        .upload(storagePath, file);
                  }
                  String downloadUrl = supabase.storage
                      .from('jaafari_storage')
                      .getPublicUrl(storagePath);

                  await supabase.from('national_exams').insert({
                    'quizId': widget.quizId,
                    'title': titleCtrl.text,
                    'exam_date': selectedDate!.toIso8601String(),
                    'file_url': downloadUrl,
                    'is_pdf': examFile!.files.single.extension == 'pdf',
                    'created_at': DateTime.now().toIso8601String(),
                  });
                  if (mounted) Navigator.pop(ctx);
                } catch (e) {
                  ScaffoldMessenger.of(ctx)
                      .showSnackBar(SnackBar(content: Text('خطأ: $e')));
                }
                setDialogState(() => isUploading = false);
              },
              child: isUploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Text(S.get('save')),
            ),
          ],
        ),
      ),
    );
  }

  void _addQuestion() {
    final qCtrl = TextEditingController();
    final opt1 = TextEditingController();
    final opt2 = TextEditingController();
    final opt3 = TextEditingController();
    final opt4 = TextEditingController();
    int correctOpt = 0;

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
                const SizedBox(height: 10),
                DropdownButton<int>(
                    value: correctOpt,
                    isExpanded: true,
                    items: [0, 1, 2, 3]
                        .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text("${S.get('correct_opt')}: ${e + 1}")))
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
                    'ans': correctOpt,
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
}

// ==========================================
// 14. صفحة الامتحانات الوطنية
// ==========================================
class NationalExamsPage extends StatefulWidget {
  final String quizId;
  final Color color;
  const NationalExamsPage(
      {super.key, required this.quizId, required this.color});

  @override
  State<NationalExamsPage> createState() => _NationalExamsPageState();
}

class _NationalExamsPageState extends State<NationalExamsPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: supabase
          .from('national_exams')
          .stream(primaryKey: ['id'])
          .eq('quizId', widget.quizId)
          .order('exam_date', ascending: true),
      builder: (context, snapshot) {
        List<Map<String, dynamic>> exams = [];
        if (snapshot.hasData) {
          exams = snapshot.data!;
          CacheManager.save('national_exams_${widget.quizId}', exams);
        } else {
          exams = CacheManager.load('national_exams_${widget.quizId}');
        }

        if (exams.isEmpty &&
            snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (exams.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.description, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 20),
                Text("لا توجد امتحانات وطنية مضافة بعد",
                    style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: exams.length,
          itemBuilder: (ctx, index) {
            var exam = exams[index];
            DateTime examDate = DateTime.parse(exam['exam_date']);
            Duration remaining = examDate.difference(DateTime.now());
            bool isExpired = remaining.isNegative;

            return Card(
              margin: const EdgeInsets.only(bottom: 15),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(exam['title'],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              Text(
                                "${S.get('exam_date')}: ${DateFormat('yyyy/MM/dd').format(examDate)}",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        if (isTeacherGlobal)
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteExam(exam['id']),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        if (!isExpired)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: widget.color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Text(S.get('countdown'),
                                    style: TextStyle(
                                        fontSize: 14, color: widget.color)),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildCountdownUnit(
                                        remaining.inDays, S.get('days')),
                                    const SizedBox(width: 15),
                                    _buildCountdownUnit(
                                        remaining.inHours.remainder(24),
                                        S.get('hours')),
                                  ],
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: const Center(
                              child: Text("✅ الامتحان قد تم!",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              bool isPdf = exam['is_pdf'] ?? false;
                              if (isPdf) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => PdfViewerPage(
                                            url: exam['file_url'],
                                            title: exam['title'])));
                              } else {
                                showFullScreenImage(context, exam['file_url']);
                              }
                            },
                            icon: Icon(exam['is_pdf'] ?? false
                                ? Icons.picture_as_pdf
                                : Icons.image),
                            label: Text(S.get('view_pdf')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.color,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCountdownUnit(int value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  void _deleteExam(String examId) async {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(S.get('confirm_delete'),
            style: const TextStyle(color: Colors.red)),
        content: Text(S.get('delete_msg')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c), child: Text(S.get('cancel'))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(c);
              try {
                await supabase.from('national_exams').delete().eq('id', examId);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم حذف الامتحان بنجاح')));
              } catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('تعذر الحذف: $e')));
              }
            },
            child: Text(S.get('delete')),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 15. صفحة الأسئلة التفاعلية
// ==========================================
class InteractiveQuizPage extends StatefulWidget {
  final String quizId;
  final Color color;
  const InteractiveQuizPage(
      {super.key, required this.quizId, required this.color});

  @override
  State<InteractiveQuizPage> createState() => _InteractiveQuizPageState();
}

class _InteractiveQuizPageState extends State<InteractiveQuizPage> {
  bool _quizStarted = false;
  int _currentQuestionIndex = 0;
  List<Map<String, dynamic>> _questions = [];
  List<int?> _userAnswers = [];
  bool _quizFinished = false;
  int _score = 0;

  @override
  Widget build(BuildContext context) {
    if (!_quizStarted && !_quizFinished) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.quiz, size: 80, color: Colors.orange),
            const SizedBox(height: 30),
            Text(S.get('quiz_title'),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text("سنجاوب على الأسئلة واحداً تلو الآخر",
                style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => _loadQuestions(),
              icon: const Icon(Icons.play_arrow),
              label: Text(S.get('start_quiz'),
                  style: const TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      );
    }

    if (_quizFinished) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, size: 80, color: Colors.amber),
            const SizedBox(height: 20),
            Text("${S.get('final_score')}: $_score/${_questions.length}",
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Text("${(_score / _questions.length * 100).toInt()}%",
                style: const TextStyle(fontSize: 20, color: Colors.grey)),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _quizStarted = false;
                  _quizFinished = false;
                  _currentQuestionIndex = 0;
                  _userAnswers.clear();
                });
              },
              icon: const Icon(Icons.replay),
              label: Text("إعادة الاختبار"),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (_questions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    var currentQ = _questions[_currentQuestionIndex];
    List<dynamic> options = currentQ['opts'];
    int? selectedAnswer = _userAnswers[_currentQuestionIndex];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions.length,
            backgroundColor: Colors.grey.shade200,
            color: widget.color,
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "سؤال ${_currentQuestionIndex + 1}/${_questions.length}",
                    style: TextStyle(
                        color: widget.color, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    currentQ['q'],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ...List.generate(options.length, (i) {
                    bool isSelected = selectedAnswer == i;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: selectedAnswer == null
                            ? () {
                                setState(() {
                                  _userAnswers[_currentQuestionIndex] = i;
                                });
                              }
                            : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? widget.color.withOpacity(0.2)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: isSelected
                                  ? widget.color
                                  : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? widget.color
                                      : Colors.grey.shade300,
                                ),
                                child: Center(
                                  child: Text(
                                    String.fromCharCode(65 + i),
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(child: Text(options[i])),
                              if (isSelected &&
                                  selectedAnswer != null &&
                                  _userAnswers[_currentQuestionIndex] != null)
                                const Icon(Icons.check_circle,
                                    color: Colors.green),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentQuestionIndex > 0)
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _currentQuestionIndex--;
                            });
                          },
                          icon: const Icon(Icons.arrow_back),
                          label: Text(S.get('previous')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                        )
                      else
                        const SizedBox(width: 80),
                      if (selectedAnswer != null)
                        ElevatedButton.icon(
                          onPressed: () {
                            if (_currentQuestionIndex ==
                                _questions.length - 1) {
                              _calculateScore();
                            } else {
                              setState(() {
                                _currentQuestionIndex++;
                              });
                            }
                          },
                          icon: Icon(
                              _currentQuestionIndex == _questions.length - 1
                                  ? Icons.check
                                  : Icons.arrow_forward),
                          label: Text(
                              _currentQuestionIndex == _questions.length - 1
                                  ? S.get('finish')
                                  : S.get('next')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.color,
                            foregroundColor: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadQuestions() async {
    try {
      final response = await supabase
          .from('quiz_questions')
          .select()
          .eq('quizId', widget.quizId)
          .order('created_at', ascending: true);

      if (mounted) {
        setState(() {
          _questions = List<Map<String, dynamic>>.from(response);
          _userAnswers = List.filled(_questions.length, null);
          _quizStarted = true;
          _currentQuestionIndex = 0;
        });
      }
    } catch (e) {
      final cached = CacheManager.load('quiz_q_${widget.quizId}');
      if (cached.isNotEmpty && mounted) {
        setState(() {
          _questions = cached;
          _userAnswers = List.filled(_questions.length, null);
          _quizStarted = true;
          _currentQuestionIndex = 0;
        });
      }
    }
  }

  void _calculateScore() {
    int correctCount = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_userAnswers[i] == _questions[i]['ans']) {
        correctCount++;
      }
    }
    setState(() {
      _score = correctCount;
      _quizFinished = true;
    });
  }
}

// ==========================================
// 16. صفحة الملف الشخصي
// ==========================================
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _contactSupport() async {
    final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'bilal38jaafari@gmail.com',
        queryParameters: {'subject': 'دعم تطبيق Jaafari Guide'});
    if (await canLaunchUrl(emailLaunchUri)) await launchUrl(emailLaunchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(S.get('profile'),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.deepPurple,
              child: Icon(Icons.person, size: 50, color: Colors.white)),
          const SizedBox(height: 15),
          Center(
              child: Text(currentUserNameGlobal,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold))),
          Center(
              child: Text(currentUserEmailGlobal,
                  style: const TextStyle(fontSize: 16, color: Colors.grey))),
          Center(
              child: Text(isTeacherGlobal ? S.get('teacher') : S.get('student'),
                  style: TextStyle(
                      color: isTeacherGlobal
                          ? Colors.redAccent
                          : Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 18))),
          const SizedBox(height: 30),
          ListTile(
              leading: const Icon(Icons.dark_mode),
              title: Text(S.get('dark_mode'),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: Switch(
                  value: themeNotifier.value == ThemeMode.dark,
                  onChanged: (v) => themeNotifier.value =
                      v ? ThemeMode.dark : ThemeMode.light)),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(S.get('lang'),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.arrow_drop_down),
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
                          }),
                      ListTile(
                          title: const Text("Français"),
                          onTap: () {
                            localeNotifier.value = const Locale('fr');
                            Navigator.pop(context);
                          }),
                    ])),
          ),
          ListTile(
              leading: const Icon(Icons.support_agent),
              title: Text(S.get('support'),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              onTap: _contactSupport),
          const Divider(height: 40),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(S.get('logout'),
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () async {
              await supabase.auth.signOut();
              isTeacherGlobal = false;
            },
          ),
        ],
      ),
    );
  }
}
