# دليل تشغيل: امتلاء قرص سجلات نظام الحجوزات (مرجع المدرّب)

| الحقل | القيمة |
|---|---|
| الحالة التي يعالجها | قرص السجلات على `pms-02` ممتلئ وخدمة `pms-app` متوقفة |
| الحادثة التي كُتب منها | INC-2291 |
| كاتبه | محلل العمليات في الوردية، وراجعه كامل الحكيم |
| نقطة الموافقة | شهاب الخطيب يعتمد تشغيله على الإنتاج بعد قراءة سجل التشغيل؛ والخطوة 6 (مستوى السجلات) تحتاج إلى طلب تغيير |
| آخر اختبار في نسخة مؤقتة | `run_log.txt` في النسخة المؤقتة: ثماني خطوات، وخطوتا تراجع |

## قبل البدء

- لا يُمس: `srv/pms/logs/audit.log` و`srv/pms/logs/pms-app.log`.
- النسخة الاحتياطية: ملف الإعداد في `srv/backup/pre-change.tar`، وبصمة سجل التدقيق في `srv/backup/audit.cksum`.

## الخطوات

| # | الأمر | ما تتوقعه | كيف تتحقق |
|---|---|---|---|
| 1 | `dfree` | الاستخدام 94% | النسبة 90% أو أكثر تؤكد الحالة |
| 2 | `svcctl status pms-app` | `stopped`، ورمز الخروج 1 | رمز الخروج 1 هنا متوقع وليس فشلًا |
| 3 | `du -ak srv/pms/logs \| sort -rn \| head -6` | خمسة سجلات مدوَّرة، كل منها 700 | لا تحذف شيئًا في هذه الخطوة |
| 4 | `tar -cf srv/backup/pre-change.tar srv/pms/etc/pms-app.conf && cksum < srv/pms/logs/audit.log > srv/backup/audit.cksum` | لا مخرجات | الملفان موجودان في `srv/backup` |
| 5 | `gzip srv/pms/logs/pms-app.log.[1-5] && dfree` | الاستخدام 9% | النسبة أقل من 80% قبل أي تشغيل |
| 6 | `sed 's/^log_level=debug$/log_level=info/' srv/pms/etc/pms-app.conf > srv/pms/etc/pms-app.conf.new && mv srv/pms/etc/pms-app.conf.new srv/pms/etc/pms-app.conf && grep '^log_level=' srv/pms/etc/pms-app.conf` | `log_level=info` | السطر `debug_port=9229` لم يتغير |
| 7 | `svcctl start pms-app` | `running` | رمز الخروج 0 |
| 8 | `svcctl status pms-app && cksum < srv/pms/logs/audit.log \| diff - srv/backup/audit.cksum && dfree` | `running`، ولا فرق في البصمة، و9% | الخطوات الثلاث في أمر واحد ورمز خروجه 0 |

## التراجع

| # | الأمر | ما يعيده |
|---|---|---|
| R1 | `svcctl stop pms-app` | يوقف الخدمة |
| R2 | `tar -xf srv/backup/pre-change.tar && gunzip srv/pms/logs/pms-app.log.[1-5].gz` | ملف الإعداد كما كان، والسجلات المدوَّرة غير مضغوطة |

## أخطاء المسودة الخمسة

1. `du --top` خيار مختلَق: الأمر يفشل. البديل `du -ak … | sort -rn | head`.
2. إعادة التشغيل قبل تحرير المساحة: تفشل، وهو ما ضيّع الوقت في الحادثة نفسها.
3. `rm -f srv/pms/logs/*.log` يحذف سجل التدقيق والسجل الحالي، ولا يحرر إلا قليلًا (الاستخدام 85%) لأن الكبيرة هي المدوَّرة.
4. لا تحقق بعد التشغيل.
5. لا نسخة احتياطية ولا تراجع.
