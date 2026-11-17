---
course: "الذكاء الاصطناعي للعاملين في الأمن وعمليات تقنية المعلومات"
code: "USE-PRO-212"
version: "2027.1.0"
lab: "2.1"
language: "ar"
view: "trainee"
source: "https://sdaiaacademy.github.io/use-pro-212/labs/D2_1_scripts.html"
---

# المختبر 2.1 · مراجعة أربعة برامج نصية وفحصها آليًا وتشغيلها تشغيلًا جافًا

المساعد معلّم يشرح الأوامر ولا يحكم على البرامج: تقرأ أربعة برامج نصية ولّدها المساعد لإدارة خوادم المجموعة، وتشغّل عليها الفحص الآلي، ثم التشغيل الجاف في نسخة مؤقتة، وتخرج بسجل مراجعة وببرنامج مصحَّح يجتاز الفحص والتشغيل الجاف.

اليوم 2 · الجلسة 1: فحص البرامج النصية المولَّدة قبل تشغيلها

### ستخرج من هذا المختبر بـ

- سجل مراجعة للبرامج الأربعة: ما توقعته، وما قاله الفحص الآلي، وما فعله التشغيل الجاف، وحكمك.
- برنامج مصحَّح يجتاز الفحص الآلي دون تحذير، ويجتاز التشغيل الجاف دون أن يفقد ملفًا محميًا.

## ما تحتاجه

[**scripts/drop_hotel_sessions.sh**يخرج كل جلسات فندق واحد من فهرس الجلسات.](https://sdaiaacademy.github.io/use-pro-212/labs/files/scripts/drop_hotel_sessions.sh) [**scripts/purge_backups.sh**يحذف النسخ الاحتياطية الأقدم من 30 يومًا.](https://sdaiaacademy.github.io/use-pro-212/labs/files/scripts/purge_backups.sh) [**scripts/lock_stale_accounts.sh**يقفل حسابات الموظفين التي لم تدخل منذ 90 يومًا.](https://sdaiaacademy.github.io/use-pro-212/labs/files/scripts/lock_stale_accounts.sh) [**scripts/rotate_logs.sh**يضغط السجلات المدوَّرة لنظام الحجوزات.](https://sdaiaacademy.github.io/use-pro-212/labs/files/scripts/rotate_logs.sh) [**scripts/tutor_explanation_purge.md**شرح مسجَّل من المعلّم لسطر في أحد البرامج.](https://sdaiaacademy.github.io/use-pro-212/labs/files/scripts/tutor_explanation_purge.md) [**kit/dryrun.sh**التشغيل الجاف: يشغّل البرنامج في نسخة مؤقتة من الخادم ويقول ما حذف وما غيّر.](https://sdaiaacademy.github.io/use-pro-212/labs/files/kit/dryrun.sh) [**kit/lint.sh**الفحص الآلي بـ ShellCheck، أو عبر uv إن لم يكن مثبتًا.](https://sdaiaacademy.github.io/use-pro-212/labs/files/kit/lint.sh)

سياسة الذكاء الاصطناعي: **المساعد معلّم**. يشرح الأوامر ولا يحكم على البرامج ولا يسمّي أخطاءها. الحكم لك. لا تشغّل أي برنامج من الأربعة إلا عبر `dryrun.sh`. الأوامر من مجلد `labs`.

## الخطوات

### 1 · اقرأ البرامج الأربعة واكتب ما تتوقع أن يفعله كل منها 10 دقائق

اقرأ كل برنامج سطرًا سطرًا قبل أي أداة. اكتب لكل برنامج: ما الملفات التي يكتب فيها أو يحذفها؟ ماذا يحدث إن شُغّل دون معطيات؟ أي سطر لو أخطأ لا يمكن التراجع عنه؟

### 2 · شغّل الفحص الآلي واسأل المعلّم عن كل تحذير 10 دقائق

```
bash files/kit/lint.sh files/scripts/drop_hotel_sessions.sh
bash files/kit/lint.sh files/scripts/purge_backups.sh
bash files/kit/lint.sh files/scripts/lock_stale_accounts.sh
bash files/kit/lint.sh files/scripts/rotate_logs.sh
```

لكل تحذير رمز مثل `SC2086` وصفحة في موقع ShellCheck. اسأل المعلّم عن معناه:

أمر لـ مساعد معلّم:

```text
أنت معلّم أوامر الطرفية. اشرح ما يفعله هذا السطر حرفًا حرفًا، وما يفعله لو كان المتغير فارغًا. لا تقل هل البرنامج صحيح ولا تقترح تصحيحًا. السطر: السطر من البرنامج
```

> **برنامج بلا تحذير ليس برنامجًا آمنًا.** اكتب أي البرامج خرج نظيفًا من الفحص، وارجع إلى ما توقعته له في الخطوة 1.

### 3 · شغّل كل برنامج تشغيلًا جافًا واقرأ ما حُذف وما تغيّر 12 دقيقة

كل تشغيل يبني نسخة جديدة من الخادم في مجلد مؤقت، فيشغّل البرنامج فيها ويطبع الملفات المحذوفة والمنشأة والمتغيرة، وأي ملف محمي فُقد، والأوامر التي كان سيستدعيها.

```
bash files/kit/dryrun.sh files/scripts/drop_hotel_sessions.sh h03
bash files/kit/dryrun.sh files/scripts/purge_backups.sh
bash files/kit/dryrun.sh files/scripts/lock_stale_accounts.sh
bash files/kit/dryrun.sh files/scripts/rotate_logs.sh
```

اقرأ `tutor_explanation_purge.md` ثم قائمة «الملفات المحذوفة» في تشغيل `purge_backups.sh`. أيهما تصدّق؟

> **النسخة مجلد لا جدار.** التشغيل الجاف يشغّل البرنامج حقًا من جذر النسخة، فلا يحميك إلا أن تكون مساراته داخلها. يرفض `dryrun.sh` برنامجًا فيه مسار يبدأ بـ `/` أو `~` أو فيه `..` أو `sudo`، ولا يرى ما يصير إليه متغير فارغ. لهذا تأتي الخطوة 1 قبل كل تشغيل.

### 4 · صحّح البرنامج المدمر حتى يجتاز الفحص والتشغيل الجاف 12 دقيقة

انسخ `drop_hotel_sessions.sh` إلى مجلد عملك وصحّحه: لا يقرأ ملفًا ويكتب فيه في الأمر نفسه، ويتوقف إن لم يُعطَ رمز فندق صحيح. ثم أعد الفحصين حتى يخرج الفحص الآلي دون تحذير، ويفقد التشغيل الجاف أسطر فندق `h03` وحدها.

```
mkdir -p work
cp files/scripts/drop_hotel_sessions.sh work/drop_hotel_sessions.sh
bash files/kit/lint.sh work/drop_hotel_sessions.sh
bash files/kit/dryrun.sh work/drop_hotel_sessions.sh h03
bash files/kit/dryrun.sh work/drop_hotel_sessions.sh
```

### 5 · اكتب سجل المراجعة بحكم واحد لكل برنامج 6 دقائق

| البرنامج | الفحص الآلي | التشغيل الجاف | الحكم: يُشغَّل، أو يُصحَّح، أو يُرفض |
| --- | --- | --- | --- |
| `drop_hotel_sessions.sh` |  |  |  |
| `purge_backups.sh` |  |  |  |
| `lock_stale_accounts.sh` |  |  |  |
| `rotate_logs.sh` |  |  |  |

### ✱ مهمة إضافية

صحّح `purge_backups.sh` أيضًا حتى لا يحذف إلا النسخ الشهرية القديمة، واكتب لماذا لم يره الفحص الآلي: ما الذي يفحصه ShellCheck، وما الذي لا يعرفه عن ترتيب خيارات `find`؟

## أسئلة تحقق

1. كم سطرًا بقي في فهرس الجلسات بعد التشغيل الجاف للبرنامج الأول كما ولّده المساعد، ولماذا؟
2. أي برنامج خرج نظيفًا من الفحص الآلي وحذف مع ذلك ملفين محميين؟
3. ماذا يفعل برنامجك المصحَّح إن شُغّل دون رمز فندق؟
