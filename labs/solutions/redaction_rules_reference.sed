# قواعد التنقيح المرجعية: القواعد الأولية، ثم القاعدتان اللتان يضيفهما المشارك،
# ثم التعديل اليدوي على الاسم الوارد في نص حر.

s/("(user_name|guest_name)": ")[^"]*"/\1[NAME]"/g
s#(://[^:/@ ]+:)[^@ ]+@#\1[SECRET:password]@#g
s/(password=)[^& "']+/\1[SECRET:password]/g
s/(--password ')[^']*'/\1[SECRET:password]'/g
s/sura_pat_[A-Za-z0-9]{24}/[SECRET:token]/g
s/SURA-KEY-[A-Z0-9]{16}/[SECRET:key]/g
s/(PMSSESSION=)[a-f0-9]+/\1[SECRET:cookie]/g
s/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[a-z]+/[EMAIL]/g
s/\+9665[0-9]{8}/[PHONE]/g

# القاعدة المضافة 1: رمز الوصول داخل رابط
s/([?&](access_)?token=)[A-Za-z0-9]+/\1[SECRET:urltoken]/g
# القاعدة المضافة 2: رقم الهوية أو الإقامة
s/((national_id|guest_id)=)[12][0-9]{9}/\1[ID]/g
# التعديل اليدوي: اسم نزيل في نص الملخص، لا يراه أي نمط عام
s/(سجل النزيل )[A-Za-z-]+ [A-Za-z-]+/\1[NAME]/
