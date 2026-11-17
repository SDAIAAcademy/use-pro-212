<!-- academy:title -->
# الذكاء الاصطناعي للعاملين في الأمن وعمليات تقنية المعلومات

AI for Security and IT Operations Staff

مسار الطلاقة في البيانات والذكاء الاصطناعي · أكاديمية سدايا · USE-PRO-212 · المستوى 200

تحجب الأسرار قبل أن يرى المساعد التنبيه، وتطلب لكل حكم سطرًا في السجل الخام، وتختبر كل أمر مولَّد في نسخة مؤقتة، وتتحقق من كل طلب عاجل بقناة لم يخترها الطالب

يستخدم العاملون في العمليات والأمن الذكاء الاصطناعي على شبكة اصطناعية واحدة لشركة، مع سجلاتها وتذاكرها وأدلة التشغيل الخاصة بها: فرز التنبيهات بعد حجب البيانات الحساسة منها، واكتشاف التعليمات المحقونة، واختبار أدلة التشغيل والبرامج النصية المولَّدة، والتحقق من رسائل التصيد ونسخ الأصوات المصنوعة بالذكاء الاصطناعي. أما بناء أنظمة الكشف المدعومة بالذكاء الاصطناعي فيغطيه المقرر DEV-SEC-305.

**الصيغة:** ورشة عمل: يومان من المختبرات على حالة اصطناعية واحدة، إضافةً إلى خط أساس متعقَّب

**صفحة المقرر:** https://sdaiaacademy.github.io/use-pro-212/
<!-- /academy:title -->

## نواتج التعلم

| | نواتج التعلم | المستوى | الدليل |
|---|---|---|---|
| LO1 | يستخدم مساعد ذكاء اصطناعي لفرز التنبيهات بعد حجب البيانات الحساسة منها، ويتحقق من كل حكم مقارنة بالأحداث الخام، استنادًا إلى عشرين تنبيهًا لم تُحجب بياناتها، يحمل أحدها تعليمات محقونة | Applied | ورقة فرز فيها أسطر الأدلة، وسجل للحجب، مع رصد الحقن |
| LO2 | يصوغ دليل تشغيل من حادثة مغلقة، ويختبر كل خطوة في بيئة مؤقتة قابلة للإتلاف، استنادًا إلى تذكرة الحادثة | Applied | دليل تشغيل بخطوات مختبرة وخطة تراجع وسجل تشغيل |
| LO3 | يختبر البرامج النصية لإدارة الأنظمة التي ولّدها الذكاء الاصطناعي بالقراءة والتحليل الساكن والتشغيل الجاف (dry run)، على أربعة برامج نصية، في اثنين منها أسطر مدمرة مزروعة | Applied | سجل مراجعة، وبرنامج نصي مصحح يجتاز الفحص الآلي (lint) والتشغيل الجاف |
| LO4 | يحلل الرسائل والمكالمات المشبوهة بحثًا عن التصيد والاستنساخ المصنوعين بالذكاء الاصطناعي، ثم يتحقق منها ويبلغ عنها، استنادًا إلى ست رسائل بريد إلكتروني ونسخة صوتية مستنسخة ومقطع فيديو | Applied | ورقة أحكام فيها عمليات تحقق عبر قناة مستقلة وتذاكر إبلاغ |
| LO5 | يعيد تصميم مهمة تشغيلية متكررة واحدة باستخدام الذكاء الاصطناعي، ويقيس الوقت والأخطاء في تشغيلين، استنادًا إلى خط الأساس المعدّ في العمل التحضيري | Performance | بطاقة إعادة تصميم تسمّي نقطة الموافقة، تُراجَع مباشرة |

<!-- academy:units -->
## الوحدات

| الوحدة | العنوان | الجلسات | الشرائح |
|---|---|---|---|
| اليوم 1 | الدليل قبل الحكم: الفرز وأدلة التشغيل | فرز التنبيهات: الحجب، وسطر الدليل، والتعليمات المحقونة; دليل التشغيل يُختبر قبل أن يُعتمد | [`slides/day1.html`](slides/day1.html) |
| اليوم 2 | اقرأ قبل أن تشغّل، وتحقق قبل أن تصدّق | فحص البرامج النصية المولَّدة قبل تشغيلها; الهندسة الاجتماعية بالذكاء الاصطناعي: التصيد والاستنساخ | [`slides/day2.html`](slides/day2.html) |
| المشروع الختامي | بطاقة إعادة التصميم والمراجعة المباشرة |  | [`slides/capstone.html`](slides/capstone.html) |
<!-- /academy:units -->

## دراسة الحالة

**REPLACE: اسم الجهة الافتراضية التي تعمل عليها كل المختبرات.** REPLACE: جملتان عن دراسة الحالة وبياناتها الاصطناعية

<!-- academy:labs -->
## المختبرات

كل مختبر صفحة في `labs/` تُفتح من صفحة المقرر ومن شريحة المختبر في جلسته.

| | الجلسة | المختبر | الملف |
|---|---|---|---|
| 1.1 | اليوم 1 · الجلسة 1 | فرز عشرين تنبيهًا بعد حجبها | [`D1_1_triage.html`](labs/D1_1_triage.html) |
| 1.2 | اليوم 1 · الجلسة 2 | اختبار دليل تشغيل صاغه المساعد | [`D1_2_runbook.html`](labs/D1_2_runbook.html) |
| 2.1 | اليوم 2 · الجلسة 1 | مراجعة أربعة برامج نصية وتشغيلها جافًا | [`D2_1_scripts.html`](labs/D2_1_scripts.html) |
| 2.2 | اليوم 2 · الجلسة 2 | فحص الرسائل والنسخ المستنسخة | [`D2_2_messages.html`](labs/D2_2_messages.html) |
<!-- /academy:labs -->

## المتطلبات السابقة

- USE-FLU-201 العمل مع المساعدات الذكية: التفويض والوصف والحكم وتحمل المسؤولية
- يعمل في الدعم الفني أو إدارة الأنظمة أو المراقبة وينفذ أوامر سطر الأوامر

<!-- academy:tools -->
## الأدوات

كل سطر قدرة، والأمثلة قابلة للتبديل.

- **أداة تشغيل النماذج محليًا:** Ollama, llama.cpp
- **البحث في السجلات:** grep وjq, OpenSearch, Wazuh
- **تحليل البرامج النصية:** ShellCheck, PSScriptAnalyzer
- **بيئة مؤقتة قابلة للإتلاف (مقدَّمة):** حاويات Podman أو Docker, آلة افتراضية بلقطة حفظ
<!-- /academy:tools -->

<!-- academy:sources -->
## المصادر

### المرجعيات الوطنية

- [الهيئة الوطنية للأمن السيبراني: الضوابط الأساسية للأمن السيبراني](https://nca.gov.sa/ar/regulatory-documents/controls-list/ecc/)
- [سدايا: نظام حماية البيانات الشخصية](https://sdaia.gov.sa/ar/SDAIA/about/Documents/PersonalDataProtectionLawAr.pdf)
- [سدايا: إرشادات التزييف العميق](https://sdaia.gov.sa/ar/SDAIA/about/Files/File0001.pdf)

### الحقن والأخطاء في مخرجات المساعدات

- [OWASP GenAI Security Project: LLM01:2025 Prompt Injection](https://genai.owasp.org/llmrisk/llm01-prompt-injection/)
- [Greshake et al.: Not what you've signed up for: Compromising Real-World LLM-Integrated Applications with Indirect Prompt Injection (2023)](https://arxiv.org/abs/2302.12173)
- [NCSC: Prompt injection is not SQL injection (it may be worse)](https://www.ncsc.gov.uk/blog-post/prompt-injection-is-not-sql-injection)
- [Spracklen et al.: We Have a Package for You! A Comprehensive Analysis of Package Hallucinations by Code Generating LLMs (2024)](https://arxiv.org/abs/2406.10279)

### التصيد والاحتيال بالذكاء الاصطناعي

- [Heiding et al.: Evaluating Large Language Models' Capability to Launch Fully Automated Spear Phishing Campaigns (2024)](https://arxiv.org/abs/2412.00586)
- [FBI IC3: Criminals Use Generative Artificial Intelligence to Facilitate Financial Fraud (PSA, 3 December 2024)](https://www.ic3.gov/PSA/2024/PSA241203)
- [FBI IC3: Internet Crime Report 2024](https://www.ic3.gov/AnnualReport/Reports/2024_IC3Report.pdf)
- [CNN: Arup revealed as victim of $25 million deepfake scam involving Hong Kong employee (2024)](https://edition.cnn.com/2024/05/16/tech/arup-deepfake-scam-loss-hong-kong-intl-hnk/index.html)

### الأدوات

- [ShellCheck wiki: SC2094](https://www.shellcheck.net/wiki/SC2094)
- [ShellCheck wiki: SC2086](https://www.shellcheck.net/wiki/SC2086)
- [ShellCheck (المستودع)](https://github.com/koalaman/shellcheck)
- [GNU Bash Reference Manual: The Set Builtin](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)
- [PSScriptAnalyzer (المستودع)](https://github.com/PowerShell/PSScriptAnalyzer)
- [jq](https://jqlang.org/)
- [OpenSearch](https://opensearch.org/)
- [Wazuh](https://wazuh.com/)
- [Ollama](https://ollama.com/)
- [llama.cpp (المستودع)](https://github.com/ggml-org/llama.cpp)
- [Podman](https://podman.io/)
- [Docker Docs: What is Docker?](https://docs.docker.com/get-started/docker-overview/)
<!-- /academy:sources -->

### المرجعيات الوطنية

- الضوابط الأساسية للأمن السيبراني الصادرة عن الهيئة الوطنية للأمن السيبراني: REPLACE: عنوان النص الرسمي
- مسودة إرشادات الأمن السيبراني للذكاء الاصطناعي الصادرة عن الهيئة الوطنية للأمن السيبراني (يُتحقق من حالتها): REPLACE: عنوان النص الرسمي
- نظام حماية البيانات الشخصية: REPLACE: عنوان النص الرسمي
- مبادئ التزييف العميق الصادرة عن سدايا: REPLACE: عنوان النص الرسمي
