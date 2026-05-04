import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:ui';
import 'dart:io' show File;
import 'dart:typed_data';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

// ==========================================
// 1. نظام الذاكرة المحلية (Cache Manager) للأوفلاين
// ==========================================
late SharedPreferences prefs;

class CacheManager {
  static void save(String key, List<Map<String, dynamic>> data) {
    prefs.setString(key, jsonEncode(data));
  }

  static List<Map<String, dynamic>> load(String key) {
    final String? cachedStr = prefs.getString(key);
    if (cachedStr != null) {
      try {
        List<dynamic> decoded = jsonDecode(cachedStr);
        return decoded.map((e) => e as Map<String, dynamic>).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }
}

// ==========================================
// 2. القاموس الشامل (ترجمة 100% فورية)
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
      'auth_error': 'حدث خطأ أثناء المصادقة.',
      'subjects': 'المواد الدراسية',
      'lesson': 'الدرس',
      'edit_title': 'تعديل العنوان',
      'new_title': 'العنوان الجديد',
      'dark_mode': 'الوضع الليلي',
      'lang': 'لغة التطبيق',
      'logout': 'تسجيل الخروج',
      'support': 'التواصل مع الدعم (Instagram)',
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
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'delete': 'حذف',
      'offline_msg': 'أنت الآن تتصفح بدون إنترنت. (البيانات محفوظة)',
      'welcome': 'مرحباً',
      'student': 'تلميذنا الطموح',
      'teacher': 'الأستاذ بلال الجعفري',
      'exam_countdown': 'الامتحان الوطني',
      'days': 'أيام',
      'hours': 'ساعات',
      'minutes': 'دقائق',
      'seconds': 'ثواني',
      'not_set': 'لم يتم تحديد موعد الامتحان بعد.',
      'set_plan': 'تحديد خطة المادة (تاريخ الانتهاء)',
      'plan_goal': 'خطة العمل:',
      'daily_plan': 'درس يومياً للانتهاء في الموعد 🚀',
      'completed': '✔️ مكتمل',
      'mark_done': 'إنهاء وإكمال الدرس',
      'mark_undone': 'إلغاء إكمال الدرس',
      'exam_files': 'أوراق الامتحان',
      'correction_files': 'أوراق التصحيح',
      'qcm_section': 'الاختبار التفاعلي (QCM)',
      'start_quiz': 'ابدأ الاختبار التفاعلي',
      'add_exam': 'إرفاق امتحان',
      'add_correction': 'إرفاق تصحيح',
      'add_q': 'إضافة سؤال',
      'q_text': 'نص السؤال',
      'correct_opt': 'الجواب الصحيح (1-4)',
      'score_is': 'نتيجتك هي:',
      'review_mistakes': 'مراجعة الأخطاء:',
      'correct_ans': 'الجواب الصحيح:',
      'your_ans': 'إجابتك:',
      'next_q': 'السؤال التالي',
      'finish_q': 'إنهاء وتسليم',
      'success_del': 'تم الحذف بنجاح ✔️',
      'error_del': 'تعذر الحذف',
      'open_pdf': 'فتح ملف الـ PDF',
      'open_img': 'تكبير الصورة',
      'no_files': 'لا توجد ملفات مرفقة حالياً.',
      'no_qcm': 'لا توجد أسئلة تفاعلية بعد.',
      'opt1': 'الخيار 1',
      'opt2': 'الخيار 2',
      'opt3': 'الخيار 3',
      'opt4': 'الخيار 4',
      'quiz_title': 'اختبار',
      'exam_setup': 'إعداد الامتحان الوطني',
      'exam_title': 'عنوان الامتحان',
      'choose_date': 'اختر التاريخ',
      'lesson_count': 'عدد الدروس:',
      'quiz_count': 'عدد الاختبارات:',
      'uploading': 'جاري الرفع...',
      'success_upload': 'تم الرفع بنجاح',
      'ig_error': 'لا يمكن فتح تطبيق إنستغرام',
      'no_ans': 'لم تجب',
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
      'register': 'Sign Up',
      'have_acc': 'Have an account? Login',
      'no_acc': 'New student? Sign Up',
      'pass_mismatch': 'Passwords do not match!',
      'fill_fields': 'Please fill all fields',
      'wrong_auth': 'Incorrect email or password.',
      'auth_error': 'Authentication error.',
      'subjects': 'Subjects',
      'lesson': 'Lesson',
      'edit_title': 'Edit Title',
      'new_title': 'New Title',
      'dark_mode': 'Dark Mode',
      'lang': 'Language',
      'logout': 'Logout',
      'support': 'Contact Support (IG)',
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
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'offline_msg': 'You are offline (Cached data).',
      'welcome': 'Welcome',
      'student': 'Ambitious Student',
      'teacher': 'Mr. Bilal Jaafari',
      'exam_countdown': 'National Exam Countdown',
      'days': 'Days',
      'hours': 'Hours',
      'minutes': 'Mins',
      'seconds': 'Secs',
      'not_set': 'Exam date not set yet.',
      'set_plan': 'Set Subject Plan',
      'plan_goal': 'Study Plan:',
      'daily_plan': 'lessons/day to finish 🚀',
      'completed': '✔️ Completed',
      'mark_done': 'Complete Lesson',
      'mark_undone': 'Mark Incomplete',
      'exam_files': 'Exam Papers',
      'correction_files': 'Correction Papers',
      'qcm_section': 'Interactive Quiz (MCQ)',
      'start_quiz': 'Start Quiz',
      'add_exam': 'Attach Exam',
      'add_correction': 'Attach Correction',
      'add_q': 'Add Question',
      'q_text': 'Question',
      'correct_opt': 'Correct Option (1-4)',
      'score_is': 'Your Score:',
      'review_mistakes': 'Review Mistakes:',
      'correct_ans': 'Correct Answer:',
      'your_ans': 'Your Answer:',
      'next_q': 'Next Question',
      'finish_q': 'Finish & Submit',
      'success_del': 'Deleted successfully ✔️',
      'error_del': 'Failed to delete',
      'open_pdf': 'Open PDF',
      'open_img': 'View Image',
      'no_files': 'No files attached.',
      'no_qcm': 'No interactive questions.',
      'opt1': 'Option 1',
      'opt2': 'Option 2',
      'opt3': 'Option 3',
      'opt4': 'Option 4',
      'quiz_title': 'Quiz',
      'exam_setup': 'National Exam Setup',
      'exam_title': 'Exam Title',
      'choose_date': 'Choose Date',
      'lesson_count': 'Lessons Count:',
      'quiz_count': 'Quizzes Count:',
      'uploading': 'Uploading...',
      'success_upload': 'Uploaded successfully',
      'ig_error': 'Cannot open Instagram',
      'no_ans': 'No answer',
    },
    'fr': {
      'app_title': 'Jaafari Guide',
      'lessons': 'Cours',
      'quizzes': 'Quiz',
      'profile': 'Profil',
      'email': 'E-mail',
      'pass': 'Mot de passe',
      'confirm_pass': 'Confirmer le mot de passe',
      'first_name': 'Prénom',
      'last_name': 'Nom',
      'login': 'Connexion',
      'register': 'S\'inscrire',
      'have_acc': 'Déjà un compte? Connexion',
      'no_acc': 'Nouvel élève? S\'inscrire',
      'pass_mismatch': 'Les mots de passe ne correspondent pas!',
      'fill_fields': 'Veuillez remplir tous les champs',
      'wrong_auth': 'Email ou mot de passe incorrect.',
      'auth_error': 'Erreur d\'authentification.',
      'subjects': 'Matières',
      'lesson': 'Leçon',
      'edit_title': 'Modifier le titre',
      'new_title': 'Nouveau titre',
      'dark_mode': 'Mode sombre',
      'lang': 'Langue',
      'logout': 'Déconnexion',
      'support': 'Contacter le support (IG)',
      'math': 'Mathématiques',
      'physics': 'Physique',
      'science': 'SVT',
      'arabic': 'Arabe',
      'french': 'Français',
      'english': 'Anglais',
      'history': 'Histoire',
      'geography': 'Géographie',
      'islamic': 'Éducation Islamique',
      'philosophy': 'Philosophie',
      'save': 'Enregistrer',
      'cancel': 'Annuler',
      'delete': 'Supprimer',
      'offline_msg': 'Vous êtes hors ligne (Données en cache).',
      'welcome': 'Bienvenue',
      'student': 'Élève Ambitieux',
      'teacher': 'M. Bilal Jaafari',
      'exam_countdown': 'Examen National',
      'days': 'Jours',
      'hours': 'Heures',
      'minutes': 'Mins',
      'seconds': 'Secs',
      'not_set': 'Date d\'examen non fixée.',
      'set_plan': 'Planifier (Date cible)',
      'plan_goal': 'Plan d\'étude:',
      'daily_plan': 'leçons/jour pour terminer 🚀',
      'completed': '✔️ Terminé',
      'mark_done': 'Terminer la leçon',
      'mark_undone': 'Annuler',
      'exam_files': 'Sujets d\'examen',
      'correction_files': 'Corrigés',
      'qcm_section': 'Quiz Interactif (QCM)',
      'start_quiz': 'Commencer le Quiz',
      'add_exam': 'Ajouter Sujet',
      'add_correction': 'Ajouter Corrigé',
      'add_q': 'Ajouter Question',
      'q_text': 'Question',
      'correct_opt': 'Option correcte (1-4)',
      'score_is': 'Votre Score:',
      'review_mistakes': 'Revue des erreurs:',
      'correct_ans': 'Réponse correcte:',
      'your_ans': 'Votre réponse:',
      'next_q': 'Question Suivante',
      'finish_q': 'Terminer',
      'success_del': 'Supprimé avec succès ✔️',
      'error_del': 'Échec de la suppression',
      'open_pdf': 'Ouvrir le PDF',
      'open_img': 'Agrandir l\'image',
      'no_files': 'Aucun fichier joint.',
      'no_qcm': 'Aucune question interactive.',
      'opt1': 'Option 1',
      'opt2': 'Option 2',
      'opt3': 'Option 3',
      'opt4': 'Option 4',
      'quiz_title': 'Quiz',
      'exam_setup': 'Configuration de l\'examen',
      'exam_title': 'Titre de l\'examen',
      'choose_date': 'Choisir la date',
      'lesson_count': 'Nombre de leçons:',
      'quiz_count': 'Nombre de quiz:',
      'uploading': 'Téléchargement...',
      'success_upload': 'Téléchargé avec succès',
      'ig_error': 'Impossible d\'ouvrir Instagram',
      'no_ans': 'Aucune réponse',
    }
  };
  static String get(String key) =>
      _data[localeNotifier.value.languageCode]?[key] ?? key;
}

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
final ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('ar'));

bool isTeacherGlobal = false;
String currentUserEmailGlobal = '';
String currentUserNameGlobal = '';
final supabase = Supabase.instance.client;

// ==========================================
// 3. دوال مساعدة (عارض الصور والـ PDF والحذف السريع)
// ==========================================

Future<void> quickDelete(BuildContext context, String table, dynamic id) async {
  try {
    await supabase.from(table).delete().eq('id', id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.get('success_del'),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2)));
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${S.get('error_del')}: $e'),
          backgroundColor: Colors.red));
    }
  }
}

void showFullScreenImage(BuildContext context, String imageUrl) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                    backgroundColor: Colors.black,
                    elevation: 0,
                    iconTheme: const IconThemeData(color: Colors.white)),
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
                      errorWidget: (context, url, error) => const Icon(
                          Icons.wifi_off,
                          size: 80,
                          color: Colors.white54),
                    ),
                  ),
                ),
              )));
}

// ⚠️ الحل العبقري لمشكلة الشاشة البيضاء (التفريق بين الويب وتطبيق الهاتف)
class InAppPdfViewer extends StatefulWidget {
  final String pdfUrl;
  final String title;
  final Color color;

  const InAppPdfViewer(
      {super.key,
      required this.pdfUrl,
      required this.title,
      required this.color});

  @override
  State<InAppPdfViewer> createState() => _InAppPdfViewerState();
}

class _InAppPdfViewerState extends State<InAppPdfViewer> {
  Uint8List? pdfBytes;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _loadPdfMobile(); // الهاتف يحمل البيانات ليعمل بدون إنترنت
    } else {
      isLoading = false; // الويب لا يحتاج تحميل، سنعرض له زر الفتح فوراً
    }
  }

  void _loadPdfMobile() async {
    try {
      final fileInfo =
          await DefaultCacheManager().getFileFromCache(widget.pdfUrl);
      if (fileInfo != null) {
        pdfBytes = await fileInfo.file.readAsBytes();
      } else {
        File file = await DefaultCacheManager().getSingleFile(widget.pdfUrl);
        pdfBytes = await file.readAsBytes();
      }
    } catch (e) {
      debugPrint("PDF Offline Error: $e");
    }
    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => launchUrl(Uri.parse(widget.pdfUrl),
                mode: LaunchMode.externalApplication),
          )
        ],
      ),
      // ⚠️ في الويب نظهر زر الفتح المباشر، وفي الهاتف نعرض الملف داخلياً
      body: kIsWeb ? _buildWebFallback() : _buildMobileViewer(),
    );
  }

  Widget _buildMobileViewer() {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (pdfBytes != null) return SfPdfViewer.memory(pdfBytes!);
    return _buildWebFallback();
  }

  Widget _buildWebFallback() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.picture_as_pdf,
                size: 100, color: widget.color.withOpacity(0.7)),
            const SizedBox(height: 20),
            const Text(
              "لعرض هذا الملف في متصفح الويب، يرجى فتحه أو تحميله مباشرة 📥",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: widget.color,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              icon: const Icon(Icons.open_in_new, size: 28),
              label: const Text("فتح / تحميل الملف",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              onPressed: () => launchUrl(Uri.parse(widget.pdfUrl),
                  mode: LaunchMode.externalApplication),
            )
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 4. التشغيل الأساسي
// ==========================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  String? savedLang = prefs.getString('app_lang');
  if (savedLang != null) localeNotifier.value = Locale(savedLang);

  bool? isDark = prefs.getBool('is_dark');
  if (isDark != null && isDark) themeNotifier.value = ThemeMode.dark;

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
              scaffoldBackgroundColor: const Color(0xFFF4F7FA),
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
// 5. التوجيه وتحديد اسم المستخدم بدقة
// ==========================================
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        final session = supabase.auth.currentSession;
        if (session != null) return UserDataFetcher(uid: session.user.id);
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
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));

        currentUserEmailGlobal = supabase.auth.currentUser?.email ?? '';
        isTeacherGlobal = (currentUserEmailGlobal.toLowerCase() ==
            'bilal38jaafari@gmail.com');

        currentUserNameGlobal = "";
        if (snapshot.hasData && snapshot.data != null) {
          var data = snapshot.data!;
          String fName = data['firstName'] ?? '';
          String lName = data['lastName'] ?? '';
          currentUserNameGlobal = "$fName $lName".trim();
        }

        return const MainNavigation();
      },
    );
  }
}

// ==========================================
// 6. واجهة تسجيل الدخول
// ==========================================
class AppleGlassLoginScreen extends StatefulWidget {
  const AppleGlassLoginScreen({super.key});
  @override
  State<AppleGlassLoginScreen> createState() => _AppleGlassLoginScreenState();
}

class _AppleGlassLoginScreenState extends State<AppleGlassLoginScreen> {
  bool isRegistering = false, isLoading = false;
  final _emailCtrl = TextEditingController(),
      _passCtrl = TextEditingController(),
      _confirmPassCtrl = TextEditingController(),
      _firstNameCtrl = TextEditingController(),
      _lastNameCtrl = TextEditingController();

  void _showError(String msg) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent));

  Future<void> _submit() async {
    if (_emailCtrl.text.isEmpty || _passCtrl.text.isEmpty)
      return _showError(S.get('fill_fields'));
    setState(() => isLoading = true);
    try {
      if (isRegistering) {
        if (_passCtrl.text != _confirmPassCtrl.text)
          throw Exception(S.get('pass_mismatch'));
        final res = await supabase.auth.signUp(
            email: _emailCtrl.text.trim(), password: _passCtrl.text.trim());
        if (res.user != null) {
          await supabase.from('users').insert({
            'id': res.user!.id,
            'firstName': _firstNameCtrl.text.trim(),
            'lastName': _lastNameCtrl.text.trim(),
            'role': 'تلميذ',
            'email': _emailCtrl.text.trim(),
            'createdAt': DateTime.now().toIso8601String(),
          });
        }
      } else {
        await supabase.auth.signInWithPassword(
            email: _emailCtrl.text.trim(), password: _passCtrl.text.trim());
      }
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
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
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
                        border:
                            Border.all(color: Colors.white.withOpacity(0.2))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                                        const Size(double.infinity, 55)),
                                onPressed: _submit,
                                child: Text(
                                    isRegistering
                                        ? S.get('register')
                                        : S.get('login'),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))),
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
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none)));
  }
}

// ==========================================
// 7. التنقل الرئيسي (التحديث الفوري الشامل للغة)
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
    return ValueListenableBuilder<Locale>(
      valueListenable: localeNotifier,
      builder: (context, locale, child) {
        return Scaffold(
          body: IndexedStack(
            key: ValueKey(locale.languageCode),
            index: _currentIndex,
            children: [
              LessonsGridPage(key: ValueKey('home_${locale.languageCode}')),
              QuizzesGridPage(key: ValueKey('quiz_${locale.languageCode}')),
              ProfilePage(key: ValueKey('prof_${locale.languageCode}'))
            ],
          ),
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
      },
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
];

// ==========================================
// 8. الرئيسية: الترحيب والعداد المتحرك
// ==========================================
class LessonsGridPage extends StatefulWidget {
  const LessonsGridPage({super.key});
  @override
  State<LessonsGridPage> createState() => _LessonsGridPageState();
}

class _LessonsGridPageState extends State<LessonsGridPage> {
  DateTime? examDate;
  String examTitle = "";
  Timer? _timer;
  Duration remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _fetchExamConfig();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (examDate != null) {
        setState(() => remainingTime = examDate!.difference(DateTime.now()));
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchExamConfig() async {
    try {
      final res = await supabase
          .from('subject_config')
          .select()
          .eq('id', 'national_exam_config')
          .maybeSingle();
      if (mounted && res != null) {
        setState(() {
          examTitle = res['custom_title'] ?? "";
          if (res['lesson_count'] != null) {
            examDate = DateTime.fromMillisecondsSinceEpoch(res['lesson_count']);
          }
        });
      }
    } catch (e) {
      debugPrint("Error fetching exam: $e");
    }
  }

  void _setExamConfig() {
    final titleCtrl = TextEditingController(text: examTitle);
    DateTime? tempDate = examDate;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          bool isSaving = false;
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(S.get('exam_setup'),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: titleCtrl,
                    decoration:
                        InputDecoration(labelText: S.get('exam_title'))),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_month),
                  label: Text(tempDate == null
                      ? S.get('choose_date')
                      : DateFormat('yyyy-MM-dd').format(tempDate!)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white),
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: tempDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030));
                    if (picked != null) setDialogState(() => tempDate = picked);
                  },
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: isSaving ? null : () => Navigator.pop(c),
                  child: Text(S.get('cancel'),
                      style: const TextStyle(color: Colors.red))),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white),
                onPressed: isSaving
                    ? null
                    : () async {
                        if (tempDate != null) {
                          setDialogState(() => isSaving = true);
                          try {
                            await supabase.from('subject_config').upsert({
                              'id': 'national_exam_config',
                              'lesson_count': tempDate!.millisecondsSinceEpoch,
                              'custom_title': titleCtrl.text.trim()
                            });

                            _fetchExamConfig();
                            if (mounted) Navigator.pop(c);
                          } catch (e) {
                            setDialogState(() => isSaving = false);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Error: $e"),
                                backgroundColor: Colors.red));
                          }
                        }
                      },
                child: isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : Text(S.get('save')),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String displayName = currentUserNameGlobal.isNotEmpty
        ? currentUserNameGlobal
        : (isTeacherGlobal ? S.get('teacher') : S.get('student'));

    return Scaffold(
      appBar: AppBar(
          title: Text(S.get('app_title'),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            margin:
                const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 20),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF2B5876), Color(0xFF4E4376)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF4E4376).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10))
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text("${S.get('welcome')} $displayName 👋",
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    if (isTeacherGlobal)
                      IconButton(
                          icon: const Icon(Icons.settings, color: Colors.white),
                          onPressed: _setExamConfig),
                  ],
                ),
                const SizedBox(height: 20),
                Text(examTitle.isEmpty ? S.get('exam_countdown') : examTitle,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 15),
                if (examDate == null)
                  Text(S.get('not_set'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16))
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _timeBox(remainingTime.inDays.toString(), S.get('days')),
                      _timeBox((remainingTime.inHours % 24).toString(),
                          S.get('hours')),
                      _timeBox((remainingTime.inMinutes % 60).toString(),
                          S.get('minutes')),
                      _timeBox((remainingTime.inSeconds % 60).toString(),
                          S.get('seconds')),
                    ],
                  )
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(S.get('subjects'),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey))),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.05),
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
                      appSubjects[i].color.withOpacity(0.7)
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                          color: appSubjects[i].color.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4))
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(appSubjects[i].icon, size: 50, color: Colors.white),
                    const SizedBox(height: 15),
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _timeBox(String value, String label) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    color: Colors.white.withOpacity(0.5), width: 1.5),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4))
                ]),
            child: Text(value.padLeft(2, '0'),
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5))),
        const SizedBox(height: 8),
        Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                shadows: [Shadow(color: Colors.black45, blurRadius: 2)]))
      ],
    );
  }
}

// ==========================================
// 9. الدروس وميزة الخطة الذكية وأزرار (+ و -) والقلم
// ==========================================
class SubjectLessonsPage extends StatefulWidget {
  final SubjectData subject;
  const SubjectLessonsPage({super.key, required this.subject});
  @override
  State<SubjectLessonsPage> createState() => _SubjectLessonsPageState();
}

class _SubjectLessonsPageState extends State<SubjectLessonsPage> {
  DateTime? targetDate;
  int currentLessonCount = 15;
  List<String> completedLessons = [];

  @override
  void initState() {
    super.initState();
    _loadPlanner();
  }

  void _loadPlanner() {
    setState(() {
      String? dateStr = prefs.getString('planner_date_${widget.subject.id}');
      if (dateStr != null) targetDate = DateTime.tryParse(dateStr);
      completedLessons = prefs.getStringList(
              'completed_${supabase.auth.currentUser?.id}_${widget.subject.id}') ??
          [];
    });
  }

  void _setPlannerDialog() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: targetDate ?? DateTime.now().add(const Duration(days: 30)),
        firstDate: DateTime.now(),
        lastDate: DateTime(2030));
    if (picked != null) {
      setState(() {
        targetDate = picked;
        prefs.setString(
            'planner_date_${widget.subject.id}', picked.toIso8601String());
      });
    }
  }

  void _editTitleDialog(String lessonId, String currentTitle) {
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
                try {
                  await supabase.from('lesson_metadata').upsert({
                    'id': lessonId,
                    'subjectId': widget.subject.id,
                    'custom_title': ctrl.text
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
              if (mounted) Navigator.pop(context);
            },
            child: Text(S.get('save')),
          ),
        ],
      ),
    );
  }

  double _calculateDailyLessons(int totalLessons) {
    if (targetDate == null) return 0;
    int remainingDays = targetDate!.difference(DateTime.now()).inDays;
    if (remainingDays <= 0) remainingDays = 1;
    int remainingLessons = totalLessons - completedLessons.length;
    if (remainingLessons <= 0) return 0;
    return remainingLessons / remainingDays;
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
          if (configSnap.hasData && configSnap.data!.isNotEmpty) {
            currentLessonCount = configSnap.data!.first['lesson_count'] ?? 15;
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

              double dailyRequired = _calculateDailyLessons(currentLessonCount);

              return Column(
                children: [
                  if (!isTeacherGlobal)
                    Container(
                      margin: const EdgeInsets.all(15),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: widget.subject.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: widget.subject.color)),
                      child: Row(
                        children: [
                          Icon(Icons.timeline,
                              color: widget.subject.color, size: 40),
                          const SizedBox(width: 15),
                          Expanded(
                            child: targetDate != null
                                ? Text(
                                    "${S.get('plan_goal')}\n${dailyRequired.toStringAsFixed(1)} ${S.get('daily_plan')}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14))
                                : Text(S.get('set_plan'),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                          ),
                          IconButton(
                              icon: Icon(Icons.calendar_month,
                                  color: widget.subject.color),
                              onPressed: _setPlannerDialog)
                        ],
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(15),
                      itemCount: currentLessonCount,
                      itemBuilder: (ctx, index) {
                        int lessonNum = index + 1;
                        String lessonId =
                            "${widget.subject.id}_lesson_$lessonNum";
                        String displayTitle = customTitles[lessonId] ??
                            "${S.get('lesson')} $lessonNum";
                        bool isCompleted = completedLessons.contains(lessonId);

                        return Card(
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(
                                  color: isCompleted
                                      ? Colors.green
                                      : Colors.grey.withOpacity(0.3),
                                  width: isCompleted ? 2 : 1)),
                          child: ListTile(
                            leading: CircleAvatar(
                                backgroundColor: isCompleted
                                    ? Colors.green
                                    : widget.subject.color.withOpacity(0.2),
                                child: Icon(
                                    isCompleted ? Icons.check : Icons.book,
                                    color: isCompleted
                                        ? Colors.white
                                        : widget.subject.color)),
                            title: Text(displayTitle,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: isCompleted
                                        ? TextDecoration.lineThrough
                                        : null)),
                            trailing: isTeacherGlobal
                                ? IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blueGrey),
                                    onPressed: () => _editTitleDialog(
                                        lessonId, displayTitle))
                                : const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () async {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => LessonContentPage(
                                          lessonId: lessonId,
                                          title: displayTitle,
                                          color: widget.subject.color,
                                          subjectId: widget.subject.id)));
                              _loadPlanner();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  if (isTeacherGlobal)
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.red, size: 35),
                              onPressed: () async {
                                if (currentLessonCount > 1) {
                                  try {
                                    await supabase
                                        .from('subject_config')
                                        .upsert({
                                      'id': widget.subject.id,
                                      'lesson_count': currentLessonCount - 1
                                    });
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error: $e')));
                                  }
                                }
                              }),
                          Text("${S.get('lesson_count')} $currentLessonCount",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          IconButton(
                              icon: const Icon(Icons.add_circle,
                                  color: Colors.green, size: 35),
                              onPressed: () async {
                                try {
                                  await supabase.from('subject_config').upsert({
                                    'id': widget.subject.id,
                                    'lesson_count': currentLessonCount + 1
                                  });
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')));
                                }
                              }),
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
// 10. محتوى الدرس + الحذف السريع
// ==========================================
class LessonContentPage extends StatefulWidget {
  final String lessonId, title, subjectId;
  final Color color;
  const LessonContentPage(
      {super.key,
      required this.lessonId,
      required this.title,
      required this.color,
      required this.subjectId});
  @override
  State<LessonContentPage> createState() => _LessonContentPageState();
}

class _LessonContentPageState extends State<LessonContentPage> {
  bool isUploading = false;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    List<String> comp = prefs.getStringList(
            'completed_${supabase.auth.currentUser?.id}_${widget.subjectId}') ??
        [];
    isCompleted = comp.contains(widget.lessonId);
  }

  void _toggleCompletion() {
    List<String> comp = prefs.getStringList(
            'completed_${supabase.auth.currentUser?.id}_${widget.subjectId}') ??
        [];
    if (isCompleted) {
      comp.remove(widget.lessonId);
    } else {
      comp.add(widget.lessonId);
    }
    prefs.setStringList(
        'completed_${supabase.auth.currentUser?.id}_${widget.subjectId}', comp);
    setState(() => isCompleted = !isCompleted);
  }

  Future<String?> _uploadSafeFile() async {
    FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg'],
        withData: true);
    if (result != null) {
      setState(() => isUploading = true);
      try {
        String ext = result.files.single.extension ?? 'file';
        String safeName = "${DateTime.now().millisecondsSinceEpoch}_doc.$ext";
        String path = 'lesson_files/${widget.lessonId}/$safeName';

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
        setState(() => isUploading = false);
        return url;
      } catch (e) {
        setState(() => isUploading = false);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: widget.color,
          foregroundColor: Colors.white),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
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
                    snapshot.connectionState == ConnectionState.waiting)
                  return const Center(child: CircularProgressIndicator());
                if (contents.isEmpty)
                  return Center(child: Text(S.get('offline_msg')));

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: contents.length,
                  itemBuilder: (ctx, i) {
                    var block = contents[i];
                    bool isPdf =
                        block['data'].toString().toLowerCase().contains('.pdf');
                    Widget contentUI;

                    if (block['type'] == 'file') {
                      if (isPdf) {
                        contentUI = InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => InAppPdfViewer(
                                      pdfUrl: block['data'],
                                      title: widget.title,
                                      color: widget.color))),
                          child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                  color: widget.color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: widget.color)),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.picture_as_pdf,
                                        size: 35, color: Colors.red),
                                    const SizedBox(width: 10),
                                    Text(S.get('open_pdf'),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: widget.color,
                                            fontWeight: FontWeight.bold))
                                  ])),
                        );
                      } else {
                        contentUI = GestureDetector(
                            onTap: () =>
                                showFullScreenImage(context, block['data']),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                    imageUrl: block['data'],
                                    fit: BoxFit.cover)));
                      }
                    } else {
                      contentUI = Text(block['data'],
                          style: const TextStyle(fontSize: 18));
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: isTeacherGlobal
                          ? Stack(children: [
                              Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  child: contentUI),
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  child: IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () => quickDelete(context,
                                          'lesson_contents', block['id'])))
                            ])
                          : contentUI,
                    );
                  },
                );
              },
            ),
          ),
          if (!isTeacherGlobal)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    backgroundColor: isCompleted ? Colors.green : widget.color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                onPressed: _toggleCompletion,
                icon: Icon(isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked),
                label: Text(
                    isCompleted ? S.get('mark_undone') : S.get('mark_done'),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
        ],
      ),
      floatingActionButton: isTeacherGlobal
          ? FloatingActionButton(
              onPressed: () async {
                String? url = await _uploadSafeFile();
                if (url != null) {
                  await supabase.from('lesson_contents').insert({
                    'lessonId': widget.lessonId,
                    'type': 'file',
                    'data': url,
                    'created_at': DateTime.now().toIso8601String()
                  });
                }
              },
              backgroundColor: widget.color,
              child: isUploading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.add, color: Colors.white))
          : null,
    );
  }
}

// ==========================================
// 11. واجهة الاختبارات المقسمة (أزرار زيادة العدد، وحذف سريع)
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
        padding: const EdgeInsets.all(15),
        itemCount: appSubjects.length,
        itemBuilder: (ctx, i) => Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(15),
            leading: CircleAvatar(
                radius: 30,
                backgroundColor: appSubjects[i].color.withOpacity(0.2),
                child: Icon(appSubjects[i].icon,
                    color: appSubjects[i].color, size: 30)),
            title: Text(S.get(appSubjects[i].nameKey),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            trailing: const Icon(Icons.arrow_forward_ios),
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
            style: ElevatedButton.styleFrom(
                backgroundColor: widget.subject.color,
                foregroundColor: Colors.white),
            onPressed: () async {
              if (ctrl.text.isNotEmpty) {
                try {
                  await supabase.from('quiz_metadata').upsert({
                    'id': quizId,
                    'subjectId': widget.subject.id,
                    'custom_title': ctrl.text
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Error: $e')));
                }
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
          title:
              Text("${S.get('quiz_title')} - ${S.get(widget.subject.nameKey)}"),
          backgroundColor: widget.subject.color,
          foregroundColor: Colors.white),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase
            .from('subject_config')
            .stream(primaryKey: ['id']).eq('id', "${widget.subject.id}_quiz"),
        builder: (context, configSnap) {
          int currentCount = configSnap.hasData && configSnap.data!.isNotEmpty
              ? configSnap.data!.first['lesson_count'] ?? 10
              : 10;

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
                        String quizId = "${widget.subject.id}_quiz_${i + 1}";
                        String displayTitle = customTitles[quizId] ??
                            "${S.get('quiz_title')} ${i + 1}";
                        return Card(
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(
                                  color:
                                      widget.subject.color.withOpacity(0.3))),
                          child: ListTile(
                            leading: const Icon(Icons.assignment,
                                color: Colors.orange, size: 30),
                            title: Text(displayTitle,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            trailing: isTeacherGlobal
                                ? IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blueGrey),
                                    onPressed: () =>
                                        _editQuizTitle(quizId, displayTitle))
                                : const Icon(Icons.play_circle_fill,
                                    color: Colors.green, size: 35),
                            onTap: () => Navigator.push(
                                ctx,
                                MaterialPageRoute(
                                    builder: (_) => QuizPlayArea(
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
                      color: Colors.white,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.red, size: 35),
                              onPressed: () async {
                                if (currentCount > 1) {
                                  try {
                                    await supabase
                                        .from('subject_config')
                                        .upsert({
                                      'id': "${widget.subject.id}_quiz",
                                      'lesson_count': currentCount - 1
                                    });
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error: $e')));
                                  }
                                }
                              }),
                          Text("${S.get('quiz_count')} $currentCount",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          IconButton(
                              icon: const Icon(Icons.add_circle,
                                  color: Colors.green, size: 35),
                              onPressed: () async {
                                try {
                                  await supabase.from('subject_config').upsert({
                                    'id': "${widget.subject.id}_quiz",
                                    'lesson_count': currentCount + 1
                                  });
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')));
                                }
                              }),
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
  bool isUploading = false;

  Future<void> _uploadDocument(String fileType) async {
    FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg'],
        withData: true);
    if (result != null) {
      setState(() => isUploading = true);
      try {
        String ext = result.files.single.extension ?? 'pdf';
        String path =
            'quizzes/${widget.quizId}/${DateTime.now().millisecondsSinceEpoch}.$ext';
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

        await supabase.from('lesson_contents').insert({
          'lessonId': widget.quizId,
          'type': fileType,
          'data': url,
          'created_at': DateTime.now().toIso8601String()
        });
      } catch (e) {}
      setState(() => isUploading = false);
    }
  }

  void _addQcmQuestion() {
    final qCtrl = TextEditingController(),
        o1 = TextEditingController(),
        o2 = TextEditingController(),
        o3 = TextEditingController(),
        o4 = TextEditingController();
    int correctOpt = 1;
    showDialog(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: Text(S.get('add_q')),
          content: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                controller: qCtrl,
                decoration: InputDecoration(labelText: S.get('q_text'))),
            TextField(
                controller: o1,
                decoration: InputDecoration(labelText: S.get('opt1'))),
            TextField(
                controller: o2,
                decoration: InputDecoration(labelText: S.get('opt2'))),
            TextField(
                controller: o3,
                decoration: InputDecoration(labelText: S.get('opt3'))),
            TextField(
                controller: o4,
                decoration: InputDecoration(labelText: S.get('opt4'))),
            DropdownButton<int>(
                value: correctOpt,
                items: [1, 2, 3, 4]
                    .map((e) => DropdownMenuItem(
                        value: e, child: Text("${S.get('correct_opt')}: $e")))
                    .toList(),
                onChanged: (v) => setD(() => correctOpt = v!))
          ])),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  if (qCtrl.text.isNotEmpty && o1.text.isNotEmpty) {
                    try {
                      await supabase.from('quiz_questions').insert({
                        'quizId': widget.quizId,
                        'q': qCtrl.text,
                        'opts': [o1.text, o2.text, o3.text, o4.text],
                        'ans': correctOpt - 1,
                        'created_at': DateTime.now().toIso8601String()
                      });
                      if (mounted) Navigator.pop(c);
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  }
                },
                child: Text(S.get('save')))
          ],
        ),
      ),
    );
  }

  Widget _buildFilesSection(
      List<Map<String, dynamic>> files, String sectionTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.all(15),
            child: Text(sectionTitle,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold))),
        if (files.isEmpty)
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(S.get('no_files'),
                  style: const TextStyle(color: Colors.grey))),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemCount: files.length,
          itemBuilder: (ctx, i) {
            bool isPdf = files[i]['data'].toString().contains('.pdf');
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: widget.color.withOpacity(0.5))),
              child: ListTile(
                leading: Icon(isPdf ? Icons.picture_as_pdf : Icons.image,
                    color: isPdf ? Colors.red : Colors.blue, size: 40),
                title: Text(isPdf ? S.get('open_pdf') : S.get('open_img'),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: isTeacherGlobal
                    ? IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => quickDelete(
                            context, 'lesson_contents', files[i]['id']))
                    : null,
                onTap: () {
                  if (isPdf) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => InAppPdfViewer(
                                pdfUrl: files[i]['data'],
                                title: sectionTitle,
                                color: widget.color)));
                  } else {
                    showFullScreenImage(context, files[i]['data']);
                  }
                },
              ),
            );
          },
        ),
      ],
    );
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: supabase
                  .from('lesson_contents')
                  .stream(primaryKey: ['id'])
                  .eq('lessonId', widget.quizId)
                  .order('created_at'),
              builder: (context, snapshot) {
                List<Map<String, dynamic>> data = [];
                if (snapshot.hasData) {
                  data = snapshot.data!;
                  CacheManager.save('quiz_contents_${widget.quizId}', data);
                } else {
                  data = CacheManager.load('quiz_contents_${widget.quizId}');
                }

                var examFiles =
                    data.where((item) => item['type'] == 'exam_file').toList();
                var correctionFiles = data
                    .where((item) => item['type'] == 'correction_file')
                    .toList();

                return Column(
                  children: [
                    _buildFilesSection(examFiles, S.get('exam_files')),
                    const Divider(thickness: 2),
                    _buildFilesSection(
                        correctionFiles, S.get('correction_files')),
                  ],
                );
              },
            ),
            const Divider(thickness: 2),
            Padding(
                padding: const EdgeInsets.all(15),
                child: Text(S.get('qcm_section'),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold))),
            if (!isTeacherGlobal)
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: widget.color,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => InteractiveQuizScreen(
                              quizId: widget.quizId,
                              title: widget.title,
                              themeColor: widget.color))),
                  icon: const Icon(Icons.touch_app, size: 25),
                  label: Text(S.get('start_quiz'),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            if (isTeacherGlobal)
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: supabase
                    .from('quiz_questions')
                    .stream(primaryKey: ['id'])
                    .eq('quizId', widget.quizId)
                    .order('created_at'),
                builder: (context, snapshot) {
                  List<Map<String, dynamic>> qData = [];
                  if (snapshot.hasData) {
                    qData = snapshot.data!;
                    CacheManager.save('quiz_q_${widget.quizId}', qData);
                  } else {
                    qData = CacheManager.load('quiz_q_${widget.quizId}');
                  }

                  if (qData.isEmpty)
                    return Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(S.get('no_qcm'),
                            style: const TextStyle(color: Colors.grey)));
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: qData.length,
                    itemBuilder: (ctx, i) => ListTile(
                        title: Text(qData[i]['q']),
                        trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => quickDelete(
                                context, 'quiz_questions', qData[i]['id']))),
                  );
                },
              )
          ],
        ),
      ),
      floatingActionButton: isTeacherGlobal
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isUploading) const CircularProgressIndicator(),
                FloatingActionButton.extended(
                    heroTag: 'f1',
                    onPressed: () => _uploadDocument('exam_file'),
                    backgroundColor: Colors.amber,
                    icon: const Icon(Icons.upload_file, color: Colors.black),
                    label: Text(S.get('add_exam'),
                        style: const TextStyle(color: Colors.black))),
                const SizedBox(height: 10),
                FloatingActionButton.extended(
                    heroTag: 'f2',
                    onPressed: () => _uploadDocument('correction_file'),
                    backgroundColor: Colors.lightGreen,
                    icon: const Icon(Icons.check_circle),
                    label: Text(S.get('add_correction'))),
                const SizedBox(height: 10),
                FloatingActionButton.extended(
                    heroTag: 'f3',
                    onPressed: _addQcmQuestion,
                    backgroundColor: widget.color,
                    icon: const Icon(Icons.add_task),
                    label: Text(S.get('add_q'))),
              ],
            )
          : null,
    );
  }
}

class InteractiveQuizScreen extends StatefulWidget {
  final String quizId;
  final String title;
  final Color themeColor;
  const InteractiveQuizScreen(
      {super.key,
      required this.quizId,
      required this.title,
      required this.themeColor});
  @override
  State<InteractiveQuizScreen> createState() => _InteractiveQuizScreenState();
}

class _InteractiveQuizScreenState extends State<InteractiveQuizScreen> {
  List<Map<String, dynamic>> questionsList = [];
  Map<int, int> studentAnswers = {};
  int currentQIndex = 0;
  bool isFinished = false, isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  void _fetchQuestions() async {
    try {
      final res = await supabase
          .from('quiz_questions')
          .select()
          .eq('quizId', widget.quizId)
          .order('created_at');
      CacheManager.save('interactive_q_${widget.quizId}', res);
      setState(() {
        questionsList = List<Map<String, dynamic>>.from(res);
        isLoading = false;
      });
    } catch (e) {
      var cached = CacheManager.load('interactive_q_${widget.quizId}');
      setState(() {
        questionsList = cached;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading)
      return Scaffold(
          appBar: AppBar(
              title: Text(widget.title), backgroundColor: widget.themeColor),
          body: const Center(child: CircularProgressIndicator()));
    if (questionsList.isEmpty)
      return Scaffold(
          appBar: AppBar(
              title: Text(widget.title), backgroundColor: widget.themeColor),
          body: Center(child: Text(S.get('no_qcm'))));

    if (isFinished) {
      int score = 0;
      for (int i = 0; i < questionsList.length; i++)
        if (studentAnswers[i] == questionsList[i]['ans']) score++;
      return Scaffold(
        appBar: AppBar(
            title: Text(S.get('score_is')),
            backgroundColor: widget.themeColor,
            foregroundColor: Colors.white),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
                child: Text("$score / ${questionsList.length}",
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: score > questionsList.length / 2
                            ? Colors.green
                            : Colors.red))),
            const SizedBox(height: 20),
            Text(S.get('review_mistakes'),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...List.generate(questionsList.length, (i) {
              var qData = questionsList[i];
              bool isCorrect = studentAnswers[i] == qData['ans'];
              return Card(
                color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                        color: isCorrect ? Colors.green : Colors.red)),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("س${i + 1}: ${qData['q']}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text(
                            "${S.get('your_ans')} ${studentAnswers[i] == null ? S.get('no_ans') : qData['opts'][studentAnswers[i]]}",
                            style: TextStyle(
                                color: isCorrect ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold)),
                        if (!isCorrect)
                          Text(
                              "${S.get('correct_ans')} ${qData['opts'][qData['ans']]}",
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)),
                      ]),
                ),
              );
            })
          ],
        ),
      );
    }

    var currentQ = questionsList[currentQIndex];
    return Scaffold(
      appBar: AppBar(
          title: Text("سؤال ${currentQIndex + 1} / ${questionsList.length}"),
          backgroundColor: widget.themeColor,
          foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
                value: (currentQIndex + 1) / questionsList.length,
                backgroundColor: Colors.grey.shade300,
                color: widget.themeColor,
                minHeight: 8),
            const SizedBox(height: 30),
            Text(currentQ['q'],
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            ...List.generate(currentQ['opts'].length, (i) {
              bool isSelected = studentAnswers[currentQIndex] == i;
              return InkWell(
                onTap: () => setState(() => studentAnswers[currentQIndex] = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: isSelected
                          ? widget.themeColor.withOpacity(0.2)
                          : Colors.white,
                      border: Border.all(
                          color: isSelected
                              ? widget.themeColor
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1),
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(currentQ['opts'][i],
                      style: TextStyle(
                          fontSize: 18,
                          color: isSelected ? widget.themeColor : Colors.black,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal)),
                ),
              );
            }),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: widget.themeColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                onPressed: () {
                  if (currentQIndex < questionsList.length - 1) {
                    setState(() => currentQIndex++);
                  } else {
                    setState(() => isFinished = true);
                  }
                },
                child: Text(
                    currentQIndex < questionsList.length - 1
                        ? S.get('next_q')
                        : S.get('finish_q'),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 12. صفحة الملف الشخصي والدعم (Instagram) وتعدد اللغات الفوري
// ==========================================
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _changeLanguage(String code) {
    localeNotifier.value =
        Locale(code); // ⚠️ هذا السطر يغيّر التطبيق بأكمله فوراً وفي لحظتها
    prefs.setString('app_lang', code);
  }

  void _contactInstagram() async {
    final Uri url = Uri.parse('https://www.instagram.com/j._.billal');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(S.get('ig_error'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayName = currentUserNameGlobal.isNotEmpty
        ? currentUserNameGlobal
        : (isTeacherGlobal ? S.get('teacher') : S.get('student'));

    return Scaffold(
      appBar: AppBar(
          title: Text(S.get('profile'),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5))
                ]),
            child: Column(
              children: [
                const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.person, size: 50, color: Colors.white)),
                const SizedBox(height: 15),
                Text(displayName,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                Text(currentUserEmailGlobal,
                    style: const TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.grey.withOpacity(0.2))),
            child: Column(
              children: [
                ListTile(
                    leading: const Icon(Icons.dark_mode, color: Colors.indigo),
                    title: Text(S.get('dark_mode'),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Switch(
                        value: themeNotifier.value == ThemeMode.dark,
                        onChanged: (v) {
                          themeNotifier.value =
                              v ? ThemeMode.dark : ThemeMode.light;
                          prefs.setBool('is_dark', v);
                        })),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language, color: Colors.teal),
                  title: Text(S.get('lang'),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.arrow_drop_down),
                  onTap: () => showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      builder: (c) => Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                      "اختر اللغة / Select Language / Choisir la langue",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  const SizedBox(height: 20),
                                  ListTile(
                                      title: const Text("العربية 🇸🇦"),
                                      onTap: () {
                                        _changeLanguage('ar');
                                        Navigator.pop(context);
                                      }),
                                  ListTile(
                                      title: const Text("English 🇬🇧"),
                                      onTap: () {
                                        _changeLanguage('en');
                                        Navigator.pop(context);
                                      }),
                                  ListTile(
                                      title: const Text("Français 🇫🇷"),
                                      onTap: () {
                                        _changeLanguage('fr');
                                        Navigator.pop(context);
                                      })
                                ]),
                          )),
                ),
                const Divider(height: 1),
                ListTile(
                    leading: const Icon(Icons.camera_alt_outlined,
                        color: Colors.purpleAccent),
                    title: Text(S.get('support'),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    onTap: _contactInstagram),
                const Divider(height: 1),
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
          )
        ],
      ),
    );
  }
}
