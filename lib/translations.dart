import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'ar_PS': {
      'CS->T_Text': 'كيف تريد استخدام التطبيق؟',
      'CS->S_Text': 'اختر كيف تريد استخدام التطبيق. يمكنك التبديل لاحقًا.',
      'CS->Offline_Title': 'استمر في العمل دون اتصال',
      'CS->Offline_Subtitle': 'الوصول إلى الملاحظات المحلية بدون إنترنت',
      'CS->Online_Title': 'استمر في العمل عبر الإنترنت',
      'CS->Online_Subtitle':
          'مزامنة عبر جميع الأجهزة\nيتطلب اتصال بالإنترنت\nميزة تجريبية',
      //Login Page
      'Login->Title_Text': 'اهلا بك مرة أخرى',
      'Login->Subtitle_Text': 'تسجيل الدخول لمتابعة رحلتك في الملاحظات',
      //Global Auth Variables
      'Auth->Email': 'البريد الإلكتروني',
      'Auth->Password': 'كلمة المرور',
      'Auth->Confirm_Password': 'تأكيد كلمة المرور',
      'Auth->Forgot_Password': 'نسيت كلمة المرور؟',
      'Auth->Login': 'تسجيل الدخول',
      'Auth->No_Account': 'لا تملك حساب؟ ',
      'Auth->Create_Account_Link': 'انشئ حسابًا الآن',
      'Auth->Have_Account': 'هل لديك حساب؟ ',
      'Auth->Logout': 'تسجيل الخروج',
      'Auth->Logout_Confirm_Title': 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
      //Register Page
      'Register->Title_Text': 'إنشاء حساب',
      'Register->Subtitle_Text': 'ابدأ بتنظيم ملاحظاتك اليوم',
      //Global
      'Global->Full_Name': 'الاسم الكامل',
      'Global->Create': 'انشاء',
      'Global->Cancel': 'إلغاء',
      'Global->Confirm': 'تأكيد',
      'Global->Ignore': 'تجاهل',
      'Global->Light': 'فاتح',
      'Global->Dark': 'داكن',
      'Global->Auto': 'تلقائي',
      'Global->Arabic': 'العربية',
      'Global->English': 'الإنجليزية',
      'Global->Language': 'اللغة',
      'GLobal->Save': 'حفظ',
      //Notes Page
      'Note->Add_Note': 'اضافة ملاحظة',
      'Note->Archived_Title': 'الملاحظات المؤرشفة',
      'Note->Archive_Empty_Title': 'لا توجد ملاحظات مؤرشفة',
      'Note->Archive_Guide_Text':
          'اضغط مع الاستمرار على الملاحظة للأرشفة/إلغاء الأرشفة',
      'Note->Title': 'الملاحظات',
      'Note->No_Notes_Title': 'لا توجد ملاحظات بعد',
      'Note->Guide_Text': 'اضغط على + لإنشاء ملاحظتك الأولى',
      'Note->Archive_Note': 'أرشفة الملاحظة',
      'Note->Unarchive_Note': 'إلغاء أرشفة الملاحظة',
      'Note->Archive_Confirm_Title':
          'هل أنت متأكد أنك تريد أرشفة هذه الملاحظة؟',
      'Note->Unarchive_Confirm_Title':
          'هل أنت متأكد أنك تريد إلغاء أرشفة هذه الملاحظة؟',
      'Note->Delete_Note': 'حذف الملاحظة',
      'Note->Delete_Confirm_Title': 'هل أنت متأكد أنك تريد حذف هذه الملاحظة بشكل دائم؟',
      'Note->Sort_Options_Title': 'ترتيب الملاحظات حسب',
      'Note->Sort_Options_Date_Desc': 'تاريخ الإنشاء (الأحدث أولاً)',
      'Note->Sort_Options_Date_Asc': 'تاريخ الإنشاء (الأقدم أولاً)',
      'Note->Sort_Options_Title_Asc': 'العنوان (A-Z)',
      'Note->Sort_Options_Title_Desc': 'العنوان (Z-A)',
      'Note->Sort_Options_Color_Asc': 'اللون (الأغمق أولاً)',
      'Note->Sort_Options_Color_Desc': 'اللون (الأفتح أولاً)',
      'Note->Color_Selection': 'لون الملاحظة',
      'Note->Unsaved_Changes_Title': 'هل تريد تجاهل التغييرات؟',
      'Note->Unsaved_Changes_Subtitle':
          'لديك تغييرات غير محفوظة. هل أنت متأكد أنك تريد تجاهلها؟',
      //New Note Page
      'Note->New->Page_Title': 'ملاحظة جديدة',
      'Note->New->Title': 'العنوان',
      'Note->New->Subtitle': 'ابدأ الكتابة...',
      //Edit Note Page
      'Note->Edit->Page_Title': 'تعديل الملاحظة',
      //Settings Page
      'Settings->Title_Text': 'الإعدادات',
      'Settings->Theme_Mode': 'وضع السمة',
      'Settings->Enable_Notifications': 'تمكين الإشعارات',
      //Search Variables
      'Search->Title_Text': 'نتائج البحث',
      'Search->Hint': 'ابحث في ملاحظاتك...',
      'Search->No_Results_Title': 'لا توجد تطابقات',
      'Search->No_Results_Subtitle': 'حاول استخدام كلمة مفتاحية مختلفة',
      //Snackbar Variables
      'Snackbar->Note_Deleted_Text': 'تم حذف الملاحظة',
      'Api->No_Connection': 'تعذّر الاتصال بالخادم. تحقق من الإنترنت وحاول مرة أخرى.',
      'Api->Error_Generic': 'حدث خطأ. حاول مرة أخرى.',
      'Api->Session_Expired': 'انتهت الجلسة. سجّل الدخول من جديد.',
      'Auth->Login_Failed': 'فشل تسجيل الدخول',
      'Auth->Register_Failed': 'فشل إنشاء الحساب',
      'Auth->Register_Success': 'تم إنشاء الحساب. يمكنك تسجيل الدخول الآن.',
      'Auth->Fill_Fields': 'أدخل البريد الإلكتروني وكلمة المرور.',
      'Auth->Passwords_Mismatch': 'كلمتا المرور غير متطابقتين.',
    },
    'en_US': {
      'CS->T_Text': 'How would you like to use the app?',
      'CS->S_Text': 'Choose how you want to use the app. You can switch later.',
      'CS->Offline_Title': 'Continue offline',
      'CS->Offline_Subtitle': 'Access local notes without internet',
      'CS->Online_Title': 'Continue online',
      'CS->Online_Subtitle':
        'Sync across all devices\nRequires an internet connection\nExperimental feature',
      //Login Page
      'Login->Title_Text': 'Welcome back',
      'Login->Subtitle_Text': 'Sign in to continue your notes journey',
      //Global Auth Variables
      'Auth->Email': 'Email',
      'Auth->Password': 'Password',
      'Auth->Confirm_Password': 'Confirm Password',
      'Auth->Forgot_Password': 'Forgot Password?',
      'Auth->Login': 'Log In',
      'Auth->No_Account': "Don't have an account? ",
      'Auth->Create_Account_Link': 'Create an account now',
      'Auth->Have_Account': 'Already have an account? ',
      'Auth->Logout': 'Log Out',
      'Auth->Logout_Confirm_Title': 'Are you sure you want to log out?',
      //Register Page
      'Register->Title_Text': 'Create Account',
      'Register->Subtitle_Text': 'Start organizing your notes today',
      //Global
      'Global->Full_Name': 'Full Name',
      'Global->Create': 'Create',
      'Global->Cancel': 'Cancel',
      'Global->Confirm': 'Confirm',
      'Global->Ignore': 'Ignore',
      'Global->Light': 'Light',
      'Global->Dark': 'Dark',
      'Global->Auto': 'Auto',
      'Global->Arabic': 'Arabic',
      'Global->English': 'English',
      'Global->Language': 'Language',
      'GLobal->Save': 'Save',
      //Notes Page
      'Note->Add_Note': 'Add Note',
      'Note->Archived_Title': 'Archived Notes',
      'Note->Archive_Empty_Title': 'No archived notes',
      'Note->Archive_Guide_Text':
        'Long press a note to archive/unarchive',
      'Note->Title': 'Notes',
      'Note->No_Notes_Title': 'No notes yet',
      'Note->Guide_Text': 'Tap + to create your first note',
      'Note->Archive_Note': 'Archive Note',
      'Note->Unarchive_Note': 'Unarchive Note',
      'Note->Archive_Confirm_Title':
        'Are you sure you want to archive this note?',
      'Note->Unarchive_Confirm_Title':
        'Are you sure you want to unarchive this note?',
      'Note->Delete_Note': 'Delete Note',
      'Note->Delete_Confirm_Title':
        'Are you sure you want to permanently delete this note?',
      'Note->Sort_Options_Title': 'Sort notes by',
      'Note->Sort_Options_Date_Desc': 'Creation date (newest first)',
      'Note->Sort_Options_Date_Asc': 'Creation date (oldest first)',
      'Note->Sort_Options_Title_Asc': 'Title (A-Z)',
      'Note->Sort_Options_Title_Desc': 'Title (Z-A)',
      'Note->Sort_Options_Color_Asc': 'Color (darkest first)',
      'Note->Sort_Options_Color_Desc': 'Color (lightest first)',
      'Note->Color_Selection': 'Note Color',
      'Note->Unsaved_Changes_Title': 'Discard changes?',
      'Note->Unsaved_Changes_Subtitle':
        'You have unsaved changes. Are you sure you want to discard them?',
      //New Note Page
      'Note->New->Page_Title': 'New Note',
      'Note->New->Title': 'Title',
      'Note->New->Subtitle': 'Start typing...',
      //Edit Note Page
      'Note->Edit->Page_Title': 'Edit Note',
      //Settings Page
      'Settings->Title_Text': 'Settings',
      'Settings->Theme_Mode': 'Theme Mode',
      'Settings->Enable_Notifications': 'Enable Notifications',
      //Search Variables
      'Search->Title_Text': 'Search Results',
      'Search->Hint': 'Search your notes...',
      'Search->No_Results_Title': 'No matches',
      'Search->No_Results_Subtitle': 'Try a different keyword',
      //Snackbar Variables
      'Snackbar->Note_Deleted_Text': 'Note deleted',
      'Api->No_Connection': 'Could not reach the server. Check your internet and try again.',
      'Api->Error_Generic': 'Something went wrong. Please try again.',
      'Api->Session_Expired': 'Your session expired. Please log in again.',
      'Auth->Login_Failed': 'Login failed',
      'Auth->Register_Failed': 'Could not create the account',
      'Auth->Register_Success': 'Account created. You can log in now.',
      'Auth->Fill_Fields': 'Enter your email and password.',
      'Auth->Passwords_Mismatch': 'The passwords do not match.',
    },
  };
}

/* class MyHomePage extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text('hello'.tr)),
     body: Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Text('welcome'.tr),
           ElevatedButton(
             onPressed: () => Get.updateLocale(Locale('es', 'ES')),
             child: Text('Switch to Spanish'),
           ),
         ],
       ),
     ),
   );
 }
} */
